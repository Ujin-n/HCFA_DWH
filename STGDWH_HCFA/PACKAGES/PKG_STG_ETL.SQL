CREATE OR REPLACE PACKAGE         PKG_STG_ETL IS
/****************************************************************************
 NAME:      PKG_STG_ETL
 PURPOSE:
 REVISIONS:
 Ver        Date        Author              Description
 ---------  ----------  ---------------     ----------------------------
 
*****************************************************************************/

    /**********************/
    /** Public constants **/
    /**********************/
    -- Process Statuses
    C$C_INITIAL_JOB_STATUS              R_STG_ETL.STG_ETL_STATUS%TYPE := 'I';
    C$C_PROCESSING_JOB_STATUS           R_STG_ETL.STG_ETL_STATUS%TYPE := 'P';
    C$C_SUCCESS_JOB_STATUS              R_STG_ETL.STG_ETL_STATUS%TYPE := 'S';
    C$C_ERROR_JOB_STATUS                R_STG_ETL.STG_ETL_STATUS%TYPE := 'E';

    -- Detail Statuses
    C$C_INITIAL_ITEM_STATUS             R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE := 'I';
    C$C_PROCESSING_ITEM_STATUS          R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE := 'P';
    C$C_SUCCESS_ITEM_STATUS             R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE := 'S';
    C$C_ERROR_ITEM_STATUS               R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE := 'E';


    /***********************/
    /** Public procedures **/
    /***********************/
    PROCEDURE SP_ETL_ENTRY_POINT (
        PDI_ETL_PROCESS_DATE                  IN     R_STG_ETL.STG_ETL_PROCESS_DATE%TYPE
    );

    PROCEDURE SP_ETL_LOG (
        PNIO_STG_ETL_ID                       IN OUT R_STG_ETL.STG_ETL_ID%TYPE,
        PVI_STG_ETL_STATUS                    IN     R_STG_ETL.STG_ETL_STATUS%TYPE,
        PDI_STG_ETL_PROCESS_DATE              IN     R_STG_ETL.STG_ETL_PROCESS_DATE%TYPE
    );

    PROCEDURE SP_ETL_DETAIL_LOG (PNIO_STG_ETL_DETAIL_ID             IN OUT R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE,
                                 PNI_STG_ETL_ID                     IN     R_STG_ETL_DETAIL.STG_ETL_ID%TYPE,
                                 PVI_STG_ETL_DETAIL_STATUS          IN     R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE,
                                 PVI_STG_ETL_MODULE                 IN     R_STG_ETL_DETAIL.STG_ETL_MODULE%TYPE,
                                 PVI_MESSAGE                        IN     R_STG_ETL_DETAIL.MESSAGE%TYPE);

END PKG_STG_ETL;
/



