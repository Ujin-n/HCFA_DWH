/**************************************************************************
 DDL statements for R_STG_ETL table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE R_STG_ETL 
        (
           STG_ETL_ID                    NUMBER(12)            NOT NULL,
           STG_ETL_STATUS                VARCHAR2(1)           NOT NULL,
           STG_ETL_PROCESS_DATE          DATE                  NOT NULL,
           STG_ETL_PROCESS_START_DATE    DATE                  NULL,
           STG_ETL_PROCESS_END_DATE      DATE                  NULL

        )
            TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table R_STG_ETL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table R_STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of R_STG_ETL table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_R_STG_ETL
            ON R_STG_ETL (STG_ETL_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_R_STG_ETL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_R_STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_R_STG_ETL index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE R_STG_ETL
            ADD CONSTRAINT PK_R_STG_ETL
                PRIMARY KEY (STG_ETL_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_R_STG_ETL was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_R_STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_R_STG_ETL constraint:' || SQLERRM);
END;
/
/**************************************************************************
 DDL statements for R_STG_ETL_DETAIL table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE R_STG_ETL_DETAIL 
        (
           STG_ETL_DETAIL_ID                      NUMBER(12)            NOT NULL,
           STG_ETL_ID                             NUMBER(12)            NOT NULL,
           STG_ETL_DETAIL_STATUS                  VARCHAR2(1)           NOT NULL,
           STG_ETL_DETAIL_STEP_START_DATE         DATE                  NULL,
           STG_ETL_DETAIL_STEP_END_DATE           DATE                  NULL,
           STG_ETL_MODULE                         VARCHAR2(256)         NULL,
           MESSAGE                                VARCHAR2(4000)        NULL
        )
            TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table R_STG_ETL_DETAIL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table R_STG_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of R_STG_ETL_DETAIL table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_R_STG_ETL_DETAIL
            ON R_STG_ETL_DETAIL (STG_ETL_DETAIL_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_R_STG_ETL_DETAIL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_R_STG_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_R_STG_ETL_DETAIL index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE R_STG_ETL_DETAIL
            ADD CONSTRAINT PK_R_STG_ETL_DETAIL
                PRIMARY KEY (STG_ETL_DETAIL_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_R_STG_ETL_DETAIL was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_R_STG_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_R_STG_ETL_DETAIL constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE R_STG_ETL_DETAIL
            ADD CONSTRAINT FK1_STG_ETL_DETAIL2STG_ETL FOREIGN KEY (STG_ETL_ID)
                REFERENCES R_STG_ETL (STG_ETL_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_STG_ETL_DETAIL2STG_ETL was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_STG_ETL_DETAIL2STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_STG_ETL_DETAIL2STG_ETL constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_R_STG_ETL_DETAIL ON R_STG_ETL_DETAIL (
            STG_ETL_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_R_STG_ETL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_R_STG_ETL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_R_STG_ETL_DETAIL index:' || SQLERRM);
END;
/