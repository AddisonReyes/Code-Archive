ALTER DATABASE DBA_LAB_CORE SET RECOVERY FULL;
GO

---

BACKUP DATABASE DBA_LAB_CORE 
TO DISK = N'B:\SQLBackups\Full\DBA_LAB_CORE\DBA_LAB_CORE_FULL.bak'
WITH
	INIT,
	CHECKSUM,
	STATS = 10;

---

USE DBA_LAB_CORE;
GO

INSERT dbo.Cliente (Nombre, Ciudad)
VALUES 
	('Cliente Post Full 1','Santo Domingo'),
	('Cliente Post Full 2','Santiago');

---

BACKUP LOG DBA_LAB_CORE
TO DISK = 'B:\SQLBackups\Log\DBA_LAB_CORE\\DBA_LAB_CORE_LOG_01.trn'
WITH INIT, CHECKSUM, STATS = 10;

---

USE DBA_LAB_CORE;
GO

INSERT dbo.Cliente(Nombre,Ciudad) VALUES ('Cliente Post Log','Bonao');

BACKUP DATABASE DBA_LAB_CORE
TO DISK = 'B:\SQLBackups\Differential\DBA_LAB_CORE\DBA_LAB_CORE_DIFF.bak'
WITH DIFFERENTIAL, INIT, CHECKSUM, STATS = 10;

---

BACKUP LOG DBA_LAB_CORE
TO DISK = 'B:\SQLBackups\Log\DBA_LAB_CORE\\DBA_LAB_CORE_LOG_02.trn'
WITH INIT, CHECKSUM, STATS = 10;

---

USE msdb;
GO

SELECT TOP (20) 
	database_name, CASE 
		WHEN type = 'D' THEN 'Full'
		WHEN type = 'I' THEN 'Differential'
		WHEN type = 'L' THEN 'Log'
	END AS Type, 
	backup_start_date, backup_finish_date,
	first_lsn, last_lsn, checkpoint_lsn, database_backup_lsn
FROM msdb.dbo.backupset
WHERE database_name='DBA_LAB_CORE'
ORDER BY backup_finish_date DESC;