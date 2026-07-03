IF OBJECT_ID(N'dbo.Especialidad', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Especialidad
	(
		IdEspecialidad dbo.idEspecialidad IDENTITY(1,1) NOT NULL,
		Especialidad VARCHAR(30) NOT NULL,

		CONSTRAINT PK_Especialidad
			PRIMARY KEY CLUSTERED (IdEspecialidad)
	);
END;
GO

IF COL_LENGTH(N'dbo.Especialidad', N'IdEspecialidad') IS NULL
BEGIN
	ALTER TABLE dbo.Especialidad ADD IdEspecialidad dbo.idEspecialidad IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Especialidad', N'Especialidad') IS NULL
BEGIN
	ALTER TABLE dbo.Especialidad ADD Especialidad VARCHAR(30) NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Especialidad')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Especialidad
		ADD CONSTRAINT PK_Especialidad PRIMARY KEY CLUSTERED (IdEspecialidad);
END;
GO

SET IDENTITY_INSERT dbo.Especialidad ON;

MERGE dbo.Especialidad AS Target
USING (VALUES
	(1, 'Medicina General'),
	(2, 'Cardiologia'),
	(3, 'Pediatria'),
	(4, 'Ginecologia'),
	(5, 'Dermatologia'),
	(6, 'Neurologia'),
	(7, 'Odontologia'),
	(8, 'Ortopedia'),
	(9, 'Oftalmologia'),
	(10, 'Urologia'),
	(11, 'Endocrinologia'),
	(12, 'Psiquiatria')
) AS Source (IdEspecialidad, Especialidad)
	ON Target.IdEspecialidad = Source.IdEspecialidad
WHEN MATCHED THEN
	UPDATE SET Especialidad = Source.Especialidad
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdEspecialidad, Especialidad)
	VALUES (Source.IdEspecialidad, Source.Especialidad);

SET IDENTITY_INSERT dbo.Especialidad OFF;
GO
