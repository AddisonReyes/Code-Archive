IF OBJECT_ID(N'dbo.MedicoEspecialidad', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.MedicoEspecialidad
	(
		IdMedico dbo.idMedico NOT NULL,
		IdEspecialidad dbo.idEspecialidad NOT NULL,
		Descripcion VARCHAR(50) NULL,

		CONSTRAINT PK_MedicoEspecialidad
			PRIMARY KEY CLUSTERED (IdMedico, IdEspecialidad)
	);
END;
GO

IF COL_LENGTH(N'dbo.MedicoEspecialidad', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad ADD IdMedico dbo.idMedico NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.MedicoEspecialidad', N'IdEspecialidad') IS NULL
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad ADD IdEspecialidad dbo.idEspecialidad NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.MedicoEspecialidad', N'Descripcion') IS NULL
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad ADD Descripcion VARCHAR(50) NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.MedicoEspecialidad')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad
		ADD CONSTRAINT PK_MedicoEspecialidad PRIMARY KEY CLUSTERED (IdMedico, IdEspecialidad);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.MedicoEspecialidad')
		AND name = N'FK_MedicoEspecialidad_Especialidad'
)
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad
		ADD CONSTRAINT FK_MedicoEspecialidad_Especialidad
		FOREIGN KEY (IdEspecialidad) REFERENCES dbo.Especialidad(IdEspecialidad);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.MedicoEspecialidad')
		AND name = N'FK_MedicoEspecialidad_Medico'
)
BEGIN
	ALTER TABLE dbo.MedicoEspecialidad
		ADD CONSTRAINT FK_MedicoEspecialidad_Medico
		FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico);
END;
GO
