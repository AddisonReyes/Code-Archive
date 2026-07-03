IF OBJECT_ID(N'dbo.Paciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Paciente
	(
		IdPaciente dbo.idPaciente IDENTITY(1,1) NOT NULL,
		Cedula NVARCHAR(20) NOT NULL,
		Nombre NVARCHAR(50) NOT NULL,
		Apellido NVARCHAR(50) NOT NULL,
		FechaNacimiento DATE NOT NULL,
		Domicilio NVARCHAR(50) NOT NULL,
		IdPais dbo.idPais NOT NULL,
		Telefono NVARCHAR(20) NULL,
		Email NVARCHAR(255) NOT NULL,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Paciente
			PRIMARY KEY CLUSTERED (IdPaciente)
	);
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD IdPaciente dbo.idPaciente IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Cedula') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Cedula NVARCHAR(20) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Nombre') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Nombre NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Apellido') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Apellido NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'FechaNacimiento') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD FechaNacimiento DATE NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Domicilio') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Domicilio NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'IdPais') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD IdPais dbo.idPais NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Telefono') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Telefono NVARCHAR(20) NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Email') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Email NVARCHAR(255) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Paciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Paciente
		ADD CONSTRAINT PK_Paciente PRIMARY KEY CLUSTERED (IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.Paciente')
		AND name = N'FK_Paciente_Pais'
)
BEGIN
	ALTER TABLE dbo.Paciente
		ADD CONSTRAINT FK_Paciente_Pais
		FOREIGN KEY (IdPais) REFERENCES dbo.Pais(IdPais);
END;
GO
