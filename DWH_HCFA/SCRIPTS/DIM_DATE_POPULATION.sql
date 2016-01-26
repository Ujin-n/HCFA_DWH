SPOOL DIM_DATE_POPULATION.LOG

/****************************************************************************
*  NAME:       DIM_DATE_POPULATION
*  PURPOSE:    This script populate DIM_DATE by dates for period 1/1/2008 - 31/12/2016
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
    C$D_START_DATE      CONSTANT DATE := TO_DATE('01/01/2008', 'MM/DD/YYYY'); 
    C$D_END_DATE        CONSTANT DATE := TO_DATE('12/31/2016', 'MM/DD/YYYY');
    D_CURRENT_DATE      DATE;
    V_HOLIDAY_FLAG      VARCHAR2(11);
    V_WEEKDAY_FLAG      VARCHAR2(11);  
    TYPE HOLIDAY_TYPE   IS VARRAY(10) OF VARCHAR2(5);
    HOLIDAYS HOLIDAY_TYPE := HOLIDAY_TYPE('01.01','07.01', '08.03', '01.05', '09.05', 
                                          '03.07', '07.11', '25.12'); 
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE(C$V_DP_NAME || ' BEGIN OF WORK: ' || TO_CHAR(SYSDATE, 'MM/DD/YYYY HH24:MI:SS'));         
    DBMS_OUTPUT.PUT_LINE('============================================================================');    


    D_CURRENT_DATE := C$D_START_DATE;

    WHILE D_CURRENT_DATE <= C$D_END_DATE
    LOOP
        FOR I IN HOLIDAYS.FIRST..HOLIDAYS.LAST
        LOOP
            IF TO_CHAR(D_CURRENT_DATE,'DD.MM') = HOLIDAYS(I) 
            THEN 
                V_HOLIDAY_FLAG := 'HOLIDAY';
                EXIT;
            ELSE
                V_HOLIDAY_FLAG := 'NON-HOLIDAY';
            END IF;
        END LOOP;
        
        IF TO_CHAR(D_CURRENT_DATE,'FMDAY') = 'SATURDAY' 
           OR TO_CHAR(D_CURRENT_DATE,'FMDAY') = 'SUNDAY' 
        THEN
            V_WEEKDAY_FLAG := 'WEEKEND';
        ELSE
            V_WEEKDAY_FLAG := 'WORKING DAY';
        END IF;
        
        INSERT INTO DIM_DATE (
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
                            VALUES ( SEQ_DIM_DATE.NEXTVAL, 
                                    D_CURRENT_DATE, 
                                    TO_CHAR(D_CURRENT_DATE, 'FMMONTH') || ' ' || TO_CHAR(D_CURRENT_DATE, 'DD') || ', ' || TO_CHAR(D_CURRENT_DATE, 'YYYY'),
                                    TO_CHAR(D_CURRENT_DATE, 'DAY'), 
                                    TO_NUMBER(TO_CHAR(D_CURRENT_DATE, 'DD')), 
                                    LAST_DAY(D_CURRENT_DATE),
                                    TO_NUMBER(TO_CHAR(D_CURRENT_DATE, 'IW')), 
                                    TO_CHAR(D_CURRENT_DATE, 'MONTH'), 
                                    TO_NUMBER(TO_CHAR(D_CURRENT_DATE, 'MM')),
                                    EXTRACT(YEAR FROM D_CURRENT_DATE), 
                                    TO_CHAR(D_CURRENT_DATE, 'MM') || '/' || TO_CHAR(D_CURRENT_DATE, 'YYYY'), 
                                    V_HOLIDAY_FLAG, 
                                    V_WEEKDAY_FLAG
                                    );
                                
        D_CURRENT_DATE := D_CURRENT_DATE + 1;
        
    END LOOP;
    
    COMMIT;

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
