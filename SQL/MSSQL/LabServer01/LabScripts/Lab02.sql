CREATE DATABASE DBA_LAB_CORE
ON PRIMARY (
	NAME = N'DBA_LAB_CORE_Data',
	FILENAME = N'B:\SQLData\DBA_LAB_CORE.mdf',
	SIZE = 64MB,
	FILEGROWTH = 32MB
)
LOG ON (
	NAME = N'DBA_LAB_CORE_Log',
	FILENAME = N'B:\SQLLogs\DBA_LAB_CORE.ldf',
	SIZE = 32MB,
	FILEGROWTH = 16MB
);

USE master;
GO

SELECT name, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = 'DBA_LAB_CORE';

---

USE DBA_LAB_CORE;
GO

SELECT
	name, type_desc, physical_name, 
	size * 8.0 / 1024 AS size_mb,
	growth, is_percent_growth
FROM sys.database_files

---

CREATE TABLE dbo.Cliente (
	ClienteID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(100) NOT NULL,
	Ciudad NVARCHAR(60) NULL,
	FechaRegistro DATETIME2 NOT NULL
		DEFAULT SYSDATETIME()
);

---

INSERT dbo.Cliente (Nombre, Ciudad)
VALUES
	('Ana', 'Santo Domingo'),
	('Luis', 'Santiago'),
	('Marta', 'Bonao');

SELECT * FROM dbo.Cliente;

---

SELECT * FROM dbo.Cliente WHERE ClienteID = 2; 
UPDATE dbo.Cliente SET Ciudad='La Vega' WHERE ClienteID = 2; 
SELECT * FROM dbo.Cliente WHERE ClienteID = 3; 
DELETE dbo.Cliente WHERE ClienteID = 3; 
