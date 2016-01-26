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
    AR_OBJECT_NAMES    T_NAMES_ARR := T_NAMES_ARR ('M_ADDRESS',
                                                   'R_BILL_ITEM',
                                                   'R_BILL_MASTER',
                                                   'R_BILL_PACKAGE',
                                                   'L_BILL_TO_DIAGNOSIS',
                                                   'M_BUSINESS',
                                                   'R_CASE_MASTER',
                                                   'M_CODE',
                                                   'M_CONTACT',
                                                   'C_GENERIC_LOOKUP',
                                                   'R_HCFA_BILL_ITEM',
                                                   'M_PEOPLE',
                                                   'R_REFERRAL_DETAIL',
                                                   'R_REFERRAL_MASTER',
                                                   'R_VISIT',
												   'R_OCM_BILL_ITEM');

    N_ITERATOR         PLS_INTEGER;

BEGIN
    N_ITERATOR := AR_OBJECT_NAMES.FIRST;

    WHILE (N_ITERATOR IS NOT NULL)
    LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON &1..' || AR_OBJECT_NAMES(N_ITERATOR) || ' TO &2.';
        EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM &2..' || AR_OBJECT_NAMES(N_ITERATOR) ||
                          ' FOR &1..' || AR_OBJECT_NAMES(N_ITERATOR);

        N_ITERATOR := AR_OBJECT_NAMES.NEXT (N_ITERATOR);

    END LOOP;
END;
/

-- Packages
DECLARE
    -- Type
    TYPE T_NAMES_ARR IS TABLE OF VARCHAR2 (30);

    -- Variables
    N_ITERATOR         PLS_INTEGER;
    AR_PACKAGES_NAMES  T_NAMES_ARR :=
                           T_NAMES_ARR (
                               -- Phoenix 2.8.2
                               'PKG_CONST');
BEGIN
    N_ITERATOR := AR_PACKAGES_NAMES.FIRST;

    WHILE (N_ITERATOR IS NOT NULL)
    LOOP
        -- Grant privileges
        EXECUTE IMMEDIATE
            'GRANT EXECUTE ON &1..'
                || AR_PACKAGES_NAMES (N_ITERATOR)
                || ' TO &2.';

        -- Create synonym
        EXECUTE IMMEDIATE
            'CREATE OR REPLACE SYNONYM &2..'
                || AR_PACKAGES_NAMES (N_ITERATOR)
                || ' FOR &1..'
                || AR_PACKAGES_NAMES (N_ITERATOR);

        N_ITERATOR := AR_PACKAGES_NAMES.NEXT (N_ITERATOR);
    END LOOP;
END;
/

SPOOL OFF

EXIT