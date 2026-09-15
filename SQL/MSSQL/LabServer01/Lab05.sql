USE master;
GO

SELECT 
	name, state_desc, user_access, 
	recovery_model_desc
FROM sys.databases
ORDER BY name

---

USE msdb;
GO

SELECT 
	d.name, 
	MAX(CASE WHEN bs.type='D' THEN bs.backup_finish_date END) AS LastFull, 
	MAX(CASE WHEN bs.type='I' THEN bs.backup_finish_date END) AS LastDiff, 
	MAX(CASE WHEN bs.type='L' THEN bs.backup_finish_date END) AS LastLog 
FROM sys.databases AS d 
LEFT JOIN msdb.dbo.backupset AS bs 
	ON bs.database_name=d.name 
GROUP BY d.name 
ORDER BY d.name; 