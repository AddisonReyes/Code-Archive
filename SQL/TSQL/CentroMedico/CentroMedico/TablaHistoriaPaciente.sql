IF OBJECT_ID(N'dbo.HistoriaPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.HistoriaPaciente
	(
		IdHistoria dbo.idHistoria NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdMedico dbo.idMedico NOT NULL,

		CONSTRAINT PK_HistoriaPaciente
			PRIMARY KEY CLUSTERED (IdHistoria, IdPaciente, IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdHistoria') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdHistoria dbo.idHistoria NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdMedico dbo.idMedico NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT PK_HistoriaPaciente PRIMARY KEY CLUSTERED (IdHistoria, IdPaciente, IdMedico);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Historia'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Historia
		FOREIGN KEY (IdHistoria) REFERENCES dbo.Historia(IdHistoria);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Medico'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Medico
		FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico);
END;
GO

MERGE dbo.HistoriaPaciente AS Target
USING (
	SELECT
		IdHistoria,
		((IdHistoria - 1) % 67) + 1 AS IdPaciente,
		((IdHistoria - 1) % 18) + 1 AS IdMedico
	FROM (VALUES
		(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
		(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
		(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
		(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
		(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
		(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
		(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
		(71),(72),(73),(74),(75),(76),(77),(78),(79),(80)
	) AS Datos (IdHistoria)
) AS Source
	ON Target.IdHistoria = Source.IdHistoria
	AND Target.IdPaciente = Source.IdPaciente
	AND Target.IdMedico = Source.IdMedico
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdHistoria, IdPaciente, IdMedico)
	VALUES (Source.IdHistoria, Source.IdPaciente, Source.IdMedico);
GO
