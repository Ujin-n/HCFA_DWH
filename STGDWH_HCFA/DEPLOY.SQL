SET VERIFY OFF
SET TRIMSPOOL ON
SET TRIMOUT ON
SET PAGESIZE 0
SET LINESIZE 2000
SET FEEDBACK ON
SET ECHO ON
SET TERMOUT ON
SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

SPOOL DWH_LAB_STAGING_DEPLOYMENT_1.0.0.2.LOG

/****************************************************************/
/*** DDL statements                                           ***/
/****************************************************************/
@./SEQUENCES/SEQUENCES.SQL
@./TABLES/LOG_TABLES.SQL
@./TABLES/TABLES.SQL
@./TYPES/TYPES.SQL

/****************************************************************/
/*** DML statements                                           ***/
/****************************************************************/


/****************************************************************/
/*** DB objects                                               ***/
/****************************************************************/
@./PACKAGES/PKG_STG_ETL.SQL


/****************************************************************/
/*** DB history                                               ***/
/****************************************************************/

BEGIN
   COMMIT;
END;
/

EXIT