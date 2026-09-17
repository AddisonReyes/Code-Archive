CREATE DATABASE DBA_LAB_SPACE
ON PRIMARY ( 
	NAME = 'DBA_LAB_SPACE_Data',
	FILENAME = 'B:\SQLData\DBA_LAB_SPACE.mdf',
	SIZE = 8MB, 
	MAXSIZE = 20MB, 
	FILEGROWTH = 2MB 
) LOG ON ( 
	NAME = 'DBA_LAB_SPACE_Log',
	FILENAME = 'B:\SQLLogs\DBA_LAB_SPACE.ldf',
	SIZE = 8MB, 
	FILEGROWTH = 2MB 
);

---

USE DBA_LAB_SPACE;

CREATE TABLE dbo.SpaceTest (
	ID int IDENTITY PRIMARY KEY, 
	Payload CHAR(7000) NOT NULL 
);
GO

INSERT dbo.SpaceTest(Payload)
SELECT TOP (5000) REPLICATE('X',7000)
FROM sys.all_objects a
CROSS JOIN sys.all_objects b

/*
Msg 1101, Level 17, State 12, Line 25
Could not allocate a new page for database 'DBA_LAB_SPACE' because of insufficient disk space in filegroup 'PRIMARY'. Create the necessary space by dropping objects in the filegroup, adding additional files to the filegroup, or setting autogrowth on for existing files in the filegroup.

Completion time: 2026-09-17T14:52:00.5187449-04:00
*/

---

SELECT 
	name, type_desc, physical_name, 
	size * 8.0/1024 AS size_mb,
	CASE max_size 
		WHEN -1 THEN -1 
		ELSE max_size * 8.0/1024 
	END AS max_size_mb,
	growth * 8.0/1024 AS growth_mb
FROM sys.database_files;

---

ALTER DATABASE DBA_LAB_SPACE
MODIFY FILE (
	NAME = 'DBA_LAB_SPACE_Data', 
	MAXSIZE = 96MB
);

---

INSERT dbo.SpaceTest(Payload)
SELECT TOP (1000) REPLICATE('Y',7000)
FROM sys.all_objects;
