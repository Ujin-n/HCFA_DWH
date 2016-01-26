/*****************************************************************************/
/** Sequences                                                               **/
/*****************************************************************************/

-- Sequence SEQ_STG_ETL
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_STG_ETL
            START WITH 1
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_STG_ETL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_STG_ETL sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_STG_ETL_DETAIL
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_STG_ETL_DETAIL
            START WITH 1
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_STG_ETL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_STG_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_STG_ETL_DETAIL sequence:' || SQLERRM);
END;
/

