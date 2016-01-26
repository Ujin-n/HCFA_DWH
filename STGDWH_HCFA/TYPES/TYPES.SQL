/*****************************************************************************/
/** Types and Collections                                                   **/
/*****************************************************************************/

-- T_NUMBER
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE T_NUMBER FORCE AS OBJECT (N NUMBER(20))';

   DBMS_OUTPUT.PUT_LINE ('[INFO]: Type T_NUMBER has been created');
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[ERROR]: Error during creation of T_NUMBER type');
END;
/

-- T_NUMBER_LIST
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE T_NUMBER_LIST AS TABLE OF T_NUMBER';

   DBMS_OUTPUT.PUT_LINE ('[INFO]: Type T_NUMBER_LIST has been created');

EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[ERROR]: Error during creation of T_NUMBER_LIST type');
END;
/