IF OBJECT_ID(N'dbo.PagoPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.PagoPaciente
	(
		IdPago dbo.idPago NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdTurno dbo.idTurno NOT NULL,

		CONSTRAINT PK_PagoPaciente
			PRIMARY KEY CLUSTERED (IdPago, IdPaciente, IdTurno)
	);
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdPago') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdPago dbo.idPago NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdTurno dbo.idTurno NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT PK_PagoPaciente PRIMARY KEY CLUSTERED (IdPago, IdPaciente, IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Pago'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Pago
		FOREIGN KEY (IdPago) REFERENCES dbo.Pago(IdPago);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Turno'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Turno
		FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno);
END;
GO

MERGE dbo.PagoPaciente AS Target
USING (
	SELECT
		IdPago,
		((IdPago - 1) % 67) + 1 AS IdPaciente,
		IdPago AS IdTurno
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
	) AS Datos (IdPago)
) AS Source
	ON Target.IdPago = Source.IdPago
	AND Target.IdPaciente = Source.IdPaciente
	AND Target.IdTurno = Source.IdTurno
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdPago, IdPaciente, IdTurno)
	VALUES (Source.IdPago, Source.IdPaciente, Source.IdTurno);
GO
