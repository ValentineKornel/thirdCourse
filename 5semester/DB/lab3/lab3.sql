ALTER SESSION SET CONTAINER = "CDB$ROOT";
show con_name;
--1
SELECT NAME, OPEN_MODE from v$pdbs;

--2
SELECT INSTANCE_NAME, STATUS, HOST_NAME FROM V$INSTANCE;
select INSTANCE_NAME from V$INSTANCE;

--3
SELECT COMP_ID, COMP_NAME, VERSION, STATUS FROM DBA_REGISTRY;

--4
CREATE PLUGGABLE DATABASE KVV_PDB
    ADMIN USER pdb_admin IDENTIFIED BY 12345
    ROLES = (DBA)
    FILE_NAME_CONVERT = ('C:\app\valen\product\21c\oradata\XE\pdbseed', 'C:\app\valen\product\21c\oradata\XE\KVV_PDB');
    
ALTER PLUGGABLE DATABASE KVV_PDB OPEN;

--5
SELECT PDB_NAME FROM DBA_PDBS;


--6
--PDB
--pdb_admin
CREATE TABLESPACE TS_PDB_KVV
    DATAFILE 'TS_PDB_KVV.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    EXTENT MANAGEMENT LOCAL;
    
CREATE TEMPORARY TABLESPACE TS_PDB_KVV_TEMP
    TEMPFILE 'TS_PDB_KVV_TEMP.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M;

CREATE ROLE RL_PDB_KVVCORE;
--DROP ROLE RL_PDB_KVVCORE;

GRANT CONNECT, CREATE SESSION, CREATE ANY TABLE, DROP ANY TABLE, CREATE ANY VIEW, 
DROP ANY VIEW, CREATE ANY PROCEDURE, DROP ANY PROCEDURE TO RL_PDB_KVVCORE;


--DROP PROFILE PF_PDB_KVVCORE
CREATE PROFILE PF_PDB_KVVCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 5
    FAILED_LOGIN_ATTEMPTS 10
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    CONNECT_TIME 180
    IDLE_TIME 30;

--DROP USER U1_KVV_PDB
CREATE USER U1_KVV_PDB IDENTIFIED BY 12345
DEFAULT TABLESPACE TS_PDB_KVV QUOTA UNLIMITED ON TS_PDB_KVV
TEMPORARY TABLESPACE TS_PDB_KVV_TEMP
PROFILE PF_PDB_KVVCORE
ACCOUNT UNLOCK;

GRANT RL_PDB_KVVCORE TO U1_KVV_PDB;


--7
--U1_KVV_PDB
CREATE TABLE KVV_TABLE(a NUMBER, b VARCHAR2(10));


INSERT INTO KVV_TABLE VALUES(1, 'one');
INSERT INTO KVV_TABLE VALUES(2, 'two');
COMMIT;

SELECT * FROM KVV_TABLE;


--8
--SYS
SELECT * FROM DBA_TABLESPACES;
SELECT ROLE FROM DBA_ROLES;
SELECT PROFILE FROM DBA_PROFILES;
SELECT USERNAME FROM DBA_USERS;

SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES;
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS;
SELECT grantee, granted_role FROM dba_role_privs where grantee = 'U1_KVV_PDB';
--���� �����������


--9
--CDB
--SYS
CREATE USER C##KVV IDENTIFIED BY 12345;
GRANT CONNECT, CREATE SESSION, CREATE ANY TABLE, DROP ANY TABLE TO C##KVV;
GRANT CREATE SESSION to C##KVV;


--PDB
--pdb_admin
GRANT CREATE SESSION TO C##KVV;

SHOW CON_NAME;


--13
ALTER PLUGGABLE DATABASE KVV_PDB CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE KVV_PDB INCLUDING DATAFILES;
DROP USER C##KVV;






