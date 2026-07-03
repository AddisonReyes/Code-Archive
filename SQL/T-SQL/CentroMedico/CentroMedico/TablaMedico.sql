IF OBJECT_ID(N'dbo.Medico', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Medico
	(
		IdMedico dbo.idMedico IDENTITY(1,1) NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Apellido VARCHAR(50) NOT NULL,

		CONSTRAINT PK_Medico
			PRIMARY KEY CLUSTERED (IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD IdMedico dbo.idMedico IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'Nombre') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD Nombre VARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'Apellido') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD Apellido VARCHAR(50) NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Medico')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Medico
		ADD CONSTRAINT PK_Medico PRIMARY KEY CLUSTERED (IdMedico);
END;
GO
