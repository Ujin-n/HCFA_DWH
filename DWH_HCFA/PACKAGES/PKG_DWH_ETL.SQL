CREATE OR REPLACE PACKAGE         PKG_DWH_ETL IS
/****************************************************************************
 NAME:      PKG_DWH_ETL
 PURPOSE:   
*****************************************************************************/

    /**********************/
    /** Public constants **/
    /**********************/
    C$V_UNKNOWN_STRING                      CONSTANT VARCHAR2(7) := 'UNKNOWN';
    C$V_UNKNOWN_DATE                        CONSTANT DATE         := TO_DATE('01/01/0001', 'MM/DD/YYYY');
    C$V_DEFAULT_VALUE_KEY                   CONSTANT PLS_INTEGER  := 1;

    -- Process Statuses
    C$C_INITIAL_JOB_STATUS                  R_DWH_ETL.DWH_ETL_STATUS%TYPE := 'I';
    C$C_PROCESSING_JOB_STATUS               R_DWH_ETL.DWH_ETL_STATUS%TYPE := 'P';
    C$C_SUCCESS_JOB_STATUS                  R_DWH_ETL.DWH_ETL_STATUS%TYPE := 'S';
    C$C_ERROR_JOB_STATUS                    R_DWH_ETL.DWH_ETL_STATUS%TYPE := 'E';

    -- Detail Statuses
    C$C_INITIAL_ITEM_STATUS                 R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE := 'I';
    C$C_PROCESSING_ITEM_STATUS              R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE := 'P';
    C$C_SUCCESS_ITEM_STATUS                 R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE := 'S';
    C$C_ERROR_ITEM_STATUS                   R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE := 'E';

    C$V_HCFA_TECH_DESC                      CONSTANT VARCHAR2(4) := 'TECH';
    C$V_HCFA_PROF_DESC                      CONSTANT VARCHAR2(4) := 'PROF';

 
    /***********************/
    /** Public procedures **/
    /***********************/
    PROCEDURE SP_ETL_ENTRY_POINT (
        PDI_ETL_PROCESS_DATE                  IN     R_DWH_ETL.DWH_ETL_PROCESS_DATE%TYPE        
    );
    
    PROCEDURE SP_ETL_LOG (
        PNIO_DWH_ETL_ID                       IN OUT R_DWH_ETL.DWH_ETL_ID%TYPE,
        PVI_DWH_ETL_STATUS                    IN     R_DWH_ETL.DWH_ETL_STATUS%TYPE,
        PDI_DWH_ETL_PROCESS_DATE              IN     R_DWH_ETL.DWH_ETL_PROCESS_DATE%TYPE
    );

    PROCEDURE SP_ETL_DETAIL_LOG (PNIO_DWH_ETL_DETAIL_ID             IN OUT R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE,
                                 PNI_DWH_ETL_ID                     IN     R_DWH_ETL_DETAIL.DWH_ETL_ID%TYPE,
                                 PVI_DWH_ETL_DETAIL_STATUS          IN     R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE,
                                 PVI_DWH_ETL_MODULE                 IN     R_DWH_ETL_DETAIL.DWH_ETL_MODULE%TYPE,
                                 PVI_MESSAGE                        IN     R_DWH_ETL_DETAIL.MESSAGE%TYPE);

END PKG_DWH_ETL;
/



