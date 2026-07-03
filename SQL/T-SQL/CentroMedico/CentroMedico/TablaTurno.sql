IF OBJECT_ID(N'dbo.Turno', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Turno
	(
		IdTurno dbo.idTurno IDENTITY(1,1) NOT NULL,
		FechaTurno DATE NOT NULL,
		IdEstado dbo.idEstado NOT NULL,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Turno
			PRIMARY KEY CLUSTERED (IdTurno)
	);
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD IdTurno dbo.idTurno IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'FechaTurno') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD FechaTurno DATE NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NULL
	AND COL_LENGTH(N'dbo.Turno', N'Estado') IS NOT NULL
BEGIN
	EXEC sys.sp_rename N'dbo.Turno.Estado', N'IdEstado', N'COLUMN';
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD IdEstado dbo.idEstado NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'Estado') IS NOT NULL
	AND COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NOT NULL
BEGIN
	EXEC sys.sp_executesql N'
IF EXISTS (SELECT 1 FROM dbo.Turno WHERE Estado <> IdEstado)
BEGIN
	THROW 51001, ''dbo.Turno has both Estado and IdEstado with different values. Resolve manually before dropping Estado.'', 1;
END;
ELSE
BEGIN
	ALTER TABLE dbo.Turno DROP COLUMN Estado;
END;';
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Turno')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Turno
		ADD CONSTRAINT PK_Turno PRIMARY KEY CLUSTERED (IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.Turno')
		AND name = N'FK_Turno_TurnoEstado'
)
BEGIN
	ALTER TABLE dbo.Turno
		ADD CONSTRAINT FK_Turno_TurnoEstado
		FOREIGN KEY (IdEstado) REFERENCES dbo.TurnoEstado(IdEstado);
END;
GO

SET IDENTITY_INSERT dbo.Turno ON;

MERGE dbo.Turno AS Target
USING (
	SELECT
		IdTurno,
		DATEADD(DAY, IdTurno, CONVERT(DATE, '2026-01-01')) AS FechaTurno,
		CONVERT(SMALLINT, ((IdTurno - 1) % 5) + 1) AS IdEstado,
		CASE IdTurno % 7
			WHEN 0 THEN 'Consulta de seguimiento'
			WHEN 1 THEN 'Consulta general'
			WHEN 2 THEN 'Revision de resultados'
			WHEN 3 THEN 'Control de tratamiento'
			WHEN 4 THEN 'Evaluacion por especialista'
			WHEN 5 THEN 'Chequeo preventivo'
			ELSE 'Paciente solicita reevaluacion'
		END AS Observacion
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
WHEN MATCHED THEN
	UPDATE SET
		FechaTurno = Source.FechaTurno,
		IdEstado = Source.IdEstado,
		Observacion = Source.Observacion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdTurno, FechaTurno, IdEstado, Observacion)
	VALUES (Source.IdTurno, Source.FechaTurno, Source.IdEstado, Source.Observacion);

SET IDENTITY_INSERT dbo.Turno OFF;
GO
