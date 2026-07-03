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

MERGE dbo.TurnoEstado AS Target
USING (VALUES
	(1, 'Programado'),
	(2, 'Confirmado'),
	(3, 'Atendido'),
	(4, 'Cancelado'),
	(5, 'No asistio')
) AS Source (IdEstado, Descripcion)
	ON Target.IdEstado = Source.IdEstado
WHEN MATCHED THEN
	UPDATE SET Descripcion = Source.Descripcion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdEstado, Descripcion)
	VALUES (Source.IdEstado, Source.Descripcion);
GO
