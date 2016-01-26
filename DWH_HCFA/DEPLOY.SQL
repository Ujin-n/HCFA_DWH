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

SPOOL DWH_LAB_DWH_1.0.0.1_20160126.LOG

/****************************************************************/
/*** DDL statements                                           ***/
/****************************************************************/

@./SEQUENCES/SEQUENCES.SQL
@./TABLES/LOG_TABLES.SQL
@./TABLES/TABLES.SQL
@./TYPES/TYPES.SQL

/****************************************************************/
/*** DB objects                                               ***/
/****************************************************************/

@./PACKAGES/PKG_DWH_ETL.SQL

/****************************************************************/
/*** DML statements                                           ***/
/****************************************************************/

@./SCRIPTS/DIM_DATE_POPULATION.SQL
@./SCRIPTS/DIM_DEFAULT_POPULATION.SQL

/****************************************************************/
/*** DB history                                               ***/
/****************************************************************/

BEGIN
    COMMIT;
END;
/


EXIT