CREATE OR REPLACE PACKAGE BODY         PKG_STG_ETL
AS

    PROCEDURE SP_ETL_CGL (
    /****************************************************************************
      NAME:       SP_ETL_CGL
      PURPOSE:    Inserting S_GENERIC_LOOKUP
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PCI_ACTIVITY_STATUS             IN      S_GENERIC_LOOKUP.ACTIVITY_STATUS%TYPE,
        PDI_CREATION_DATE               IN      S_GENERIC_LOOKUP.CREATION_DATE%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_GENERIC_LOOKUP.LAST_MODIFICATION_DATE%TYPE,
        PNI_LOOKUP_ID                   IN      S_GENERIC_LOOKUP.LOOKUP_ID%TYPE,
        PNI_LOOKUP_TYPE_ID              IN      S_GENERIC_LOOKUP.LOOKUP_TYPE_ID%TYPE,
        PNI_ROW_ORDER                   IN      S_GENERIC_LOOKUP.ROW_ORDER%TYPE,
        PVI_LOOKUP_NAME                 IN      S_GENERIC_LOOKUP.LOOKUP_NAME%TYPE,
        PVI_LOOKUP_ABBREVIATION         IN      S_GENERIC_LOOKUP.LOOKUP_ABBREVIATION%TYPE,
        PVI_USER_CODE                   IN      S_GENERIC_LOOKUP.CREATED_BY%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_CGL';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for LOOKUP_ID=' || PNI_LOOKUP_ID
        );

      INSERT INTO S_GENERIC_LOOKUP ( LOOKUP_ID,
                                     LOOKUP_NAME,
                                     LOOKUP_ABBREVIATION,
                                     ROW_ORDER,
                                     CREATED_BY,
                                     CREATION_DATE,
                                     LAST_MODIFIED_BY,
                                     LAST_MODIFICATION_DATE,
                                     LOOKUP_TYPE_ID,
                                     ACTIVITY_STATUS )
      VALUES ( PNI_LOOKUP_ID,
               PVI_LOOKUP_NAME,
               PVI_LOOKUP_ABBREVIATION,
               PNI_ROW_ORDER,
               PVI_USER_CODE,
               PDI_CREATION_DATE,
               PVI_USER_CODE,
               PDI_LAST_MODIFICATION_DATE,
               PNI_LOOKUP_TYPE_ID,
               PCI_ACTIVITY_STATUS );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'LOOKUP_ID=' || PNI_LOOKUP_ID || ' has been loaded to S_GENERIC_LOOKUP'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'LOOKUP_ID=' || PNI_LOOKUP_ID || ' has already existed in S_GENERIC_LOOKUP'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of LOOKUP_ID=' || PNI_LOOKUP_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_CGL;

    PROCEDURE SP_ETL_CODE (
    /****************************************************************************
      NAME:      SP_ETL_CODE
      PURPOSE:   Processing of S_CODE
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PLI_CODES               IN    T_NUMBER_LIST,
        PNI_STG_ETL_ID          IN    R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS              OUT   NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_CODE';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
        C_CODE_DATA                    M_CODE%ROWTYPE;
        N_CODE_DATA_EXISTS             PLS_INTEGER;
        N_CODE_ID                      S_CODE.CODE_ID%TYPE;

    BEGIN

        FOR CODE_ITEM IN (SELECT CC.N AS CODE_ID
                            FROM TABLE (PLI_CODES) CC)
        LOOP
            BEGIN
                IF CODE_ITEM.CODE_ID IS NOT NULL
                THEN
                    N_CODE_ID := CODE_ITEM.CODE_ID;

                    SELECT COUNT(*)
                      INTO N_CODE_DATA_EXISTS
                      FROM M_CODE
                     WHERE CODE_ID = N_CODE_ID;

                    IF N_CODE_DATA_EXISTS > 0
                    THEN
                        SP_ETL_DETAIL_LOG (
                            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
                            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                            PVI_MESSAGE                             => 'Start for CODE_ID=' || N_CODE_ID
                        );

                        SELECT *
                          INTO C_CODE_DATA
                          FROM M_CODE
                         WHERE CODE_ID = N_CODE_ID;

                        INSERT INTO S_CODE (
                            CODE,
                            CODE_ID,
                            CREATED_BY,
                            CREATION_DATE,
                            LAST_MODIFIED_BY,
                            LAST_MODIFICATION_DATE,
                            START_DATE,
                            END_DATE,
                            REVISED_DATE,
                            CODE_TYPE_ID)
                        VALUES (
                            C_CODE_DATA.CODE,
                            C_CODE_DATA.CODE_ID,
                            C_CODE_DATA.CREATED_BY,
                            C_CODE_DATA.CREATION_DATE,
                            C_CODE_DATA.LAST_MODIFIED_BY,
                            C_CODE_DATA.LAST_MODIFICATION_DATE,
                            C_CODE_DATA.START_DATE,
                            C_CODE_DATA.END_DATE,
                            C_CODE_DATA.REVISED_DATE,
                            C_CODE_DATA.CODE_TYPE_ID);

                        SP_ETL_DETAIL_LOG (
                            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                            PVI_MESSAGE                             => 'CODE_ID=' || N_CODE_ID || ' has been loaded to S_CODE'
                        );

                    END IF;
                END IF;
            EXCEPTION
              WHEN DUP_VAL_ON_INDEX
              THEN
                  SP_ETL_DETAIL_LOG (
                      PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                      PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                      PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                      PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                      PVI_MESSAGE                             => 'CODE_ID=' || N_CODE_ID || ' has already existed in S_CODE'
                  );
            END;
        END LOOP;

        PNO_STATUS := 1;

    EXCEPTION
        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of CODE_ID=' || N_CODE_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_CODE;

    PROCEDURE SP_ETL_BUSINESS (
    /****************************************************************************
      NAME:      SP_ETL_BUSINESS
      PURPOSE:   Processing of S_BUSINESS
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_BUSINESS_ID                 IN      S_BUSINESS.BUSINESS_ID%TYPE := NULL,
        PVI_INTREPID_CODE               IN      S_BUSINESS.INTREPID_CODE%TYPE := NULL,
        PVI_CREATED_BY                  IN      S_BUSINESS.CREATED_BY%TYPE := NULL,
        PDI_CREATION_DATE               IN      S_BUSINESS.CREATION_DATE%TYPE := NULL,
        PVI_LAST_MODIFIED_BY            IN      S_BUSINESS.LAST_MODIFIED_BY%TYPE := NULL,
        PDI_WEB_EMAIL_ACTIVE_DATE       IN      S_BUSINESS.WEB_EMAIL_ACTIVE_DATE%TYPE := NULL,
        PDI_LAST_STATUS_CHANGED_DATE    IN      S_BUSINESS.LAST_STATUS_CHANGED_DATE%TYPE := NULL,
        PDI_BUSINESS_CLOSURE_DATE       IN      S_BUSINESS.BUSINESS_CLOSURE_DATE%TYPE := NULL,
        PVI_COMPANY_NAME                IN      S_BUSINESS.COMPANY_NAME%TYPE := NULL,
        PDI_LAST_MODIFICATION_DATE      IN      S_BUSINESS.LAST_MODIFICATION_DATE%TYPE := NULL,
        PNI_BUSINESS_CLOSURE_ID         IN      S_BUSINESS.BUSINESS_CLOSURE_ID%TYPE := NULL,
        PNI_BUSINESS_TYPE_ID            IN      S_BUSINESS.BUSINESS_TYPE_ID%TYPE := NULL,
        PCI_ACTIVITY_STATUS             IN      S_BUSINESS.ACTIVITY_STATUS%TYPE := NULL,
        PCI_VERIFIED_STATUS             IN      S_BUSINESS.VERIFIED_STATUS%TYPE := NULL,
        PNI_BUSINESS_SUB_TYPE           IN      S_BUSINESS.BUSINESS_SUB_TYPE%TYPE := NULL,
        PNI_FEDERAL_ID                  IN      S_BUSINESS.FEDERAL_ID%TYPE := NULL,
        PNI_PARTNER_TYPE_ID             IN      S_BUSINESS.PARTNER_TYPE_ID%TYPE := NULL,
        PCI_PAY_ON_PAY                  IN      S_BUSINESS.PAY_ON_PAY%TYPE := NULL,
        PNI_INTREPID_CODE_NUMBER        IN      S_BUSINESS.INTREPID_CODE_NUMBER%TYPE := NULL,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_BUSINESS';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for BUSINESS_ID=' || PNI_BUSINESS_ID
        );

        INSERT INTO S_BUSINESS (
                            BUSINESS_ID,
                            INTREPID_CODE,
                            CREATED_BY,
                            CREATION_DATE,
                            LAST_MODIFIED_BY,
                            WEB_EMAIL_ACTIVE_DATE,
                            LAST_STATUS_CHANGED_DATE,
                            BUSINESS_CLOSURE_DATE,
                            COMPANY_NAME,
                            LAST_MODIFICATION_DATE,
                            BUSINESS_CLOSURE_ID,
                            BUSINESS_TYPE_ID,
                            ACTIVITY_STATUS,
                            VERIFIED_STATUS,
                            BUSINESS_SUB_TYPE,
                            FEDERAL_ID,
                            PARTNER_TYPE_ID,
                            PAY_ON_PAY,
                            INTREPID_CODE_NUMBER)
                            VALUES
                            (
                            PNI_BUSINESS_ID,
                            PVI_INTREPID_CODE,
                            PVI_CREATED_BY,
                            PDI_CREATION_DATE,
                            PVI_LAST_MODIFIED_BY,
                            PDI_WEB_EMAIL_ACTIVE_DATE,
                            PDI_LAST_STATUS_CHANGED_DATE,
                            PDI_BUSINESS_CLOSURE_DATE,
                            PVI_COMPANY_NAME,
                            PDI_LAST_MODIFICATION_DATE,
                            PNI_BUSINESS_CLOSURE_ID,
                            PNI_BUSINESS_TYPE_ID,
                            PCI_ACTIVITY_STATUS,
                            PCI_VERIFIED_STATUS,
                            PNI_BUSINESS_SUB_TYPE,
                            PNI_FEDERAL_ID,
                            PNI_PARTNER_TYPE_ID,
                            PCI_PAY_ON_PAY,
                            PNI_INTREPID_CODE_NUMBER);

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'BUSINESS_ID=' || PNI_BUSINESS_ID || ' has been loaded to S_BUSINESS'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'BUSINESS_ID=' || PNI_BUSINESS_ID || ' has already existed in S_BUSINESS'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of BUSINESS_ID=' || PNI_BUSINESS_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_BUSINESS;

    PROCEDURE SP_ETL_PEOPLE (
    /****************************************************************************
      NAME:      SP_ETL_PEOPLE
      PURPOSE:   Processing of S_PEOPLE
      REVISIONS:
      Ver          Date       Author             Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_PEOPLE_ID                 IN        S_PEOPLE.PEOPLE_ID%TYPE,
        PNI_PEOPLE_TYPE_ID            IN        S_PEOPLE.PEOPLE_TYPE_ID%TYPE,
        PNI_PEOPLE_SUB_TYPE           IN        S_PEOPLE.PEOPLE_SUB_TYPE%TYPE := NULL,
        PVI_FIRST_NAME                IN        S_PEOPLE.FIRST_NAME%TYPE := NULL,
        PCI_MIDDLE_INITIAL            IN        S_PEOPLE.MIDDLE_INITIAL%TYPE := NULL,
        PVI_MIDDLE_NAME               IN        S_PEOPLE.MIDDLE_NAME%TYPE := NULL,
        PVI_LAST_NAME                 IN        S_PEOPLE.LAST_NAME%TYPE := NULL,
        PDI_BIRTH_DATE                IN        S_PEOPLE.BIRTH_DATE%TYPE := NULL,
        PVI_SOCIAL_SECURITY_NUMBER    IN        S_PEOPLE.SOCIAL_SECURITY_NUMBER%TYPE := NULL,
        PNI_FEDERAL_TAX_ID            IN        S_PEOPLE.FEDERAL_TAX_ID%TYPE := NULL,
        PVI_PREFIX                    IN        S_PEOPLE.PREFIX%TYPE := NULL,
        PCI_ACTIVITY_STATUS           IN        S_PEOPLE.ACTIVITY_STATUS%TYPE := NULL,
        PCI_VERIFIED_STATUS           IN        S_PEOPLE.VERIFIED_STATUS%TYPE := NULL,
        PVI_FULL_NAME                 IN        S_PEOPLE.FULL_NAME%TYPE := NULL,
        PNI_USER_ID                   IN        S_PEOPLE.USER_ID%TYPE := NULL,
        PVI_INTREPID_CODE             IN        S_PEOPLE.INTREPID_CODE%TYPE := NULL,
        PVI_CREATED_BY                IN        S_PEOPLE.CREATED_BY%TYPE := NULL,
        PDI_CREATION_DATE             IN        S_PEOPLE.CREATION_DATE%TYPE,
        PCI_GENDER                    IN        S_PEOPLE.GENDER%TYPE := NULL,
        PVI_PARTIAL_SSN               IN        S_PEOPLE.PARTIAL_SSN%TYPE := NULL,
        PNI_STG_ETL_ID                IN        R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                    OUT       NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_PEOPLE';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for PNI_PEOPLE_ID=' || PNI_PEOPLE_ID
        );

        INSERT INTO S_PEOPLE
                (PEOPLE_ID,
                 PEOPLE_TYPE_ID,
                 PEOPLE_SUB_TYPE,
                 FIRST_NAME,
                 MIDDLE_INITIAL,
                 MIDDLE_NAME,
                 LAST_NAME,
                 BIRTH_DATE,
                 SOCIAL_SECURITY_NUMBER,
                 FEDERAL_TAX_ID,
                 PREFIX,
                 ACTIVITY_STATUS,
                 VERIFIED_STATUS,
                 FULL_NAME,
                 USER_ID,
                 INTREPID_CODE,
                 CREATED_BY,
                 CREATION_DATE,
                 LAST_MODIFIED_BY,
                 LAST_MODIFICATION_DATE,
                 GENDER,
                 FIRST_NAME_SOUNDEX,
                 LAST_NAME_SOUNDEX,
                 PARTIAL_SSN
                )
         VALUES (PNI_PEOPLE_ID,
                 PNI_PEOPLE_TYPE_ID,
                 PNI_PEOPLE_SUB_TYPE,
                 PVI_FIRST_NAME,
                 PCI_MIDDLE_INITIAL,
                 PVI_MIDDLE_NAME,
                 PVI_LAST_NAME,
                 PDI_BIRTH_DATE,
                 PVI_SOCIAL_SECURITY_NUMBER,
                 PNI_FEDERAL_TAX_ID,
                 PVI_PREFIX,
                 PCI_ACTIVITY_STATUS,
                 PCI_VERIFIED_STATUS,
                 PVI_FULL_NAME,
                 PNI_USER_ID,
                 PVI_INTREPID_CODE,
                 PVI_CREATED_BY,
                 PDI_CREATION_DATE,
                 PVI_CREATED_BY,
                 PDI_CREATION_DATE,
                 PCI_GENDER,
                 PVI_FIRST_NAME,
                 PVI_LAST_NAME,
                 PVI_PARTIAL_SSN
                );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'PEOPLE_ID=' || PNI_PEOPLE_ID || ' has been loaded to S_PEOPLE'
        );
        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'PEOPLE_ID=' || PNI_PEOPLE_ID || ' has already existed in S_PEOPLE'
            );
            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of PEOPLE_ID=' || PNI_PEOPLE_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_PEOPLE;

    PROCEDURE SP_ETL_ADDRESS (
    /****************************************************************************
      NAME:      SP_ETL_ADDRESS
      PURPOSE:   Inserting S_ADDRESS
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PVI_COUNTY                      IN      S_ADDRESS.COUNTY%TYPE,
        PCI_REQUIRES_GEOCODING          IN      S_ADDRESS.REQUIRES_GEOCODING%TYPE,
        PVI_P_MAPCODE                   IN      S_ADDRESS.MAPCODE%TYPE,
        PVI_COUNTRY                     IN      S_ADDRESS.COUNTRY%TYPE,
        PVI_ALTERNATE_COMPANY_NAME      IN      S_ADDRESS.ALTERNATE_COMPANY_NAME%TYPE,
        PCI_STATE_CODE                  IN      S_ADDRESS.STATE_CODE%TYPE,
        PNI_BUSINESS_ID                 IN      S_ADDRESS.BUSINESS_ID%TYPE,
        PNI_PEOPLE_ID                   IN      S_ADDRESS.PEOPLE_ID%TYPE,
        PVI_INTREPID_CODE               IN      S_ADDRESS.INTREPID_CODE%TYPE,
        PVI_ADDRESS1                    IN      S_ADDRESS.ADDRESS1%TYPE,
        PVI_ADDRESS2                    IN      S_ADDRESS.ADDRESS2%TYPE,
        PVI_ADDRESS3                    IN      S_ADDRESS.ADDRESS3%TYPE,
        PNI_ADDRESS_ID                  IN      S_ADDRESS.ADDRESS_ID%TYPE,
        PVI_ZIP_PLUS_FOUR               IN      S_ADDRESS.ZIP_PLUS_FOUR%TYPE,
        PNI_LONGITUDE                   IN      S_ADDRESS.LONGITUDE%TYPE,
        PNI_LATITUDE                    IN      S_ADDRESS.LATITUDE%TYPE,
        PCI_ACTIVITY_STATUS             IN      S_ADDRESS.ACTIVITY_STATUS%TYPE,
        PNI_ADDRESS_TYPE_ID             IN      S_ADDRESS.ADDRESS_TYPE_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_ADDRESS';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for ADDRESS_ID=' || PNI_ADDRESS_ID
        );

      INSERT INTO S_ADDRESS ( COUNTY,
                              REQUIRES_GEOCODING,
                              MAPCODE,
                              COUNTRY,
                              ALTERNATE_COMPANY_NAME,
                              STATE_CODE,
                              BUSINESS_ID,
                              PEOPLE_ID,
                              INTREPID_CODE,
                              ADDRESS1,
                              ADDRESS2,
                              ADDRESS3,
                              ADDRESS_ID,
                              ZIP_PLUS_FOUR,
                              LONGITUDE,
                              LATITUDE,
                              ACTIVITY_STATUS,
                              ADDRESS_TYPE_ID )
      VALUES ( PVI_COUNTY,
               PCI_REQUIRES_GEOCODING,
               PVI_P_MAPCODE,
               PVI_COUNTRY,
               PVI_ALTERNATE_COMPANY_NAME,
               PCI_STATE_CODE,
               PNI_BUSINESS_ID,
               PNI_PEOPLE_ID,
               PVI_INTREPID_CODE,
               PVI_ADDRESS1,
               PVI_ADDRESS2,
               PVI_ADDRESS3,
               PNI_ADDRESS_ID,
               PVI_ZIP_PLUS_FOUR,
               PNI_LONGITUDE,
               PNI_LATITUDE,
               PCI_ACTIVITY_STATUS,
               PNI_ADDRESS_TYPE_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'ADDRESS_ID=' || PNI_ADDRESS_ID || ' has been loaded to S_ADDRESS'
        );

        PNO_STATUS := 1;

    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ADDRESS_ID=' || PNI_ADDRESS_ID || ' has already existed in S_ADDRESS'
            );
            PNO_STATUS := 1;

      WHEN OTHERS
      THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of ADDRESS_ID=' || PNI_ADDRESS_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_ADDRESS;

    PROCEDURE SP_ETL_CONTACT (
    /****************************************************************************
      NAME:      SP_ETL_CONTACT
      PURPOSE:   Processing of S_CONTACT
      REVISIONS:
      Ver        Date        Author             Description
      ---------  ----------  -----------------  ----------------------------
      
    *****************************************************************************/
        PNI_CONTACT_ID                  IN      S_CONTACT.CONTACT_ID%TYPE,
        PNI_CONTACT_TYPE_ID             IN      S_CONTACT.CONTACT_TYPE_ID%TYPE := NULL,
        PNI_PEOPLE_ID                   IN      S_CONTACT.PEOPLE_ID%TYPE := NULL,
        PNI_BUSINESS_ID                 IN      S_CONTACT.BUSINESS_ID%TYPE := NULL,
        PVI_PHONE_NUMBER                IN      S_CONTACT.PHONE_NUMBER%TYPE := NULL,
        PVI_PHONE_NUMBER_EXTENSION      IN      S_CONTACT.PHONE_NUMBER_EXTENSION%TYPE := NULL,
        PVI_HOME_PHONE                  IN      S_CONTACT.HOME_PHONE%TYPE := NULL,
        PVI_OTHER_PHONE                 IN      S_CONTACT.OTHER_PHONE%TYPE := NULL,
        PNI_OTHER_PHONE_TYPE_ID         IN      S_CONTACT.PHONE_TYPE_ID%TYPE := NULL,
        PVI_FAX                         IN      S_CONTACT.FAX%TYPE := NULL,
        PVI_EMAIL_ADDRESS               IN      S_CONTACT.EMAIL_ADDRESS%TYPE := NULL,
        PVI_WEB_SITE                    IN      S_CONTACT.WEB_SITE%TYPE := NULL,
        PCI_ACTIVITY_STATUS             IN      S_CONTACT.ACTIVITY_STATUS%TYPE := NULL,
        PNI_ADDRESS_ID                  IN      S_CONTACT.ADDRESS_ID%TYPE := NULL,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_CONTACT';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for CONTACT_ID=' || PNI_CONTACT_ID
        );

        INSERT INTO S_CONTACT
                (CONTACT_ID,
                 CONTACT_TYPE_ID,
                 PEOPLE_ID,
                 BUSINESS_ID,
                 PHONE_NUMBER,
                 PHONE_NUMBER_EXTENSION,
                 HOME_PHONE,
                 OTHER_PHONE,
                 PHONE_TYPE_ID,
                 FAX,
                 EMAIL_ADDRESS,
                 WEB_SITE,
                 ACTIVITY_STATUS,
                 ADDRESS_ID
                )
         VALUES (PNI_CONTACT_ID,
                 PNI_CONTACT_TYPE_ID,
                 PNI_PEOPLE_ID,
                 PNI_BUSINESS_ID,
                 PVI_PHONE_NUMBER,
                 PVI_PHONE_NUMBER_EXTENSION,
                 PVI_HOME_PHONE,
                 PVI_OTHER_PHONE,
                 PNI_OTHER_PHONE_TYPE_ID,
                 PVI_FAX,
                 PVI_EMAIL_ADDRESS,
                 PVI_WEB_SITE,
                 PCI_ACTIVITY_STATUS,
                 PNI_ADDRESS_ID
                );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'CONTACT_ID=' || PNI_CONTACT_ID || ' has been loaded to S_CONTACT'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'CONTACT_ID=' || PNI_CONTACT_ID || ' has already existed in S_CONTACT'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of CONTACT_ID=' || PNI_CONTACT_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_CONTACT;

    PROCEDURE SP_ETL_SCM (
    /****************************************************************************
      NAME:      SP_ETL_SCM
      PURPOSE:   Inserting S_CASE_MASTER
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_CASE_MASTER_ID              IN      S_CASE_MASTER.CASE_MASTER_ID%TYPE,
        PVI_CLAIM_NUMBER                IN      S_CASE_MASTER.CLAIM_NUMBER%TYPE,
        PDI_DATE_OF_INJURY              IN      S_CASE_MASTER.DATE_OF_INJURY%TYPE,
        PDI_CREATION_DATE               IN      S_CASE_MASTER.CREATION_DATE%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_CASE_MASTER.LAST_MODIFICATION_DATE%TYPE,
        PVI_CREATED_BY                  IN      S_CASE_MASTER.CREATED_BY%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_CASE_MASTER.LAST_MODIFIED_BY%TYPE,
        PCI_AGED                        IN      S_CASE_MASTER.AGED%TYPE,
        PCI_AGED_TYPE                   IN      S_CASE_MASTER.AGED_TYPE%TYPE,
        PNI_EXTERNAL_REFERRAL_ID        IN      S_CASE_MASTER.EXTERNAL_REFERRAL_ID%TYPE,
        PVI_EXTERNAL_REFERRAL_TYPE      IN      S_CASE_MASTER.EXTERNAL_REFERRAL_TYPE%TYPE,
        PNI_PATIENT_ID                  IN      S_CASE_MASTER.PATIENT_ID%TYPE,
        PVI_INTREPID_CODE               IN      S_CASE_MASTER.INTREPID_CODE%TYPE,
        PNI_DUP_CASE_MASTER_ID          IN      S_CASE_MASTER.DUP_CASE_MASTER_ID%TYPE,
        PCI_ACTIVITY_STATUS             IN      S_CASE_MASTER.ACTIVITY_STATUS%TYPE,
        PNI_PRIMARY_PAYER_ID            IN      S_CASE_MASTER.PRIMARY_PAYER_ID%TYPE,
        PNI_EMP_AT_TIME_OF_INJURY_ID    IN      S_CASE_MASTER.EMPLOYER_AT_TIME_OF_INJURY_ID%TYPE,
        PNI_LINE_OF_BUSINESS_ID         IN      S_CASE_MASTER.LINE_OF_BUSINESS_ID%TYPE,
        PNI_JURISDICTION_ID             IN      S_CASE_MASTER.JURISDICTION_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RCM';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for CASE_MASTER_ID=' || PNI_CASE_MASTER_ID
        );

      INSERT INTO S_CASE_MASTER ( CASE_MASTER_ID,
                                  CLAIM_NUMBER,
                                  DATE_OF_INJURY,
                                  CREATION_DATE,
                                  LAST_MODIFICATION_DATE,
                                  CREATED_BY,
                                  LAST_MODIFIED_BY,
                                  AGED,
                                  AGED_TYPE,
                                  EXTERNAL_REFERRAL_ID,
                                  EXTERNAL_REFERRAL_TYPE,
                                  PATIENT_ID,
                                  INTREPID_CODE,
                                  DUP_CASE_MASTER_ID,
                                  ACTIVITY_STATUS,
                                  PRIMARY_PAYER_ID,
                                  EMPLOYER_AT_TIME_OF_INJURY_ID,
                                  LINE_OF_BUSINESS_ID,
                                  JURISDICTION_ID )
      VALUES ( PNI_CASE_MASTER_ID,
               PVI_CLAIM_NUMBER,
               PDI_DATE_OF_INJURY,
               PDI_CREATION_DATE,
               PDI_LAST_MODIFICATION_DATE,
               PVI_CREATED_BY,
               PVI_LAST_MODIFIED_BY,
               PCI_AGED,
               PCI_AGED_TYPE,
               PNI_EXTERNAL_REFERRAL_ID,
               PVI_EXTERNAL_REFERRAL_TYPE,
               PNI_PATIENT_ID,
               PVI_INTREPID_CODE,
               PNI_DUP_CASE_MASTER_ID,
               PCI_ACTIVITY_STATUS,
               PNI_PRIMARY_PAYER_ID,
               PNI_EMP_AT_TIME_OF_INJURY_ID,
               PNI_LINE_OF_BUSINESS_ID,
               PNI_JURISDICTION_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'CASE_MASTER_ID=' || PNI_CASE_MASTER_ID || ' has been loaded to S_CASE_MASTER'
        );

        PNO_STATUS := 1;

    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'CASE_MASTER_ID=' || PNI_CASE_MASTER_ID || ' has already existed in S_CASE_MASTER'
            );
            PNO_STATUS := 1;

      WHEN OTHERS
      THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" during loading of CASE_MASTER_ID=' || PNI_CASE_MASTER_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_SCM;

    PROCEDURE SP_ETL_RRM (
    /****************************************************************************
      NAME:        SP_ETL_RRM
      PURPOSE:     Processing of S_REFFERRAL_MASTER table
      REVISIONS:
      Ver           Date        Author             Description
      ------------  ----------  -----------------  ----------------------------
      
    *****************************************************************************/
        PDI_INTAKE_DATE                     IN   S_REFERRAL_MASTER.INTAKE_DATE%TYPE := NULL,
        PCI_PATIENT_OUT_OF_WORK                IN   S_REFERRAL_MASTER.PATIENT_OUT_OF_WORK%TYPE := NULL,
        PNI_REFERRAL_MASTER_ID                IN   S_REFERRAL_MASTER.REFERRAL_MASTER_ID%TYPE := NULL,
        PVI_PRECERTIFICATION_TEXT            IN   S_REFERRAL_MASTER.PRECERTIFICATION_TEXT%TYPE := NULL,
        PDI_FOLLOW_UP_DATE                    IN   S_REFERRAL_MASTER.FOLLOW_UP_DATE%TYPE := NULL,
        PVI_REF_TOTAL_COST_SAVINGS           IN   S_REFERRAL_MASTER.REFERRAL_TOTAL_COST_SAVINGS%TYPE := NULL,
        PNI_CASE_MASTER_ID                    IN   S_REFERRAL_MASTER.CASE_MASTER_ID%TYPE := NULL,
        PVI_CREATED_BY                        IN   S_REFERRAL_MASTER.CREATED_BY%TYPE := NULL,
        PDI_CREATION_DATE                    IN   S_REFERRAL_MASTER.CREATION_DATE%TYPE := NULL,
        PVI_LAST_MODIFIED_BY                IN   S_REFERRAL_MASTER.LAST_MODIFIED_BY%TYPE := NULL,
        PDI_LAST_MODIFICATION_DATE            IN   S_REFERRAL_MASTER.LAST_MODIFICATION_DATE%TYPE := NULL,
        PNI_REFERRING_MD_ID                    IN   S_REFERRAL_MASTER.REFERRING_MD_ID%TYPE := NULL,
        PNI_ADJUSTER_ID                        IN   S_REFERRAL_MASTER.ADJUSTER_ID%TYPE := NULL,
        PNI_NCM_ID                            IN   S_REFERRAL_MASTER.NCM_ID%TYPE := NULL,
        PCI_DISTR_1ST_CONTACT_FLAG          IN   S_REFERRAL_MASTER.DISTRIBUTOR_1ST_CONTACT_FLAG%TYPE := NULL,
        PNI_DISTRIBUTOR_PASS_NUMBER            IN   S_REFERRAL_MASTER.DISTRIBUTOR_PASS_NUMBER%TYPE := NULL,
        PCI_DISTRIBUTOR_OST_FLAG            IN   S_REFERRAL_MASTER.DISTRIBUTOR_OST_FLAG%TYPE := NULL,
        PNI_REFERRAL_TYPE_ID                IN   S_REFERRAL_MASTER.REFERRAL_TYPE_ID%TYPE := NULL,
        PNI_REFERRAL_SOURCE_TYPE_ID            IN   S_REFERRAL_MASTER.REFERRAL_SOURCE_TYPE_ID%TYPE := NULL,
        PNI_REFERRAL_METHOD_TYPE_ID            IN   S_REFERRAL_MASTER.REFERRAL_METHOD_TYPE_ID%TYPE := NULL,
        PNI_REFERRAL_PRIORITY_ID            IN   S_REFERRAL_MASTER.REFERRAL_PRIORITY_ID%TYPE := NULL,
        PCI_REQUEST_FILMS                    IN   S_REFERRAL_MASTER.REQUEST_FILMS%TYPE := NULL,
        PVI_CREATED_BY_USER_ID                IN   S_REFERRAL_MASTER.CREATED_BY_USER_ID%TYPE := NULL,
        PNI_LAST_MODIFIED_BY_USER_ID        IN   S_REFERRAL_MASTER.LAST_MODIFIED_BY_USER_ID%TYPE := NULL,
        PCI_REFERRAL_MASTER_STATUS            IN   S_REFERRAL_MASTER.REFERRAL_MASTER_STATUS%TYPE := NULL,
        PCI_IS_RETRO                        IN   S_REFERRAL_MASTER.IS_RETRO%TYPE := NULL,
        PCI_IS_CARVE_OUT                    IN   S_REFERRAL_MASTER.IS_CARVE_OUT%TYPE := NULL,
        PNI_CASE_MANAGER_ID                    IN   S_REFERRAL_MASTER.CASE_MANAGER_ID%TYPE := NULL,
        PNI_REFERRING_MD_LOCATION_ID        IN   S_REFERRAL_MASTER.REFERRING_MD_LOCATION_ID%TYPE := NULL,
        PVI_INTREPID_CODE                   IN   S_REFERRAL_MASTER.INTREPID_CODE%TYPE := NULL,
        PNI_CARRIER_ID                        IN   S_REFERRAL_MASTER.CARRIER_ID%TYPE := NULL,
        PNI_EXTERNAL_SOURCE_TYPE_ID            IN   S_REFERRAL_MASTER.EXTERNAL_SOURCE_TYPE_ID%TYPE := NULL,
        PNI_REFERRAL_SUBTYPE_ID                IN   S_REFERRAL_MASTER.REFERRAL_SUBTYPE_ID%TYPE := NULL,
        PVI_SPOKE_TO                        IN   S_REFERRAL_MASTER.SPOKE_TO%TYPE := NULL,
        PCI_CD_REQUEST                        IN   S_REFERRAL_MASTER.CD_REQUEST%TYPE := NULL,
        PCI_IS_TRANSPORTATION_REQUIRED        IN   S_REFERRAL_MASTER.IS_TRANSPORTATION_REQUIRED%TYPE := NULL,
        PCI_IS_INTERPRETATION_REQUIRED        IN   S_REFERRAL_MASTER.IS_INTERPRETATION_REQUIRED%TYPE := NULL,
        PNI_REFERRAL_QUEUE_ID                IN   S_REFERRAL_MASTER.REFERRAL_QUEUE_ID%TYPE := NULL,
        PNI_STG_ETL_ID                      IN   R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                          OUT  NUMBER
    )

    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RRM';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
    BEGIN

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for REFERRAL_MASTER_ID=' || PNI_REFERRAL_MASTER_ID
        );

        INSERT INTO S_REFERRAL_MASTER (
            INTAKE_DATE,
            PATIENT_OUT_OF_WORK,
            REFERRAL_MASTER_ID,
            PRECERTIFICATION_TEXT,
            FOLLOW_UP_DATE,
            REFERRAL_TOTAL_COST_SAVINGS,
            CASE_MASTER_ID,
            CREATED_BY,
            CREATION_DATE,
            LAST_MODIFIED_BY,
            LAST_MODIFICATION_DATE,
            REFERRING_MD_ID,
            ADJUSTER_ID,
            NCM_ID,
            DISTRIBUTOR_1ST_CONTACT_FLAG,
            DISTRIBUTOR_PASS_NUMBER,
            DISTRIBUTOR_OST_FLAG,
            REFERRAL_TYPE_ID,
            REFERRAL_SOURCE_TYPE_ID,
            REFERRAL_METHOD_TYPE_ID,
            REFERRAL_PRIORITY_ID,
            REQUEST_FILMS,
            CREATED_BY_USER_ID,
            LAST_MODIFIED_BY_USER_ID,
            REFERRAL_MASTER_STATUS,
            IS_RETRO,
            IS_CARVE_OUT,
            CASE_MANAGER_ID,
            REFERRING_MD_LOCATION_ID,
            INTREPID_CODE,
            CARRIER_ID,
            EXTERNAL_SOURCE_TYPE_ID,
            REFERRAL_SUBTYPE_ID,
            SPOKE_TO,
            CD_REQUEST,
            IS_TRANSPORTATION_REQUIRED,
            IS_INTERPRETATION_REQUIRED,
            REFERRAL_QUEUE_ID)
        VALUES(
            PDI_INTAKE_DATE,
            PCI_PATIENT_OUT_OF_WORK,
            PNI_REFERRAL_MASTER_ID,
            PVI_PRECERTIFICATION_TEXT,
            PDI_FOLLOW_UP_DATE,
            PVI_REF_TOTAL_COST_SAVINGS,
            PNI_CASE_MASTER_ID,
            PVI_CREATED_BY,
            PDI_CREATION_DATE,
            PVI_LAST_MODIFIED_BY,
            PDI_LAST_MODIFICATION_DATE,
            PNI_REFERRING_MD_ID,
            PNI_ADJUSTER_ID,
            PNI_NCM_ID,
            NVL(PCI_DISTR_1ST_CONTACT_FLAG, 'N'),
            NVL(PNI_DISTRIBUTOR_PASS_NUMBER, 0),
            NVL(PCI_DISTRIBUTOR_OST_FLAG, 'N'),
            PNI_REFERRAL_TYPE_ID,
            PNI_REFERRAL_SOURCE_TYPE_ID,
            PNI_REFERRAL_METHOD_TYPE_ID,
            PNI_REFERRAL_PRIORITY_ID,
            PCI_REQUEST_FILMS,
            PVI_CREATED_BY_USER_ID,
            PNI_LAST_MODIFIED_BY_USER_ID,
            PCI_REFERRAL_MASTER_STATUS,
            PCI_IS_RETRO,
            PCI_IS_CARVE_OUT,
            PNI_CASE_MANAGER_ID,
            PNI_REFERRING_MD_LOCATION_ID,
            PVI_INTREPID_CODE,
            PNI_CARRIER_ID,
            NVL(PNI_EXTERNAL_SOURCE_TYPE_ID, 12241),
            PNI_REFERRAL_SUBTYPE_ID,
            PVI_SPOKE_TO,
            NVL(PCI_CD_REQUEST, 'N'),
            NVL(PCI_IS_TRANSPORTATION_REQUIRED, 'N'),
            NVL(PCI_IS_INTERPRETATION_REQUIRED, 'N'),
            PNI_REFERRAL_QUEUE_ID
        );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'REFERRAL_MASTER_ID=' || PNI_REFERRAL_MASTER_ID || ' has been loaded to S_REFERRAL_MASTER'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'REFERRAL_MASTER_ID=' || PNI_REFERRAL_MASTER_ID || ' has already existed in S_REFERRAL_MASTER'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of REFERRAL_MASTER_ID=' || PNI_REFERRAL_MASTER_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_RRM;


    PROCEDURE SP_ETL_VISIT (
    /****************************************************************************
      NAME:      SP_ETL_VISIT
      PURPOSE:   Inserting S_VISIT
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_VISIT_ID                    IN      S_VISIT.VISIT_ID%TYPE,
        PDI_DUE_DATE                    IN      S_VISIT.DUE_DATE%TYPE,
        PVI_CREATED_BY                  IN      S_VISIT.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_VISIT.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_VISIT.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_VISIT.LAST_MODIFICATION_DATE%TYPE,
        PCI_CONFIRMED_WITH_PATIENT      IN      S_VISIT.CONFIRMED_WITH_PATIENT%TYPE,
        PNI_REFERRAL_MASTER_ID          IN      S_VISIT.REFERRAL_MASTER_ID%TYPE,
        PNI_BUSINESS_ID                 IN      S_VISIT.BUSINESS_ID%TYPE,
        PNI_PEOPLE_ID                   IN      S_VISIT.PEOPLE_ID%TYPE,
        PNI_OCM_REVIEVER_ID             IN      S_VISIT.OCM_REVIEVER_ID%TYPE,
        PNI_SERVICE_ID                  IN      S_VISIT.SERVICE_ID%TYPE,
        PVI_CLINICAL_REVIEW_STATUS      IN      S_VISIT.CLINICAL_REVIEW_STATUS%TYPE,
        PCI_DONE_DEAL                   IN      S_VISIT.DONE_DEAL%TYPE,
        PCI_ACTIVITY_STATUS             IN      S_VISIT.ACTIVITY_STATUS%TYPE,
        PDI_SCHEDULED_DATE              IN      S_VISIT.SCHEDULED_DATE%TYPE,
        PNI_CLINICAL_REVIEW_TYPE        IN      S_VISIT.CLINICAL_REVIEW_TYPE%TYPE,
        PNI_CO_OWNER_ID                 IN      S_VISIT.CO_OWNER_ID%TYPE,
        PNI_LAST_VISIT_ID               IN      S_VISIT.LAST_VISIT_ID%TYPE,
        PNI_INTERPRETATION_CHOICE_ID    IN      S_VISIT.INTERPRETATION_CHOICE_ID%TYPE,
        PNI_TRANSPORTATION_CHOICE_ID    IN      S_VISIT.TRANSPORTATION_CHOICE_ID%TYPE,
        PNI_PARENT_BUSINESS_ID          IN      S_VISIT.PARENT_BUSINESS_ID%TYPE,
        PNI_EXTERNAL_REVIEVER_ID        IN      S_VISIT.EXTERNAL_REVIEVER_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RV';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for VISIT_ID=' || PNI_VISIT_ID
        );

      INSERT INTO S_VISIT ( VISIT_ID,
                            DUE_DATE,
                            CREATED_BY,
                            CREATION_DATE,
                            LAST_MODIFIED_BY,
                            LAST_MODIFICATION_DATE,
                            CONFIRMED_WITH_PATIENT,
                            REFERRAL_MASTER_ID,
                            BUSINESS_ID,
                            PEOPLE_ID,
                            OCM_REVIEVER_ID,
                            SERVICE_ID,
                            CLINICAL_REVIEW_STATUS,
                            DONE_DEAL,
                            ACTIVITY_STATUS,
                            SCHEDULED_DATE,
                            CLINICAL_REVIEW_TYPE,
                            CO_OWNER_ID,
                            LAST_VISIT_ID,
                            INTERPRETATION_CHOICE_ID,
                            TRANSPORTATION_CHOICE_ID,
                            PARENT_BUSINESS_ID,
                            EXTERNAL_REVIEVER_ID )
      VALUES ( PNI_VISIT_ID,
               PDI_DUE_DATE,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PCI_CONFIRMED_WITH_PATIENT,
               PNI_REFERRAL_MASTER_ID,
               PNI_BUSINESS_ID,
               PNI_PEOPLE_ID,
               PNI_OCM_REVIEVER_ID,
               PNI_SERVICE_ID,
               PVI_CLINICAL_REVIEW_STATUS,
               PCI_DONE_DEAL,
               PCI_ACTIVITY_STATUS,
               PDI_SCHEDULED_DATE,
               PNI_CLINICAL_REVIEW_TYPE,
               PNI_CO_OWNER_ID,
               PNI_LAST_VISIT_ID,
               PNI_INTERPRETATION_CHOICE_ID,
               PNI_TRANSPORTATION_CHOICE_ID,
               PNI_PARENT_BUSINESS_ID,
               PNI_EXTERNAL_REVIEVER_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'VISIT_ID=' || PNI_VISIT_ID || ' has been loaded to S_VISIT'
        );

        PNO_STATUS := 1;


    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'VISIT_ID=' || PNI_VISIT_ID || ' has already existed in S_VISIT'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of PNI_VISIT_ID=' || PNI_VISIT_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_VISIT;


    PROCEDURE SP_ETL_REFERRAL_DETAIL (
    /****************************************************************************
      NAME:      SP_ETL_REFERRAL_DETAIL
      PURPOSE:   Inserting S_REFERRAL_DETAIL
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PDI_RELEASE_TO_BILLING_DATE     IN      S_REFERRAL_DETAIL.RELEASE_TO_BILLING_DATE%TYPE,
        PNI_REFERRAL_DETAIL_ID          IN      S_REFERRAL_DETAIL.REFERRAL_DETAIL_ID%TYPE,
        PNI_VISIT_ID                    IN      S_REFERRAL_DETAIL.VISIT_ID%TYPE,
        PVI_CREATED_BY                  IN      S_REFERRAL_DETAIL.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_REFERRAL_DETAIL.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_REFERRAL_DETAIL.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_REFERRAL_DETAIL.LAST_MODIFICATION_DATE%TYPE,
        PNI_PACKAGE_ID                  IN      S_REFERRAL_DETAIL.PACKAGE_ID%TYPE,
        PNI_REFERRAL_LINE_NUMBER        IN      S_REFERRAL_DETAIL.REFERRAL_LINE_NUMBER%TYPE,
        PNI_REFERRAL_MASTER_ID          IN      S_REFERRAL_DETAIL.REFERRAL_MASTER_ID%TYPE,
        PNI_REASON_ID                   IN      S_REFERRAL_DETAIL.REASON_ID%TYPE,
        PNI_CLAIM_RESOLUTION_TYPE_ID    IN      S_REFERRAL_DETAIL.CLAIM_RESOLUTION_TYPE_ID%TYPE,
        PCI_REFERRAL_DETAIL_STATUS      IN      S_REFERRAL_DETAIL.REFERRAL_DETAIL_STATUS%TYPE,
        PNI_CREATED_BY_USER_ID          IN      S_REFERRAL_DETAIL.CREATED_BY_USER_ID%TYPE,
        PNI_LAST_MODIFIED_BY_USER_ID    IN      S_REFERRAL_DETAIL.LAST_MODIFIED_BY_USER_ID%TYPE,
        PDI_DATE_OF_SERVICE             IN      S_REFERRAL_DETAIL.DATE_OF_SERVICE%TYPE,
        PCI_FEE_NEGOTIATION             IN      S_REFERRAL_DETAIL.FEE_NEGOTIATION%TYPE,
        PNI_PEOPLE_ID                   IN      S_REFERRAL_DETAIL.PEOPLE_ID%TYPE,
        PNI_AGING_SOURCE_ID             IN      S_REFERRAL_DETAIL.AGING_SOURCE_ID%TYPE,
        PVI_AGED_NOTE                   IN      S_REFERRAL_DETAIL.AGED_NOTE%TYPE,
        PNI_AGING_REVIEWER_ID           IN      S_REFERRAL_DETAIL.AGING_REVIEWER_ID%TYPE,
        PNI_AGING_METHOD_ID             IN      S_REFERRAL_DETAIL.AGING_METHOD_ID%TYPE,
        PNI_AGING_OUTCOME_ID            IN      S_REFERRAL_DETAIL.AGING_OUTCOME_ID%TYPE,
        PNI_AGING_EXT_REVIEWER_ID       IN      S_REFERRAL_DETAIL.AGING_EXT_REVIEWER_ID%TYPE,
        PCI_AGING_STATUS                IN      S_REFERRAL_DETAIL.AGING_STATUS%TYPE,
        PDI_AGING_DATE                  IN      S_REFERRAL_DETAIL.AGING_DATE%TYPE,
        PCI_MR_STATUS                   IN      S_REFERRAL_DETAIL.MR_STATUS%TYPE,
        PDI_MR_POSTED_DATE              IN      S_REFERRAL_DETAIL.MR_POSTED_DATE%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RRD';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for REFERRAL_DETAIL_ID=' || PNI_REFERRAL_DETAIL_ID
        );

      INSERT INTO S_REFERRAL_DETAIL ( RELEASE_TO_BILLING_DATE,
                                      REFERRAL_DETAIL_ID,
                                      VISIT_ID,
                                      CREATED_BY,
                                      CREATION_DATE,
                                      LAST_MODIFIED_BY,
                                      LAST_MODIFICATION_DATE,
                                      PACKAGE_ID,
                                      REFERRAL_LINE_NUMBER,
                                      REFERRAL_MASTER_ID,
                                      REASON_ID,
                                      CLAIM_RESOLUTION_TYPE_ID,
                                      REFERRAL_DETAIL_STATUS,
                                      CREATED_BY_USER_ID,
                                      LAST_MODIFIED_BY_USER_ID,
                                      DATE_OF_SERVICE,
                                      FEE_NEGOTIATION,
                                      PEOPLE_ID,
                                      AGING_SOURCE_ID,
                                      AGED_NOTE,
                                      AGING_REVIEWER_ID,
                                      AGING_METHOD_ID,
                                      AGING_OUTCOME_ID,
                                      AGING_EXT_REVIEWER_ID,
                                      AGING_STATUS,
                                      AGING_DATE,
                                      MR_STATUS,
                                      MR_POSTED_DATE )
      VALUES ( PDI_RELEASE_TO_BILLING_DATE,
               PNI_REFERRAL_DETAIL_ID,
               PNI_VISIT_ID,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PNI_PACKAGE_ID,
               PNI_REFERRAL_LINE_NUMBER,
               PNI_REFERRAL_MASTER_ID,
               PNI_REASON_ID,
               PNI_CLAIM_RESOLUTION_TYPE_ID,
               PCI_REFERRAL_DETAIL_STATUS,
               PNI_CREATED_BY_USER_ID,
               PNI_LAST_MODIFIED_BY_USER_ID,
               PDI_DATE_OF_SERVICE,
               PCI_FEE_NEGOTIATION,
               PNI_PEOPLE_ID,
               PNI_AGING_SOURCE_ID,
               PVI_AGED_NOTE,
               PNI_AGING_REVIEWER_ID,
               PNI_AGING_METHOD_ID,
               PNI_AGING_OUTCOME_ID,
               PNI_AGING_EXT_REVIEWER_ID,
               PCI_AGING_STATUS,
               PDI_AGING_DATE,
               PCI_MR_STATUS,
               PDI_MR_POSTED_DATE );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'REFERRAL_DETAIL_ID=' || PNI_REFERRAL_DETAIL_ID || ' has been loaded to S_REFERRAL_DETAIL'
        );

        PNO_STATUS := 1;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'REFERRAL_DETAIL_ID=' || PNI_REFERRAL_DETAIL_ID || ' has already existed in S_REFERRAL_DETAIL'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of REFERRAL_DETAIL_ID=' || PNI_REFERRAL_DETAIL_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_REFERRAL_DETAIL;


    PROCEDURE SP_ETL_BILL_MASTER (
    /****************************************************************************
      NAME:      SP_ETL_BILL_MASTER
      PURPOSE:   Inserting S_BILL_MASTER
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_BILL_MASTER_ID              IN      S_BILL_MASTER.BILL_MASTER_ID%TYPE,
        PDI_HCFA_RECEIVED_DATE          IN      S_BILL_MASTER.HCFA_RECEIVED_DATE%TYPE,
        PVI_CREATED_BY                  IN      S_BILL_MASTER.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_BILL_MASTER.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_BILL_MASTER.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_BILL_MASTER.LAST_MODIFICATION_DATE%TYPE,
        PCI_RETRO_REFERRAL              IN      S_BILL_MASTER.RETRO_REFERRAL%TYPE,
        PCI_SPLIT_BILL                  IN      S_BILL_MASTER.SPLIT_BILL%TYPE,
        PVI_BILL_CODE                   IN      S_BILL_MASTER.BILL_CODE%TYPE,
        PNI_VISIT_ID                    IN      S_BILL_MASTER.VISIT_ID%TYPE,
        PCI_AR_BILL_STATUS              IN      S_BILL_MASTER.AR_BILL_STATUS%TYPE,
        PCI_AP_BILL_STATUS              IN      S_BILL_MASTER.AP_BILL_STATUS%TYPE,
        PCI_SPLIT_PAYER                 IN      S_BILL_MASTER.SPLIT_PAYER%TYPE,
        PNI_BILLING_LOCATION_ID         IN      S_BILL_MASTER.BILLING_LOCATION_ID%TYPE,
        PNI_NOTE_ID                     IN      S_BILL_MASTER.NOTE_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RBM';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for BILL_MASTER_ID=' || PNI_BILL_MASTER_ID
        );

      INSERT INTO S_BILL_MASTER ( BILL_MASTER_ID,
                                  HCFA_RECEIVED_DATE,
                                  CREATED_BY,
                                  CREATION_DATE,
                                  LAST_MODIFIED_BY,
                                  LAST_MODIFICATION_DATE,
                                  RETRO_REFERRAL,
                                  SPLIT_BILL,
                                  BILL_CODE,
                                  VISIT_ID,
                                  AR_BILL_STATUS,
                                  AP_BILL_STATUS,
                                  SPLIT_PAYER,
                                  BILLING_LOCATION_ID,
                                  NOTE_ID )
      VALUES ( PNI_BILL_MASTER_ID,
               PDI_HCFA_RECEIVED_DATE,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PCI_RETRO_REFERRAL,
               PCI_SPLIT_BILL,
               PVI_BILL_CODE,
               PNI_VISIT_ID,
               PCI_AR_BILL_STATUS,
               PCI_AP_BILL_STATUS,
               PCI_SPLIT_PAYER,
               PNI_BILLING_LOCATION_ID,
               PNI_NOTE_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'BILL_MASTER_ID=' || PNI_BILL_MASTER_ID || ' has been loaded to S_BILL_MASTER'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'BILL_MASTER_ID=' || PNI_BILL_MASTER_ID || ' has already existed in S_BILL_MASTER'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of BILL_MASTER_ID=' || PNI_BILL_MASTER_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_BILL_MASTER;


    PROCEDURE SP_ETL_BILL_PACKAGE (
    /****************************************************************************
      NAME:       SP_ETL_BILL_PACKAGE
      PURPOSE:    Inserting S_BILL_PACKAGE
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_BILL_PACKAGE_ID             IN      S_BILL_PACKAGE.BILL_PACKAGE_ID%TYPE,
        PCI_BILL_PACKAGE_STATUS         IN      S_BILL_PACKAGE.BILL_PACKAGE_STATUS%TYPE,
        PVI_CREATED_BY                  IN      S_BILL_PACKAGE.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_BILL_PACKAGE.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_BILL_PACKAGE.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_BILL_PACKAGE.LAST_MODIFICATION_DATE%TYPE,
        PNI_PROV_CHANGE_BILL_PACK_ID    IN      S_BILL_PACKAGE.PROV_CHANGE_BILL_PACKAGE_ID%TYPE,
        PNI_PACKAGE_ID                  IN      S_BILL_PACKAGE.PACKAGE_ID%TYPE,
        PNI_REFERRAL_DETAIL_ID          IN      S_BILL_PACKAGE.REFERRAL_DETAIL_ID%TYPE,
        PNI_BILL_MASTER_ID              IN      S_BILL_PACKAGE.BILL_MASTER_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RBP';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for BILL_PACKAGE_ID=' || PNI_BILL_PACKAGE_ID
        );

      INSERT INTO S_BILL_PACKAGE ( BILL_PACKAGE_ID,
                                   BILL_PACKAGE_STATUS,
                                   CREATED_BY,
                                   CREATION_DATE,
                                   LAST_MODIFIED_BY,
                                   LAST_MODIFICATION_DATE,
                                   PROV_CHANGE_BILL_PACKAGE_ID,
                                   PACKAGE_ID,
                                   REFERRAL_DETAIL_ID,
                                   BILL_MASTER_ID )
      VALUES ( PNI_BILL_PACKAGE_ID,
               PCI_BILL_PACKAGE_STATUS,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PNI_PROV_CHANGE_BILL_PACK_ID,
               PNI_PACKAGE_ID,
               PNI_REFERRAL_DETAIL_ID,
               PNI_BILL_MASTER_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'BILL_PACKAGE_ID=' || PNI_BILL_PACKAGE_ID || ' has been loaded to S_BILL_PACKAGE'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'BILL_PACKAGE_ID=' || PNI_BILL_PACKAGE_ID || ' has already existed in S_BILL_PACKAGE'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of BILL_PACKAGE_ID=' || PNI_BILL_PACKAGE_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_BILL_PACKAGE;


    PROCEDURE SP_ETL_BILL_ITEM (
    /****************************************************************************
      NAME:       SP_ETL_BILL_ITEM
      PURPOSE:    Inserting S_BILL_ITEM
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_BILL_ITEM_ID                IN      S_BILL_ITEM.BILL_ITEM_ID%TYPE,
        PVI_INTREPID_CODE               IN      S_BILL_ITEM.INTREPID_CODE%TYPE,
        PCI_AP_TECH_STATUS              IN      S_BILL_ITEM.AP_TECH_STATUS%TYPE,
        PCI_AP_PROF_STATUS              IN      S_BILL_ITEM.AP_PROF_STATUS%TYPE,
        PVI_CREATED_BY                  IN      S_BILL_ITEM.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_BILL_ITEM.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_BILL_ITEM.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_BILL_ITEM.LAST_MODIFICATION_DATE%TYPE,
        PNI_PAYER_AMOUNT                IN      S_BILL_ITEM.PAYER_AMOUNT%TYPE,
        PNI_HCFA_AMOUNT                 IN      S_BILL_ITEM.HCFA_AMOUNT%TYPE,
        PNI_PROVIDER_AMOUNT             IN      S_BILL_ITEM.PROVIDER_AMOUNT%TYPE,
        PNI_MARGIN_AMOUNT               IN      S_BILL_ITEM.MARGIN_AMOUNT%TYPE,
        PNI_COST_SAVING_AMOUNT          IN      S_BILL_ITEM.COST_SAVING_AMOUNT%TYPE,
        PCI_ACCELERATED_FLAG            IN      S_BILL_ITEM.ACCELERATED_FLAG%TYPE,
        PCI_AR_STATUS                   IN      S_BILL_ITEM.AR_STATUS%TYPE,
        PCI_IS_BILLED                   IN      S_BILL_ITEM.IS_BILLED%TYPE,
        PCI_CONTRACT_STATUS             IN      S_BILL_ITEM.CONTRACT_STATUS%TYPE,
        PNI_BILL_PACKAGE_ID             IN      S_BILL_ITEM.BILL_PACKAGE_ID%TYPE,
        PNI_ADMIN_BROKER_AMOUNT         IN      S_BILL_ITEM.ADMIN_BROKER_AMOUNT%TYPE,
        PNI_TOTAL_PAYER_AMOUNT          IN      S_BILL_ITEM.TOTAL_PAYER_AMOUNT%TYPE,
        PNI_BILLING_REASON_ID           IN      S_BILL_ITEM.BILLING_REASON_ID%TYPE,
        PNI_DISALLOW_ID                 IN      S_BILL_ITEM.DISALLOW_ID%TYPE,
        PNI_RR_BUSINESS_ID              IN      S_BILL_ITEM.RR_BUSINESS_ID%TYPE,
        PNI_RESENT_TYPE_ID              IN      S_BILL_ITEM.RESENT_TYPE_ID%TYPE,
        PNI_NOTE_ID                     IN      S_BILL_ITEM.NOTE_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RBI';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for BILL_ITEM_ID=' || PNI_BILL_ITEM_ID
        );

      INSERT INTO S_BILL_ITEM ( BILL_ITEM_ID,
                                INTREPID_CODE,
                                AP_TECH_STATUS,
                                AP_PROF_STATUS,
                                CREATED_BY,
                                CREATION_DATE,
                                LAST_MODIFIED_BY,
                                LAST_MODIFICATION_DATE,
                                PAYER_AMOUNT,
                                HCFA_AMOUNT,
                                PROVIDER_AMOUNT,
                                MARGIN_AMOUNT,
                                COST_SAVING_AMOUNT,
                                ACCELERATED_FLAG,
                                AR_STATUS,
                                IS_BILLED,
                                CONTRACT_STATUS,
                                BILL_PACKAGE_ID,
                                ADMIN_BROKER_AMOUNT,
                                TOTAL_PAYER_AMOUNT,
                                BILLING_REASON_ID,
                                DISALLOW_ID,
                                RR_BUSINESS_ID,
                                RESENT_TYPE_ID,
                                NOTE_ID )
      VALUES ( PNI_BILL_ITEM_ID,
               PVI_INTREPID_CODE,
               PCI_AP_TECH_STATUS,
               PCI_AP_PROF_STATUS,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PNI_PAYER_AMOUNT,
               PNI_HCFA_AMOUNT,
               PNI_PROVIDER_AMOUNT,
               PNI_MARGIN_AMOUNT,
               PNI_COST_SAVING_AMOUNT,
               PCI_ACCELERATED_FLAG,
               PCI_AR_STATUS,
               PCI_IS_BILLED,
               PCI_CONTRACT_STATUS,
               PNI_BILL_PACKAGE_ID,
               PNI_ADMIN_BROKER_AMOUNT,
               PNI_TOTAL_PAYER_AMOUNT,
               PNI_BILLING_REASON_ID,
               PNI_DISALLOW_ID,
               PNI_RR_BUSINESS_ID,
               PNI_RESENT_TYPE_ID,
               PNI_NOTE_ID );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'BILL_ITEM_ID=' || PNI_BILL_ITEM_ID || ' has been loaded to S_BILL_ITEM'
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'BILL_ITEM_ID=' || PNI_BILL_ITEM_ID || ' has already existed in S_BILL_ITEM'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of BILL_ITEM_ID=' || PNI_BILL_ITEM_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_BILL_ITEM;


    PROCEDURE SP_ETL_HCFA_BILL_ITEM (
    /****************************************************************************
      NAME:       SP_ETL_HCFA_BILL_ITEM
      PURPOSE:    Inserting S_HCFA_BILL_ITEM
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_HCFA_BILL_ITEM_ID           IN      S_HCFA_BILL_ITEM.HCFA_BILL_ITEM_ID%TYPE,
        PNI_BILL_ITEM_ID                IN      S_HCFA_BILL_ITEM.BILL_ITEM_ID%TYPE,
        PNI_HCFA_CPT_CODE_ID            IN      S_HCFA_BILL_ITEM.HCFA_CPT_CODE_ID%TYPE,
        PNI_HCFA_TECH_MODIFIER_ID       IN      S_HCFA_BILL_ITEM.HCFA_TECH_MODIFIER_ID%TYPE,
        PNI_HCFA_PROF_MODIFIER_ID       IN      S_HCFA_BILL_ITEM.HCFA_PROF_MODIFIER_ID%TYPE,
        PDI_HCFA_PROF_RECEIVED_DATE     IN      S_HCFA_BILL_ITEM.HCFA_PROF_RECEIVED_DATE%TYPE,
        PDI_HCFA_TECH_RECEIVED_DATE     IN      S_HCFA_BILL_ITEM.HCFA_TECH_RECEIVED_DATE%TYPE,
        PDI_HCFA_TECH_START_DATE        IN      S_HCFA_BILL_ITEM.HCFA_TECH_START_DATE%TYPE,
        PDI_HCFA_TECH_END_DATE          IN      S_HCFA_BILL_ITEM.HCFA_TECH_END_DATE%TYPE,
        PVI_HCFA_TECH_PATIENT_ACCOUNT   IN      S_HCFA_BILL_ITEM.HCFA_TECH_PATIENT_ACCOUNT%TYPE,
        PVI_HCFA_PROF_PATIENT_ACCOUNT   IN      S_HCFA_BILL_ITEM.HCFA_PROF_PATIENT_ACCOUNT%TYPE,
        PNI_HCFA_TECH_AMOUNT            IN      S_HCFA_BILL_ITEM.HCFA_TECH_AMOUNT%TYPE,
        PDI_HCFA_PROF_START_DATE        IN      S_HCFA_BILL_ITEM.HCFA_PROF_START_DATE%TYPE,
        PDI_HCFA_PROF_END_DATE          IN      S_HCFA_BILL_ITEM.HCFA_PROF_END_DATE%TYPE,
        PNI_HCFA_PROF_AMOUNT            IN      S_HCFA_BILL_ITEM.HCFA_PROF_AMOUNT%TYPE,
        PNI_HCFA_TOTAL_AMOUNT           IN      S_HCFA_BILL_ITEM.HCFA_TOTAL_AMOUNT%TYPE,
        PVI_CREATED_BY                  IN      S_HCFA_BILL_ITEM.CREATED_BY%TYPE,
        PDI_CREATION_DATE               IN      S_HCFA_BILL_ITEM.CREATION_DATE%TYPE,
        PVI_LAST_MODIFIED_BY            IN      S_HCFA_BILL_ITEM.LAST_MODIFIED_BY%TYPE,
        PDI_LAST_MODIFICATION_DATE      IN      S_HCFA_BILL_ITEM.LAST_MODIFICATION_DATE%TYPE,
        PNI_TECH_PLACE_OF_SERVICE_ID    IN      S_HCFA_BILL_ITEM.TECH_PLACE_OF_SERVICE_ID%TYPE,
        PNI_TECH_TYPE_OF_SERVICE_ID     IN      S_HCFA_BILL_ITEM.TECH_TYPE_OF_SERVICE_ID%TYPE,
        PNI_PROF_TYPE_OF_SERVICE_ID     IN      S_HCFA_BILL_ITEM.PROF_TYPE_OF_SERVICE_ID%TYPE,
        PNI_PROF_PLACE_OF_SERVICE_ID    IN      S_HCFA_BILL_ITEM.PROF_PLACE_OF_SERVICE_ID%TYPE,
        PNI_ORIGINAL_HCFA_TECH_AMOUNT   IN      S_HCFA_BILL_ITEM.ORIGINAL_HCFA_TECH_AMOUNT%TYPE,
        PNI_ORIGINAL_HCFA_PROF_AMOUNT   IN      S_HCFA_BILL_ITEM.ORIGINAL_HCFA_PROF_AMOUNT%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_RHBI';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
        );

      INSERT INTO S_HCFA_BILL_ITEM ( HCFA_BILL_ITEM_ID,
                                     BILL_ITEM_ID,
                                     HCFA_CPT_CODE_ID,
                                     HCFA_TECH_MODIFIER_ID,
                                     HCFA_PROF_MODIFIER_ID,
                                     HCFA_PROF_RECEIVED_DATE,
                                     HCFA_TECH_RECEIVED_DATE,
                                     HCFA_TECH_START_DATE,
                                     HCFA_TECH_END_DATE,
                                     HCFA_TECH_PATIENT_ACCOUNT,
                                     HCFA_PROF_PATIENT_ACCOUNT,
                                     HCFA_TECH_AMOUNT,
                                     HCFA_PROF_START_DATE,
                                     HCFA_PROF_END_DATE,
                                     HCFA_PROF_AMOUNT,
                                     HCFA_TOTAL_AMOUNT,
                                     CREATED_BY,
                                     CREATION_DATE,
                                     LAST_MODIFIED_BY,
                                     LAST_MODIFICATION_DATE,
                                     TECH_PLACE_OF_SERVICE_ID,
                                     TECH_TYPE_OF_SERVICE_ID,
                                     PROF_TYPE_OF_SERVICE_ID,
                                     PROF_PLACE_OF_SERVICE_ID,
                                     ORIGINAL_HCFA_TECH_AMOUNT,
                                     ORIGINAL_HCFA_PROF_AMOUNT )
      VALUES ( PNI_HCFA_BILL_ITEM_ID,
               PNI_BILL_ITEM_ID,
               PNI_HCFA_CPT_CODE_ID,
               PNI_HCFA_TECH_MODIFIER_ID,
               PNI_HCFA_PROF_MODIFIER_ID,
               PDI_HCFA_PROF_RECEIVED_DATE,
               PDI_HCFA_TECH_RECEIVED_DATE,
               PDI_HCFA_TECH_START_DATE,
               PDI_HCFA_TECH_END_DATE,
               PVI_HCFA_TECH_PATIENT_ACCOUNT,
               PVI_HCFA_PROF_PATIENT_ACCOUNT,
               PNI_HCFA_TECH_AMOUNT,
               PDI_HCFA_PROF_START_DATE,
               PDI_HCFA_PROF_END_DATE,
               PNI_HCFA_PROF_AMOUNT,
               PNI_HCFA_TOTAL_AMOUNT,
               PVI_CREATED_BY,
               PDI_CREATION_DATE,
               PVI_LAST_MODIFIED_BY,
               PDI_LAST_MODIFICATION_DATE,
               PNI_TECH_PLACE_OF_SERVICE_ID,
               PNI_TECH_TYPE_OF_SERVICE_ID,
               PNI_PROF_TYPE_OF_SERVICE_ID,
               PNI_PROF_PLACE_OF_SERVICE_ID,
               PNI_ORIGINAL_HCFA_TECH_AMOUNT,
               PNI_ORIGINAL_HCFA_PROF_AMOUNT );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID || ' has been loaded to S_HCFA_BILL_ITEM'
        );

       PNO_STATUS := 1;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID || ' has already existed in S_HCFA_BILL_ITEM'
            );

            PNO_STATUS := 1;

        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during loading of HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
            );

            PNO_STATUS := 0;

    END SP_ETL_HCFA_BILL_ITEM;


    PROCEDURE SP_ETL_LBTD (
    /****************************************************************************
      NAME:      SP_ETL_LBTD
      PURPOSE:   Processing of S_BILL_TO_DIAGNOSIS
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNI_HCFA_BILL_ITEM_ID           IN      S_BILL_TO_DIAGNOSIS.HCFA_BILL_ITEM_ID%TYPE,
        PNI_BILL_MASTER_ID              IN      S_BILL_TO_DIAGNOSIS.BILL_MASTER_ID%TYPE,
        PNI_STG_ETL_ID                  IN      R_STG_ETL.STG_ETL_ID%TYPE := NULL,
        PNO_STATUS                      OUT     NUMBER
    )
    IS
        C$V_PROCEDURE                  CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_LBTD';
        N_STG_ETL_DETAIL_ID            R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

        N_DIAGNOSIS_DATA_EXISTS        PLS_INTEGER;
        L_DIAGNOSIS_LIST               T_NUMBER_LIST;
        EX_FAIL_DIAGNOSIS              EXCEPTION;
        N_STATUS                       NUMBER(1);

    BEGIN
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Start for HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID || ' [S_BILL_TO_DIAGNOSIS]'
        );

        FOR DIAG_RECORD IN (SELECT LBTD.ROW_ORDER,
                                   LBTD.DIAGNOSIS_ID
                              FROM M_CODE C,
                                   L_BILL_TO_DIAGNOSIS LBTD
                             WHERE C.CODE_ID = LBTD.DIAGNOSIS_ID
                               AND LBTD.BILL_MASTER_ID = PNI_BILL_MASTER_ID
                               AND LBTD.HCFA_BILL_ITEM_ID = PNI_HCFA_BILL_ITEM_ID
                           )
        LOOP
            BEGIN
                SP_ETL_DETAIL_LOG (
                    PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                    PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                    PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_INITIAL_ITEM_STATUS,
                    PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'Start for DIAGNOSIS_ID=' || DIAG_RECORD.DIAGNOSIS_ID
                );

                -- S_CODE processing
                SELECT COUNT(*)
                  INTO N_DIAGNOSIS_DATA_EXISTS
                  FROM M_CODE C
                 WHERE C.CODE_ID = DIAG_RECORD.DIAGNOSIS_ID;

                IF N_DIAGNOSIS_DATA_EXISTS > 0
                THEN
                    L_DIAGNOSIS_LIST := T_NUMBER_LIST(T_NUMBER(DIAG_RECORD.DIAGNOSIS_ID));

                    SP_ETL_CODE(PLI_CODES                  => L_DIAGNOSIS_LIST,
                                PNI_STG_ETL_ID             => PNI_STG_ETL_ID,
                                PNO_STATUS                 => N_STATUS);

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_DIAGNOSIS;
                    END IF;
                END IF;

                INSERT INTO S_BILL_TO_DIAGNOSIS (HCFA_BILL_ITEM_ID,
                                                 BILL_MASTER_ID,
                                                 DIAGNOSIS_ID,
                                                 ROW_ORDER )
                VALUES(
                       PNI_HCFA_BILL_ITEM_ID,
                       PNI_BILL_MASTER_ID,
                       DIAG_RECORD.DIAGNOSIS_ID,
                       DIAG_RECORD.ROW_ORDER
                      );

                SP_ETL_DETAIL_LOG (
                    PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                    PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                    PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'DIAGNOSIS_ID=' || DIAG_RECORD.DIAGNOSIS_ID || ' has been loaded to S_BILL_TO_DIAGNOSIS at HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
                );

            EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    SP_ETL_DETAIL_LOG (
                        PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                        PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                        PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                        PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'DIAGNOSIS_ID=' || DIAG_RECORD.DIAGNOSIS_ID || ' has already existed in S_BILL_TO_DIAGNOSIS at HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
                    );

            END;

        END LOOP;

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'All diagnosis have been uploaded to S_BILL_TO_DIAGNOSIS at HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID
        );

        PNO_STATUS := 1;

    EXCEPTION
        WHEN OTHERS
        THEN
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during uploading of diagnosis at HCFA_BILL_ITEM_ID=' || PNI_HCFA_BILL_ITEM_ID || ' to S_BILL_TO_DIAGNOSIS'
            );

            PNO_STATUS := 0;

    END SP_ETL_LBTD;

    PROCEDURE SP_ETL_LOG (
    /****************************************************************************
      NAME:       SP_ETL_LOG
      PURPOSE:    Logging the process of filling staging
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
      PNIO_STG_ETL_ID            IN OUT R_STG_ETL.STG_ETL_ID%TYPE,
      PVI_STG_ETL_STATUS         IN     R_STG_ETL.STG_ETL_STATUS%TYPE,
      PDI_STG_ETL_PROCESS_DATE   IN     R_STG_ETL.STG_ETL_PROCESS_DATE%TYPE
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        C$V_PROCEDURE                 CONSTANT VARCHAR2 (256) := 'PKG_STG_ETL.SP_ETL_LOG';
    BEGIN

        IF PNIO_STG_ETL_ID IS NULL
        THEN
            INSERT INTO R_STG_ETL(
                STG_ETL_ID,
                STG_ETL_STATUS,
                STG_ETL_PROCESS_DATE,
                STG_ETL_PROCESS_START_DATE,
                STG_ETL_PROCESS_END_DATE)
            VALUES(
                SEQ_STG_ETL.NEXTVAL,
                PVI_STG_ETL_STATUS,
                PDI_STG_ETL_PROCESS_DATE,
                SYSDATE,
                NULL)
            RETURNING
                STG_ETL_ID
            INTO
                PNIO_STG_ETL_ID;

        ELSE
            UPDATE R_STG_ETL
               SET STG_ETL_STATUS = PVI_STG_ETL_STATUS,
                   STG_ETL_PROCESS_END_DATE = SYSDATE
             WHERE STG_ETL_ID = PNIO_STG_ETL_ID;

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN ROLLBACK;
             PNIO_STG_ETL_ID := NULL; -- 01/12/2016 - AC: Processing of general errors should be elaborated.

    END SP_ETL_LOG;

    PROCEDURE SP_ETL_DETAIL_LOG (
    /****************************************************************************
      NAME:       SP_ETL_DETAIL_LOG
      PURPOSE:    Logging the process of filling staging
      REVISIONS:
      Ver        Date        Author              Description
      ---------  ----------  ---------------     ----------------------------
      
    *****************************************************************************/
        PNIO_STG_ETL_DETAIL_ID             IN OUT R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE,
        PNI_STG_ETL_ID                     IN     R_STG_ETL_DETAIL.STG_ETL_ID%TYPE,
        PVI_STG_ETL_DETAIL_STATUS          IN     R_STG_ETL_DETAIL.STG_ETL_DETAIL_STATUS%TYPE,
        PVI_STG_ETL_MODULE                 IN     R_STG_ETL_DETAIL.STG_ETL_MODULE%TYPE,
        PVI_MESSAGE                        IN     R_STG_ETL_DETAIL.MESSAGE%TYPE
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        C$V_PROCEDURE                 CONSTANT VARCHAR2 (256) := 'PKG_STG_ETL.SP_ETL_DETAIL_LOG';
    BEGIN

        IF PNIO_STG_ETL_DETAIL_ID IS NULL
        THEN
            INSERT INTO R_STG_ETL_DETAIL (
                STG_ETL_DETAIL_ID,
                STG_ETL_ID,
                STG_ETL_DETAIL_STATUS,
                STG_ETL_DETAIL_STEP_START_DATE,
                STG_ETL_DETAIL_STEP_END_DATE,
                STG_ETL_MODULE,
                MESSAGE)
            VALUES (
                SEQ_STG_ETL_DETAIL.NEXTVAL,
                PNI_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS,
                SYSDATE,
                NULL,
                PVI_STG_ETL_MODULE,
                PVI_MESSAGE)
            RETURNING
                STG_ETL_DETAIL_ID
            INTO
                PNIO_STG_ETL_DETAIL_ID;

        ELSE

            UPDATE R_STG_ETL_DETAIL
               SET STG_ETL_DETAIL_STATUS = PVI_STG_ETL_DETAIL_STATUS,
                   STG_ETL_DETAIL_STEP_END_DATE = SYSDATE,
                   STG_ETL_MODULE = PVI_STG_ETL_MODULE,
                   MESSAGE = PVI_MESSAGE
             WHERE STG_ETL_DETAIL_ID = PNIO_STG_ETL_DETAIL_ID;

        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS
        THEN ROLLBACK;
             PNIO_STG_ETL_DETAIL_ID := NULL; -- 01/12/2016 - AC: Processing of general errors should be elaborated.

    END SP_ETL_DETAIL_LOG;

   PROCEDURE SP_ETL_ENTRY_POINT(
    /****************************************************************************
      NAME:         SP_ETL_ENTRY_POINT
      PURPOSE:      Entry Point for ETL Staging Job
      REVISIONS:
      Ver           Date        Author             Description
      ------------  ----------  -----------------  ----------------------------
      
    *****************************************************************************/
       PDI_ETL_PROCESS_DATE    IN R_STG_ETL.STG_ETL_PROCESS_DATE%TYPE
   )
   IS

       C$V_PROCEDURE            CONSTANT VARCHAR2(256) := 'PKG_STG_ETL.SP_ETL_ENTRY_POINT';

       CURSOR C_MAIN_HCFA_DATA
        IS
            -- technical part
            SELECT /*+ INDEX (RHBI XIE1_HCFA_BILL_ITEM) USE_NL(RHBI RBI ROBI RBP RBM RV RRD RRM RCM BILLING_MOD PROVIDER DOCTOR PROV_CGL DOC_CGL)*/
                   RHBI.HCFA_BILL_ITEM_ID,
                   RHBI.HCFA_CPT_CODE_ID,
                   RHBI.HCFA_TECH_MODIFIER_ID,
                   RHBI.HCFA_PROF_MODIFIER_ID,
                   RBI.BILL_ITEM_ID,
                   RBP.BILL_PACKAGE_ID,
                   RBM.BILL_MASTER_ID,
                   RRD.REFERRAL_DETAIL_ID,
                   RRD.PEOPLE_ID AS RR_DOCTOR_ID,
                   RV.VISIT_ID,
                   RV.BUSINESS_ID AS PROVIDER_ID,
                   RV.PEOPLE_ID AS EMG_DOCTOR_ID,
                   RRM.REFERRAL_MASTER_ID,
                   RCM.CASE_MASTER_ID,
                   RCM.PATIENT_ID,
                   CASE
                       WHEN RV.SERVICE_ID = 1 -- EMG
                       THEN DOC_CGL.LOOKUP_ID
                       WHEN RV.SERVICE_ID = 2 -- MRI
                       THEN PROV_CGL.LOOKUP_ID
                       ELSE NULL
                   END AS LOOKUP_ID
              FROM R_HCFA_BILL_ITEM RHBI,
                   R_BILL_ITEM RBI,
                   R_BILL_PACKAGE RBP,
                   R_BILL_MASTER RBM,
                   R_REFERRAL_DETAIL RRD,
                   R_VISIT RV,
                   R_REFERRAL_MASTER RRM,
                   R_CASE_MASTER RCM,
                   R_OCM_BILL_ITEM ROBI,
                   M_CODE BILLING_MOD,
                   M_BUSINESS PROVIDER,
                   C_GENERIC_LOOKUP PROV_CGL,
                   M_PEOPLE DOCTOR,
                   C_GENERIC_LOOKUP DOC_CGL
             WHERE RHBI.HCFA_TECH_START_DATE >= PDI_ETL_PROCESS_DATE
               AND RHBI.HCFA_TECH_END_DATE < PDI_ETL_PROCESS_DATE + 1
               AND RBI.BILL_ITEM_ID = RHBI.BILL_ITEM_ID
               AND ROBI.BILL_ITEM_ID = RBI.BILL_ITEM_ID
               AND RBP.BILL_PACKAGE_ID = RBI.BILL_PACKAGE_ID
               AND RBM.BILL_MASTER_ID = RBP.BILL_MASTER_ID
               AND RV.VISIT_ID = RBM.VISIT_ID
               AND RRD.VISIT_ID = RV.VISIT_ID
               AND RRD.REFERRAL_DETAIL_ID = RBP.REFERRAL_DETAIL_ID
               AND RRM.REFERRAL_MASTER_ID = RV.REFERRAL_MASTER_ID
               AND RCM.CASE_MASTER_ID = RRM.CASE_MASTER_ID
               AND RV.ACTIVITY_STATUS = PKG_CONST.ACTIVE_STATUS_ID
               AND BILLING_MOD.CODE_ID (+) = RHBI.HCFA_TECH_MODIFIER_ID
               AND BILLING_MOD.CODE_TYPE_ID (+) = PKG_CONST.BILLING_MODIFIER_TYPE_ID
               AND PROVIDER.BUSINESS_ID = RV.BUSINESS_ID
               AND PROV_CGL.LOOKUP_ID = PROVIDER.BUSINESS_TYPE_ID
               AND DOCTOR.PEOPLE_ID (+) = RV.PEOPLE_ID
               AND DOC_CGL.LOOKUP_ID (+) = DOCTOR.PEOPLE_TYPE_ID

             UNION
            -- professional part
            SELECT /*+ INDEX (RHBI XIE2_HCFA_BILL_ITEM) USE_NL(RHBI RBI ROBI RBP RBM RV RRD RRM RCM PROVIDER DOCTOR PROV_CGL DOC_CGL)*/
                   RHBI.HCFA_BILL_ITEM_ID,
                   RHBI.HCFA_CPT_CODE_ID,
                   RHBI.HCFA_TECH_MODIFIER_ID,
                   RHBI.HCFA_PROF_MODIFIER_ID,
                   RBI.BILL_ITEM_ID,
                   RBP.BILL_PACKAGE_ID,
                   RBM.BILL_MASTER_ID,
                   RRD.REFERRAL_DETAIL_ID,
                   RRD.PEOPLE_ID AS RR_DOCTOR_ID,
                   RV.VISIT_ID,
                   RV.BUSINESS_ID AS PROVIDER_ID,
                   RV.PEOPLE_ID AS EMG_DOCTOR_ID,
                   RRM.REFERRAL_MASTER_ID,
                   RCM.CASE_MASTER_ID,
                   RCM.PATIENT_ID,
                   CASE
                       WHEN RV.SERVICE_ID = 1 -- EMG
                       THEN DOC_CGL.LOOKUP_ID
                       WHEN RV.SERVICE_ID = 2 -- MRI
                       THEN PROV_CGL.LOOKUP_ID
                       ELSE NULL
                   END AS LOOKUP_ID
              FROM R_HCFA_BILL_ITEM RHBI,
                   R_BILL_ITEM RBI,
                   R_BILL_PACKAGE RBP,
                   R_BILL_MASTER RBM,
                   R_REFERRAL_DETAIL RRD,
                   R_VISIT RV,
                   R_REFERRAL_MASTER RRM,
                   R_OCM_BILL_ITEM ROBI,
                   R_CASE_MASTER RCM,
                   M_BUSINESS PROVIDER,
                   C_GENERIC_LOOKUP PROV_CGL,
                   M_PEOPLE DOCTOR,
                   C_GENERIC_LOOKUP DOC_CGL
             WHERE RHBI.HCFA_PROF_START_DATE >= PDI_ETL_PROCESS_DATE
               AND RHBI.HCFA_PROF_END_DATE < PDI_ETL_PROCESS_DATE + 1
               AND RHBI.HCFA_PROF_MODIFIER_ID IS NOT NULL
               AND RBI.BILL_ITEM_ID = RHBI.BILL_ITEM_ID
               AND ROBI.BILL_ITEM_ID = RBI.BILL_ITEM_ID
               AND RBP.BILL_PACKAGE_ID = RBI.BILL_PACKAGE_ID
               AND RBM.BILL_MASTER_ID = RBP.BILL_MASTER_ID
               AND RV.VISIT_ID = RBM.VISIT_ID
               AND RRD.VISIT_ID = RV.VISIT_ID
               AND RRD.REFERRAL_DETAIL_ID = RBP.REFERRAL_DETAIL_ID
               AND RRM.REFERRAL_MASTER_ID = RV.REFERRAL_MASTER_ID
               AND RCM.CASE_MASTER_ID = RRM.CASE_MASTER_ID
               AND NVL(RBM.SPLIT_BILL, PKG_CONST.NO_VALUE) = PKG_CONST.YES_VALUE
               AND RV.ACTIVITY_STATUS = PKG_CONST.ACTIVE_STATUS_ID
               AND PROVIDER.BUSINESS_ID = RV.BUSINESS_ID
               AND PROV_CGL.LOOKUP_ID = PROVIDER.BUSINESS_TYPE_ID
               AND DOCTOR.PEOPLE_ID (+) = RV.PEOPLE_ID
               AND DOC_CGL.LOOKUP_ID (+) = DOCTOR.PEOPLE_TYPE_ID;

        N_CGL_DATA_EXISTS               PLS_INTEGER;
        N_BUSINESS_DATA_EXISTS          PLS_INTEGER;
        N_PEOPLE_DATA_EXISTS            PLS_INTEGER;
        N_DOCTOR_DATA_EXISTS            PLS_INTEGER;
        N_CONTACT_DATA_EXISTS           PLS_INTEGER;
        N_ADDRESS_DATA_EXISTS           PLS_INTEGER;
        N_RRM_DATA_EXISTS               PLS_INTEGER;
        N_CODE_DATA_EXISTS              PLS_INTEGER;
        N_CASE_MASTER_DATA_EXISTS       PLS_INTEGER;
        N_VISIT_DATA_EXISTS             PLS_INTEGER;
        N_REFERRAL_DETAIL_DATA_EXISTS   PLS_INTEGER;
        N_BILL_MASTER_DATA_EXISTS       PLS_INTEGER;
        N_BILL_PACKAGE_DATA_EXISTS      PLS_INTEGER;
        N_BILL_ITEM_DATA_EXISTS         PLS_INTEGER;
        N_HCFA_BILL_ITEM_DATA_EXISTS    PLS_INTEGER;
        N_DIAGNOSIS_DATA_EXISTS         PLS_INTEGER;

        HCFA_ITEM                       C_MAIN_HCFA_DATA%ROWTYPE;
        C_CGL_DATA                      C_GENERIC_LOOKUP%ROWTYPE;
        C_BUSINESS_DATA                 M_BUSINESS%ROWTYPE;
        C_PEOPLE_DATA                   M_PEOPLE%ROWTYPE;
        C_DOCTOR_DATA                   M_PEOPLE%ROWTYPE;
        C_CONTACT_DATA                  M_CONTACT%ROWTYPE;
        C_ADDRESS_DATA                  M_ADDRESS%ROWTYPE;
        C_RRM_DATA                      R_REFERRAL_MASTER%ROWTYPE;
        C_CASE_MASTER                   R_CASE_MASTER%ROWTYPE;
        C_VISIT_DATA                    R_VISIT%ROWTYPE;
        C_REFERRAL_DETAIL_DATA          R_REFERRAL_DETAIL%ROWTYPE;
        C_BILL_MASTER_DATA              R_BILL_MASTER%ROWTYPE;
        C_BILL_PACKAGE_DATA             R_BILL_PACKAGE%ROWTYPE;
        C_BILL_ITEM_DATA                R_BILL_ITEM%ROWTYPE;
        C_HCFA_BILL_ITEM_DATA           R_HCFA_BILL_ITEM%ROWTYPE;
        N_BUSINESS_ID                   M_CONTACT.BUSINESS_ID%TYPE;
        N_PEOPLE_ID                     M_CONTACT.PEOPLE_ID%TYPE;
        N_ADDR_BUSINESS_ID              M_ADDRESS.BUSINESS_ID%TYPE;
        N_ADDR_PEOPLE_ID                M_ADDRESS.PEOPLE_ID%TYPE;

        N_STG_ETL_ID                    R_STG_ETL.STG_ETL_ID%TYPE := NULL;
        N_STG_ETL_DETAIL_ID             R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
        N_TEMP_STG_ETL_DETAIL_ID        R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
        N_JOB_STG_ETL_DETAIL_ID         R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;
        N_ITEM_STG_ETL_DETAIL_ID        R_STG_ETL_DETAIL.STG_ETL_DETAIL_ID%TYPE;

        L_CODES_LIST                    T_NUMBER_LIST;

        -- FOR STATISTICS PURPOSES
        N_CONSIDERED_CNT                NUMBER(12);
        N_PROCESSED_CNT                 NUMBER(12);
        N_SUCCESS_CNT                   NUMBER(12);
        N_ERROR_CNT                     NUMBER(12);
        N_STATUS                        NUMBER(1);

        EX_FAIL_HCFA_ITEM               EXCEPTION;
        PRAGMA EXCEPTION_INIT(EX_FAIL_HCFA_ITEM, -20001);


    BEGIN

        -- Start of the processing
        SP_ETL_LOG (
            PNIO_STG_ETL_ID                       => N_STG_ETL_ID,
            PVI_STG_ETL_STATUS                    => PKG_STG_ETL.C$C_INITIAL_JOB_STATUS,
            PDI_STG_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
        );

        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => N_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_PROCESSING_ITEM_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
        );

        N_JOB_STG_ETL_DETAIL_ID := N_STG_ETL_DETAIL_ID;

        OPEN C_MAIN_HCFA_DATA;

        LOOP

            BEGIN
                FETCH C_MAIN_HCFA_DATA
                 INTO HCFA_ITEM;

                EXIT WHEN C_MAIN_HCFA_DATA%NOTFOUND;

                N_ITEM_STG_ETL_DETAIL_ID := NULL;

                SP_ETL_DETAIL_LOG (
                    PNIO_STG_ETL_DETAIL_ID                  => N_ITEM_STG_ETL_DETAIL_ID,
                    PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                    PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_PROCESSING_ITEM_STATUS,
                    PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'Start for HCFA_BILL_ITEM_ID=' || HCFA_ITEM.HCFA_BILL_ITEM_ID
                );

                --The initial point
                SAVEPOINT SAVEPOINT_HCFA_ITEM;

                -- C_GENERIC_LOOKUP processing
                SELECT COUNT(*)
                  INTO N_CGL_DATA_EXISTS
                  FROM C_GENERIC_LOOKUP CGL
                 WHERE CGL.LOOKUP_ID = HCFA_ITEM.LOOKUP_ID;

                IF N_CGL_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_CGL_DATA
                      FROM C_GENERIC_LOOKUP CGL
                     WHERE CGL.LOOKUP_ID = HCFA_ITEM.LOOKUP_ID;

                    SP_ETL_CGL(
                        PCI_ACTIVITY_STATUS             =>      C_CGL_DATA.ACTIVITY_STATUS,
                        PDI_CREATION_DATE               =>      C_CGL_DATA.CREATION_DATE,
                        PDI_LAST_MODIFICATION_DATE      =>      C_CGL_DATA.LAST_MODIFICATION_DATE,
                        PNI_LOOKUP_ID                   =>      C_CGL_DATA.LOOKUP_ID,
                        PNI_LOOKUP_TYPE_ID              =>      C_CGL_DATA.LOOKUP_TYPE_ID,
                        PNI_ROW_ORDER                   =>      C_CGL_DATA.ROW_ORDER,
                        PVI_LOOKUP_NAME                 =>      C_CGL_DATA.LOOKUP_NAME,
                        PVI_LOOKUP_ABBREVIATION         =>      C_CGL_DATA.LOOKUP_ABBREVIATION,
                        PVI_USER_CODE                   =>      C_CGL_DATA.CREATED_BY,
                        PNI_STG_ETL_ID                  =>      N_STG_ETL_ID,
                        PNO_STATUS                      =>      N_STATUS
                    );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- S_CODE processing
                SELECT COUNT(*)
                  INTO N_CODE_DATA_EXISTS
                  FROM M_CODE C
                 WHERE C.CODE_ID IN (HCFA_ITEM.HCFA_CPT_CODE_ID,
                                     HCFA_ITEM.HCFA_PROF_MODIFIER_ID,
                                     HCFA_ITEM.HCFA_TECH_MODIFIER_ID);

                IF N_CODE_DATA_EXISTS > 0
                THEN
                    L_CODES_LIST := T_NUMBER_LIST(T_NUMBER(HCFA_ITEM.HCFA_CPT_CODE_ID),
                                                  T_NUMBER(HCFA_ITEM.HCFA_PROF_MODIFIER_ID),
                                                  T_NUMBER(HCFA_ITEM.HCFA_TECH_MODIFIER_ID));

                    SP_ETL_CODE(PLI_CODES                  => L_CODES_LIST,
                                PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                PNO_STATUS                 => N_STATUS);

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- M_BUSINESS (PROVIDER) processing
                SELECT COUNT(*)
                  INTO N_BUSINESS_DATA_EXISTS
                  FROM M_BUSINESS B
                 WHERE B.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID;

                IF N_BUSINESS_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_BUSINESS_DATA
                      FROM M_BUSINESS B
                     WHERE B.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID;

                    SP_ETL_BUSINESS(PNI_BUSINESS_ID               => C_BUSINESS_DATA.BUSINESS_ID,
                                    PVI_INTREPID_CODE             => C_BUSINESS_DATA.INTREPID_CODE,
                                    PVI_CREATED_BY                => C_BUSINESS_DATA.CREATED_BY,
                                    PDI_CREATION_DATE             => C_BUSINESS_DATA.CREATION_DATE,
                                    PVI_LAST_MODIFIED_BY          => C_BUSINESS_DATA.LAST_MODIFIED_BY,
                                    PDI_WEB_EMAIL_ACTIVE_DATE     => C_BUSINESS_DATA.WEB_EMAIL_ACTIVE_DATE,
                                    PDI_LAST_STATUS_CHANGED_DATE  => C_BUSINESS_DATA.LAST_STATUS_CHANGED_DATE,
                                    PDI_BUSINESS_CLOSURE_DATE     => C_BUSINESS_DATA.BUSINESS_CLOSURE_DATE,
                                    PVI_COMPANY_NAME              => C_BUSINESS_DATA.COMPANY_NAME,
                                    PDI_LAST_MODIFICATION_DATE    => C_BUSINESS_DATA.LAST_MODIFICATION_DATE,
                                    PNI_BUSINESS_CLOSURE_ID       => C_BUSINESS_DATA.BUSINESS_CLOSURE_ID,
                                    PNI_BUSINESS_TYPE_ID          => C_BUSINESS_DATA.BUSINESS_TYPE_ID,
                                    PCI_ACTIVITY_STATUS           => C_BUSINESS_DATA.ACTIVITY_STATUS,
                                    PCI_VERIFIED_STATUS           => C_BUSINESS_DATA.VERIFIED_STATUS,
                                    PNI_BUSINESS_SUB_TYPE         => C_BUSINESS_DATA.BUSINESS_SUB_TYPE,
                                    PNI_FEDERAL_ID                => C_BUSINESS_DATA.FEDERAL_ID,
                                    PNI_PARTNER_TYPE_ID           => C_BUSINESS_DATA.PARTNER_TYPE_ID,
                                    PCI_PAY_ON_PAY                => C_BUSINESS_DATA.PAY_ON_PAY,
                                    PNI_INTREPID_CODE_NUMBER      => C_BUSINESS_DATA.INTREPID_CODE_NUMBER,
                                    PNI_STG_ETL_ID                => N_STG_ETL_ID,
                                    PNO_STATUS                    => N_STATUS);

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;

                    -- M_ADDRESS (PROVIDER) processing
                    SELECT COUNT(*)
                      INTO N_ADDRESS_DATA_EXISTS
                      FROM M_ADDRESS A
                     WHERE A.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID
                       AND A.ADDRESS_TYPE_ID = 1
                       AND A.ACTIVITY_STATUS = 'A';

                    IF N_ADDRESS_DATA_EXISTS > 0
                    THEN
                        SELECT *
                          INTO C_ADDRESS_DATA
                          FROM M_ADDRESS A
                         WHERE A.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID
                           AND A.ADDRESS_TYPE_ID = 1
                           AND A.ACTIVITY_STATUS = 'A';

                        N_ADDR_BUSINESS_ID := C_ADDRESS_DATA.BUSINESS_ID;
                        N_ADDR_PEOPLE_ID := NULL;

                        SP_ETL_ADDRESS(PVI_COUNTY                 => C_ADDRESS_DATA.COUNTY,
                                       PCI_REQUIRES_GEOCODING     => C_ADDRESS_DATA.REQUIRES_GEOCODING,
                                       PVI_P_MAPCODE              => C_ADDRESS_DATA.MAPCODE,
                                       PVI_COUNTRY                => C_ADDRESS_DATA.COUNTRY,
                                       PVI_ALTERNATE_COMPANY_NAME => C_ADDRESS_DATA.ALTERNATE_COMPANY_NAME,
                                       PCI_STATE_CODE             => C_ADDRESS_DATA.STATE_CODE,
                                       PNI_BUSINESS_ID            => N_ADDR_BUSINESS_ID,
                                       PNI_PEOPLE_ID              => N_ADDR_PEOPLE_ID,
                                       PVI_INTREPID_CODE          => C_ADDRESS_DATA.INTREPID_CODE,
                                       PVI_ADDRESS1               => C_ADDRESS_DATA.ADDRESS1,
                                       PVI_ADDRESS2               => C_ADDRESS_DATA.ADDRESS2,
                                       PVI_ADDRESS3               => C_ADDRESS_DATA.ADDRESS3,
                                       PNI_ADDRESS_ID             => C_ADDRESS_DATA.ADDRESS_ID,
                                       PVI_ZIP_PLUS_FOUR          => C_ADDRESS_DATA.ZIP_PLUS_FOUR,
                                       PNI_LONGITUDE              => C_ADDRESS_DATA.LONGITUDE,
                                       PNI_LATITUDE               => C_ADDRESS_DATA.LATITUDE,
                                       PCI_ACTIVITY_STATUS        => C_ADDRESS_DATA.ACTIVITY_STATUS,
                                       PNI_ADDRESS_TYPE_ID        => C_ADDRESS_DATA.ADDRESS_TYPE_ID,
                                       PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                       PNO_STATUS                 => N_STATUS);
                        IF N_STATUS = 0
                        THEN
                            RAISE EX_FAIL_HCFA_ITEM;
                        END IF;
                    END IF;

                    -- M_CONTACT (PROVIDER) processing
                    SELECT COUNT(*)
                      INTO N_CONTACT_DATA_EXISTS
                      FROM M_CONTACT C
                     WHERE C.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID
                       AND C.CONTACT_TYPE_ID = 89
                       AND C.ACTIVITY_STATUS = 'A';

                    IF N_CONTACT_DATA_EXISTS > 0
                    THEN
                        SELECT *
                          INTO C_CONTACT_DATA
                          FROM M_CONTACT C
                         WHERE C.BUSINESS_ID = HCFA_ITEM.PROVIDER_ID
                           AND C.CONTACT_TYPE_ID = 89
                           AND C.ACTIVITY_STATUS = 'A';

                        N_BUSINESS_ID := C_CONTACT_DATA.BUSINESS_ID;
                        N_PEOPLE_ID := NULL;

                        SP_ETL_CONTACT(PNI_CONTACT_ID              =>     C_CONTACT_DATA.CONTACT_ID,
                                       PNI_CONTACT_TYPE_ID         =>     C_CONTACT_DATA.CONTACT_TYPE_ID ,
                                       PNI_PEOPLE_ID               =>     N_PEOPLE_ID ,
                                       PNI_BUSINESS_ID             =>     N_BUSINESS_ID,
                                       PVI_PHONE_NUMBER            =>     C_CONTACT_DATA.PHONE_NUMBER ,
                                       PVI_PHONE_NUMBER_EXTENSION  =>     C_CONTACT_DATA.PHONE_NUMBER_EXTENSION ,
                                       PVI_HOME_PHONE              =>     C_CONTACT_DATA.HOME_PHONE ,
                                       PVI_OTHER_PHONE             =>     C_CONTACT_DATA.OTHER_PHONE ,
                                       PNI_OTHER_PHONE_TYPE_ID     =>     C_CONTACT_DATA.PHONE_TYPE_ID,
                                       PVI_FAX                     =>     C_CONTACT_DATA.FAX ,
                                       PVI_EMAIL_ADDRESS           =>     C_CONTACT_DATA.EMAIL_ADDRESS ,
                                       PVI_WEB_SITE                =>     C_CONTACT_DATA.WEB_SITE ,
                                       PCI_ACTIVITY_STATUS         =>     C_CONTACT_DATA.ACTIVITY_STATUS ,
                                       PNI_ADDRESS_ID              =>     C_CONTACT_DATA.ADDRESS_ID ,
                                       PNI_STG_ETL_ID              =>     N_STG_ETL_ID,
                                       PNO_STATUS                  =>     N_STATUS);

                        IF N_STATUS = 0
                        THEN
                            RAISE EX_FAIL_HCFA_ITEM;
                        END IF;
                    END IF;

                END IF;

                -- M_PEOPLE (PATIENT) processing
                SELECT COUNT(*)
                  INTO N_PEOPLE_DATA_EXISTS
                  FROM M_PEOPLE PE
                 WHERE PE.PEOPLE_ID = HCFA_ITEM.PATIENT_ID;

                IF N_PEOPLE_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_PEOPLE_DATA
                      FROM M_PEOPLE PE
                     WHERE PE.PEOPLE_ID = HCFA_ITEM.PATIENT_ID;

                    SP_ETL_PEOPLE(PNI_PEOPLE_ID                 => C_PEOPLE_DATA.PEOPLE_ID,
                                  PNI_PEOPLE_TYPE_ID            => C_PEOPLE_DATA.PEOPLE_TYPE_ID,
                                  PNI_PEOPLE_SUB_TYPE           => C_PEOPLE_DATA.PEOPLE_SUB_TYPE,
                                  PVI_FIRST_NAME                => C_PEOPLE_DATA.FIRST_NAME,
                                  PCI_MIDDLE_INITIAL            => C_PEOPLE_DATA.MIDDLE_INITIAL ,
                                  PVI_MIDDLE_NAME               => C_PEOPLE_DATA.MIDDLE_NAME,
                                  PVI_LAST_NAME                 => C_PEOPLE_DATA.LAST_NAME,
                                  PDI_BIRTH_DATE                => C_PEOPLE_DATA.BIRTH_DATE ,
                                  PVI_SOCIAL_SECURITY_NUMBER    => C_PEOPLE_DATA.SOCIAL_SECURITY_NUMBER,
                                  PNI_FEDERAL_TAX_ID            => C_PEOPLE_DATA.FEDERAL_TAX_ID,
                                  PVI_PREFIX                    => C_PEOPLE_DATA.PREFIX ,
                                  PCI_ACTIVITY_STATUS           => C_PEOPLE_DATA.ACTIVITY_STATUS ,
                                  PCI_VERIFIED_STATUS           => C_PEOPLE_DATA.VERIFIED_STATUS ,
                                  PVI_FULL_NAME                 => C_PEOPLE_DATA.FULL_NAME ,
                                  PNI_USER_ID                   => C_PEOPLE_DATA.USER_ID ,
                                  PVI_INTREPID_CODE             => C_PEOPLE_DATA.INTREPID_CODE,
                                  PVI_CREATED_BY                => C_PEOPLE_DATA.CREATED_BY ,
                                  PDI_CREATION_DATE             => C_PEOPLE_DATA.CREATION_DATE ,
                                  PCI_GENDER                    => C_PEOPLE_DATA.GENDER,
                                  PVI_PARTIAL_SSN               => C_PEOPLE_DATA.PARTIAL_SSN,
                                  PNI_STG_ETL_ID                => N_STG_ETL_ID,
                                  PNO_STATUS                    => N_STATUS);
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;

                    -- M_ADDRESS (PATIENT) processing
                    SELECT COUNT(*)
                      INTO N_ADDRESS_DATA_EXISTS
                      FROM M_ADDRESS A
                     WHERE A.PEOPLE_ID = HCFA_ITEM.PATIENT_ID
                       AND A.ADDRESS_TYPE_ID = 3
                       AND A.ACTIVITY_STATUS = 'A';

                    IF N_ADDRESS_DATA_EXISTS > 0
                    THEN
                        SELECT *
                          INTO C_ADDRESS_DATA
                          FROM M_ADDRESS A
                         WHERE A.PEOPLE_ID = HCFA_ITEM.PATIENT_ID
                           AND A.ADDRESS_TYPE_ID = 3
                           AND A.ACTIVITY_STATUS = 'A';

                        N_ADDR_BUSINESS_ID := NULL;
                        N_ADDR_PEOPLE_ID := C_ADDRESS_DATA.PEOPLE_ID;

                        SP_ETL_ADDRESS(PVI_COUNTY                 => C_ADDRESS_DATA.COUNTY,
                                       PCI_REQUIRES_GEOCODING     => C_ADDRESS_DATA.REQUIRES_GEOCODING,
                                       PVI_P_MAPCODE              => C_ADDRESS_DATA.MAPCODE,
                                       PVI_COUNTRY                => C_ADDRESS_DATA.COUNTRY,
                                       PVI_ALTERNATE_COMPANY_NAME => C_ADDRESS_DATA.ALTERNATE_COMPANY_NAME,
                                       PCI_STATE_CODE             => C_ADDRESS_DATA.STATE_CODE,
                                       PNI_BUSINESS_ID            => N_ADDR_BUSINESS_ID,
                                       PNI_PEOPLE_ID              => N_ADDR_PEOPLE_ID,
                                       PVI_INTREPID_CODE          => C_ADDRESS_DATA.INTREPID_CODE,
                                       PVI_ADDRESS1               => C_ADDRESS_DATA.ADDRESS1,
                                       PVI_ADDRESS2               => C_ADDRESS_DATA.ADDRESS2,
                                       PVI_ADDRESS3               => C_ADDRESS_DATA.ADDRESS3,
                                       PNI_ADDRESS_ID             => C_ADDRESS_DATA.ADDRESS_ID,
                                       PVI_ZIP_PLUS_FOUR          => C_ADDRESS_DATA.ZIP_PLUS_FOUR,
                                       PNI_LONGITUDE              => C_ADDRESS_DATA.LONGITUDE,
                                       PNI_LATITUDE               => C_ADDRESS_DATA.LATITUDE,
                                       PCI_ACTIVITY_STATUS        => C_ADDRESS_DATA.ACTIVITY_STATUS,
                                       PNI_ADDRESS_TYPE_ID        => C_ADDRESS_DATA.ADDRESS_TYPE_ID,
                                       PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                       PNO_STATUS                 => N_STATUS);
                        IF N_STATUS = 0
                        THEN
                            RAISE EX_FAIL_HCFA_ITEM;
                        END IF;
                    END IF;

                    -- M_CONTACT (PATIENT) processing
                    SELECT COUNT(*)
                      INTO N_CONTACT_DATA_EXISTS
                      FROM M_CONTACT C
                     WHERE C.PEOPLE_ID = HCFA_ITEM.PATIENT_ID
                       AND C.CONTACT_TYPE_ID = 89
                       AND C.ACTIVITY_STATUS = 'A';

                    IF N_CONTACT_DATA_EXISTS > 0
                    THEN
                        SELECT *
                          INTO C_CONTACT_DATA
                          FROM M_CONTACT C
                         WHERE C.PEOPLE_ID = HCFA_ITEM.PATIENT_ID
                           AND C.CONTACT_TYPE_ID = 89
                           AND C.ACTIVITY_STATUS = 'A';

                        N_BUSINESS_ID := NULL;
                        N_PEOPLE_ID := C_CONTACT_DATA.PEOPLE_ID;

                        SP_ETL_CONTACT(PNI_CONTACT_ID              =>     C_CONTACT_DATA.CONTACT_ID,
                                       PNI_CONTACT_TYPE_ID         =>     C_CONTACT_DATA.CONTACT_TYPE_ID ,
                                       PNI_PEOPLE_ID               =>     N_PEOPLE_ID ,
                                       PNI_BUSINESS_ID             =>     N_BUSINESS_ID,
                                       PVI_PHONE_NUMBER            =>     C_CONTACT_DATA.PHONE_NUMBER ,
                                       PVI_PHONE_NUMBER_EXTENSION  =>     C_CONTACT_DATA.PHONE_NUMBER_EXTENSION ,
                                       PVI_HOME_PHONE              =>     C_CONTACT_DATA.HOME_PHONE ,
                                       PVI_OTHER_PHONE             =>     C_CONTACT_DATA.OTHER_PHONE ,
                                       PNI_OTHER_PHONE_TYPE_ID     =>     C_CONTACT_DATA.PHONE_TYPE_ID,
                                       PVI_FAX                     =>     C_CONTACT_DATA.FAX ,
                                       PVI_EMAIL_ADDRESS           =>     C_CONTACT_DATA.EMAIL_ADDRESS ,
                                       PVI_WEB_SITE                =>     C_CONTACT_DATA.WEB_SITE ,
                                       PCI_ACTIVITY_STATUS         =>     C_CONTACT_DATA.ACTIVITY_STATUS ,
                                       PNI_ADDRESS_ID              =>     C_CONTACT_DATA.ADDRESS_ID ,
                                       PNI_STG_ETL_ID              =>     N_STG_ETL_ID,
                                       PNO_STATUS                  =>     N_STATUS);
                        IF N_STATUS = 0
                        THEN
                            RAISE EX_FAIL_HCFA_ITEM;
                        END IF;
                    END IF;

                END IF;
                
                -- M_PEOPLE (RR DOCTOR) processing
                SELECT COUNT(*)
                  INTO N_PEOPLE_DATA_EXISTS
                  FROM M_PEOPLE PE
                 WHERE PE.PEOPLE_ID = HCFA_ITEM.RR_DOCTOR_ID;

                IF N_PEOPLE_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_PEOPLE_DATA
                      FROM M_PEOPLE PE
                      WHERE PE.PEOPLE_ID = HCFA_ITEM.RR_DOCTOR_ID;

                    SP_ETL_PEOPLE(PNI_PEOPLE_ID                 => C_PEOPLE_DATA.PEOPLE_ID,
                                  PNI_PEOPLE_TYPE_ID            => C_PEOPLE_DATA.PEOPLE_TYPE_ID,
                                  PNI_PEOPLE_SUB_TYPE           => C_PEOPLE_DATA.PEOPLE_SUB_TYPE,
                                  PVI_FIRST_NAME                => C_PEOPLE_DATA.FIRST_NAME,
                                  PCI_MIDDLE_INITIAL            => C_PEOPLE_DATA.MIDDLE_INITIAL ,
                                  PVI_MIDDLE_NAME               => C_PEOPLE_DATA.MIDDLE_NAME,
                                  PVI_LAST_NAME                 => C_PEOPLE_DATA.LAST_NAME,
                                  PDI_BIRTH_DATE                => C_PEOPLE_DATA.BIRTH_DATE ,
                                  PVI_SOCIAL_SECURITY_NUMBER    => C_PEOPLE_DATA.SOCIAL_SECURITY_NUMBER,
                                  PNI_FEDERAL_TAX_ID            => C_PEOPLE_DATA.FEDERAL_TAX_ID,
                                  PVI_PREFIX                    => C_PEOPLE_DATA.PREFIX ,
                                  PCI_ACTIVITY_STATUS           => C_PEOPLE_DATA.ACTIVITY_STATUS ,
                                  PCI_VERIFIED_STATUS           => C_PEOPLE_DATA.VERIFIED_STATUS ,
                                  PVI_FULL_NAME                 => C_PEOPLE_DATA.FULL_NAME ,
                                  PNI_USER_ID                   => C_PEOPLE_DATA.USER_ID ,
                                  PVI_INTREPID_CODE             => C_PEOPLE_DATA.INTREPID_CODE,
                                  PVI_CREATED_BY                => C_PEOPLE_DATA.CREATED_BY ,
                                  PDI_CREATION_DATE             => C_PEOPLE_DATA.CREATION_DATE ,
                                  PCI_GENDER                    => C_PEOPLE_DATA.GENDER,
                                  PVI_PARTIAL_SSN               => C_PEOPLE_DATA.PARTIAL_SSN,
                                  PNI_STG_ETL_ID                => N_STG_ETL_ID,
                                  PNO_STATUS                    => N_STATUS);
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;

                    -- 01/15/2016 - AC - Processing of RR Doctor's Address and Contact should be elaborated

                END IF;
                
                -- M_PEOPLE (EMG DOCTOR) processing
                SELECT COUNT(*)
                  INTO N_DOCTOR_DATA_EXISTS
                  FROM M_PEOPLE PE
                 WHERE PE.PEOPLE_ID = HCFA_ITEM.EMG_DOCTOR_ID;

                IF N_DOCTOR_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_DOCTOR_DATA
                      FROM M_PEOPLE PE
                     WHERE PE.PEOPLE_ID = HCFA_ITEM.EMG_DOCTOR_ID;

                    SP_ETL_PEOPLE(PNI_PEOPLE_ID                 => C_DOCTOR_DATA.PEOPLE_ID,
                                  PNI_PEOPLE_TYPE_ID            => C_PEOPLE_DATA.PEOPLE_TYPE_ID,
                                  PNI_PEOPLE_SUB_TYPE           => C_DOCTOR_DATA.PEOPLE_SUB_TYPE,
                                  PVI_FIRST_NAME                => C_DOCTOR_DATA.FIRST_NAME,
                                  PCI_MIDDLE_INITIAL            => C_DOCTOR_DATA.MIDDLE_INITIAL ,
                                  PVI_MIDDLE_NAME               => C_DOCTOR_DATA.MIDDLE_NAME,
                                  PVI_LAST_NAME                 => C_DOCTOR_DATA.LAST_NAME,
                                  PDI_BIRTH_DATE                => C_DOCTOR_DATA.BIRTH_DATE ,
                                  PVI_SOCIAL_SECURITY_NUMBER    => C_DOCTOR_DATA.SOCIAL_SECURITY_NUMBER,
                                  PNI_FEDERAL_TAX_ID            => C_DOCTOR_DATA.FEDERAL_TAX_ID,
                                  PVI_PREFIX                    => C_DOCTOR_DATA.PREFIX ,
                                  PCI_ACTIVITY_STATUS           => C_DOCTOR_DATA.ACTIVITY_STATUS ,
                                  PCI_VERIFIED_STATUS           => C_DOCTOR_DATA.VERIFIED_STATUS ,
                                  PVI_FULL_NAME                 => C_PEOPLE_DATA.FULL_NAME ,
                                  PNI_USER_ID                   => C_DOCTOR_DATA.USER_ID ,
                                  PVI_INTREPID_CODE             => C_DOCTOR_DATA.INTREPID_CODE,
                                  PVI_CREATED_BY                => C_DOCTOR_DATA.CREATED_BY ,
                                  PDI_CREATION_DATE             => C_DOCTOR_DATA.CREATION_DATE ,
                                  PCI_GENDER                    => C_DOCTOR_DATA.GENDER,
                                  PVI_PARTIAL_SSN               => C_PEOPLE_DATA.PARTIAL_SSN,
                                  PNI_STG_ETL_ID                => N_STG_ETL_ID,
                                  PNO_STATUS                    => N_STATUS);
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;

                    -- 01/12/2016 - AC - Processing of EMG Doctor's Address and Contact should be elaborated

                END IF;

                -- R_CASE_MASTER processing
                SELECT COUNT(*)
                  INTO N_CASE_MASTER_DATA_EXISTS
                  FROM R_CASE_MASTER CM
                 WHERE CM.CASE_MASTER_ID = HCFA_ITEM.CASE_MASTER_ID;

                IF N_CASE_MASTER_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_CASE_MASTER
                      FROM R_CASE_MASTER CM
                     WHERE CM.CASE_MASTER_ID = HCFA_ITEM.CASE_MASTER_ID;

                    SP_ETL_SCM(PNI_CASE_MASTER_ID           => C_CASE_MASTER.CASE_MASTER_ID,
                               PVI_CLAIM_NUMBER             => C_CASE_MASTER.CLAIM_NUMBER,
                               PDI_DATE_OF_INJURY           => C_CASE_MASTER.DATE_OF_INJURY,
                               PDI_CREATION_DATE            => C_CASE_MASTER.CREATION_DATE,
                               PDI_LAST_MODIFICATION_DATE   => C_CASE_MASTER.LAST_MODIFICATION_DATE,
                               PVI_CREATED_BY               => C_CASE_MASTER.CREATED_BY,
                               PVI_LAST_MODIFIED_BY         => C_CASE_MASTER.LAST_MODIFIED_BY,
                               PCI_AGED                     => C_CASE_MASTER.AGED,
                               PCI_AGED_TYPE                => C_CASE_MASTER.AGED_TYPE,
                               PNI_EXTERNAL_REFERRAL_ID     => C_CASE_MASTER.EXTERNAL_REFERRAL_ID,
                               PVI_EXTERNAL_REFERRAL_TYPE   => C_CASE_MASTER.EXTERNAL_REFERRAL_TYPE,
                               PNI_PATIENT_ID               => C_CASE_MASTER.PATIENT_ID,
                               PVI_INTREPID_CODE            => C_CASE_MASTER.INTREPID_CODE,
                               PNI_DUP_CASE_MASTER_ID       => C_CASE_MASTER.DUP_CASE_MASTER_ID,
                               PCI_ACTIVITY_STATUS          => C_CASE_MASTER.ACTIVITY_STATUS,
                               PNI_PRIMARY_PAYER_ID         => C_CASE_MASTER.PRIMARY_PAYER_ID,
                               PNI_EMP_AT_TIME_OF_INJURY_ID => C_CASE_MASTER.EMPLOYER_AT_TIME_OF_INJURY_ID,
                               PNI_LINE_OF_BUSINESS_ID      => C_CASE_MASTER.LINE_OF_BUSINESS_ID,
                               PNI_JURISDICTION_ID          => C_CASE_MASTER.JURISDICTION_ID,
                               PNI_STG_ETL_ID               => N_STG_ETL_ID,
                               PNO_STATUS                   => N_STATUS);
                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_REFERRAL_MASTER processing
                SELECT COUNT(*)
                  INTO N_RRM_DATA_EXISTS
                  FROM R_REFERRAL_MASTER RRM
                 WHERE HCFA_ITEM.REFERRAL_MASTER_ID = RRM.REFERRAL_MASTER_ID;

                IF N_RRM_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_RRM_DATA
                      FROM R_REFERRAL_MASTER RRM
                     WHERE RRM.REFERRAL_MASTER_ID = HCFA_ITEM.REFERRAL_MASTER_ID;

                    SP_ETL_RRM(
                                PDI_INTAKE_DATE                     => C_RRM_DATA.INTAKE_DATE,
                                PCI_PATIENT_OUT_OF_WORK                => C_RRM_DATA.PATIENT_OUT_OF_WORK,
                                PNI_REFERRAL_MASTER_ID                => C_RRM_DATA.REFERRAL_MASTER_ID,
                                PVI_PRECERTIFICATION_TEXT            => C_RRM_DATA.PRECERTIFICATION_TEXT,
                                PDI_FOLLOW_UP_DATE                    => C_RRM_DATA.FOLLOW_UP_DATE,
                                PVI_REF_TOTAL_COST_SAVINGS            => C_RRM_DATA.REFERRAL_TOTAL_COST_SAVINGS,
                                PNI_CASE_MASTER_ID                    => C_RRM_DATA.CASE_MASTER_ID,
                                PVI_CREATED_BY                        => C_RRM_DATA.CREATED_BY,
                                PDI_CREATION_DATE                    => C_RRM_DATA.CREATION_DATE,
                                PVI_LAST_MODIFIED_BY                => C_RRM_DATA.LAST_MODIFIED_BY,
                                PDI_LAST_MODIFICATION_DATE            => C_RRM_DATA.LAST_MODIFICATION_DATE,
                                PNI_REFERRING_MD_ID                    => C_RRM_DATA.REFERRING_MD_ID,
                                PNI_ADJUSTER_ID                        => C_RRM_DATA.ADJUSTER_ID,
                                PNI_NCM_ID                            => C_RRM_DATA.NCM_ID,
                                PCI_DISTR_1ST_CONTACT_FLAG          => C_RRM_DATA.DISTRIBUTOR_1ST_CONTACT_FLAG,
                                PNI_DISTRIBUTOR_PASS_NUMBER            => C_RRM_DATA.DISTRIBUTOR_PASS_NUMBER,
                                PCI_DISTRIBUTOR_OST_FLAG            => C_RRM_DATA.DISTRIBUTOR_OST_FLAG,
                                PNI_REFERRAL_TYPE_ID                => C_RRM_DATA.REFERRAL_TYPE_ID,
                                PNI_REFERRAL_SOURCE_TYPE_ID            => C_RRM_DATA.REFERRAL_SOURCE_TYPE_ID,
                                PNI_REFERRAL_METHOD_TYPE_ID            => C_RRM_DATA.REFERRAL_METHOD_TYPE_ID,
                                PNI_REFERRAL_PRIORITY_ID            => C_RRM_DATA.REFERRAL_PRIORITY_ID,
                                PCI_REQUEST_FILMS                    => C_RRM_DATA.REQUEST_FILMS,
                                PVI_CREATED_BY_USER_ID                => C_RRM_DATA.CREATED_BY_USER_ID,
                                PNI_LAST_MODIFIED_BY_USER_ID        => C_RRM_DATA.LAST_MODIFIED_BY_USER_ID,
                                PCI_REFERRAL_MASTER_STATUS            => C_RRM_DATA.REFERRAL_MASTER_STATUS,
                                PCI_IS_RETRO                        => C_RRM_DATA.IS_RETRO,
                                PCI_IS_CARVE_OUT                    => C_RRM_DATA.IS_CARVE_OUT,
                                PNI_CASE_MANAGER_ID                    => C_RRM_DATA.CASE_MANAGER_ID,
                                PNI_REFERRING_MD_LOCATION_ID        => C_RRM_DATA.REFERRING_MD_LOCATION_ID,
                                PVI_INTREPID_CODE                   => C_RRM_DATA.INTREPID_CODE,
                                PNI_CARRIER_ID                        => C_RRM_DATA.CARRIER_ID,
                                PNI_EXTERNAL_SOURCE_TYPE_ID            => C_RRM_DATA.EXTERNAL_SOURCE_TYPE_ID,
                                PNI_REFERRAL_SUBTYPE_ID                => C_RRM_DATA.REFERRAL_SUBTYPE_ID,
                                PVI_SPOKE_TO                        => C_RRM_DATA.SPOKE_TO,
                                PCI_CD_REQUEST                        => C_RRM_DATA.CD_REQUEST,
                                PCI_IS_TRANSPORTATION_REQUIRED        => C_RRM_DATA.IS_TRANSPORTATION_REQUIRED,
                                PCI_IS_INTERPRETATION_REQUIRED        => C_RRM_DATA.IS_INTERPRETATION_REQUIRED,
                                PNI_REFERRAL_QUEUE_ID                => C_RRM_DATA.REFERRAL_QUEUE_ID,
                                PNI_STG_ETL_ID                      => N_STG_ETL_ID,
                                PNO_STATUS                          => N_STATUS
                                );


                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_VISIT processing
                SELECT COUNT(*)
                  INTO N_VISIT_DATA_EXISTS
                  FROM R_VISIT RV
                 WHERE RV.VISIT_ID = HCFA_ITEM.VISIT_ID;

                IF N_VISIT_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_VISIT_DATA
                      FROM R_VISIT RV
                     WHERE RV.VISIT_ID = HCFA_ITEM.VISIT_ID;

                    SP_ETL_VISIT( PNI_VISIT_ID                 => C_VISIT_DATA.VISIT_ID,
                                  PDI_DUE_DATE                 => C_VISIT_DATA.DUE_DATE,
                                  PVI_CREATED_BY               => C_VISIT_DATA.CREATED_BY,
                                  PDI_CREATION_DATE            => C_VISIT_DATA.CREATION_DATE,
                                  PVI_LAST_MODIFIED_BY         => C_VISIT_DATA.LAST_MODIFIED_BY,
                                  PDI_LAST_MODIFICATION_DATE   => C_VISIT_DATA.LAST_MODIFICATION_DATE,
                                  PCI_CONFIRMED_WITH_PATIENT   => C_VISIT_DATA.CONFIRMED_WITH_PATIENT,
                                  PNI_REFERRAL_MASTER_ID       => C_VISIT_DATA.REFERRAL_MASTER_ID,
                                  PNI_BUSINESS_ID              => C_VISIT_DATA.BUSINESS_ID,
                                  PNI_PEOPLE_ID                => C_VISIT_DATA.PEOPLE_ID,
                                  PNI_OCM_REVIEVER_ID          => C_VISIT_DATA.OCM_REVIEVER_ID,
                                  PNI_SERVICE_ID               => C_VISIT_DATA.SERVICE_ID,
                                  PVI_CLINICAL_REVIEW_STATUS   => C_VISIT_DATA.CLINICAL_REVIEW_STATUS,
                                  PCI_DONE_DEAL                => C_VISIT_DATA.DONE_DEAL,
                                  PCI_ACTIVITY_STATUS          => C_VISIT_DATA.ACTIVITY_STATUS,
                                  PDI_SCHEDULED_DATE           => C_VISIT_DATA.SCHEDULED_DATE,
                                  PNI_CLINICAL_REVIEW_TYPE     => C_VISIT_DATA.CLINICAL_REVIEW_TYPE,
                                  PNI_CO_OWNER_ID              => C_VISIT_DATA.CO_OWNER_ID,
                                  PNI_LAST_VISIT_ID            => C_VISIT_DATA.LAST_VISIT_ID,
                                  PNI_INTERPRETATION_CHOICE_ID => C_VISIT_DATA.INTERPRETATION_CHOICE_ID,
                                  PNI_TRANSPORTATION_CHOICE_ID => C_VISIT_DATA.TRANSPORTATION_CHOICE_ID,
                                  PNI_PARENT_BUSINESS_ID       => C_VISIT_DATA.PARENT_BUSINESS_ID,
                                  PNI_EXTERNAL_REVIEVER_ID     => C_VISIT_DATA.EXTERNAL_REVIEVER_ID,
                                  PNI_STG_ETL_ID               => N_STG_ETL_ID,
                                  PNO_STATUS                   => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_REFERRAL_DETAIL processing
                SELECT COUNT(*)
                  INTO N_REFERRAL_DETAIL_DATA_EXISTS
                  FROM R_REFERRAL_DETAIL RRD
                 WHERE RRD.REFERRAL_DETAIL_ID = HCFA_ITEM.REFERRAL_DETAIL_ID;

                IF N_REFERRAL_DETAIL_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_REFERRAL_DETAIL_DATA
                      FROM R_REFERRAL_DETAIL RRD
                     WHERE RRD.REFERRAL_DETAIL_ID = HCFA_ITEM.REFERRAL_DETAIL_ID;

                    SP_ETL_REFERRAL_DETAIL( PDI_RELEASE_TO_BILLING_DATE  => C_REFERRAL_DETAIL_DATA.RELEASE_TO_BILLING_DATE,
                                            PNI_REFERRAL_DETAIL_ID       => C_REFERRAL_DETAIL_DATA.REFERRAL_DETAIL_ID,
                                            PNI_VISIT_ID                 => C_REFERRAL_DETAIL_DATA.VISIT_ID,
                                            PVI_CREATED_BY               => C_REFERRAL_DETAIL_DATA.CREATED_BY,
                                            PDI_CREATION_DATE            => C_REFERRAL_DETAIL_DATA.CREATION_DATE,
                                            PVI_LAST_MODIFIED_BY         => C_REFERRAL_DETAIL_DATA.LAST_MODIFIED_BY,
                                            PDI_LAST_MODIFICATION_DATE   => C_REFERRAL_DETAIL_DATA.LAST_MODIFICATION_DATE,
                                            PNI_PACKAGE_ID               => C_REFERRAL_DETAIL_DATA.PACKAGE_ID,
                                            PNI_REFERRAL_LINE_NUMBER     => C_REFERRAL_DETAIL_DATA.REFERRAL_LINE_NUMBER,
                                            PNI_REFERRAL_MASTER_ID       => C_REFERRAL_DETAIL_DATA.REFERRAL_MASTER_ID,
                                            PNI_REASON_ID                => C_REFERRAL_DETAIL_DATA.REASON_ID,
                                            PNI_CLAIM_RESOLUTION_TYPE_ID => C_REFERRAL_DETAIL_DATA.CLAIM_RESOLUTION_TYPE_ID,
                                            PCI_REFERRAL_DETAIL_STATUS   => C_REFERRAL_DETAIL_DATA.REFERRAL_DETAIL_STATUS,
                                            PNI_CREATED_BY_USER_ID       => C_REFERRAL_DETAIL_DATA.CREATED_BY_USER_ID,
                                            PNI_LAST_MODIFIED_BY_USER_ID => C_REFERRAL_DETAIL_DATA.LAST_MODIFIED_BY_USER_ID,
                                            PDI_DATE_OF_SERVICE          => C_REFERRAL_DETAIL_DATA.DATE_OF_SERVICE,
                                            PCI_FEE_NEGOTIATION          => C_REFERRAL_DETAIL_DATA.FEE_NEGOTIATION,
                                            PNI_PEOPLE_ID                => C_REFERRAL_DETAIL_DATA.PEOPLE_ID,
                                            PNI_AGING_SOURCE_ID          => C_REFERRAL_DETAIL_DATA.AGING_SOURCE_ID,
                                            PVI_AGED_NOTE                => C_REFERRAL_DETAIL_DATA.AGED_NOTE,
                                            PNI_AGING_REVIEWER_ID        => C_REFERRAL_DETAIL_DATA.AGING_REVIEWER_ID,
                                            PNI_AGING_METHOD_ID          => C_REFERRAL_DETAIL_DATA.AGING_METHOD_ID,
                                            PNI_AGING_OUTCOME_ID         => C_REFERRAL_DETAIL_DATA.AGING_OUTCOME_ID,
                                            PNI_AGING_EXT_REVIEWER_ID    => C_REFERRAL_DETAIL_DATA.AGING_EXT_REVIEWER_ID,
                                            PCI_AGING_STATUS             => C_REFERRAL_DETAIL_DATA.AGING_STATUS,
                                            PDI_AGING_DATE               => C_REFERRAL_DETAIL_DATA.AGING_DATE,
                                            PCI_MR_STATUS                => C_REFERRAL_DETAIL_DATA.MR_STATUS,
                                            PDI_MR_POSTED_DATE           => C_REFERRAL_DETAIL_DATA.MR_POSTED_DATE,
                                            PNI_STG_ETL_ID               => N_STG_ETL_ID,
                                            PNO_STATUS                   => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_BILL_MASTER processing
                SELECT COUNT(*)
                  INTO N_BILL_MASTER_DATA_EXISTS
                  FROM R_BILL_MASTER RBM
                 WHERE RBM.BILL_MASTER_ID = HCFA_ITEM.BILL_MASTER_ID;

                IF N_BILL_MASTER_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_BILL_MASTER_DATA
                      FROM R_BILL_MASTER RBM
                     WHERE RBM.BILL_MASTER_ID = HCFA_ITEM.BILL_MASTER_ID;

                    SP_ETL_BILL_MASTER( PNI_BILL_MASTER_ID         => C_BILL_MASTER_DATA.BILL_MASTER_ID,
                                        PDI_HCFA_RECEIVED_DATE     => C_BILL_MASTER_DATA.HCFA_RECEIVED_DATE,
                                        PVI_CREATED_BY             => C_BILL_MASTER_DATA.CREATED_BY,
                                        PDI_CREATION_DATE          => C_BILL_MASTER_DATA.CREATION_DATE,
                                        PVI_LAST_MODIFIED_BY       => C_BILL_MASTER_DATA.LAST_MODIFIED_BY,
                                        PDI_LAST_MODIFICATION_DATE => C_BILL_MASTER_DATA.LAST_MODIFICATION_DATE,
                                        PCI_RETRO_REFERRAL         => C_BILL_MASTER_DATA.RETRO_REFERRAL,
                                        PCI_SPLIT_BILL             => C_BILL_MASTER_DATA.SPLIT_BILL,
                                        PVI_BILL_CODE              => C_BILL_MASTER_DATA.BILL_CODE,
                                        PNI_VISIT_ID               => C_BILL_MASTER_DATA.VISIT_ID,
                                        PCI_AR_BILL_STATUS         => C_BILL_MASTER_DATA.AR_BILL_STATUS,
                                        PCI_AP_BILL_STATUS         => C_BILL_MASTER_DATA.AP_BILL_STATUS,
                                        PCI_SPLIT_PAYER            => C_BILL_MASTER_DATA.SPLIT_PAYER,
                                        PNI_BILLING_LOCATION_ID    => C_BILL_MASTER_DATA.BILLING_LOCATION_ID,
                                        PNI_NOTE_ID                => C_BILL_MASTER_DATA.NOTE_ID,
                                        PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                        PNO_STATUS                 => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_BILL_PACKAGE processing
                SELECT COUNT(*)
                  INTO N_BILL_PACKAGE_DATA_EXISTS
                  FROM R_BILL_PACKAGE RBP
                 WHERE RBP.BILL_PACKAGE_ID = HCFA_ITEM.BILL_PACKAGE_ID;

                IF N_BILL_PACKAGE_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_BILL_PACKAGE_DATA
                      FROM R_BILL_PACKAGE RBP
                     WHERE RBP.BILL_PACKAGE_ID = HCFA_ITEM.BILL_PACKAGE_ID;

                    SP_ETL_BILL_PACKAGE( PNI_BILL_PACKAGE_ID          => C_BILL_PACKAGE_DATA.BILL_PACKAGE_ID,
                                         PCI_BILL_PACKAGE_STATUS      => C_BILL_PACKAGE_DATA.BILL_PACKAGE_STATUS,
                                         PVI_CREATED_BY               => C_BILL_PACKAGE_DATA.CREATED_BY,
                                         PDI_CREATION_DATE            => C_BILL_PACKAGE_DATA.CREATION_DATE,
                                         PVI_LAST_MODIFIED_BY         => C_BILL_PACKAGE_DATA.LAST_MODIFIED_BY,
                                         PDI_LAST_MODIFICATION_DATE   => C_BILL_PACKAGE_DATA.LAST_MODIFICATION_DATE,
                                         PNI_PROV_CHANGE_BILL_PACK_ID => C_BILL_PACKAGE_DATA.PROV_CHANGE_BILL_PACKAGE_ID,
                                         PNI_PACKAGE_ID               => C_BILL_PACKAGE_DATA.PACKAGE_ID,
                                         PNI_REFERRAL_DETAIL_ID       => C_BILL_PACKAGE_DATA.REFERRAL_DETAIL_ID,
                                         PNI_BILL_MASTER_ID           => C_BILL_PACKAGE_DATA.BILL_MASTER_ID,
                                         PNI_STG_ETL_ID               => N_STG_ETL_ID,
                                         PNO_STATUS                   => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_BILL_ITEM processing
                SELECT COUNT(*)
                  INTO N_BILL_ITEM_DATA_EXISTS
                  FROM R_BILL_ITEM RBI
                 WHERE RBI.BILL_ITEM_ID = HCFA_ITEM.BILL_ITEM_ID;

                IF N_BILL_ITEM_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_BILL_ITEM_DATA
                      FROM R_BILL_ITEM RBI
                     WHERE RBI.BILL_ITEM_ID = HCFA_ITEM.BILL_ITEM_ID;

                    SP_ETL_BILL_ITEM( PNI_BILL_ITEM_ID           => C_BILL_ITEM_DATA.BILL_ITEM_ID,
                                      PVI_INTREPID_CODE          => C_BILL_ITEM_DATA.INTREPID_CODE,
                                      PCI_AP_TECH_STATUS         => C_BILL_ITEM_DATA.AP_TECH_STATUS,
                                      PCI_AP_PROF_STATUS         => C_BILL_ITEM_DATA.AP_PROF_STATUS,
                                      PVI_CREATED_BY             => C_BILL_ITEM_DATA.CREATED_BY,
                                      PDI_CREATION_DATE          => C_BILL_ITEM_DATA.CREATION_DATE,
                                      PVI_LAST_MODIFIED_BY       => C_BILL_ITEM_DATA.LAST_MODIFIED_BY,
                                      PDI_LAST_MODIFICATION_DATE => C_BILL_ITEM_DATA.LAST_MODIFICATION_DATE,
                                      PNI_PAYER_AMOUNT           => C_BILL_ITEM_DATA.PAYER_AMOUNT,
                                      PNI_HCFA_AMOUNT            => C_BILL_ITEM_DATA.HCFA_AMOUNT,
                                      PNI_PROVIDER_AMOUNT        => C_BILL_ITEM_DATA.PROVIDER_AMOUNT,
                                      PNI_MARGIN_AMOUNT          => C_BILL_ITEM_DATA.MARGIN_AMOUNT,
                                      PNI_COST_SAVING_AMOUNT     => C_BILL_ITEM_DATA.COST_SAVING_AMOUNT,
                                      PCI_ACCELERATED_FLAG       => C_BILL_ITEM_DATA.ACCELERATED_FLAG,
                                      PCI_AR_STATUS              => C_BILL_ITEM_DATA.AR_STATUS,
                                      PCI_IS_BILLED              => C_BILL_ITEM_DATA.IS_BILLED,
                                      PCI_CONTRACT_STATUS        => C_BILL_ITEM_DATA.CONTRACT_STATUS,
                                      PNI_BILL_PACKAGE_ID        => C_BILL_ITEM_DATA.BILL_PACKAGE_ID,
                                      PNI_ADMIN_BROKER_AMOUNT    => C_BILL_ITEM_DATA.ADMIN_BROKER_AMOUNT,
                                      PNI_TOTAL_PAYER_AMOUNT     => C_BILL_ITEM_DATA.TOTAL_PAYER_AMOUNT,
                                      PNI_BILLING_REASON_ID      => C_BILL_ITEM_DATA.BILLING_REASON_ID,
                                      PNI_DISALLOW_ID            => C_BILL_ITEM_DATA.DISALLOW_ID,
                                      PNI_RR_BUSINESS_ID         => C_BILL_ITEM_DATA.RR_BUSINESS_ID,
                                      PNI_RESENT_TYPE_ID         => C_BILL_ITEM_DATA.RESENT_TYPE_ID,
                                      PNI_NOTE_ID                => C_BILL_ITEM_DATA.NOTE_ID,
                                      PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                      PNO_STATUS                 => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- R_HCFA_BILL_ITEM processing
                SELECT COUNT(*)
                  INTO N_HCFA_BILL_ITEM_DATA_EXISTS
                  FROM R_HCFA_BILL_ITEM RHBI
                 WHERE RHBI.HCFA_BILL_ITEM_ID = HCFA_ITEM.HCFA_BILL_ITEM_ID;

                IF N_HCFA_BILL_ITEM_DATA_EXISTS > 0
                THEN
                    SELECT *
                      INTO C_HCFA_BILL_ITEM_DATA
                      FROM R_HCFA_BILL_ITEM RHBI
                     WHERE RHBI.HCFA_BILL_ITEM_ID = HCFA_ITEM.HCFA_BILL_ITEM_ID;

                    SP_ETL_HCFA_BILL_ITEM( PNI_HCFA_BILL_ITEM_ID         => C_HCFA_BILL_ITEM_DATA.HCFA_BILL_ITEM_ID,
                                           PNI_BILL_ITEM_ID              => C_HCFA_BILL_ITEM_DATA.BILL_ITEM_ID,
                                           PNI_HCFA_CPT_CODE_ID          => C_HCFA_BILL_ITEM_DATA.HCFA_CPT_CODE_ID,
                                           PNI_HCFA_TECH_MODIFIER_ID     => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_MODIFIER_ID,
                                           PNI_HCFA_PROF_MODIFIER_ID     => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_MODIFIER_ID,
                                           PDI_HCFA_PROF_RECEIVED_DATE   => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_RECEIVED_DATE,
                                           PDI_HCFA_TECH_RECEIVED_DATE   => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_RECEIVED_DATE,
                                           PDI_HCFA_TECH_START_DATE      => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_START_DATE,
                                           PDI_HCFA_TECH_END_DATE        => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_END_DATE,
                                           PVI_HCFA_TECH_PATIENT_ACCOUNT => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_PATIENT_ACCOUNT,
                                           PVI_HCFA_PROF_PATIENT_ACCOUNT => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_PATIENT_ACCOUNT,
                                           PNI_HCFA_TECH_AMOUNT          => C_HCFA_BILL_ITEM_DATA.HCFA_TECH_AMOUNT,
                                           PDI_HCFA_PROF_START_DATE      => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_START_DATE,
                                           PDI_HCFA_PROF_END_DATE        => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_END_DATE,
                                           PNI_HCFA_PROF_AMOUNT          => C_HCFA_BILL_ITEM_DATA.HCFA_PROF_AMOUNT,
                                           PNI_HCFA_TOTAL_AMOUNT         => C_HCFA_BILL_ITEM_DATA.HCFA_TOTAL_AMOUNT,
                                           PVI_CREATED_BY                => C_HCFA_BILL_ITEM_DATA.CREATED_BY,
                                           PDI_CREATION_DATE             => C_HCFA_BILL_ITEM_DATA.CREATION_DATE,
                                           PVI_LAST_MODIFIED_BY          => C_HCFA_BILL_ITEM_DATA.LAST_MODIFIED_BY,
                                           PDI_LAST_MODIFICATION_DATE    => C_HCFA_BILL_ITEM_DATA.LAST_MODIFICATION_DATE,
                                           PNI_TECH_PLACE_OF_SERVICE_ID  => C_HCFA_BILL_ITEM_DATA.TECH_PLACE_OF_SERVICE_ID,
                                           PNI_TECH_TYPE_OF_SERVICE_ID   => C_HCFA_BILL_ITEM_DATA.TECH_TYPE_OF_SERVICE_ID,
                                           PNI_PROF_TYPE_OF_SERVICE_ID   => C_HCFA_BILL_ITEM_DATA.PROF_TYPE_OF_SERVICE_ID,
                                           PNI_PROF_PLACE_OF_SERVICE_ID  => C_HCFA_BILL_ITEM_DATA.PROF_PLACE_OF_SERVICE_ID,
                                           PNI_ORIGINAL_HCFA_TECH_AMOUNT => C_HCFA_BILL_ITEM_DATA.ORIGINAL_HCFA_TECH_AMOUNT,
                                           PNI_ORIGINAL_HCFA_PROF_AMOUNT => C_HCFA_BILL_ITEM_DATA.ORIGINAL_HCFA_PROF_AMOUNT,
                                           PNI_STG_ETL_ID                => N_STG_ETL_ID,
                                           PNO_STATUS                    => N_STATUS );

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                -- L_BILL_TO_DIAGNOSIS processing
                SELECT COUNT(*)
                  INTO N_DIAGNOSIS_DATA_EXISTS
                  FROM L_BILL_TO_DIAGNOSIS L
                 WHERE L.BILL_MASTER_ID = HCFA_ITEM.BILL_MASTER_ID
                   AND L.HCFA_BILL_ITEM_ID = HCFA_ITEM.HCFA_BILL_ITEM_ID;

                IF N_DIAGNOSIS_DATA_EXISTS > 0
                THEN
                    SP_ETL_LBTD(PNI_HCFA_BILL_ITEM_ID      => HCFA_ITEM.HCFA_BILL_ITEM_ID,
                                PNI_BILL_MASTER_ID         => HCFA_ITEM.BILL_MASTER_ID,
                                PNI_STG_ETL_ID             => N_STG_ETL_ID,
                                PNO_STATUS                 => N_STATUS);

                    IF N_STATUS = 0
                    THEN
                        RAISE EX_FAIL_HCFA_ITEM;
                    END IF;
                END IF;

                COMMIT; -- CURRENT ITERATION

                SP_ETL_DETAIL_LOG (
                    PNIO_STG_ETL_DETAIL_ID                  => N_ITEM_STG_ETL_DETAIL_ID,
                    PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                    PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_ITEM_STATUS,
                    PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                    PVI_MESSAGE                             => 'HCFA_BILL_ITEM_ID=' || HCFA_ITEM.HCFA_BILL_ITEM_ID || ' has been processed successfully'
                );

            EXCEPTION
                WHEN EX_FAIL_HCFA_ITEM
                THEN

                    ROLLBACK TO SAVEPOINT SAVEPOINT_HCFA_ITEM;

                    SP_ETL_DETAIL_LOG (
                        PNIO_STG_ETL_DETAIL_ID                  => N_ITEM_STG_ETL_DETAIL_ID,
                        PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                        PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                        PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'ERROR occurred during processing of HCFA_BILL_ITEM_ID=' || HCFA_ITEM.HCFA_BILL_ITEM_ID
                    );

                WHEN OTHERS
                THEN

                    SP_ETL_DETAIL_LOG (
                        PNIO_STG_ETL_DETAIL_ID                  => N_ITEM_STG_ETL_DETAIL_ID,
                        PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                        PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_ITEM_STATUS,
                        PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                        PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during processing of HCFA_BILL_ITEM_ID=' || HCFA_ITEM.HCFA_BILL_ITEM_ID || '. TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                    );

                    RAISE;

            END;
        END LOOP;

        COMMIT;

        -- TBD: Added Statistics
        SP_ETL_DETAIL_LOG (
            PNIO_STG_ETL_DETAIL_ID                  => N_JOB_STG_ETL_DETAIL_ID,
            PNI_STG_ETL_ID                          => N_STG_ETL_ID,
            PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_SUCCESS_JOB_STATUS,
            PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
            PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
        );

        -- End of the processing
        SP_ETL_LOG (
            PNIO_STG_ETL_ID                       => N_STG_ETL_ID,
            PVI_STG_ETL_STATUS                    => PKG_STG_ETL.C$C_SUCCESS_JOB_STATUS,
            PDI_STG_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
        );

    EXCEPTION
        WHEN OTHERS
        THEN

            ROLLBACK;

            -- Log the error
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_TEMP_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_JOB_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'ERROR "' || SQLERRM || '" occurred during processing. TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
            );

            -- TBD: Added Statistics
            SP_ETL_DETAIL_LOG (
                PNIO_STG_ETL_DETAIL_ID                  => N_JOB_STG_ETL_DETAIL_ID,
                PNI_STG_ETL_ID                          => N_STG_ETL_ID,
                PVI_STG_ETL_DETAIL_STATUS               => PKG_STG_ETL.C$C_ERROR_JOB_STATUS,
                PVI_STG_ETL_MODULE                      => C$V_PROCEDURE,
                PVI_MESSAGE                             => 'Outcomes for ' || TO_CHAR(PDI_ETL_PROCESS_DATE, 'MM/DD/YYYY')
            );

            -- End of the processing
            SP_ETL_LOG (
                PNIO_STG_ETL_ID                       => N_STG_ETL_ID,
                PVI_STG_ETL_STATUS                    => PKG_STG_ETL.C$C_ERROR_JOB_STATUS,
                PDI_STG_ETL_PROCESS_DATE              => PDI_ETL_PROCESS_DATE
            );

    END;

END PKG_STG_ETL;
/
