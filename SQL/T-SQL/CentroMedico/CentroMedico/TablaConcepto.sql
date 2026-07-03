IF OBJECT_ID(N'dbo.Concepto', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Concepto
	(
		IdConcepto dbo.idConcepto IDENTITY(1,1) NOT NULL,
		Descripcion VARCHAR(100) NOT NULL,

		CONSTRAINT PK_Concepto
			PRIMARY KEY CLUSTERED (IdConcepto)
	);
END;
GO

IF COL_LENGTH(N'dbo.Concepto', N'IdConcepto') IS NULL
BEGIN
	ALTER TABLE dbo.Concepto ADD IdConcepto dbo.idConcepto IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Concepto', N'Descripcion') IS NULL
BEGIN
	ALTER TABLE dbo.Concepto ADD Descripcion VARCHAR(100) NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Concepto')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Concepto
		ADD CONSTRAINT PK_Concepto PRIMARY KEY CLUSTERED (IdConcepto);
END;
GO

SET IDENTITY_INSERT dbo.Concepto ON;

MERGE dbo.Concepto AS Target
USING (VALUES
	(1, 'Consulta general'),
	(2, 'Consulta especializada'),
	(3, 'Analitica de laboratorio'),
	(4, 'Estudio de imagen'),
	(5, 'Procedimiento ambulatorio'),
	(6, 'Emergencia'),
	(7, 'Terapia fisica'),
	(8, 'Vacunacion')
) AS Source (IdConcepto, Descripcion)
	ON Target.IdConcepto = Source.IdConcepto
WHEN MATCHED THEN
	UPDATE SET Descripcion = Source.Descripcion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdConcepto, Descripcion)
	VALUES (Source.IdConcepto, Source.Descripcion);

SET IDENTITY_INSERT dbo.Concepto OFF;
GO
