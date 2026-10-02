USE DBA_LAB_CORE;
GO

SELECT * FROM Cliente;

---

USE master;
GO

ALTER DATABASE DBA_LAB_CORE
SET HADR OFF;

---

SELECT
    name,
    state_desc,
    replica_id,
    group_database_id
FROM sys.databases
WHERE name = 'DBA_LAB_CORE';

