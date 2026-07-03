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

SET IDENTITY_INSERT dbo.Historia ON;

MERGE dbo.Historia AS Target
USING (
	SELECT
		IdHistoria,
		DATEADD(HOUR, IdHistoria % 8, DATEADD(DAY, IdHistoria * 3, CONVERT(DATETIME, '2025-01-01'))) AS FechaHistoria,
		CASE IdHistoria % 6
			WHEN 0 THEN 'Evaluacion inicial sin hallazgos de alarma'
			WHEN 1 THEN 'Seguimiento clinico con evolucion favorable'
			WHEN 2 THEN 'Se indican laboratorios de control'
			WHEN 3 THEN 'Paciente orientado y hemodinamicamente estable'
			WHEN 4 THEN 'Se refuerzan medidas de prevencion y dieta'
			ELSE 'Resultados revisados en consulta'
		END AS Observacion
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
WHEN MATCHED THEN
	UPDATE SET
		FechaHistoria = Source.FechaHistoria,
		Observacion = Source.Observacion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdHistoria, FechaHistoria, Observacion)
	VALUES (Source.IdHistoria, Source.FechaHistoria, Source.Observacion);

SET IDENTITY_INSERT dbo.Historia OFF;
GO
