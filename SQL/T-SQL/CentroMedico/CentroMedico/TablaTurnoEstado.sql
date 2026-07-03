IF OBJECT_ID(N'dbo.TurnoEstado', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.TurnoEstado
	(
		IdEstado dbo.idEstado NOT NULL,
		Descripcion VARCHAR(50) NULL,

		CONSTRAINT PK_TurnoEstado
			PRIMARY KEY CLUSTERED (IdEstado)
	);
END;
GO

IF COL_LENGTH(N'dbo.TurnoEstado', N'IdEstado') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoEstado ADD IdEstado dbo.idEstado NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.TurnoEstado', N'Descripcion') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoEstado ADD Descripcion VARCHAR(50) NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoEstado')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.TurnoEstado
		ADD CONSTRAINT PK_TurnoEstado PRIMARY KEY CLUSTERED (IdEstado);
END;
GO
