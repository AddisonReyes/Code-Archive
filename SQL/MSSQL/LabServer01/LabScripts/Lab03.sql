USE master;
GO

CREATE LOGIN dba_lab_reader
WITH PASSWORD = 'LabServer#2026!';

---

USE DBA_LAB_CORE;
GO

CREATE USER dba_lab_reader
FOR LOGIN dba_lab_reader;

---

ALTER ROLE db_datareader
ADD MEMBER dba_lab_reader;

---

EXECUTE AS LOGIN = 'dba_lab_reader';
	USE DBA_LAB_CORE;
	SELECT * FROM dbo.Cliente;
REVERT;

---

EXECUTE AS LOGIN = 'dba_lab_reader';
	USE DBA_LAB_CORE; 
	
	UPDATE dbo.Cliente 
	SET Ciudad = 'Prueba' 
	WHERE ClienteID=1; 
REVERT; 