IF OBJECT_ID(N'dbo.Historia', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Historia
	(
		IdHistoria dbo.idHistoria IDENTITY(1,1) NOT NULL,
		FechaHistoria DATETIME NOT NULL,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Historia
			PRIMARY KEY CLUSTERED (IdHistoria)
	);
END;
GO

IF COL_LENGTH(N'dbo.Historia', N'IdHistoria') IS NULL
BEGIN
	ALTER TABLE dbo.Historia ADD IdHistoria dbo.idHistoria IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Historia', N'FechaHistoria') IS NULL
BEGIN
	ALTER TABLE dbo.Historia ADD FechaHistoria DATETIME NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Historia', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Historia ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Historia')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Historia
		ADD CONSTRAINT PK_Historia PRIMARY KEY CLUSTERED (IdHistoria);
END;
GO
