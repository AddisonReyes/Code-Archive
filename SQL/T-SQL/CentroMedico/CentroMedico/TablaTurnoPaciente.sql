IF OBJECT_ID(N'dbo.TurnoPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.TurnoPaciente
	(
		IdTurno dbo.idTurno NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdMedico dbo.idMedico NOT NULL,

		CONSTRAINT PK_TurnoPaciente
			PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdTurno dbo.idTurno NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdMedico dbo.idMedico NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT PK_TurnoPaciente PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Turno'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Turno
		FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Medico'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Medico
		FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico);
END;
GO

MERGE dbo.TurnoPaciente AS Target
USING (
	SELECT
		IdTurno,
		((IdTurno - 1) % 67) + 1 AS IdPaciente,
		((IdTurno - 1) % 18) + 1 AS IdMedico
	FROM (VALUES
		(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
		(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
		(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
		(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
		(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
		(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
		(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
		(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
		(81),(82),(83),(84),(85),(86),(87),(88),(89),(90),
		(91),(92),(93),(94),(95),(96),(97),(98),(99),(100)
	) AS Datos (IdTurno)
) AS Source
	ON Target.IdTurno = Source.IdTurno
	AND Target.IdPaciente = Source.IdPaciente
	AND Target.IdMedico = Source.IdMedico
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdTurno, IdPaciente, IdMedico)
	VALUES (Source.IdTurno, Source.IdPaciente, Source.IdMedico);
GO
