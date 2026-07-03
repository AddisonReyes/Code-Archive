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
