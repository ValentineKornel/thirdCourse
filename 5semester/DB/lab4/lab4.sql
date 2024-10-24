ALTER SESSION SET CONTAINER = "XEPDB1";
ALTER SESSION SET CONTAINER = "CDB$ROOT";
show con_name;
--1
SELECT * FROM DBA_DATA_FILES;
SELECT * FROM DBA_TEMP_FILES;

--2
DROP TABLESPACE KVV_QDATA INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE KVV_QDATA
    DATAFILE 'KVV_QDATA.DBF'
    SIZE 10M
    OFFLINE;
    
ALTER TABLESPACE KVV_QDATA ONLINE;

ALTER USER KVVCORE QUOTA 2M ON KVV_QDATA;


--KVVCORE
--DROP TABLE KVV_T1
CREATE TABLE KVV_T1(
    a INT PRIMARY KEY,
    b VARCHAR2(20)
) TABLESPACE KVV_QDATA;

INSERT ALL
    INTO KVV_T1 VALUES(1, 'ONE')
    INTO KVV_T1 VALUES(2, 'TWO')
    INTO KVV_T1 VALUES(3, 'THREE')
SELECT * FROM DUAL;

SELECT * FROM KVV_T1;

--3
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS 
FROM USER_SEGMENTS WHERE TABLESPACE_NAME = 'KVV_QDATA';

SELECT * FROM USER_SEGMENTS;

--4
DROP TABLE KVV_T1;
SELECT * FROM USER_SEGMENTS WHERE TABLESPACE_NAME = 'KVV_QDATA';

SELECT * FROM USER_RECYCLEBIN;

--5
FLASHBACK TABLE KVV_T1 TO BEFORE DROP;


--6
BEGIN
    FOR x IN 4..10004
    LOOP
        INSERT INTO KVV_T1 VALUES(x, 'smth');
    END LOOP;
END;

SELECT COUNT(*) FROM KVV_T1;

SELECT * FROM KVV_T1 FETCH FIRST 10 ROWS ONLY;
SELECT * FROM KVV_T1 WHERE a = 1;

SELECT * FROM USER_SEGMENTS;
SELECT * FROM USER_EXTENTS;


--8
--SYS
DROP TABLESPACE KVV_QDATA INCLUDING CONTENTS AND DATAFILES;

--9
SELECT * FROM V$LOG ORDER BY GROUP#;

--10
SELECT * FROM V$LOGFILE ORDER BY GROUP#;

--11
--CDB
ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$LOG ORDER BY GROUP#;

--12
ALTER DATABASE ADD LOGFILE
    GROUP 4
    'C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\REDO04.LOG'
    SIZE 50M
    BLOCKSIZE 512;
    
ALTER DATABASE ADD LOGFILE
    MEMBER
    'C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\REDO04_1.LOG'
    TO GROUP 4;

ALTER DATABASE ADD LOGFILE
    MEMBER
    'C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\REDO04_2.LOG'
    TO GROUP 4;

SELECT * FROM V$LOG ORDER BY GROUP#;
SELECT GROUP#, MEMBER FROM V$LOGFILE ORDER BY GROUP#;

--SELECT current_scn FROM v$database;
ALTER SYSTEM SWITCH LOGFILE;


--13
--ALTER SYSTEM CHECKPOINT;
ALTER DATABASE DROP LOGFILE MEMBER 'C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\REDO04_2.LOG';
ALTER DATABASE DROP LOGFILE MEMBER 'C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\REDO04_1.LOG';
ALTER DATABASE DROP LOGFILE GROUP 4;

SELECT * FROM V$LOG ORDER BY GROUP#;
SELECT GROUP#, MEMBER FROM V$LOGFILE ORDER BY GROUP#;

--14
SELECT DBID, NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
--LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED

--15
SELECT * FROM V$ARCHIVED_LOG;

--16
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;

SELECT DBID, NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
--LOG_MODE = ARCHIVELOG; ARCHIVER = STARTED


--17
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=C:\APP\VALEN\PRODUCT\21C\ORADATA\XE\Archive';
SELECT * FROM V$ARCHIVED_LOG;
ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$LOG ORDER BY GROUP#;

--18
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE NOARCHIVELOG;
--ALTER DATABASE OPEN;

SELECT DBID, NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

--19
SELECT * FROM V$CONTROLFILE;

--20
SHOW PARAMETER CONTROL;
SELECT * FROM V$CONTROLFILE_RECORD_SECTION;


--21
SHOW PARAMETER SPFILE;

--22
CREATE PFILE = 'C:\app\valen\product\21c\database\KVV_PFILE.ora' FROM SPFILE;

--23
SHOW PARAMETER REMOTE_LOGIN_PASSWORDFILE;
SELECT * FROM V$PWFILE_USERS;

--24
SELECT * FROM V$DIAG_INFO;

--25
--C:\app\valen\product\21c\diag\rdbms\xe\xe\alert


select distinct segment_type from dba_segments;
