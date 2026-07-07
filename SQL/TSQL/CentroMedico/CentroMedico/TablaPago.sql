IF OBJECT_ID(N'dbo.Pago', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Pago
	(
		IdPago dbo.idPago IDENTITY(1,1) NOT NULL,
		IdConcepto dbo.idConcepto NOT NULL,
		Fecha DATETIME NOT NULL CONSTRAINT DF_Pago_Fecha DEFAULT GETDATE(),
		Monto MONEY NOT NULL CONSTRAINT DF_Pago_Monto DEFAULT 0,
		Estado TINYINT NOT NULL CONSTRAINT DF_Pago_Estado DEFAULT 1,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Pago
			PRIMARY KEY CLUSTERED (IdPago)
	);
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'IdPago') IS NULL
BEGIN
	ALTER TABLE dbo.Pago ADD IdPago dbo.idPago IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'IdConcepto') IS NULL
	AND COL_LENGTH(N'dbo.Pago', N'Concepto') IS NOT NULL
BEGIN
	EXEC sys.sp_rename N'dbo.Pago.Concepto', N'IdConcepto', N'COLUMN';
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'IdConcepto') IS NULL
BEGIN
	ALTER TABLE dbo.Pago ADD IdConcepto dbo.idConcepto NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'Concepto') IS NOT NULL
	AND COL_LENGTH(N'dbo.Pago', N'IdConcepto') IS NOT NULL
BEGIN
	EXEC sys.sp_executesql N'
IF EXISTS (SELECT 1 FROM dbo.Pago WHERE Concepto <> IdConcepto)
BEGIN
	THROW 51002, ''dbo.Pago has both Concepto and IdConcepto with different values. Resolve manually before dropping Concepto.'', 1;
END;
ELSE
BEGIN
	ALTER TABLE dbo.Pago DROP COLUMN Concepto;
END;';
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'Fecha') IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD Fecha DATETIME NOT NULL CONSTRAINT DF_Pago_Fecha DEFAULT GETDATE() WITH VALUES;
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'Monto') IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD Monto MONEY NOT NULL CONSTRAINT DF_Pago_Monto DEFAULT 0 WITH VALUES;
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'Estado') IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD Estado TINYINT NOT NULL CONSTRAINT DF_Pago_Estado DEFAULT 1 WITH VALUES;
END;
GO

IF COL_LENGTH(N'dbo.Pago', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Pago ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Pago')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Pago
		ADD CONSTRAINT PK_Pago PRIMARY KEY CLUSTERED (IdPago);
END;
GO

DECLARE @DefaultName sysname;

SELECT @DefaultName = dc.name
FROM sys.default_constraints AS dc
INNER JOIN sys.columns AS c
	ON c.object_id = dc.parent_object_id
	AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Pago')
	AND c.name = N'Fecha';

IF @DefaultName IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Fecha DEFAULT GETDATE() FOR Fecha;
END
ELSE IF @DefaultName <> N'DF_Pago_Fecha'
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = N'ALTER TABLE dbo.Pago DROP CONSTRAINT ' + QUOTENAME(@DefaultName) + N';';
	EXEC sys.sp_executesql @Sql;

	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Fecha DEFAULT GETDATE() FOR Fecha;
END;
GO

DECLARE @DefaultName sysname;

SELECT @DefaultName = dc.name
FROM sys.default_constraints AS dc
INNER JOIN sys.columns AS c
	ON c.object_id = dc.parent_object_id
	AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Pago')
	AND c.name = N'Monto';

IF @DefaultName IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Monto DEFAULT 0 FOR Monto;
END
ELSE IF @DefaultName <> N'DF_Pago_Monto'
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = N'ALTER TABLE dbo.Pago DROP CONSTRAINT ' + QUOTENAME(@DefaultName) + N';';
	EXEC sys.sp_executesql @Sql;

	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Monto DEFAULT 0 FOR Monto;
END;
GO

DECLARE @DefaultName sysname;

SELECT @DefaultName = dc.name
FROM sys.default_constraints AS dc
INNER JOIN sys.columns AS c
	ON c.object_id = dc.parent_object_id
	AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Pago')
	AND c.name = N'Estado';

IF @DefaultName IS NULL
BEGIN
	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Estado DEFAULT 1 FOR Estado;
END
ELSE IF @DefaultName <> N'DF_Pago_Estado'
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = N'ALTER TABLE dbo.Pago DROP CONSTRAINT ' + QUOTENAME(@DefaultName) + N';';
	EXEC sys.sp_executesql @Sql;

	ALTER TABLE dbo.Pago
		ADD CONSTRAINT DF_Pago_Estado DEFAULT 1 FOR Estado;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.Pago')
		AND name = N'FK_Pago_Concepto'
)
BEGIN
	ALTER TABLE dbo.Pago
		ADD CONSTRAINT FK_Pago_Concepto
		FOREIGN KEY (IdConcepto) REFERENCES dbo.Concepto(IdConcepto);
END;
GO

SET IDENTITY_INSERT dbo.Pago ON;

MERGE dbo.Pago AS Target
USING (
	SELECT
		IdPago,
		CONVERT(TINYINT, ((IdPago - 1) % 8) + 1) AS IdConcepto,
		DATEADD(HOUR, IdPago % 10, DATEADD(DAY, IdPago, CONVERT(DATETIME, '2026-01-01'))) AS Fecha,
		CONVERT(MONEY, 750 + (((IdPago - 1) % 8) * 425)) AS Monto,
		CONVERT(TINYINT, CASE WHEN IdPago % 9 = 0 THEN 0 ELSE 1 END) AS Estado,
		CASE IdPago % 6
			WHEN 0 THEN 'Pago recibido en caja'
			WHEN 1 THEN 'Copago registrado'
			WHEN 2 THEN 'Cubierto parcialmente por seguro'
			WHEN 3 THEN 'Pendiente de autorizacion'
			WHEN 4 THEN 'Pago aplicado a consulta'
			ELSE 'Factura entregada al paciente'
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
	) AS Datos (IdPago)
) AS Source
	ON Target.IdPago = Source.IdPago
WHEN MATCHED THEN
	UPDATE SET
		IdConcepto = Source.IdConcepto,
		Fecha = Source.Fecha,
		Monto = Source.Monto,
		Estado = Source.Estado,
		Observacion = Source.Observacion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdPago, IdConcepto, Fecha, Monto, Estado, Observacion)
	VALUES (Source.IdPago, Source.IdConcepto, Source.Fecha, Source.Monto, Source.Estado, Source.Observacion);

SET IDENTITY_INSERT dbo.Pago OFF;
GO
