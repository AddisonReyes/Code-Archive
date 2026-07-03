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
