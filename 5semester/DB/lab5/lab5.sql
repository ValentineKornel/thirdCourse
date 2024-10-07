--1
SELECT SUM(VALUE) TOTAL_SGA_IN_BYTES FROM V$SGA;

--2
SELECT NAME POOL_NAME, VALUE SIZE_IN_BYTES FROM V$SGA;

--3
SELECT COMPONENT, GRANULE_SIZE FROM V$SGA_DYNAMIC_COMPONENTS;


--4
SELECT CURRENT_SIZE FROM V$SGA_DYNAMIC_FREE_MEMORY;

--5
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME IN ('sga_target', 'sga_max_size');

--6
SELECT COMPONENT, MIN_SIZE, MAX_SIZE, CURRENT_SIZE FROM V$SGA_DYNAMIC_COMPONENTS
WHERE COMPONENT IN ('KEEP buffer cache', 'RECYCLE buffer cache', 'DEFAULT buffer cache');

--7
CREATE TABLE KEEP_T1 (a NUMBER) STORAGE (BUFFER_POOL KEEP);
INSERT INTO KEEP_T1 VALUES(1);
INSERT INTO KEEP_T1 VALUES(2);
INSERT INTO KEEP_T1 VALUES(3);
COMMIT;

select * from KEEP_T1;

SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
FROM USER_SEGMENTS WHERE SEGMENT_NAME LIKE 'KEEP%';


--8
CREATE TABLE DEFAULT_T2 (b NUMBER) STORAGE (BUFFER_POOL DEFAULT);
INSERT INTO DEFAULT_T2 VALUES(4);
INSERT INTO DEFAULT_T2 VALUES(5);

SELECT * FROM DEFAULT_T2;
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'DEFAULT_T2%';


--9
SHOW PARAMETER LOG_BUFFER;


--10
SELECT POOL, NAME, BYTES FROM V$SGASTAT WHERE POOL = 'large pool' AND NAME = 'free memory';


--11
SELECT SID, STATUS, SERVER, LOGON_TIME, PROGRAM, OSUSER, MACHINE, USERNAME, STATE
FROM V$SESSION WHERE STATUS = 'ACTIVE';


--12
SELECT SID, PROCESS, NAME, DESCRIPTION, PROGRAM
FROM V$SESSION s JOIN V$BGPROCESS b on s.paddr = b.paddr
WHERE s.STATUS = 'ACTIVE';


--13
SELECT PID, PNAME, USERNAME, PROGRAM FROM V$PROCESS;

--14
SHOW PARAMETER DB_WRITER_PROCESSES;

SELECT * FROM V$PROCESS WHERE PNAME LIKE 'DBW%';

--15
SELECT NAME, NETWORK_NAME, PDB FROM V$SERVICES;


--16
SHOW PARAMETER DISPATCHERS;
SELECT * FROM V$DISPATCHER;

--17
-- services.msc -> OracleOraDB21Home1TNSListener

--18
--  C:\app\valen\product\21c\dbhomeXE\network\admin\sample

--19
--  start, stop, status, services, version, reload, save_config, trace, quit, exit, set, show

--20
--  lsnrctl -> services








