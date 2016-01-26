SPOOL DIM_DEFAULT_POPULATION.LOG

/****************************************************************************
*  NAME:       DIM_DEFAULT_POPULATION
*  PURPOSE:    This script populates dimension tables with default values, using '1' for primary key
*  REVISIONS: 

*  Ver         Date        Author           Description
*  ---------   ----------  ---------------  ----------------------------

*****************************************************************************/

SET TERMOUT ON;
SET TRIMOUT ON;
SET TRIMSPOOL ON;
SET LINESIZE 1000;
SET SERVEROUTPUT ON SIZE UNLIMITED;


DECLARE 
    C$V_DP_NAME         CONSTANT VARCHAR2 (100) := 'DIM_DATE_POPULATION';
    C$V_UNKNOWN_STRING                      CONSTANT VARCHAR2(7) := 'UNKNOWN';
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE(C$V_DP_NAME || ' BEGIN OF WORK: ' || TO_CHAR(SYSDATE, 'MM/DD/YYYY HH24:MI:SS'));         
    DBMS_OUTPUT.PUT_LINE('============================================================================');    

    BEGIN
        INSERT INTO DIM_DIAGNOSE (
               DIAGNOSE_ID, 
               DIAGNOSE_CODE)
        VALUES (1, 
                C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('DIAGNOSE_ID = 1 already exists in DIM_DIAGNOSE');
    END;
    
    BEGIN
        INSERT INTO DIM_MODIFIER (
               MODIFIER_ID, 
               MODIFIER_CODE, 
               MODIFIER_DESC)
        VALUES (1, 
                C$V_UNKNOWN_STRING, 
                C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('MODIFIER_ID = 1 already exists in DIM_MODIFIER');
    END;
    
    BEGIN
        INSERT INTO DIM_BILL (
               BILL_ID, 
               BILL_CODE)
        VALUES(1, 
               C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('BILL_ID = 1 already exists in DIM_BILL');
    END;
    
    BEGIN
        INSERT INTO DIM_CPT(
               CPT_ID, 
               CPT_CODE, 
               CPT_DESC)
        VALUES(1, 
              C$V_UNKNOWN_STRING, 
              C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN DBMS_OUTPUT.PUT_LINE('CPT_ID = 1 already exists in DIM_CPT');
    END;
    
    BEGIN
        INSERT INTO DIM_PROVIDER(
               PROVIDER_ID, 
               PROVIDER_TYPE, 
               PROVIDER_FEDERAL_TAX_ID, 
               PROVIDER_NAME, 
               PROVIDER_ADDRESS_1, 
               PROVIDER_ADDRESS_2, 
               PROVIDER_CITY,
               PROVIDER_STATE,
               PROVIDER_ZIP_CODE,
               PROVIDER_OFFICE_PHONE_NUM)
        VALUES(1, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('PROVIDER_ID = 1 already exists in DIM_PROVIDER');
    END;
    
    BEGIN
        INSERT INTO DIM_PATIENT(
               PATIENT_ID,
               PATIENT_SSN,
               PATIENT_CLAIM_NUMBER,
               PATIENT_GENDER,
               PATIENT_LAST_NAME,
               PATIENT_FIRST_NAME,
               PATIENT_MIDDLE_NAME,
               PATIENT_FULL_NAME,
               PATIENT_BIRTHDATE,
               PATIENT_ADDRESS_1,
               PATIENT_ADDRESS_2,
               PATIENT_CITY,
               PATIENT_STATE,
               PATIENT_ZIP_CODE,
               PATIENT_MOBILE_PHONE_NUM)
        VALUES(1, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               TO_DATE('01/01/0001', 'MM/DD/YYYY'), 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('PATIENT_ID = 1 already exists in DIM_PATIENT');
    END;
    
    BEGIN
        INSERT INTO DIM_DATE(
               DATE_ID, 
               DATE_NAME, 
               DATE_FULL_DESC, 
               DAY_OF_WEEK_NAME, 
               DAY_NUMBER_IN_MONTH, 
               LAST_DATE_MONTH_FLAG_DESC, 
               WEEK_NUM_IN_YEAR, 
               MONTH_NAME, 
               MONTH_NUM_IN_YEAR, 
               YEAR, 
               YEAR_MONTH_DESC, 
               HOLIDAY_FLAG, 
               WEEKDAY_FLAG)
        VALUES(1, 
               TO_DATE('01/01/0001', 'MM/DD/YYYY'), 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               0, 
               C$V_UNKNOWN_STRING, 
               0, 
               C$V_UNKNOWN_STRING, 
               0, 
               0, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING, 
               C$V_UNKNOWN_STRING);
        
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN ROLLBACK;
             DBMS_OUTPUT.PUT_LINE('DATE_ID = 1 already exists in DIM_DATE');
    END;

    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE(C$V_DP_NAME || ' END OF WORK: ' || TO_CHAR(SYSDATE, 'MM/DD/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('============================================================================');  
                     
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

SPOOL OFF
