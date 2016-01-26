REM *******************************************************
REM   Set all necessary variables
REM *******************************************************
SET VERSION=DWH_LAB_STAGING_1.0.0.2

SET TNS=EVBYMINSD641A_ORCL
SET DBA_USER=SYSTEM
SET DBA_PWD=oracle

SET USER_NAME=STGDWH3
SET USER_PWD=OCM
SET DEFAULT_TABLESPACE=PHOENIXDATA
SET TEMP_TABLESPACE=REALTEMP
SET INDEX_TABLESPACE=PHOENIXINDEX

SET SOURCE_USER=PHOENIX3
SET TARGET_USER=STGDWH3

REM *******************************************************
REM   Deployment
REM *******************************************************
SQLPLUS -S %USER_NAME%/%USER_PWD%@%TNS% @DEPLOY.SQL
IF ERRORLEVEL == 1 GOTO DEPLOY_ERROR

REM *******************************************************
REM   Privileges
REM *******************************************************
SQLPLUS %DBA_USER%/%DBA_PWD%@%TNS% @./SYNONYMS/PRIVILEGES.SQL %SOURCE_USER% %TARGET_USER%
IF ERRORLEVEL == 1 GOTO DEPLOY_ERROR

REM *******************************************************
REM   Final compilation
REM *******************************************************
SQLPLUS -S %USER_NAME%/%USER_PWD%@%TNS% @COMPILE.SQL
IF ERRORLEVEL == 1 GOTO DEPLOY_ERROR


GOTO SUCCESS

:ERROR
    SET MSG="ERROR: SCHEMA DEPLOYMENT FAILED."
    GOTO END
:SUCCESS
    SET MSG="SCHEMA HAS BEEN SUCCESSFULLY DEPLOYED"
    GOTO END
:END
    ECHO %MSG%
    ECHO %MSG% >> %LOG_FILE%

EXIT