CREATE OR REPLACE PACKAGE BODY      PKG_DWH_ETL
AS

    PROCEDURE SP_ETL_LOG (
    /****************************************************************************
      NAME:      SP_ETL_LOG
      PURPOSE:   Logging the process of filling DWH
    *****************************************************************************/
      PNIO_DWH_ETL_ID            IN OUT R_DWH_ETL.DWH_ETL_ID%TYPE,
      PVI_DWH_ETL_STATUS         IN     R_DWH_ETL.DWH_ETL_STATUS%TYPE,
      PDI_DWH_ETL_PROCESS_DATE   IN     R_DWH_ETL.DWH_ETL_PROCESS_DATE%TYPE
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        C$V_PROCEDURE                 CONSTANT VARCHAR2 (256) := 'PKG_DWH_ETL.SP_ETL_LOG';
    BEGIN
    
        IF PNIO_DWH_ETL_ID IS NULL 
        THEN
            INSERT INTO R_DWH_ETL(
                DWH_ETL_ID,        
                DWH_ETL_STATUS,        
                DWH_ETL_PROCESS_DATE,        
                DWH_ETL_PROCESS_START_DATE,        
                DWH_ETL_PROCESS_END_DATE)
            VALUES(
                SEQ_DWH_ETL.NEXTVAL,
                PVI_DWH_ETL_STATUS,
                PDI_DWH_ETL_PROCESS_DATE,
                SYSDATE,
                NULL)
            RETURNING 
                DWH_ETL_ID
            INTO
                PNIO_DWH_ETL_ID;                                
                
        ELSE
            UPDATE R_DWH_ETL
               SET DWH_ETL_STATUS = PVI_DWH_ETL_STATUS,
                   DWH_ETL_PROCESS_END_DATE = SYSDATE
             WHERE DWH_ETL_ID = PNIO_DWH_ETL_ID;
             
        END IF;
        
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS 
        THEN ROLLBACK; 
          PNIO_DWH_ETL_ID := NULL; -- 12/30/2015 - AC: Processing of general errors should be elaborated.
      
    END SP_ETL_LOG;
    
    
    PROCEDURE SP_ETL_DETAIL_LOG (
    /****************************************************************************
      NAME:      SP_ETL_DETAIL_LOG
      PURPOSE:   Logging the process of filling DWH
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
    *****************************************************************************/     
        PNIO_DWH_ETL_DETAIL_ID             IN OUT R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE,
        PNI_DWH_ETL_ID                     IN     R_DWH_ETL_DETAIL.DWH_ETL_ID%TYPE,
        PVI_DWH_ETL_DETAIL_STATUS          IN     R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_STATUS%TYPE,
        PVI_DWH_ETL_MODULE                 IN     R_DWH_ETL_DETAIL.DWH_ETL_MODULE%TYPE,
        PVI_MESSAGE                        IN     R_DWH_ETL_DETAIL.MESSAGE%TYPE
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        C$V_PROCEDURE                 CONSTANT VARCHAR2 (256) := 'PKG_DWH_ETL.SP_ETL_DETAIL_LOG';
    BEGIN
        
        IF PNIO_DWH_ETL_DETAIL_ID IS NULL
        THEN
            INSERT INTO R_DWH_ETL_DETAIL (
                DWH_ETL_DETAIL_ID,        
                DWH_ETL_ID,        
                DWH_ETL_DETAIL_STATUS,        
                DWH_ETL_DETAIL_STEP_START_DATE,        
                DWH_ETL_DETAIL_STEP_END_DATE,
                DWH_ETL_MODULE,
                MESSAGE)        
            VALUES ( 
                SEQ_DWH_ETL_DETAIL.NEXTVAL,
                PNI_DWH_ETL_ID, 
                PVI_DWH_ETL_DETAIL_STATUS,
                SYSDATE,
                NULL, 
                PVI_DWH_ETL_MODULE, 
                PVI_MESSAGE)
            RETURNING 
                DWH_ETL_DETAIL_ID
            INTO
                PNIO_DWH_ETL_DETAIL_ID;                                

        ELSE
            
            UPDATE R_DWH_ETL_DETAIL
               SET DWH_ETL_DETAIL_STATUS = PVI_DWH_ETL_DETAIL_STATUS,
                   DWH_ETL_DETAIL_STEP_END_DATE = SYSDATE,
                   DWH_ETL_MODULE = PVI_DWH_ETL_MODULE,
                   MESSAGE = PVI_MESSAGE
             WHERE DWH_ETL_DETAIL_ID = PNIO_DWH_ETL_DETAIL_ID;      
               
        END IF;
        
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS
        THEN ROLLBACK;
          PNIO_DWH_ETL_DETAIL_ID := NULL;
          
    END SP_ETL_DETAIL_LOG;

    
    PROCEDURE SP_ETL_DATE (
    /****************************************************************************
      NAME:      SP_ETL_DATE
      PURPOSE:   Processing of DIM_DATE
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      1.0.0.1    1/14/2016    Yauheni Neshyn     Created
    *****************************************************************************/
        PDI_DATE_NAME                   IN      DIM_DATE.DATE_NAME%TYPE,
        PNI_DWH_ETL_ID                  IN      R_DWH_ETL.DWH_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER,
        PNO_DATE_ID                     OUT     DIM_DATE.DATE_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_DATE';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        N_DATE_DATA_EXISTS             PLS_INTEGER;
        
        N_DATE_FULL_DESC               DIM_DATE.DATE_FULL_DESC%TYPE;
        N_DAY_OF_WEEK_NAME             DIM_DATE.DAY_OF_WEEK_NAME%TYPE;
        N_DAY_NUMBER_IN_MONTH          DIM_DATE.DAY_NUMBER_IN_MONTH%TYPE;       
        N_LAST_DATE_MONTH_FLAG_DESC    DIM_DATE.LAST_DATE_MONTH_FLAG_DESC%TYPE;
        N_WEEK_NUM_IN_YEAR             DIM_DATE.WEEK_NUM_IN_YEAR%TYPE;
        N_MONTH_NAME                   DIM_DATE.MONTH_NAME%TYPE;
        N_MONTH_NUM_IN_YEAR            DIM_DATE.MONTH_NUM_IN_YEAR%TYPE;
        N_YEAR                         DIM_DATE.YEAR%TYPE;
        N_YEAR_MONTH_DESC              DIM_DATE.YEAR_MONTH_DESC%TYPE;
        N_HOLIDAY_FLAG                 DIM_DATE.HOLIDAY_FLAG%TYPE;
        N_WEEKDAY_FLAG                 DIM_DATE.WEEKDAY_FLAG%TYPE;
          
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PDI_DATE_NAME=' || PDI_DATE_NAME
        );
        
        SELECT DD.DATE_ID
          INTO PNO_DATE_ID
          FROM DIM_DATE DD
         WHERE DD.DATE_NAME = PDI_DATE_NAME;
        
        IF PNO_DATE_ID IS NOT NULL
        THEN
            SP_ETL_DETAIL_LOG (
                  PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                  PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                  PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                  PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                  PVI_MESSAGE                             => 'DATE_NAME=' || PDI_DATE_NAME || ' has already existed in DIM_DATE'
              );
          
            PNO_STATUS := 1;
          
            RETURN;
        END IF;
        
        /* DIM_DATE ATRIBUTES FORMATION */
        N_DATE_FULL_DESC := TO_CHAR(PDI_DATE_NAME, 'MONTHDD,YYYY');
        N_DAY_OF_WEEK_NAME := TO_CHAR(PDI_DATE_NAME, 'DAY');
        N_DAY_NUMBER_IN_MONTH := TO_NUMBER(TO_CHAR(PDI_DATE_NAME, 'DD'));
        
        IF LAST_DAY(PDI_DATE_NAME) = PDI_DATE_NAME
        THEN
            N_LAST_DATE_MONTH_FLAG_DESC := 'MONTH END';
        ELSE
            N_LAST_DATE_MONTH_FLAG_DESC := 'NOT MONTH END';
        END IF;
        
        N_WEEK_NUM_IN_YEAR := TO_NUMBER(TO_CHAR(PDI_DATE_NAME, 'WW'));
        N_MONTH_NAME := TRIM(BOTH ' ' FROM TO_CHAR(PDI_DATE_NAME, 'MONTH'));
        N_MONTH_NUM_IN_YEAR := TO_NUMBER(TO_CHAR(PDI_DATE_NAME, 'MM'));
        N_YEAR := TO_NUMBER(TO_CHAR(PDI_DATE_NAME, 'YYYY'));
        N_YEAR_MONTH_DESC := TO_CHAR(PDI_DATE_NAME, 'YYYYMM');
        
        IF TO_CHAR(PDI_DATE_NAME,'DD.MM') IN ('01.01','07.01', '08.03', '01.05', '09.05', '03.07', '07.11', '25.12')
        THEN
            N_HOLIDAY_FLAG := 'HOLIDAY';
        ELSE
            N_HOLIDAY_FLAG := 'NON-HOLIDAY';
        END IF;
        
        IF TO_CHAR(PDI_DATE_NAME,'FMDAY') IN ('SATURDAY', 'SUNDAY')
        THEN
            N_WEEKDAY_FLAG := 'WEEKEND';
        ELSE
            N_WEEKDAY_FLAG := 'WORKING DAY';
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
        VALUES (
            SEQ_DIM_DATE.NEXTVAL,
            PDI_DATE_NAME,
            N_DATE_FULL_DESC,
            N_DAY_OF_WEEK_NAME,
            N_DAY_NUMBER_IN_MONTH,
            N_LAST_DATE_MONTH_FLAG_DESC,
            N_WEEK_NUM_IN_YEAR,
            N_MONTH_NAME,
            N_MONTH_NUM_IN_YEAR,
            N_YEAR,
            N_YEAR_MONTH_DESC,
            N_HOLIDAY_FLAG,
            N_WEEKDAY_FLAG);
        
        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'DATE_NAME' || PDI_DATE_NAME || ' has been loaded to DIM_DATE'
        );
        
        PNO_STATUS := 1;
               
    EXCEPTION
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of DATE = ' || PDI_DATE_NAME
            );
      
    END SP_ETL_DATE;


    PROCEDURE SP_ETL_PATIENT (
    /****************************************************************************
      NAME:      SP_ETL_PATIENT
      PURPOSE:   Processing of DIM_PATIENT
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
     
    *****************************************************************************/
        PNI_STG_PATIENT_ID                  IN      S_PEOPLE.PEOPLE_ID%TYPE,
        PNI_DIM_PATIENT_ID                  IN      S_PEOPLE.DIM_PATIENT_ID%TYPE,
        PNI_CASE_MASTER_ID                  IN      S_CASE_MASTER.CASE_MASTER_ID%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PNO_DWH_PATIENT_ID                  OUT     DIM_PATIENT.PATIENT_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_PATIENT';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        C_PATIENT_DATA                 DIM_PATIENT%ROWTYPE;
        N_PATIENT_EXISTS               PLS_INTEGER;
        
    BEGIN
        
        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_STG_PATIENT_ID=' || PNI_STG_PATIENT_ID
        );
        
        IF PNI_DIM_PATIENT_ID IS NULL
        THEN
            SELECT COUNT(*)
              INTO N_PATIENT_EXISTS
              FROM S_PEOPLE PE
              JOIN S_CASE_MASTER SCM ON ( SCM.PATIENT_ID = PE.PEOPLE_ID )
             WHERE PE.DIM_PATIENT_ID IS NULL
               AND PE.PEOPLE_ID = PNI_STG_PATIENT_ID
               AND SCM.CASE_MASTER_ID = PNI_CASE_MASTER_ID;
            
            IF N_PATIENT_EXISTS > 0
            THEN
                SELECT NULL,
                       PE.SOCIAL_SECURITY_NUMBER AS PATIENT_SSN,
                       SCM.CLAIM_NUMBER          AS PATIENT_CLAIM_NUMBER,
                       PE.GENDER                 AS PATIENT_GENDER,
                       PE.LAST_NAME              AS PATIENT_LAST_NAME,
                       PE.FIRST_NAME             AS PATIENT_FIRST_NAME,
                       PE.MIDDLE_NAME            AS PATIENT_MIDDLE_NAME,
                       PE.FULL_NAME              AS PATIENT_FULL_NAME,
                       PE.BIRTH_DATE             AS PATIENT_BIRTHDATE,
                       SA.ADDRESS1               AS PATIENT_ADDRESS_1,
                       SA.ADDRESS2               AS PATIENT_ADDRESS_2,
                       NULL                      AS PATIENT_CITY, -- SA.CITY, -- 1/20/2016 - AC IT SHOULD BE FIXED IN THE STAGING!!! 
                       SA.STATE_CODE             AS PATIENT_STATE,
                       SA.ZIP_PLUS_FOUR          AS PATIENT_ZIP_CODE,
                       SC.PHONE_NUMBER           AS PATIENT_MOBILE_PHONE_NUM
                  INTO C_PATIENT_DATA
                  FROM S_PEOPLE PE 
                       LEFT JOIN S_ADDRESS SA ON ( SA.PEOPLE_ID = PE.PEOPLE_ID )
                       LEFT JOIN S_CONTACT SC ON ( SC.PEOPLE_ID = PE.PEOPLE_ID )
                       JOIN S_CASE_MASTER SCM ON ( SCM.PATIENT_ID = PE.PEOPLE_ID )
                 WHERE PE.PEOPLE_ID = PNI_STG_PATIENT_ID
                   AND SCM.CASE_MASTER_ID = PNI_CASE_MASTER_ID;
                 
                INSERT INTO DIM_PATIENT(PATIENT_ID, 
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
                                        PATIENT_MOBILE_PHONE_NUM
                                        )
                                VALUES (SEQ_DIM_PATIENT.NEXTVAL, 
                                        NVL(C_PATIENT_DATA.PATIENT_SSN, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_CLAIM_NUMBER, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_GENDER, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_LAST_NAME, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_FIRST_NAME, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_MIDDLE_NAME, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_FULL_NAME, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_BIRTHDATE, C$V_UNKNOWN_DATE), 
                                        NVL(C_PATIENT_DATA.PATIENT_ADDRESS_1, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_ADDRESS_2, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_CITY, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_STATE, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_ZIP_CODE, C$V_UNKNOWN_STRING), 
                                        NVL(C_PATIENT_DATA.PATIENT_MOBILE_PHONE_NUM, C$V_UNKNOWN_STRING)
                                        )
                           RETURNING PATIENT_ID INTO PNO_DWH_PATIENT_ID;
                
                UPDATE S_PEOPLE PE
                   SET PE.DIM_PATIENT_ID = PNO_DWH_PATIENT_ID
                 WHERE PE.PEOPLE_ID = PNI_STG_PATIENT_ID;
                 
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'PATIENT_ID=' || PNO_DWH_PATIENT_ID || ' has been loaded to DIM_PATIENT'
                );
                
                PNO_STATUS := 1;
            ELSE

                SELECT DIM_PATIENT_ID
                  INTO PNO_DWH_PATIENT_ID
                  FROM S_PEOPLE PE
                  JOIN S_CASE_MASTER SCM ON ( SCM.PATIENT_ID = PE.PEOPLE_ID )
                 WHERE PE.PEOPLE_ID = PNI_STG_PATIENT_ID
                   AND SCM.CASE_MASTER_ID = PNI_CASE_MASTER_ID;

                PNO_STATUS := 1;
                
                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'PATIENT_ID=' || PNO_DWH_PATIENT_ID || ' has already existed in DIM_PATIENT'
                    );
                
            END IF; 
        ELSE

            SELECT DIM_PATIENT_ID
              INTO PNO_DWH_PATIENT_ID
              FROM S_PEOPLE PE
             WHERE PE.PEOPLE_ID = PNI_STG_PATIENT_ID;

            PNO_STATUS := 1;
            
            SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'PATIENT_ID=' || PNO_DWH_PATIENT_ID || ' has already existed in DIM_PATIENT'
                );
        END IF;
               
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'PATIENT_ID=' || PNO_DWH_PATIENT_ID || ' has already existed in DIM_PATIENT'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_STG_PATIENT_ID=' || PNI_STG_PATIENT_ID
            );
      
    END SP_ETL_PATIENT;


    PROCEDURE SP_ETL_PROVIDER (
    /****************************************************************************
      NAME:      SP_ETL_PROVIDER
      PURPOSE:   Processing of DIM_PROVIDER
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_STG_BUSINESS_ID                 IN      DIM_PROVIDER.PROVIDER_ID%TYPE,
        PNI_DIM_PROVIDER_ID                 IN      S_BUSINESS.DIM_PROVIDER_ID%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PNO_DWH_PROVIDER_ID                 OUT     DIM_PROVIDER.PROVIDER_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_PROVIDER';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        C_PROVIDER_DATA                DIM_PROVIDER%ROWTYPE;
        N_PROVIDER_EXISTS              PLS_INTEGER;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_STG_BUSINESS_ID=' || PNI_STG_BUSINESS_ID
        );
        
        IF PNI_DIM_PROVIDER_ID IS NULL
        THEN
            SELECT COUNT(*)
              INTO N_PROVIDER_EXISTS
              FROM S_BUSINESS BU
             WHERE BU.BUSINESS_ID = PNI_STG_BUSINESS_ID
               AND BU.DIM_PROVIDER_ID IS NULL;
            
            IF N_PROVIDER_EXISTS > 0
            THEN  
                SELECT NULL,
                       BU.BUSINESS_TYPE_ID,
                       BU.FEDERAL_ID,
                       BU.COMPANY_NAME,
                       SA.ADDRESS1,
                       SA.ADDRESS2,
                       NULL, -- SA.CITY, -- 1/20/2016 - AC - IT SHOULD BE FIXED IN STAGING!!!
                       SA.STATE_CODE,
                       SA.ZIP_PLUS_FOUR,
                       SC.PHONE_NUMBER
                  INTO C_PROVIDER_DATA
                  FROM S_BUSINESS BU
                       LEFT JOIN S_ADDRESS SA  ON ( SA.BUSINESS_ID = BU.BUSINESS_ID )
                       LEFT JOIN S_CONTACT SC  ON ( SC.BUSINESS_ID = BU.BUSINESS_ID )
                 WHERE BU.BUSINESS_ID = PNI_STG_BUSINESS_ID;
                           
                INSERT INTO DIM_PROVIDER (
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
                                  VALUES ( 
                                           SEQ_DIM_PROVIDER.NEXTVAL, 
                                           NVL(C_PROVIDER_DATA.PROVIDER_TYPE, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_FEDERAL_TAX_ID, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_NAME, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_ADDRESS_1, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_ADDRESS_2, C$V_UNKNOWN_STRING),
                                           NVL(C_PROVIDER_DATA.PROVIDER_CITY, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_STATE, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_ZIP_CODE, C$V_UNKNOWN_STRING), 
                                           NVL(C_PROVIDER_DATA.PROVIDER_OFFICE_PHONE_NUM, C$V_UNKNOWN_STRING))
                              RETURNING PROVIDER_ID INTO PNO_DWH_PROVIDER_ID;
                
                UPDATE S_BUSINESS BU
                   SET BU.DIM_PROVIDER_ID = PNO_DWH_PROVIDER_ID
                 WHERE BU.BUSINESS_ID = PNI_STG_BUSINESS_ID;
                        
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'PROVIDER_ID=' || PNO_DWH_PROVIDER_ID || ' has been loaded to DIM_PROVIDER'
                );
                
                PNO_STATUS := 1;
            ELSE

                SELECT DIM_PROVIDER_ID
                  INTO PNO_DWH_PROVIDER_ID
                  FROM S_BUSINESS BU
                 WHERE BU.BUSINESS_ID = PNI_STG_BUSINESS_ID;

                PNO_STATUS := 1;
                
                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'PROVIDER_ID=' || PNO_DWH_PROVIDER_ID || ' has already existed in DIM_PROVIDER'
                    );
                            
            END IF;
        ELSE
            PNO_DWH_PROVIDER_ID := PNI_DIM_PROVIDER_ID;
            PNO_STATUS := 1;
            
            SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'PROVIDER_ID=' || PNO_DWH_PROVIDER_ID || ' has already existed in DIM_PROVIDER'
                );
        END IF;    
               
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'PROVIDER_ID=' || PNO_DWH_PROVIDER_ID || ' has already existed in DIM_PROVIDER'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
          PNO_STATUS := 0;
          SP_ETL_DETAIL_LOG (
              PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
              PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
              PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
              PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
              PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_STG_BUSINESS_ID=' || PNI_STG_BUSINESS_ID
          );
      
    END SP_ETL_PROVIDER;
    

    PROCEDURE SP_ETL_BILL (
    /****************************************************************************
      NAME:      SP_ETL_BILL
      PURPOSE:   Processing of DIM_BILL
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_STG_BILL_MASTER_ID              IN      DIM_BILL.BILL_ID%TYPE,
        PNI_DIM_BILL_ID                     IN      S_BILL_MASTER.DIM_BILL_ID%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PNO_DWH_BILL_MASTER_ID              OUT     DIM_BILL.BILL_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_BILL';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        C_BILL_DATA                    DIM_BILL%ROWTYPE;
        N_BILL_EXISTS                  PLS_INTEGER;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_STG_BILL_MASTER_ID=' || PNI_STG_BILL_MASTER_ID
        );
        IF PNI_DIM_BILL_ID IS NULL
        THEN
            SELECT COUNT(*)
              INTO N_BILL_EXISTS
              FROM S_BILL_MASTER BM
             WHERE BM.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID
               AND BM.DIM_BILL_ID IS NULL;
            
            IF N_BILL_EXISTS > 0
            THEN           
                SELECT NULL, 
                       SBM.BILL_CODE
                  INTO C_BILL_DATA
                  FROM S_BILL_MASTER SBM
                 WHERE SBM.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID;
                  
                INSERT INTO DIM_BILL(BILL_ID,
                                     BILL_CODE)
                             VALUES(SEQ_DIM_BILL.NEXTVAL,
                                    NVL(C_BILL_DATA.BILL_CODE, C$V_UNKNOWN_STRING))
                          RETURNING BILL_ID INTO PNO_DWH_BILL_MASTER_ID;
                
                UPDATE S_BILL_MASTER BM
                   SET BM.DIM_BILL_ID = PNO_DWH_BILL_MASTER_ID
                 WHERE BM.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID;
                        
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'BILL_ID=' || PNO_DWH_BILL_MASTER_ID || ' has been loaded to DIM_BILL'
                );
                
                PNO_STATUS := 1;
            ELSE
                SELECT DIM_BILL_ID
                  INTO PNO_DWH_BILL_MASTER_ID
                  FROM S_BILL_MASTER BM
                 WHERE BM.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID;

                PNO_STATUS := 1;
                
                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'BILL_ID=' || PNO_DWH_BILL_MASTER_ID || ' has already existed in DIM_BILL'
                    );
            
            END IF;
        ELSE
            PNO_DWH_BILL_MASTER_ID := PNI_DIM_BILL_ID;
            PNO_STATUS := 1;
            
            SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'BILL_ID=' || PNO_DWH_BILL_MASTER_ID || ' has already existed in DIM_BILL'
                );
        END IF;
                   
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'BIIL_ID=' || PNO_DWH_BILL_MASTER_ID || ' has already existed in DIM_BILL'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_STG_BILL_MASTER_ID=' || PNI_STG_BILL_MASTER_ID
            );
      
    END SP_ETL_BILL;  
    

    PROCEDURE SP_ETL_CPT (
    /****************************************************************************
      NAME:      SP_ETL_CPT
      PURPOSE:   Processing of DIM_CPT
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_STG_CPT_CODE_ID                 IN      DIM_CPT.CPT_ID%TYPE,
        PNI_DIM_CPT_ID                      IN      S_CODE.DIM_CPT_ID%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PNO_DWH_CPT_CODE_ID                 OUT     DIM_CPT.CPT_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_CPT';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        C_CPT_DATA                     DIM_CPT%ROWTYPE;
        N_CPT_EXISTS                   PLS_INTEGER;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_STG_CPT_CODE_ID=' || PNI_STG_CPT_CODE_ID
        );
        IF PNI_DIM_CPT_ID IS NULL
        THEN
            SELECT COUNT(*)
              INTO N_CPT_EXISTS
              FROM S_CODE SC
             WHERE SC.CODE_ID = PNI_STG_CPT_CODE_ID
               AND SC.DIM_CPT_ID IS NULL;
            
            IF N_CPT_EXISTS > 0
            THEN  
                SELECT NULL,
                       SC.CODE,
                       NULL -- 01/20/2016 - AC - IT SHOULD BE FIXED
                  INTO C_CPT_DATA 
                  FROM S_CODE SC
                 WHERE SC.CODE_ID = PNI_STG_CPT_CODE_ID;
                
                INSERT INTO DIM_CPT(CPT_ID,
                                    CPT_CODE,
                                    CPT_DESC)
                             VALUES(SEQ_DIM_CPT.NEXTVAL,
                                    NVL(C_CPT_DATA.CPT_CODE, C$V_UNKNOWN_STRING),
                                    C$V_UNKNOWN_STRING
                                   )
                          RETURNING CPT_ID INTO PNO_DWH_CPT_CODE_ID;
                
                UPDATE S_CODE SC
                   SET SC.DIM_CPT_ID = PNO_DWH_CPT_CODE_ID
                 WHERE SC.CODE_ID = PNI_STG_CPT_CODE_ID;
                                     
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'CPT_ID=' || PNO_DWH_CPT_CODE_ID || ' has been loaded to DIM_CPT'
                );
                
                PNO_STATUS := 1;
            ELSE
            
                SELECT DIM_CPT_ID
                  INTO PNO_DWH_CPT_CODE_ID
                  FROM S_CODE SC
                 WHERE SC.CODE_ID = PNI_STG_CPT_CODE_ID;

                PNO_STATUS := 1;
                
                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'CPT_ID=' || PNO_DWH_CPT_CODE_ID || ' has already existed in DIM_CPT'
                    );
            
            END IF;
        
        ELSE
            PNO_DWH_CPT_CODE_ID := PNI_DIM_CPT_ID;
            PNO_STATUS := 1;
            
            SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'CPT_ID=' || PNO_DWH_CPT_CODE_ID || ' has already existed in DIM_CPT'
                );
        END IF;           
        
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'CPT_ID=' || PNO_DWH_CPT_CODE_ID || ' has already existed in DIM_CPT'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_STG_CPT_CODE_ID=' || PNI_STG_CPT_CODE_ID
            );
      
    END SP_ETL_CPT;
    
    
    PROCEDURE SP_ETL_MODIFIER (
    /****************************************************************************
      NAME:      SP_ETL_MODIFIER
      PURPOSE:   Processing of DIM_MODIFIER
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_STG_MODIFIER_ID                 IN      DIM_MODIFIER.MODIFIER_ID%TYPE,
        PNI_DIM_MODIFIER_ID                 IN      S_CODE.DIM_MODIFIER_ID%TYPE,
        PVI_MODIFIER_DESC                   IN      DIM_MODIFIER.MODIFIER_DESC%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PNO_DWH_MODIFIER_ID                 OUT     DIM_MODIFIER.MODIFIER_ID%TYPE        
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_MODIFIER';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        C_MODIFIER_DATA                DIM_MODIFIER%ROWTYPE;
        N_MODIFIER_EXISTS              PLS_INTEGER;
        V_CODE                         DIM_MODIFIER.MODIFIER_CODE%TYPE;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_STG_MODIFIER_ID=' || PNI_STG_MODIFIER_ID
        );

        IF PNI_DIM_MODIFIER_ID IS NULL
        THEN
            SELECT COUNT(*)
              INTO N_MODIFIER_EXISTS
              FROM S_CODE SC 
             WHERE SC.CODE_ID = PNI_STG_MODIFIER_ID
               AND SC.DIM_MODIFIER_ID IS NULL;
            
            IF N_MODIFIER_EXISTS > 0
            THEN
                SELECT SC.CODE
                  INTO V_CODE
                  FROM S_CODE SC
                 WHERE SC.CODE_ID = PNI_STG_MODIFIER_ID;
                 
                INSERT INTO DIM_MODIFIER(
                            MODIFIER_ID,
                            MODIFIER_CODE,
                            MODIFIER_DESC)
                     VALUES(SEQ_DIM_MODIFIER.NEXTVAL,
                            NVL(V_CODE, C$V_UNKNOWN_STRING),
                            NVL(PVI_MODIFIER_DESC, C$V_UNKNOWN_STRING)) -- 01/20/2016 - AC - IT SHOULD BE FIXED
                  RETURNING MODIFIER_ID 
                       INTO PNO_DWH_MODIFIER_ID;
                
                UPDATE S_CODE SC
                   SET SC.DIM_MODIFIER_ID = PNO_DWH_MODIFIER_ID
                 WHERE SC.CODE_ID = PNI_STG_MODIFIER_ID;
                         
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'MODIFIER_ID=' || PNO_DWH_MODIFIER_ID || ' has been loaded to DIM_MODIFIER'
                );
                
                PNO_STATUS := 1;
            ELSE
                SELECT DIM_MODIFIER_ID
                  INTO PNO_DWH_MODIFIER_ID
                  FROM S_CODE SC 
                 WHERE SC.CODE_ID = PNI_STG_MODIFIER_ID;
            
                PNO_STATUS := 1;
                
                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'MODIFIER_ID=' || PNO_DWH_MODIFIER_ID || ' has already existed in DIM_MODIFIER'
                    );
            
            END IF;
        
        ELSE
            PNO_DWH_MODIFIER_ID := PNI_DIM_MODIFIER_ID;
            PNO_STATUS := 1;
            
            SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'MODIFIER_ID=' || PNO_DWH_MODIFIER_ID || ' has already existed in DIM_MODIFIER'
                );
        END IF;
                   
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'MODIFIER_ID=' || PNO_DWH_MODIFIER_ID || ' has already existed in DIM_MODIFIER'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_STG_MODIFIER_ID=' || PNI_STG_MODIFIER_ID
            );
      
    END SP_ETL_MODIFIER;

    PROCEDURE SP_ETL_DIAGNOSE (
    /****************************************************************************
      NAME:      SP_ETL_DIAGNOSE
      PURPOSE:   Processing of DIM_DIAGNOSE
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_STG_HCFA_BILL_ITEM_ID           IN      DIM_DIAGNOSE.DIAGNOSE_ID%TYPE,
        PNI_STG_BILL_MASTER_ID              IN      DIM_DIAGNOSE.DIAGNOSE_ID%TYPE,
        PNI_DWH_ETL_ID                      IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                          OUT     NUMBER,
        PLO_DWH_DIAGNOSE_IDS                OUT     T_NUMBER_LIST
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_DIAGNOSE';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        N_DIAGNOSE_ID                  DIM_DIAGNOSE.DIAGNOSE_ID%TYPE;
        N_DIAG_EXISTS                  PLS_INTEGER;
               
        L_DIAGNOSE_IDS                 T_NUMBER_LIST := T_NUMBER_LIST();
        N_ITERATOR                     PLS_INTEGER;
    BEGIN
    
        -- Initialization of Collection by full set of Diagnosis - by Default    
        FOR N_ITERATOR IN 1..4
        LOOP
            L_DIAGNOSE_IDS.EXTEND;
            L_DIAGNOSE_IDS(N_ITERATOR) := T_NUMBER(C$V_DEFAULT_VALUE_KEY); 
        END LOOP;
        
        SELECT COUNT(*)
          INTO N_DIAG_EXISTS
          FROM S_CODE SC,
               S_BILL_TO_DIAGNOSIS SBTD
         WHERE SC.CODE_ID = SBTD.DIAGNOSIS_ID
           AND SBTD.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID
           AND SBTD.HCFA_BILL_ITEM_ID = PNI_STG_HCFA_BILL_ITEM_ID;
             
        IF N_DIAG_EXISTS > 0
        THEN
            N_ITERATOR := 1;
            
            FOR DIAG_RECORD IN (SELECT SBTD.DIAGNOSIS_ID,
                                       SC.CODE,
                                       SC.CODE_ID,
                                       SC.DIM_DIAGNOSIS_ID
                                  FROM S_CODE SC,
                                       S_BILL_TO_DIAGNOSIS SBTD
                                 WHERE SC.CODE_ID = SBTD.DIAGNOSIS_ID
                                   AND SBTD.BILL_MASTER_ID = PNI_STG_BILL_MASTER_ID
                                   AND SBTD.HCFA_BILL_ITEM_ID = PNI_STG_HCFA_BILL_ITEM_ID
                               )
            LOOP
                
                BEGIN    
                    SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'Start for DIAGNOSE_ID=' || DIAG_RECORD.DIAGNOSIS_ID
                    );
                    
                    IF DIAG_RECORD.DIM_DIAGNOSIS_ID IS NULL
                    THEN
                        INSERT INTO DIM_DIAGNOSE(
                                    DIAGNOSE_ID,
                                    DIAGNOSE_CODE)
                            VALUES (SEQ_DIM_DIAGNOSE.NEXTVAL,
                                    NVL(DIAG_RECORD.CODE, C$V_UNKNOWN_STRING)
                                   )
                         RETURNING DIAGNOSE_ID 
                              INTO N_DIAGNOSE_ID;

                    ELSE
                        N_DIAGNOSE_ID := DIAG_RECORD.DIM_DIAGNOSIS_ID;    

                    END IF;
                    
                    UPDATE S_CODE
                       SET DIM_DIAGNOSIS_ID = N_DIAGNOSE_ID
                     WHERE CODE_ID = DIAG_RECORD.CODE_ID;

                    L_DIAGNOSE_IDS.EXTEND;
                    L_DIAGNOSE_IDS(N_ITERATOR) := T_NUMBER(N_DIAGNOSE_ID);

                    N_ITERATOR := N_ITERATOR + 1;
                                                                 
                    SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'DIAGNOSE_ID=' || N_DIAGNOSE_ID || CASE 
                                                                                                          WHEN DIAG_RECORD.DIM_DIAGNOSIS_ID IS NULL
                                                                                                          THEN ' has been loaded to DIM_DIAGNOSE'
                                                                                                          ELSE ' has already existed in DIM_DIAGNOSE'
                                                                                                      END
                    );
                    
                    
                EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                    THEN
                        SP_ETL_DETAIL_LOG (
                            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                            PVI_MESSAGE                             => 'DIAGNOSE_ID=' || N_DIAGNOSE_ID || ' has already existed in DIM_DIAGNOSE'
                        );
                END;
            END LOOP;
        END IF;

        PLO_DWH_DIAGNOSE_IDS := L_DIAGNOSE_IDS;
        PNO_STATUS := 1;
              
    EXCEPTION
      WHEN OTHERS 
      THEN 
            PLO_DWH_DIAGNOSE_IDS := L_DIAGNOSE_IDS;
            PNO_STATUS := 0;
            
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of DIAGNOSE_ID=' || N_DIAGNOSE_ID
            );
      
    END SP_ETL_DIAGNOSE;

    PROCEDURE SP_ETL_HCFA (
    /****************************************************************************
      NAME:      SP_ETL_HCFA
      PURPOSE:   Processing of FACT_HCFA
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_HCFA_BILL_ITEM_ID           IN      FACT_HCFA.FACT_ID%TYPE,
        PNI_DATE_ID                     IN      DIM_DATE.DATE_ID%TYPE,
        PNI_PATIENT_ID                  IN      DIM_PATIENT.PATIENT_ID%TYPE,
        PNI_PROVIDER_ID                 IN      DIM_PROVIDER.PROVIDER_ID%TYPE,
        PNI_CPT_ID                      IN      DIM_CPT.CPT_ID%TYPE,
        PNI_MODIFIER_ID                 IN      DIM_MODIFIER.MODIFIER_ID%TYPE,
        PNI_BILL_ID                     IN      DIM_BILL.BILL_ID%TYPE,
        PLI_DIAGNOSE_IDS                IN      T_NUMBER_LIST,
        PVI_HCFA_TYPE                   IN      VARCHAR2,
        PNI_DWH_ETL_ID                  IN      R_DWH_ETL.DWH_ETL_ID%TYPE,
        PNO_STATUS                      OUT     NUMBER,
        PNO_FACT_HCFA_ID                OUT     FACT_HCFA.FACT_ID%TYPE
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_HCFA';
        N_DWH_ETL_DETAIL_ID            R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;

        N_FACT_EXISTS                  PLS_INTEGER;
        N_CHARGES                      FACT_HCFA.CHARGES%TYPE;
        N_DIAGNOSIS_COUNT              PLS_INTEGER;
    BEGIN
    
        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
        );
        
        SELECT COUNT(DS.HCFA_EXISTS)
          INTO N_FACT_EXISTS
          FROM (SELECT 1 AS HCFA_EXISTS  
                  FROM S_HCFA_BILL_ITEM SHBI,
                       FACT_HCFA FH
                 WHERE SHBI.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID
                   AND FH.FACT_ID = SHBI.FACT_HCFA_TECH_FACT_ID
                   AND PVI_HCFA_TYPE = C$V_HCFA_TECH_DESC
             UNION ALL           
                SELECT 1 AS HCFA_EXISTS  
                  FROM S_HCFA_BILL_ITEM SHBI,
                       FACT_HCFA FH
                 WHERE SHBI.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID
                   AND FH.FACT_ID = SHBI.FACT_HCFA_PROF_FACT_ID
                   AND PVI_HCFA_TYPE = C$V_HCFA_PROF_DESC) DS;

        IF N_FACT_EXISTS = 0
        THEN
           
            SELECT CASE
                       WHEN PVI_HCFA_TYPE = C$V_HCFA_TECH_DESC
                       THEN NVL(SHBI.HCFA_TECH_AMOUNT, 0)
                       WHEN PVI_HCFA_TYPE = C$V_HCFA_PROF_DESC
                       THEN NVL(SHBI.HCFA_PROF_AMOUNT, 0)
                       ELSE NULL
                   END                   
              INTO N_CHARGES
              FROM S_HCFA_BILL_ITEM SHBI
             WHERE SHBI.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID;    

            INSERT INTO FACT_HCFA (
                        FACT_ID, 
                        DATE_ID, 
                        PATIENT_ID, 
                        PROVIDER_ID, 
                        CPT_ID, 
                        MODIFIER_ID, 
                        BILL_ID, 
                        CHARGES, 
                        DIAGNOSE_ID_1, 
                        DIAGNOSE_ID_2, 
                        DIAGNOSE_ID_3, 
                        DIAGNOSE_ID_4) 
                VALUES (SEQ_FACT_HCFA.NEXTVAL, 
                        PNI_DATE_ID, 
                        PNI_PATIENT_ID,
                        PNI_PROVIDER_ID, 
                        PNI_CPT_ID, 
                        PNI_MODIFIER_ID,
                        PNI_BILL_ID, 
                        N_CHARGES, 
                        PLI_DIAGNOSE_IDS(1).N,
                        PLI_DIAGNOSE_IDS(2).N, 
                        PLI_DIAGNOSE_IDS(3).N, 
                        PLI_DIAGNOSE_IDS(4).N)
              RETURNING FACT_ID 
                   INTO PNO_FACT_HCFA_ID;
                          
            IF (PVI_HCFA_TYPE = C$V_HCFA_TECH_DESC)
            THEN
                UPDATE S_HCFA_BILL_ITEM
                   SET FACT_HCFA_TECH_FACT_ID = PNO_FACT_HCFA_ID
                 WHERE HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID;
            ELSIF (PVI_HCFA_TYPE = C$V_HCFA_PROF_DESC)
            THEN
                UPDATE S_HCFA_BILL_ITEM
                   SET FACT_HCFA_PROF_FACT_ID = PNO_FACT_HCFA_ID
                 WHERE HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID;
            END IF;

            IF SQL%ROWCOUNT = 0
            THEN
                RAISE_APPLICATION_ERROR (-20002, 'HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID || ' AT S_HCFA_BILL_ITEM HAS NOT FOUND!');     
            END IF;
                           
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'N_FACT_ID=' || PNO_FACT_HCFA_ID || ' has been loaded to FACT_HCFA'
            );
       
            PNO_STATUS := 1;
        ELSE

            SELECT DS.FACT_ID
              INTO PNO_FACT_HCFA_ID
              FROM (SELECT FH.FACT_ID  
                      FROM S_HCFA_BILL_ITEM SHBI,
                           FACT_HCFA FH
                     WHERE SHBI.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID
                       AND FH.FACT_ID = FACT_HCFA_TECH_FACT_ID
                       AND PVI_HCFA_TYPE = C$V_HCFA_TECH_DESC
                 UNION ALL           
                    SELECT FH.FACT_ID  
                      FROM S_HCFA_BILL_ITEM SHBI,
                           FACT_HCFA FH
                     WHERE SHBI.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID
                       AND FH.FACT_ID = FACT_HCFA_PROF_FACT_ID
                       AND PVI_HCFA_TYPE = C$V_HCFA_PROF_DESC) DS;

            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'N_FACT_ID=' || PNO_FACT_HCFA_ID || ' has already existed in FACT_HCFA'
            );
       
            PNO_STATUS := 1;

        END IF;
                 
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'N_FACT_ID=' || PNO_FACT_HCFA_ID || ' has already existed in FACT_HCFA'
            );
            PNO_STATUS := 1;
      WHEN OTHERS 
      THEN 
            PNO_STATUS := 0;
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => PNI_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of PNI_HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
            );
      
    END SP_ETL_HCFA;
    
       
    PROCEDURE SP_ETL_ENTRY_POINT(
    /****************************************************************************
      NAME:         SP_ETL_ENTRY_POINT
      PURPOSE:      Entry Point for ETL DWH Job
      REVISIONS:
      Ver           Date        Author             Description
      ------------  ----------  -----------------  ----------------------------
      
    *****************************************************************************/
        PDI_ETL_PROCESS_DATE    IN R_DWH_ETL.DWH_ETL_PROCESS_DATE%TYPE
    )
    IS 
        C$V_PROCEDURE            CONSTANT VARCHAR2(256) := 'PKG_DWH_ETL.SP_ETL_ENTRY_POINT';
       
        CURSOR C_MAIN_STAGING_DATA
        IS
            -- technical part
            SELECT SHBI.HCFA_BILL_ITEM_ID,
                   SHBI.HCFA_CPT_CODE_ID,
                   SHBI.HCFA_TECH_MODIFIER_ID,
                   NULL AS HCFA_PROF_MODIFIER_ID,
                   NVL(SHBI.HCFA_TECH_AMOUNT, 0) AS HCFA_AMOUNT,
                   SBI.BILL_ITEM_ID,
                   SBP.BILL_PACKAGE_ID,
                   SRD.REFERRAL_DETAIL_ID,
                   SRM.REFERRAL_MASTER_ID,
                   SCM.CASE_MASTER_ID,
                   SP.PEOPLE_ID,
                   SP.DIM_PATIENT_ID,
                   SB.BUSINESS_ID,
                   SB.DIM_PROVIDER_ID,
                   SBM.BILL_MASTER_ID,
                   SBM.DIM_BILL_ID,
                   SC1.DIM_CPT_ID,
                   SC2.DIM_MODIFIER_ID,
                   SC2.CODE_ID,
                   'TECH' AS HCFA_TYPE
              FROM R_STG_ETL RSE, 
                   S_HCFA_BILL_ITEM SHBI,
                   S_BILL_ITEM SBI,
                   S_BILL_PACKAGE SBP,
                   S_BILL_MASTER SBM,
                   S_REFERRAL_DETAIL SRD,
                   S_VISIT SV,
                   S_REFERRAL_MASTER SRM,
                   S_CASE_MASTER SCM,
                   S_PEOPLE SP,
                   S_BUSINESS SB,
                   S_CODE SC1,
                   S_CODE SC2
             WHERE RSE.STG_ETL_PROCESS_DATE = PDI_ETL_PROCESS_DATE
               AND SHBI.HCFA_TECH_START_DATE >= RSE.STG_ETL_PROCESS_DATE
               AND SHBI.HCFA_TECH_END_DATE < (RSE.STG_ETL_PROCESS_DATE + 1)
               AND SBI.BILL_ITEM_ID = SHBI.BILL_ITEM_ID
               AND SBP.BILL_PACKAGE_ID = SBI.BILL_PACKAGE_ID
               AND SBM.BILL_MASTER_ID = SBP.BILL_MASTER_ID
               AND SV.VISIT_ID = SBM.VISIT_ID
               AND SRD.VISIT_ID = SV.VISIT_ID
               AND SRD.REFERRAL_DETAIL_ID = SBP.REFERRAL_DETAIL_ID
               AND SRM.REFERRAL_MASTER_ID = SV.REFERRAL_MASTER_ID
               AND SCM.CASE_MASTER_ID = SRM.CASE_MASTER_ID
               AND SP.PEOPLE_ID(+) = SCM.PATIENT_ID
               AND SB.BUSINESS_ID(+) = SV.BUSINESS_ID
               AND SC1.CODE_ID(+) = SHBI.HCFA_CPT_CODE_ID
               AND SC2.CODE_ID(+) = SHBI.HCFA_TECH_MODIFIER_ID
   
             UNION
            
            -- professional part
            SELECT SHBI.HCFA_BILL_ITEM_ID,
                   SHBI.HCFA_CPT_CODE_ID,
                   NULL AS HCFA_TECH_MODIFIER_ID,
                   SHBI.HCFA_PROF_MODIFIER_ID,
                   NVL(SHBI.HCFA_PROF_AMOUNT, 0) AS HCFA_AMOUNT,
                   SBI.BILL_ITEM_ID,
                   SBP.BILL_PACKAGE_ID,
                   SRD.REFERRAL_DETAIL_ID,
                   SRM.REFERRAL_MASTER_ID,
                   SCM.CASE_MASTER_ID,
                   SP.PEOPLE_ID,
                   SP.DIM_PATIENT_ID,
                   SB.BUSINESS_ID,
                   SB.DIM_PROVIDER_ID,
                   SBM.BILL_MASTER_ID,
                   SBM.DIM_BILL_ID,
                   SC1.DIM_CPT_ID,
                   SC2.DIM_MODIFIER_ID,
                   SC2.CODE_ID,                   
                   'PROF' AS HCFA_TYPE
              FROM R_STG_ETL RSE, 
                   S_HCFA_BILL_ITEM SHBI,
                   S_BILL_ITEM SBI,
                   S_BILL_PACKAGE SBP,
                   S_BILL_MASTER SBM,
                   S_REFERRAL_DETAIL SRD,
                   S_VISIT SV,
                   S_REFERRAL_MASTER SRM,
                   S_CASE_MASTER SCM,
                   S_PEOPLE SP,
                   S_BUSINESS SB,
                   S_CODE SC1,
                   S_CODE SC2                   
             WHERE RSE.STG_ETL_PROCESS_DATE = PDI_ETL_PROCESS_DATE
               AND SHBI.HCFA_PROF_START_DATE >= RSE.STG_ETL_PROCESS_DATE
               AND SHBI.HCFA_PROF_END_DATE < (RSE.STG_ETL_PROCESS_DATE + 1)
               AND SBI.BILL_ITEM_ID = SHBI.BILL_ITEM_ID
               AND SBP.BILL_PACKAGE_ID = SBI.BILL_PACKAGE_ID
               AND SBM.BILL_MASTER_ID = SBP.BILL_MASTER_ID
               AND SV.VISIT_ID = SBM.VISIT_ID
               AND SRD.VISIT_ID = SV.VISIT_ID
               AND SRD.REFERRAL_DETAIL_ID = SBP.REFERRAL_DETAIL_ID
               AND SRM.REFERRAL_MASTER_ID = SV.REFERRAL_MASTER_ID
               AND SCM.CASE_MASTER_ID = SRM.CASE_MASTER_ID
               AND SHBI.HCFA_PROF_MODIFIER_ID IS NOT NULL
               AND SBM.SPLIT_BILL = 'Y'
               AND SP.PEOPLE_ID(+) = SCM.PATIENT_ID
               AND SB.BUSINESS_ID(+) = SV.BUSINESS_ID
               AND SC1.CODE_ID(+) = SHBI.HCFA_CPT_CODE_ID
               AND SC2.CODE_ID(+) = SHBI.HCFA_PROF_MODIFIER_ID;
               
        STAGING_ITEM                    C_MAIN_STAGING_DATA%ROWTYPE;
        
        N_MODIFIER_ID                   NUMBER(12);
        V_MODIFIER_DESC                 VARCHAR2(256);
                
        N_DWH_ETL_ID                    R_DWH_ETL.DWH_ETL_ID%TYPE := NULL;
        N_DWH_ETL_DETAIL_ID             R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;

        N_JOB_DWH_ETL_DETAIL_ID         R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        N_ITEM_DWH_ETL_DETAIL_ID        R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;
        N_TEMP_DWH_ETL_DETAIL_ID        R_DWH_ETL_DETAIL.DWH_ETL_DETAIL_ID%TYPE;

        N_DIM_DATE_ID                   DIM_DATE.DATE_ID%TYPE;
        N_DIM_PROVIDER_ID               DIM_PROVIDER.PROVIDER_ID%TYPE;
        N_DIM_BILL_ID                   DIM_BILL.BILL_ID%TYPE;
        N_DIM_CPT_ID                    DIM_CPT.CPT_ID%TYPE;
        N_DIM_MODIFIER_ID               DIM_MODIFIER.MODIFIER_ID%TYPE;
        N_DIM_PATIENT_ID                DIM_PATIENT.PATIENT_ID%TYPE;
        N_FACT_HCFA_ID                  FACT_HCFA.FACT_ID%TYPE;
        
        N_DIAGNOSIS_DATA_EXISTS         PLS_INTEGER;
        
        L_DIAGNOSE_IDS                  T_NUMBER_LIST := T_NUMBER_LIST();


        -- FOR STATISTICS PURPOSES
        N_CONSIDERED_CNT                NUMBER(12) := 0;
        N_PROCESSED_CNT                 NUMBER(12) := 0;
        N_SUCCESS_CNT                   NUMBER(12) := 0;
        N_ERROR_CNT                     NUMBER(12) := 0;

        N_STATUS                        NUMBER(1);

        EX_FAIL_LOAD                    EXCEPTION;
        PRAGMA EXCEPTION_INIT(EX_FAIL_LOAD, -20001);
    BEGIN
    
        -- Start of the processing
        SP_ETL_LOG (
            PNIO_DWH_ETL_ID                       => N_DWH_ETL_ID,
            PVI_DWH_ETL_STATUS                    => PKG_DWH_ETL.C$C_INITIAL_JOB_STATUS,
            PDI_DWH_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
        );
    
        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_PROCESSING_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
        );

        N_JOB_DWH_ETL_DETAIL_ID := N_DWH_ETL_DETAIL_ID;
    
        -- DIM_DATE processing
        SP_ETL_DATE (PDI_DATE_NAME          => PDI_ETL_PROCESS_DATE,
                     PNI_DWH_ETL_ID         => N_DWH_ETL_ID, 
                     PNO_STATUS             => N_STATUS,
                     PNO_DATE_ID            => N_DIM_DATE_ID);
                     
        IF N_STATUS = 0
        THEN
            RAISE EX_FAIL_LOAD;
        END IF;
        
        OPEN C_MAIN_STAGING_DATA;
       
        LOOP
            
            BEGIN 
                FETCH C_MAIN_STAGING_DATA
                 INTO STAGING_ITEM;
               
                EXIT WHEN C_MAIN_STAGING_DATA%NOTFOUND;

                N_CONSIDERED_CNT := N_CONSIDERED_CNT + 1;
    
                N_ITEM_DWH_ETL_DETAIL_ID := NULL;
    
                SP_ETL_DETAIL_LOG (
                    PNIO_DWH_ETL_DETAIL_ID                  => N_ITEM_DWH_ETL_DETAIL_ID,
                    PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                    PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_PROCESSING_ITEM_STATUS,
                    PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'Start for HCFA_BILL_ITEM_ID=' || STAGING_ITEM.HCFA_BILL_ITEM_ID
                );
                
                --The initial point
                SAVEPOINT SP_ETL_ENTRY_POINT;
                
                -- DIM_PATIENT processing
                IF STAGING_ITEM.PEOPLE_ID IS NOT NULL
                THEN
                    N_DIM_PATIENT_ID := STAGING_ITEM.DIM_PATIENT_ID;
                    
                    SP_ETL_PATIENT(PNI_STG_PATIENT_ID => STAGING_ITEM.PEOPLE_ID,
                                   PNI_DIM_PATIENT_ID => N_DIM_PATIENT_ID,
                                   PNI_CASE_MASTER_ID => STAGING_ITEM.CASE_MASTER_ID,
                                   PNI_DWH_ETL_ID     => N_DWH_ETL_ID,
                                   PNO_STATUS         => N_STATUS,
                                   PNO_DWH_PATIENT_ID => N_DIM_PATIENT_ID
                                   );
                                  
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE
                    N_DIM_PATIENT_ID := PKG_DWH_ETL.C$V_DEFAULT_VALUE_KEY;                        
                END IF;               
                
                
                -- DIM_PROVIDER processing
                IF STAGING_ITEM.BUSINESS_ID IS NOT NULL
                THEN
                    N_DIM_PROVIDER_ID := STAGING_ITEM.DIM_PROVIDER_ID;
                    
                    SP_ETL_PROVIDER(PNI_STG_BUSINESS_ID => STAGING_ITEM.BUSINESS_ID,
                                    PNI_DIM_PROVIDER_ID => N_DIM_PROVIDER_ID,
                                    PNI_DWH_ETL_ID      => N_DWH_ETL_ID,
                                    PNO_STATUS          => N_STATUS,
                                    PNO_DWH_PROVIDER_ID => N_DIM_PROVIDER_ID);
                                    
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE
                    N_DIM_PROVIDER_ID := PKG_DWH_ETL.C$V_DEFAULT_VALUE_KEY;                        
                END IF;
                
                
                -- DIM_BILL processing
                IF STAGING_ITEM.BILL_MASTER_ID IS NOT NULL
                THEN
                    N_DIM_BILL_ID := STAGING_ITEM.DIM_BILL_ID;
                    
                    SP_ETL_BILL(PNI_STG_BILL_MASTER_ID  => STAGING_ITEM.BILL_MASTER_ID,
                                PNI_DIM_BILL_ID         => N_DIM_BILL_ID,
                                PNI_DWH_ETL_ID          => N_DWH_ETL_ID,
                                PNO_STATUS              => N_STATUS,
                                PNO_DWH_BILL_MASTER_ID  => N_DIM_BILL_ID
                                );
                
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE
                    N_DIM_BILL_ID := PKG_DWH_ETL.C$V_DEFAULT_VALUE_KEY;                        
                END IF;
                
                
                -- DIM_CPT processing
                IF STAGING_ITEM.HCFA_CPT_CODE_ID IS NOT NULL
                THEN
                    N_DIM_CPT_ID := STAGING_ITEM.DIM_CPT_ID;
                    
                    SP_ETL_CPT(PNI_STG_CPT_CODE_ID => STAGING_ITEM.HCFA_CPT_CODE_ID,
                               PNI_DIM_CPT_ID      => N_DIM_CPT_ID,
                               PNI_DWH_ETL_ID      => N_DWH_ETL_ID,
                               PNO_STATUS          => N_STATUS,
                               PNO_DWH_CPT_CODE_ID => N_DIM_CPT_ID);
                
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE
                    N_DIM_CPT_ID := PKG_DWH_ETL.C$V_DEFAULT_VALUE_KEY;                        
                END IF;

                
                -- DIM_MODIFIER processing
                N_MODIFIER_ID := NVL(STAGING_ITEM.HCFA_TECH_MODIFIER_ID, STAGING_ITEM.HCFA_PROF_MODIFIER_ID);
                
                IF N_MODIFIER_ID IS NOT NULL
                THEN
                    IF STAGING_ITEM.HCFA_TECH_MODIFIER_ID IS NOT NULL
                    THEN
                        V_MODIFIER_DESC := 'TECHNICAL BILLING MODIFIER';
                    ELSE
                        V_MODIFIER_DESC := 'PROFESSIONAL BILLING MODIFIER';
                    END IF;
                    
                    N_DIM_MODIFIER_ID := STAGING_ITEM.DIM_MODIFIER_ID;
                      
                    SP_ETL_MODIFIER(PNI_STG_MODIFIER_ID     => N_MODIFIER_ID,
                                    PNI_DIM_MODIFIER_ID     => N_DIM_MODIFIER_ID,
                                    PVI_MODIFIER_DESC       => V_MODIFIER_DESC,
                                    PNI_DWH_ETL_ID          => N_DWH_ETL_ID,
                                    PNO_STATUS              => N_STATUS,
                                    PNO_DWH_MODIFIER_ID     => N_DIM_MODIFIER_ID);
                
                
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE 
                    N_DIM_MODIFIER_ID := PKG_DWH_ETL.C$V_DEFAULT_VALUE_KEY;                        
                END IF;
                
                
                -- DIM_DIAGNOSE processing
                SELECT COUNT(*)
                  INTO N_DIAGNOSIS_DATA_EXISTS
                  FROM S_BILL_TO_DIAGNOSIS D
                 WHERE D.BILL_MASTER_ID = STAGING_ITEM.BILL_MASTER_ID
                   AND D.HCFA_BILL_ITEM_ID = STAGING_ITEM.HCFA_BILL_ITEM_ID;
                
                IF N_DIAGNOSIS_DATA_EXISTS > 0
                THEN
                    SP_ETL_DIAGNOSE ( PNI_STG_HCFA_BILL_ITEM_ID => STAGING_ITEM.HCFA_BILL_ITEM_ID,
                                      PNI_STG_BILL_MASTER_ID    => STAGING_ITEM.BILL_MASTER_ID,
                                      PNI_DWH_ETL_ID            => N_DWH_ETL_ID,
                                      PNO_STATUS                => N_STATUS,
                                      PLO_DWH_DIAGNOSE_IDS      => L_DIAGNOSE_IDS );
                    
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_LOAD;
                    END IF;
                ELSE
                    -- Initialization of Collection by full set of Diagnosis - by Default    
                    FOR N_ITERATOR IN 1..4
                    LOOP
                        L_DIAGNOSE_IDS.EXTEND;
                        L_DIAGNOSE_IDS(N_ITERATOR) := T_NUMBER(C$V_DEFAULT_VALUE_KEY); 
                    END LOOP;
                END IF;
                
                -- FACT_HCFA processing
                SP_ETL_HCFA ( PNI_HCFA_BILL_ITEM_ID => STAGING_ITEM.HCFA_BILL_ITEM_ID,
                              PNI_DATE_ID           => N_DIM_DATE_ID,
                              PNI_PATIENT_ID        => N_DIM_PATIENT_ID,
                              PNI_PROVIDER_ID       => N_DIM_PROVIDER_ID,
                              PNI_CPT_ID            => N_DIM_CPT_ID,
                              PNI_MODIFIER_ID       => N_DIM_MODIFIER_ID,
                              PNI_BILL_ID           => N_DIM_BILL_ID,
                              PLI_DIAGNOSE_IDS      => L_DIAGNOSE_IDS,
                              PVI_HCFA_TYPE         => STAGING_ITEM.HCFA_TYPE,
                              PNI_DWH_ETL_ID        => N_DWH_ETL_ID,
                              PNO_STATUS            => N_STATUS,
                              PNO_FACT_HCFA_ID      => N_FACT_HCFA_ID);
                              
                IF N_STATUS = 0
                THEN
                    RAISE EX_FAIL_LOAD;
                END IF;

                N_PROCESSED_CNT := N_PROCESSED_CNT + 1;
                N_SUCCESS_CNT := N_SUCCESS_CNT + 1;
      
                COMMIT; -- CURRENT ITERATION

                SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_ITEM_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'HCFA_BILL_ITEM_ID=' || STAGING_ITEM.HCFA_BILL_ITEM_ID || ' has been processed successfully'
                );

            EXCEPTION
                WHEN EX_FAIL_LOAD
                THEN 

                    N_PROCESSED_CNT := N_PROCESSED_CNT + 1;
                    N_ERROR_CNT := N_ERROR_CNT + 1;
                    
                    ROLLBACK TO SAVEPOINT SP_ETL_ENTRY_POINT;
                    
                    SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_ITEM_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'ERROR during processing of HCFA_BILL_ITEM_ID=' || STAGING_ITEM.HCFA_BILL_ITEM_ID || ' was occurred'
                    );
                
                
                WHEN OTHERS
                THEN

                    SP_ETL_DETAIL_LOG (
                        PNIO_DWH_ETL_DETAIL_ID                  => N_ITEM_DWH_ETL_DETAIL_ID,
                        PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                        PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                        PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during processing of HCFA_BILL_ITEM_ID=' || STAGING_ITEM.HCFA_BILL_ITEM_ID || '. TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                    );

                    RAISE;
                
            END;                
        END LOOP;

        COMMIT;
        
        -- TBD: Added Statistics        
        SP_ETL_DETAIL_LOG (
            PNIO_DWH_ETL_DETAIL_ID                  => N_JOB_DWH_ETL_DETAIL_ID,
            PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
            PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
                                                       || ': ITEMS: Considered=' || N_CONSIDERED_CNT
                                                       || ', Processed=' || N_PROCESSED_CNT
                                                       || ', Successful=' || N_SUCCESS_CNT
                                                       || ', Errors=' || N_ERROR_CNT
        );
        
        -- End of the processing
        SP_ETL_LOG (
            PNIO_DWH_ETL_ID                       => N_DWH_ETL_ID,
            PVI_DWH_ETL_STATUS                    => PKG_DWH_ETL.C$C_SUCCESS_JOB_STATUS,
            PDI_DWH_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
        );

    EXCEPTION
        WHEN OTHERS
        THEN

            -- Log the error
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_TEMP_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during processing. TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
            );
            
            -- TBD: Added Statistics        
            SP_ETL_DETAIL_LOG (
                PNIO_DWH_ETL_DETAIL_ID                  => N_JOB_DWH_ETL_DETAIL_ID,
                PNI_DWH_ETL_ID                          => N_DWH_ETL_ID,
                PVI_DWH_ETL_DETAIL_STATUS               => PKG_DWH_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_DWH_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
                                                           || ': ITEMS: Considered=' || N_CONSIDERED_CNT
                                                           || ', Processed=' || N_PROCESSED_CNT
                                                           || ', Successful=' || N_SUCCESS_CNT
                                                           || ', Errors=' || N_ERROR_CNT
            );

            -- End of the processing
            SP_ETL_LOG (
                PNIO_DWH_ETL_ID                       => N_DWH_ETL_ID, 
                PVI_DWH_ETL_STATUS                    => PKG_DWH_ETL.C$C_ERROR_JOB_STATUS,
                PDI_DWH_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
            );
            
    END;
    
END PKG_DWH_ETL;
/
