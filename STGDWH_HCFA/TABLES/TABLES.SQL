/**************************************************************************
 DDL statements for S_GENERIC_LOOKUP table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_GENERIC_LOOKUP 
(
   LOOKUP_ID              NUMBER(12)           NOT NULL,
   LOOKUP_NAME            VARCHAR2(256 BYTE),
   LOOKUP_ABBREVIATION    VARCHAR2(20 BYTE),
   ROW_ORDER              NUMBER(4),
   CREATED_BY             VARCHAR2(256 BYTE),
   CREATION_DATE          DATE,
   LAST_MODIFIED_BY       VARCHAR2(256 BYTE),
   LAST_MODIFICATION_DATE DATE,
   LOOKUP_TYPE_ID         NUMBER(12),
   ACTIVITY_STATUS        CHAR(1 BYTE)
 )
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_GENERIC_LOOKUP was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_GENERIC_LOOKUP already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_GENERIC_LOOKUP table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_GENERIC_LOOKUP
            ON S_GENERIC_LOOKUP (LOOKUP_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_GENERIC_LOOKUP was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_GENERIC_LOOKUP already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_GENERIC_LOOKUP index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_GENERIC_LOOKUP
            ADD CONSTRAINT PK_S_GENERIC_LOOKUP
                PRIMARY KEY (LOOKUP_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_GENERIC_LOOKUP was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_GENERIC_LOOKUP already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_GENERIC_LOOKUP constraint:' || SQLERRM);
END;
/



/**************************************************************************
 DDL statements for S_BUSINESS table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_BUSINESS 
(
   BUSINESS_ID              NUMBER(12)           NOT NULL,
   INTREPID_CODE            VARCHAR2(20 BYTE),
   CREATED_BY               VARCHAR2(256 BYTE),
   CREATION_DATE            DATE,
   LAST_MODIFIED_BY         VARCHAR2(256 BYTE),
   WEB_EMAIL_ACTIVE_DATE    DATE,
   LAST_STATUS_CHANGED_DATE DATE,
   BUSINESS_CLOSURE_DATE    DATE,
   COMPANY_NAME             VARCHAR2(256 BYTE),
   LAST_MODIFICATION_DATE   DATE,
   ACTIVITY_STATUS          CHAR(1 BYTE),
   VERIFIED_STATUS          CHAR(1 BYTE),
   BUSINESS_SUB_TYPE        NUMBER(5),
   FEDERAL_ID               VARCHAR2(12 BYTE),
   PAY_ON_PAY               CHAR(1 BYTE),
   INTREPID_CODE_NUMBER     NUMBER(20),
   BUSINESS_TYPE_ID         NUMBER(12),
   BUSINESS_CLOSURE_ID      NUMBER(12),
   PARTNER_TYPE_ID          NUMBER(12),
   DIM_PROVIDER_ID          NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_BUSINESS was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BUSINESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_BUSINESS table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_BUSINESS
            ON S_BUSINESS (BUSINESS_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BUSINESS was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BUSINESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_BUSINESS index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BUSINESS
            ADD CONSTRAINT PK_S_BUSINESS
                PRIMARY KEY (BUSINESS_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BUSINESS was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BUSINESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_BUSINESS constraint:' || SQLERRM);
END;
/




/**************************************************************************
 DDL statements for S_CODE table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_CODE 
(
   CODE                   VARCHAR2(15 BYTE),
   CODE_ID                NUMBER(12)           NOT NULL,
   CREATED_BY             VARCHAR2(256 BYTE),
   CREATION_DATE          DATE,
   LAST_MODIFIED_BY       VARCHAR2(256 BYTE),
   LAST_MODIFICATION_DATE DATE,
   START_DATE             DATE,
   END_DATE               DATE,
   REVISED_DATE           DATE,
   CODE_TYPE_ID           NUMBER(12),
   DIM_CPT_ID             NUMBER(12),
   DIM_MODIFIER_ID        NUMBER(12),
   DIM_DIAGNOSIS_ID       NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_CODE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_CODE table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_CODE
            ON S_CODE (CODE_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CODE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_CODE index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CODE
            ADD CONSTRAINT PK_S_CODE
                PRIMARY KEY (CODE_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CODE was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_CODE constraint:' || SQLERRM);
END;
/




/**************************************************************************
 DDL statements for S_PEOPLE table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_PEOPLE 
(
   PEOPLE_ID              NUMBER(12)           NOT NULL,
   FIRST_NAME             VARCHAR2(256 BYTE),
   MIDDLE_INITIAL         CHAR(1 BYTE),
   LAST_NAME              VARCHAR2(256 BYTE),
   BIRTH_DATE			  DATE,
   SOCIAL_SECURITY_NUMBER VARCHAR2(9 BYTE),
   FEDERAL_TAX_ID         VARCHAR2(12 BYTE),
   PREFIX                 VARCHAR2(5 BYTE),
   CREATION_DATE          DATE,
   LAST_MODIFIED_BY       VARCHAR2(256 BYTE),
   FULL_NAME              VARCHAR2(515 BYTE),
   USER_ID                NUMBER(12),
   CREATED_BY             VARCHAR2(256 BYTE),
   INTREPID_CODE          VARCHAR2(20 BYTE),
   LAST_MODIFICATION_DATE DATE,
   ACTIVITY_STATUS        CHAR(1 BYTE),
   MIDDLE_NAME            VARCHAR2(256 BYTE),
   GENDER                 CHAR(1 BYTE),
   VERIFIED_STATUS        CHAR(1 BYTE),
   PEOPLE_SUB_TYPE        NUMBER(5),
   FIRST_NAME_SOUNDEX     VARCHAR2(256 BYTE),
   LAST_NAME_SOUNDEX      VARCHAR2(256 BYTE),
   PARTIAL_SSN            VARCHAR2(4 BYTE),
   INTREPID_CODE_NUMBER   NUMBER(20),
   PEOPLE_TYPE_ID         NUMBER(12),
   DIM_PATIENT_ID         NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_PEOPLE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_PEOPLE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_PEOPLE table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_PEOPLE
            ON S_PEOPLE (PEOPLE_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_PEOPLE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_PEOPLE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_PEOPLE index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_PEOPLE
            ADD CONSTRAINT PK_S_PEOPLE
                PRIMARY KEY (PEOPLE_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_PEOPLE was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_PEOPLE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_PEOPLE constraint:' || SQLERRM);
END;
/




/**************************************************************************
 DDL statements for S_ADDRESS table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_ADDRESS 
(
   COUNTY                 VARCHAR2(50 BYTE),
   REQUIRES_GEOCODING     CHAR(1 BYTE),
   MAPCODE                VARCHAR2(256 BYTE),
   COUNTRY                VARCHAR2(50 BYTE),
   ALTERNATE_COMPANY_NAME VARCHAR2(256 BYTE),
   STATE_CODE             CHAR(2 BYTE),
   BUSINESS_ID            NUMBER(12),
   PEOPLE_ID              NUMBER(12),
   INTREPID_CODE          VARCHAR2(20 BYTE),
   ADDRESS1               VARCHAR2(256 BYTE),
   ADDRESS2               VARCHAR2(256 BYTE),
   ADDRESS3               VARCHAR2(256 BYTE),
   ADDRESS_ID             NUMBER(12)           NOT NULL,
   ZIP_PLUS_FOUR          VARCHAR2(9 BYTE),
   LONGITUDE              NUMBER(10, 6),
   LATITUDE               NUMBER(10, 6),
   ACTIVITY_STATUS        CHAR(1 BYTE),
   ADDRESS_TYPE_ID        NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_ADDRESS was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_ADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_ADDRESS table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_ADDRESS
            ON S_ADDRESS (ADDRESS_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_ADDRESS was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_ADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_ADDRESS index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_ADDRESS
            ADD CONSTRAINT PK_S_ADDRESS
                PRIMARY KEY (ADDRESS_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_ADDRESS was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_ADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_ADDRESS constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_ADDRESS
            ADD CONSTRAINT FK_MBUSINESS_REF_MADDRESS FOREIGN KEY (BUSINESS_ID)
                REFERENCES S_BUSINESS(BUSINESS_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MBUSINESS_REF_MADDRESS was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MBUSINESS_REF_MADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_MBUSINESS_REF_MADDRESS constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_ADDRESS ON S_ADDRESS (
            BUSINESS_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_ADDRESS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_ADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_ADDRESS index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_ADDRESS
            ADD CONSTRAINT FK_MPEOPLE_REF_MADDRESS FOREIGN KEY (PEOPLE_ID)
                REFERENCES S_PEOPLE(PEOPLE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_MADDRESS was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_MADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_MPEOPLE_REF_MADDRESS constraint:' || SQLERRM);
END;
/


-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_ADDRESS ON S_ADDRESS (
            PEOPLE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_ADDRESS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_ADDRESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_ADDRESS index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_CONTACT table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_CONTACT 
(
   CONTACT_ID             NUMBER(12)           NOT NULL,
   PHONE_NUMBER           VARCHAR2(16 BYTE),
   PHONE_NUMBER_EXTENSION VARCHAR2(10 BYTE),
   EMAIL_ADDRESS          VARCHAR2(256 BYTE),
   WEB_SITE               VARCHAR2(256 BYTE),
   PEOPLE_ID              NUMBER(12),
   BUSINESS_ID            NUMBER(12),
   FAX                    VARCHAR2(16 BYTE),
   HOME_PHONE             VARCHAR2(16 BYTE),
   OTHER_PHONE            VARCHAR2(16 BYTE),
   ACTIVITY_STATUS        CHAR(1 BYTE),
   CONTACT_TYPE_ID        NUMBER(12),
   PHONE_TYPE_ID          NUMBER(12),
   ADDRESS_ID             NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_CONTACT was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_CONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_CONTACT table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_CONTACT
            ON S_CONTACT (CONTACT_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CONTACT was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_CONTACT index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CONTACT
            ADD CONSTRAINT PK_S_CONTACT
                PRIMARY KEY (CONTACT_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CONTACT was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_CONTACT constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CONTACT
            ADD CONSTRAINT FK_MBUSINESS_REF_MCONTACT FOREIGN KEY (BUSINESS_ID)
                REFERENCES S_BUSINESS(BUSINESS_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MBUSINESS_REF_MCONTACT was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MBUSINESS_REF_MCONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_MBUSINESS_REF_MCONTACT constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_CONTACT ON S_CONTACT (
            BUSINESS_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_CONTACT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_CONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_CONTACT index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CONTACT
            ADD CONSTRAINT FK_MPEOPLE_REF_MCONTACT FOREIGN KEY (PEOPLE_ID)
                REFERENCES S_PEOPLE(PEOPLE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_MCONTACT was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_MCONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_MPEOPLE_REF_MCONTACT constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_CONTACT ON S_CONTACT (
            PEOPLE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_CONTACT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_CONTACT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_CONTACT index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_CASE_MASTER table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_CASE_MASTER 
(
   CASE_MASTER_ID                NUMBER(12)           NOT NULL,
   CLAIM_NUMBER                  VARCHAR2(30 BYTE),
   DATE_OF_INJURY                DATE,
   CREATION_DATE                 DATE,
   LAST_MODIFICATION_DATE        DATE,
   CREATED_BY                    VARCHAR2(256 BYTE),
   LAST_MODIFIED_BY              VARCHAR2(256 BYTE),
   AGED                          CHAR(1 BYTE),
   AGED_TYPE                     CHAR(1 BYTE),
   EXTERNAL_REFERRAL_ID          NUMBER(12),
   EXTERNAL_REFERRAL_TYPE        VARCHAR2(256 BYTE),
   PATIENT_ID                    NUMBER(12),
   INTREPID_CODE                 VARCHAR2(20 BYTE),
   DUP_CASE_MASTER_ID            NUMBER(12),
   ACTIVITY_STATUS               CHAR(1 BYTE),
   PRIMARY_PAYER_ID              NUMBER(12),
   EMPLOYER_AT_TIME_OF_INJURY_ID NUMBER(12),
   LINE_OF_BUSINESS_ID           NUMBER(12),
   JURISDICTION_ID               NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_CASE_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_CASE_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_CASE_MASTER table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_CASE_MASTER
            ON S_CASE_MASTER (CASE_MASTER_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CASE_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_CASE_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_CASE_MASTER index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CASE_MASTER
            ADD CONSTRAINT PK_S_CASE_MASTER
                PRIMARY KEY (CASE_MASTER_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CASE_MASTER was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_CASE_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_CASE_MASTER constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_CASE_MASTER
            ADD CONSTRAINT FK_MPEOPLE_REF_RCASEMASTER FOREIGN KEY (PATIENT_ID)
                REFERENCES S_PEOPLE(PEOPLE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_RCASEMASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_MPEOPLE_REF_RCASEMASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_MPEOPLE_REF_RCASEMASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_CASE_MASTER ON S_CASE_MASTER (
            PATIENT_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_CASE_MASTER was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_CASE_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_CASE_MASTER index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_REFERRAL_MASTER table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_REFERRAL_MASTER 
(
   INTAKE_DATE                  DATE,
   PATIENT_OUT_OF_WORK          CHAR(1 BYTE),
   REFERRAL_MASTER_ID           NUMBER(12)           NOT NULL,
   PRECERTIFICATION_TEXT        VARCHAR2(4000 BYTE),
   FOLLOW_UP_DATE               DATE,
   REFERRAL_TOTAL_COST_SAVINGS  VARCHAR2(256 BYTE),
   CASE_MASTER_ID               NUMBER(12)           NOT NULL,
   CREATED_BY                   VARCHAR2(256 BYTE),
   CREATION_DATE                DATE,
   LAST_MODIFIED_BY             VARCHAR2(256 BYTE),
   LAST_MODIFICATION_DATE       DATE,
   REFERRING_MD_ID              NUMBER(12),
   ADJUSTER_ID                  NUMBER(12),
   DISTRIBUTOR_1ST_CONTACT_FLAG CHAR(1 BYTE)         NOT NULL,
   DISTRIBUTOR_PASS_NUMBER      NUMBER(1)            NOT NULL,
   DISTRIBUTOR_OST_FLAG         CHAR(1 BYTE)         NOT NULL,
   REQUEST_FILMS                CHAR(1 BYTE),
   CREATED_BY_USER_ID           NUMBER(12),
   LAST_MODIFIED_BY_USER_ID     NUMBER(12),
   REFERRAL_MASTER_STATUS       CHAR(1 BYTE),
   IS_RETRO                     CHAR(1 BYTE),
   IS_CARVE_OUT                 CHAR(1 BYTE),
   INTREPID_CODE                VARCHAR2(20 BYTE),
   CARRIER_ID                   NUMBER(12),
   SPOKE_TO                     VARCHAR2(256 BYTE),
   CD_REQUEST                   CHAR(1 BYTE)         NOT NULL,
   IS_TRANSPORTATION_REQUIRED   CHAR(1 BYTE)         NOT NULL,
   IS_INTERPRETATION_REQUIRED   CHAR(1 BYTE)         NOT NULL,
   NCM_ID                       NUMBER(12),
   REFERRAL_QUEUE_ID            NUMBER(12),
   EXTERNAL_SOURCE_TYPE_ID      NUMBER(12),
   REFERRAL_TYPE_ID             NUMBER(12),
   REFERRAL_SUBTYPE_ID          NUMBER(12),
   REFERRAL_SOURCE_TYPE_ID      NUMBER(12),
   REFERRAL_PRIORITY_ID         NUMBER(12),
   REFERRAL_METHOD_TYPE_ID      NUMBER(12),
   REFERRING_MD_LOCATION_ID     NUMBER(12),
   CASE_MANAGER_ID              NUMBER(12)
)
   TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_REFERRAL_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_REFERRAL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_REFERRAL_MASTER table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_REFERRAL_MASTER
            ON S_REFERRAL_MASTER (REFERRAL_MASTER_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_REFERRAL_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_REFERRAL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_REFERRAL_MASTER index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_MASTER
            ADD CONSTRAINT PK_S_REFERRAL_MASTER
                PRIMARY KEY (REFERRAL_MASTER_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_REFERRAL_MASTER was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_REFERRAL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_REFERRAL_MASTER constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_MASTER
            ADD CONSTRAINT FK_RCASEMASTER_REF_RREFMASTER FOREIGN KEY (CASE_MASTER_ID)
                REFERENCES S_CASE_MASTER(CASE_MASTER_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_RCASEMASTER_REF_RREFMASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK_RCASEMASTER_REF_RREFMASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK_RCASEMASTER_REF_RREFMASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_REFERRAL_MASTER ON S_REFERRAL_MASTER (
            CASE_MASTER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_REFERRAL_MASTER was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_REFERRAL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_REFERRAL_MASTER index:' || SQLERRM);
END;
/

/**************************************************************************
 DDL statements for S_VISIT table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_VISIT 
(
   VISIT_ID                             NUMBER(12)            NOT NULL,
   DUE_DATE                             DATE                  NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   CONFIRMED_WITH_PATIENT               CHAR(1)               NULL,
   REFERRAL_MASTER_ID                   NUMBER(12)            NOT NULL,
   BUSINESS_ID                          NUMBER(12)            NULL,
   PEOPLE_ID                            NUMBER(12)            NULL,
   OCM_REVIEVER_ID                      NUMBER(12)            NULL,
   SERVICE_ID                           NUMBER(12)            NULL,
   CLINICAL_REVIEW_STATUS               VARCHAR2(3)           NULL,
   DONE_DEAL                            CHAR(1)               NULL,
   ACTIVITY_STATUS                      CHAR(1)               NULL,
   SCHEDULED_DATE                       TIMESTAMP(3) WITH TIME ZONE NULL,
   CLINICAL_REVIEW_TYPE                 NUMBER(3)             NULL,
   CO_OWNER_ID                          NUMBER(12)            NULL,
   LAST_VISIT_ID                        NUMBER(12)            NULL,
   INTERPRETATION_CHOICE_ID             NUMBER(12)            NULL,
   TRANSPORTATION_CHOICE_ID             NUMBER(12)            NULL,
   PARENT_BUSINESS_ID                   NUMBER(12)            NULL,
   EXTERNAL_REVIEVER_ID                 NUMBER(12)            NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_VISIT was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_VISIT table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_VISIT
            ON S_VISIT (VISIT_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_VISIT was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_VISIT index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_VISIT
            ADD CONSTRAINT PK_S_VISIT
                PRIMARY KEY (VISIT_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_VISIT was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_VISIT constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_VISIT
            ADD CONSTRAINT FK1_VISIT2REFERRAL_MASTER FOREIGN KEY (REFERRAL_MASTER_ID)
                REFERENCES S_REFERRAL_MASTER(REFERRAL_MASTER_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_VISIT2REFERRAL_MASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_VISIT2REFERRAL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_VISIT2REFERRAL_MASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_VISIT ON S_VISIT (
            REFERRAL_MASTER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_VISIT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_VISIT index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_VISIT
            ADD CONSTRAINT FK2_VISIT2PEOPLE FOREIGN KEY (PEOPLE_ID)
                REFERENCES S_PEOPLE(PEOPLE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_VISIT2PEOPLE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_VISIT2PEOPLE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK2_VISIT2PEOPLE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_VISIT ON S_VISIT (
            PEOPLE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_VISIT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_VISIT index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_VISIT
            ADD CONSTRAINT FK3_VISIT2BUSINESS FOREIGN KEY (BUSINESS_ID)
                REFERENCES S_BUSINESS(BUSINESS_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_VISIT2BUSINESS was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_VISIT2BUSINESS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK3_VISIT2BUSINESS constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK3_S_VISIT ON S_VISIT (
            BUSINESS_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_VISIT was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK3_S_VISIT index:' || SQLERRM);
END;
/



/**************************************************************************
 DDL statements for S_BILL_MASTER table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_BILL_MASTER 
(
   BILL_MASTER_ID                       NUMBER(12)            NOT NULL,
   HCFA_RECEIVED_DATE                   DATE                  NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   RETRO_REFERRAL                       CHAR(1)               NULL,
   SPLIT_BILL                           CHAR(1)               NULL,
   BILL_CODE                            VARCHAR2(32)          NULL,
   VISIT_ID                             NUMBER(12)            NULL,
   AR_BILL_STATUS                       CHAR(1)               NULL,
   AP_BILL_STATUS                       CHAR(1)               NULL,
   SPLIT_PAYER                          CHAR(1)               NULL,
   BILLING_LOCATION_ID                  NUMBER(12)            NULL,
   DIM_BILL_ID                          NUMBER(12)            NULL,
   NOTE_ID                              NUMBER(12)            NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_BILL_MASTER table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_BILL_MASTER
            ON S_BILL_MASTER (BILL_MASTER_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_MASTER was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_BILL_MASTER index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_MASTER
            ADD CONSTRAINT PK_S_BILL_MASTER
                PRIMARY KEY (BILL_MASTER_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_MASTER was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_BILL_MASTER constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_MASTER
            ADD CONSTRAINT FK1_BILL_MASTER2VISIT FOREIGN KEY (VISIT_ID)
                REFERENCES S_VISIT(VISIT_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_MASTER2VISIT was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_MASTER2VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_BILL_MASTER2VISIT constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_BILL_MASTER ON S_BILL_MASTER (
            VISIT_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_MASTER was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_BILL_MASTER index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_REFERRAL_DETAIL table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_REFERRAL_DETAIL 
(
   RELEASE_TO_BILLING_DATE              DATE                  NULL,
   REFERRAL_DETAIL_ID                   NUMBER(12)            NOT NULL,
   VISIT_ID                             NUMBER(12)            NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   PACKAGE_ID                           NUMBER(12)            NULL,
   REFERRAL_LINE_NUMBER                 NUMBER(15)            NULL,
   REFERRAL_MASTER_ID                   NUMBER(12)            NULL,
   REASON_ID                            NUMBER(12)            NULL,
   CLAIM_RESOLUTION_TYPE_ID             NUMBER(12)            NULL,
   REFERRAL_DETAIL_STATUS               CHAR(1)               NULL,
   CREATED_BY_USER_ID                   NUMBER(12)            NULL,
   LAST_MODIFIED_BY_USER_ID             NUMBER(12)            NULL,
   DATE_OF_SERVICE                      DATE                  NULL,
   FEE_NEGOTIATION                      CHAR(1)               NULL,
   PEOPLE_ID                            NUMBER(12)            NULL,
   AGING_SOURCE_ID                      NUMBER(12)            NULL,
   AGED_NOTE                            VARCHAR2(256)         NULL,
   AGING_REVIEWER_ID                    NUMBER(12)            NULL,
   AGING_METHOD_ID                      NUMBER(12)            NULL,
   AGING_OUTCOME_ID                     NUMBER(12)            NULL,
   AGING_EXT_REVIEWER_ID                NUMBER(12)            NULL,
   AGING_STATUS                         CHAR(1)               NULL,
   AGING_DATE                           DATE                  NULL,
   MR_STATUS                            CHAR(1)               NULL,
   MR_POSTED_DATE                       DATE                  NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_REFERRAL_DETAIL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_REFERRAL_DETAIL table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_REFERRAL_DETAIL
            ON S_REFERRAL_DETAIL (REFERRAL_DETAIL_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_REFERRAL_DETAIL was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_REFERRAL_DETAIL index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_DETAIL
            ADD CONSTRAINT PK_S_REFERRAL_DETAIL
                PRIMARY KEY (REFERRAL_DETAIL_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_REFERRAL_DETAIL was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_REFERRAL_DETAIL constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_DETAIL
            ADD CONSTRAINT FK1_REF_DETAIL2REF_MASTER FOREIGN KEY (REFERRAL_MASTER_ID)
                REFERENCES S_REFERRAL_MASTER(REFERRAL_MASTER_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_REF_DETAIL2REF_MASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_REF_DETAIL2REF_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_REF_DETAIL2REF_MASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_REFERRAL_DETAIL ON S_REFERRAL_DETAIL (
            REFERRAL_MASTER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_REFERRAL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_REFERRAL_DETAIL index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_DETAIL
            ADD CONSTRAINT FK2_REFERRAL_DETAIL2PEOPLE FOREIGN KEY (PEOPLE_ID)
                REFERENCES S_PEOPLE(PEOPLE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_REFERRAL_DETAIL2PEOPLE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_REFERRAL_DETAIL2PEOPLE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK2_REFERRAL_DETAIL2PEOPLE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_REFERRAL_DETAIL ON S_REFERRAL_DETAIL (
            PEOPLE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_REFERRAL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_REFERRAL_DETAIL index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_REFERRAL_DETAIL
            ADD CONSTRAINT FK3_REFERRAL_DETAIL2VISIT FOREIGN KEY (VISIT_ID)
                REFERENCES S_VISIT(VISIT_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_REFERRAL_DETAIL2VISIT was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_REFERRAL_DETAIL2VISIT already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK3_REFERRAL_DETAIL2VISIT constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK3_S_REFERRAL_DETAIL ON S_REFERRAL_DETAIL (
            VISIT_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_REFERRAL_DETAIL was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_REFERRAL_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK3_S_REFERRAL_DETAIL index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_BILL_PACKAGE table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_BILL_PACKAGE 
(
   BILL_PACKAGE_ID                      NUMBER(12)            NOT NULL,
   BILL_PACKAGE_STATUS                  CHAR(1)               NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   PROV_CHANGE_BILL_PACKAGE_ID          NUMBER(12)            NULL,   
   PACKAGE_ID                           NUMBER(12)            NULL,
   REFERRAL_DETAIL_ID                   NUMBER(12)            NULL,
   BILL_MASTER_ID                       NUMBER(12)            NULL

)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_BILL_PACKAGE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_BILL_PACKAGE table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_BILL_PACKAGE
            ON S_BILL_PACKAGE (BILL_PACKAGE_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_PACKAGE was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_BILL_PACKAGE index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_PACKAGE
            ADD CONSTRAINT PK_S_BILL_PACKAGE
                PRIMARY KEY (BILL_PACKAGE_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_PACKAGE was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_BILL_PACKAGE constraint:' || SQLERRM);
END;
/



-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_PACKAGE
            ADD CONSTRAINT FK1_BILL_PACKAGE2BILL_MASTER FOREIGN KEY (BILL_MASTER_ID)
                REFERENCES S_BILL_MASTER (BILL_MASTER_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_PACKAGE2BILL_MASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_PACKAGE2BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_BILL_PACKAGE2BILL_MASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_BILL_PACKAGE ON S_BILL_PACKAGE (
            BILL_MASTER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_PACKAGE was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_BILL_PACKAGE index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_PACKAGE
            ADD CONSTRAINT FK2_BILL_PACKAGE2REF_DETAIL FOREIGN KEY (REFERRAL_DETAIL_ID)
                REFERENCES S_REFERRAL_DETAIL (REFERRAL_DETAIL_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_BILL_PACKAGE2REF_DETAIL was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_BILL_PACKAGE2REF_DETAIL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK2_BILL_PACKAGE2REF_DETAIL constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_BILL_PACKAGE ON S_BILL_PACKAGE (
            REFERRAL_DETAIL_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_BILL_PACKAGE was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_BILL_PACKAGE index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_BILL_ITEM table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_BILL_ITEM 
(
   BILL_ITEM_ID                         NUMBER(12)            NOT NULL,
   INTREPID_CODE                        VARCHAR2(20)          NULL,
   AP_TECH_STATUS                       CHAR(1)               NULL,
   AP_PROF_STATUS                       CHAR(1)               NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   PAYER_AMOUNT                         NUMBER(8, 2)          NULL,
   HCFA_AMOUNT                          NUMBER(8, 2)          NULL,
   PROVIDER_AMOUNT                      NUMBER(8, 2)          NULL,
   MARGIN_AMOUNT                        NUMBER(8, 2)          NULL,
   COST_SAVING_AMOUNT                   NUMBER(8, 2)          NULL,
   ACCELERATED_FLAG                     CHAR(1)               NULL,
   AR_STATUS                            CHAR(1)               NULL,
   IS_BILLED                            CHAR(1)               NULL,
   CONTRACT_STATUS                      CHAR(1)               NULL,      
   BILL_PACKAGE_ID                      NUMBER(12)            NULL,
   ADMIN_BROKER_AMOUNT                  NUMBER(8, 2)          NULL,
   TOTAL_PAYER_AMOUNT                   NUMBER(8, 2)          NULL,
   BILLING_REASON_ID                    NUMBER(12)            NULL,
   DISALLOW_ID                          NUMBER(12)            NULL,
   RR_BUSINESS_ID                       NUMBER(12)            NULL,
   RESENT_TYPE_ID                       NUMBER(12)            NULL,
   NOTE_ID                              NUMBER(12)            NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_ITEM was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_BILL_ITEM table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_BILL_ITEM
            ON S_BILL_ITEM (BILL_ITEM_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_ITEM was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_BILL_ITEM index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_ITEM
            ADD CONSTRAINT PK_S_BILL_ITEM
                PRIMARY KEY (BILL_ITEM_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_ITEM was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_BILL_ITEM constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_ITEM
            ADD CONSTRAINT FK1_BILL_ITEM2BILL_PACKAGE FOREIGN KEY (BILL_PACKAGE_ID)
                REFERENCES S_BILL_PACKAGE(BILL_PACKAGE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_ITEM2BILL_PACKAGE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_ITEM2BILL_PACKAGE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_BILL_ITEM2BILL_PACKAGE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_BILL_ITEM ON S_BILL_ITEM (
            BILL_PACKAGE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_BILL_ITEM index:' || SQLERRM);
END;
/


/**************************************************************************
 DDL statements for S_HCFA_BILL_ITEM table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_HCFA_BILL_ITEM 
(
   HCFA_BILL_ITEM_ID                    NUMBER(12)            NOT NULL,
   BILL_ITEM_ID                         NUMBER(12)            NULL,
   HCFA_CPT_CODE_ID                     NUMBER(12)            NULL,
   HCFA_TECH_MODIFIER_ID                NUMBER(12)            NULL,
   HCFA_PROF_MODIFIER_ID                NUMBER(12)            NULL,
   HCFA_PROF_RECEIVED_DATE              DATE                  NULL,
   HCFA_TECH_RECEIVED_DATE              DATE                  NULL,
   HCFA_TECH_START_DATE                 DATE                  NULL,
   HCFA_TECH_END_DATE                   DATE                  NULL,
   HCFA_TECH_PATIENT_ACCOUNT            VARCHAR2(32)          NULL,
   HCFA_PROF_PATIENT_ACCOUNT            VARCHAR2(32)          NULL,
   HCFA_TECH_AMOUNT                     NUMBER(8, 2)          NULL,
   HCFA_PROF_START_DATE                 DATE                  NULL,
   HCFA_PROF_END_DATE                   DATE                  NULL,
   HCFA_PROF_AMOUNT                     NUMBER(8, 2)          NULL,
   HCFA_TOTAL_AMOUNT                    NUMBER(8, 2)          NULL,
   CREATED_BY                           VARCHAR2(256)         NULL,
   CREATION_DATE                        DATE                  NULL,
   LAST_MODIFIED_BY                     VARCHAR2(256)         NULL,
   LAST_MODIFICATION_DATE               DATE                  NULL,
   TECH_PLACE_OF_SERVICE_ID             NUMBER(12)            NULL,
   TECH_TYPE_OF_SERVICE_ID              NUMBER(12)            NULL,
   PROF_TYPE_OF_SERVICE_ID              NUMBER(12)            NULL,
   PROF_PLACE_OF_SERVICE_ID             NUMBER(12)            NULL,
   ORIGINAL_HCFA_TECH_AMOUNT            NUMBER(8, 2)          NULL,  
   ORIGINAL_HCFA_PROF_AMOUNT            NUMBER(8, 2)          NULL,
   FACT_HCFA_TECH_FACT_ID               NUMBER(12)            NULL,
   FACT_HCFA_PROF_FACT_ID               NUMBER(12)            NULL,
   STG_ETL_ID                           NUMBER(12)            NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE(    '[INFO]: Table S_HCFA_BILL_ITEM was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_HCFA_BILL_ITEM table:' || SQLERRM);
END;
/

-- Primary key
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XPK_S_HCFA_BILL_ITEM
            ON S_HCFA_BILL_ITEM (HCFA_BILL_ITEM_ID)
                TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_HCFA_BILL_ITEM was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XPK_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XPK_S_HCFA_BILL_ITEM index:' || SQLERRM);
        
END;
/

DECLARE
    E_PRIMARY_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_PRIMARY_KEY_EXISTS, -02260);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT PK_S_HCFA_BILL_ITEM
                PRIMARY KEY (HCFA_BILL_ITEM_ID)
                    USING INDEX
                    TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_PRIMARY_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint PK_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of PK_S_HCFA_BILL_ITEM constraint:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT FK1_HCFA_BILL_ITEM2CODE FOREIGN KEY (HCFA_CPT_CODE_ID)
                REFERENCES S_CODE(CODE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_HCFA_BILL_ITEM2CODE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_HCFA_BILL_ITEM2CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_HCFA_BILL_ITEM2CODE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_HCFA_BILL_ITEM ON S_HCFA_BILL_ITEM (
            HCFA_CPT_CODE_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_HCFA_BILL_ITEM index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT FK2_HCFA_BILL_ITEM2CODE FOREIGN KEY (HCFA_PROF_MODIFIER_ID)
                REFERENCES S_CODE(CODE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_HCFA_BILL_ITEM2CODE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_HCFA_BILL_ITEM2CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK2_HCFA_BILL_ITEM2CODE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_HCFA_BILL_ITEM ON S_HCFA_BILL_ITEM (
            HCFA_PROF_MODIFIER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_HCFA_BILL_ITEM index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT FK3_HCFA_BILL_ITEM2CODE FOREIGN KEY (HCFA_TECH_MODIFIER_ID)
                REFERENCES S_CODE(CODE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_HCFA_BILL_ITEM2CODE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_HCFA_BILL_ITEM2CODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK3_HCFA_BILL_ITEM2CODE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK3_S_HCFA_BILL_ITEM ON S_HCFA_BILL_ITEM (
            HCFA_TECH_MODIFIER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK3_S_HCFA_BILL_ITEM index:' || SQLERRM);
END;
/


-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT FK4_HCFA_BILL_BILL_ITEM FOREIGN KEY (BILL_ITEM_ID)
                REFERENCES S_BILL_ITEM(BILL_ITEM_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK4_HCFA_BILL_BILL_ITEM was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK4_HCFA_BILL_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK4_HCFA_BILL_BILL_ITEM constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK4_S_HCFA_BILL_ITEM ON S_HCFA_BILL_ITEM (
            BILL_ITEM_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK4_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK4_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK4_S_HCFA_BILL_ITEM index:' || SQLERRM);
END;
/


-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_HCFA_BILL_ITEM
            ADD CONSTRAINT FK5_HCFA_BILL_ITEM2STG_ETL FOREIGN KEY (STG_ETL_ID)
                REFERENCES R_STG_ETL(STG_ETL_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK5_HCFA_BILL_ITEM2STG_ETL was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK5_HCFA_BILL_ITEM2STG_ETL already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK5_HCFA_BILL_ITEM2STG_ETL constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK5_S_HCFA_BILL_ITEM ON S_HCFA_BILL_ITEM (
            STG_ETL_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK5_S_HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK5_S_HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK5_S_HCFA_BILL_ITEM index:' || SQLERRM);
END;
/

/**************************************************************************
 DDL statements for S_BILL_TO_DIAGNOSIS table
**************************************************************************/
DECLARE
    E_OBJECT_EXISTS       EXCEPTION;
    PRAGMA EXCEPTION_INIT (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
CREATE TABLE S_BILL_TO_DIAGNOSIS 
(
   BILL_MASTER_ID                       NUMBER(12)            NOT NULL,
   DIAGNOSIS_ID                         NUMBER(12)            NOT NULL,
   HCFA_BILL_ITEM_ID                    NUMBER(12)            NULL,
   ROW_ORDER                            NUMBER(3)             NULL
)
    TABLESPACE PHOENIXDATA';

    DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_TO_DIAGNOSIS was created');
EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: Table S_BILL_TO_DIAGNOSIS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of S_BILL_TO_DIAGNOSIS table:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_TO_DIAGNOSIS
            ADD CONSTRAINT FK1_BILL_TO_DIAG2BILL_MASTER FOREIGN KEY (BILL_MASTER_ID)
                REFERENCES S_BILL_MASTER (BILL_MASTER_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_TO_DIAG2BILL_MASTER was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK1_BILL_TO_DIAG2BILL_MASTER already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK1_BILL_TO_DIAG2BILL_MASTER constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK1_S_BILL_TO_DIAGNOSIS ON S_BILL_TO_DIAGNOSIS (
            BILL_MASTER_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_TO_DIAGNOSIS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK1_S_BILL_TO_DIAGNOSIS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK1_S_BILL_TO_DIAGNOSIS index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_TO_DIAGNOSIS
            ADD CONSTRAINT FK2_BILLTODIAG2HCFABILLITEM FOREIGN KEY (HCFA_BILL_ITEM_ID)
                REFERENCES S_HCFA_BILL_ITEM (HCFA_BILL_ITEM_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_BILL_TO_DIAG2HCFA_BILL_ITEM was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK2_BILL_TO_DIAG2HCFA_BILL_ITEM already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK2_BILL_TO_DIAG2HCFA_BILL_ITEM constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK2_S_BILL_TO_DIAGNOSIS ON S_BILL_TO_DIAGNOSIS (
            HCFA_BILL_ITEM_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_BILL_TO_DIAGNOSIS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK2_S_BILL_TO_DIAGNOSIS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK2_S_BILL_TO_DIAGNOSIS index:' || SQLERRM);
END;
/

-- Foreign key
DECLARE
    E_FOREIGN_KEY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_FOREIGN_KEY_EXISTS, -02275);
BEGIN
    EXECUTE IMMEDIATE '
        ALTER TABLE S_BILL_TO_DIAGNOSIS
            ADD CONSTRAINT FK3_BILL_TO_DIAG2MCODE FOREIGN KEY (DIAGNOSIS_ID)
                REFERENCES S_CODE (CODE_ID)';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_BILL_TO_DIAG2MCODE was created');

EXCEPTION
    WHEN E_FOREIGN_KEY_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Constraint FK3_BILL_TO_DIAG2MCODE already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of FK3_BILL_TO_DIAG2MCODE constraint:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE INDEX XFK3_S_BILL_TO_DIAGNOSIS ON S_BILL_TO_DIAGNOSIS (
            DIAGNOSIS_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_BILL_TO_DIAGNOSIS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XFK3_S_BILL_TO_DIAGNOSIS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XFK3_S_BILL_TO_DIAGNOSIS index:' || SQLERRM);
END;
/

-- Index
DECLARE
    E_OBJECT_EXISTS        EXCEPTION;
    PRAGMA EXCEPTION_INIT  (E_OBJECT_EXISTS, -00955);
BEGIN
    EXECUTE IMMEDIATE '
        CREATE UNIQUE INDEX XAK1_S_BILL_TO_DIAGNOSIS ON S_BILL_TO_DIAGNOSIS (
            BILL_MASTER_ID, 
            DIAGNOSIS_ID,
            HCFA_BILL_ITEM_ID
        )
        TABLESPACE PHOENIXINDEX';

    DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XAK1_S_BILL_TO_DIAGNOSIS was created');

EXCEPTION
    WHEN E_OBJECT_EXISTS
    THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO]: Index XAK1_S_BILL_TO_DIAGNOSIS already exists');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR]: Error during creation of XAK1_S_BILL_TO_DIAGNOSIS index:' || SQLERRM);
END;
/
