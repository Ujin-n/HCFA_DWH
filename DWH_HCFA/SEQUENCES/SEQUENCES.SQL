/*****************************************************************************/
/** Sequences                                                               **/
/*****************************************************************************/

-- Sequence SEQ_DIM_DATE
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_DATE
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_DATE was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_DATE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_DATE sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_PATIENT
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_PATIENT
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_PATIENT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_PATIENT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_PATIENT sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_PROVIDER
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_PROVIDER
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_PROVIDER was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_PROVIDER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_PROVIDER sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_CPT
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_CPT
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_CPT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_CPT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_CPT sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_BILL
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_BILL
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_BILL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_BILL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_BILL sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_MODIFIER
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_MODIFIER
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_MODIFIER was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_MODIFIER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_MODIFIER sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DIM_DIAGNOSE
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DIM_DIAGNOSE
            START WITH 2
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_DIAGNOSE was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DIM_DIAGNOSE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DIM_DIAGNOSE sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_FACT_HCFA
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_FACT_HCFA
            START WITH 1
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_FACT_HCFA was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_FACT_HCFA already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_FACT_HCFA sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DWH_ETL
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DWH_ETL
            START WITH 1
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DWH_ETL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DWH_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DWH_ETL sequence:' || SQLERRM);
END;
/

-- Sequence SEQ_DWH_ETL_DETAIL
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE SEQUENCE SEQ_DWH_ETL_DETAIL
            START WITH 1
            INCREMENT BY 1
            NOCACHE';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DWH_ETL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Sequence SEQ_DWH_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of SEQ_DWH_ETL_DETAIL sequence:' || SQLERRM);
END;
/
