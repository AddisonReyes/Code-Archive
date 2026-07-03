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
