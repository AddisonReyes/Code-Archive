--- Session A ---

USE DBA_LAB_CORE;
GO

BEGIN TRAN;
	UPDATE dbo.Cliente
	SET Ciudad = 'Bloqueo Lab'
	WHERE ClienteID = 1;
-- No ejecutar COMMIT todavia

ROLLBACK;