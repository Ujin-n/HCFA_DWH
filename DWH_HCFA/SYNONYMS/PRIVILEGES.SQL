REM Script is intended mostly for granting privileges on objects
REM from PHOENIX3 schema to STGDWH schema and requires
REM to be applied after main upgrade script.

SET ECHO ON
SET TERMOUT ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE ON

SPOOL GRANTS_AFTER.LOG

-- Tables
DECLARE
    TYPE T_NAMES_ARR IS TABLE OF VARCHAR2(30);
    AR_OBJECT_NAMES    T_NAMES_ARR := T_NAMES_ARR ('S_ADDRESS',
                                                   'S_BILL_ITEM',
                                                   'S_BILL_MASTER',
                                                   'S_BILL_PACKAGE',
                                                   'S_BILL_TO_DIAGNOSIS',
                                                   'S_BUSINESS',
                                                   'S_CASE_MASTER',
                                                   'S_CODE',
                                                   'S_CONTACT',
                                                   'S_GENERIC_LOOKUP',
                                                   'S_HCFA_BILL_ITEM',
                                                   'S_PEOPLE',
                                                   'S_REFERRAL_DETAIL',
                                                   'S_REFERRAL_MASTER',
                                                   'S_VISIT',
												   'R_STG_ETL'
                                                   );

    N_ITERATOR         PLS_INTEGER;

BEGIN
    N_ITERATOR := AR_OBJECT_NAMES.FIRST;

    WHILE (N_ITERATOR IS NOT NULL)
    LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE ON &1..' || AR_OBJECT_NAMES(N_ITERATOR) || ' TO &2.';
        EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM &2..' || AR_OBJECT_NAMES(N_ITERATOR) ||
                          ' FOR &1..' || AR_OBJECT_NAMES(N_ITERATOR);

        N_ITERATOR := AR_OBJECT_NAMES.NEXT (N_ITERATOR);

    END LOOP;
END;
/

SPOOL OFF

EXIT