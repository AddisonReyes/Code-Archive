--- Session B ---

USE DBA_LAB_CORE;
GO

UPDATE dbo.Cliente
SET Ciudad='Sesion B'
WHERE ClienteID=1;