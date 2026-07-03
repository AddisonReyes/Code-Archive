IF OBJECT_ID(N'dbo.PacienteInfo', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.PacienteInfo
	(
		IdPaciente dbo.idPaciente NOT NULL,
		Diabetico BIT NOT NULL CONSTRAINT DF_PacienteInfo_Diabetico DEFAULT 0,
		Implantes BIT NOT NULL CONSTRAINT DF_PacienteInfo_Implantes DEFAULT 0,

		CONSTRAINT PK_PacienteInfo
			PRIMARY KEY CLUSTERED (IdPaciente)
	);
END;
GO

IF COL_LENGTH(N'dbo.PacienteInfo', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.PacienteInfo ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.PacienteInfo', N'Diabetico') IS NULL
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD Diabetico BIT NOT NULL CONSTRAINT DF_PacienteInfo_Diabetico DEFAULT 0 WITH VALUES;
END;
GO

IF COL_LENGTH(N'dbo.PacienteInfo', N'Implantes') IS NULL
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD Implantes BIT NOT NULL CONSTRAINT DF_PacienteInfo_Implantes DEFAULT 0 WITH VALUES;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.PacienteInfo')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD CONSTRAINT PK_PacienteInfo PRIMARY KEY CLUSTERED (IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.PacienteInfo')
		AND name = N'DF_PacienteInfo_Diabetico'
)
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD CONSTRAINT DF_PacienteInfo_Diabetico DEFAULT 0 FOR Diabetico;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.PacienteInfo')
		AND name = N'DF_PacienteInfo_Implantes'
)
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD CONSTRAINT DF_PacienteInfo_Implantes DEFAULT 0 FOR Implantes;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PacienteInfo')
		AND name = N'FK_PacienteInfo_Paciente'
)
BEGIN
	ALTER TABLE dbo.PacienteInfo
		ADD CONSTRAINT FK_PacienteInfo_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO
