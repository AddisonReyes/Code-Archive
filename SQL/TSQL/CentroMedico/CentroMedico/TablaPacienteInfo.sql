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

MERGE dbo.PacienteInfo AS Target
USING (
	SELECT
		IdPaciente,
		CONVERT(BIT, CASE WHEN IdPaciente % 5 = 0 THEN 1 ELSE 0 END) AS Diabetico,
		CONVERT(BIT, CASE WHEN IdPaciente % 7 = 0 THEN 1 ELSE 0 END) AS Implantes
	FROM (VALUES
		(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
		(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
		(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
		(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
		(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
		(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
		(61),(62),(63),(64),(65),(66),(67)
	) AS Datos (IdPaciente)
) AS Source
	ON Target.IdPaciente = Source.IdPaciente
WHEN MATCHED THEN
	UPDATE SET
		Diabetico = Source.Diabetico,
		Implantes = Source.Implantes
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdPaciente, Diabetico, Implantes)
	VALUES (Source.IdPaciente, Source.Diabetico, Source.Implantes);
GO
