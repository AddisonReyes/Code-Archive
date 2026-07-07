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

MERGE dbo.MedicoEspecialidad AS Target
USING (VALUES
	(1, 1, 'Consulta primaria'),
	(2, 2, 'Cardiologia adultos'),
	(3, 3, 'Pediatria general'),
	(4, 4, 'Salud femenina'),
	(5, 5, 'Dermatologia clinica'),
	(6, 6, 'Neurologia general'),
	(7, 7, 'Odontologia preventiva'),
	(8, 8, 'Ortopedia y trauma'),
	(9, 9, 'Oftalmologia general'),
	(10, 10, 'Urologia adultos'),
	(11, 11, 'Diabetes y metabolismo'),
	(12, 12, 'Salud mental'),
	(13, 1, 'Medicina familiar'),
	(14, 2, 'Riesgo cardiovascular'),
	(15, 3, 'Pediatria preventiva'),
	(16, 4, 'Control prenatal'),
	(17, 5, 'Procedimientos menores'),
	(18, 6, 'Cefaleas y mareos'),
	(1, 8, 'Evaluacion musculoesqueletica'),
	(2, 11, 'Hipertension metabolica'),
	(3, 8, 'Ortopedia infantil'),
	(4, 11, 'Endocrinologia femenina'),
	(5, 7, 'Cirugia oral menor'),
	(6, 12, 'Neuropsiquiatria')
) AS Source (IdMedico, IdEspecialidad, Descripcion)
	ON Target.IdMedico = Source.IdMedico
	AND Target.IdEspecialidad = Source.IdEspecialidad
WHEN MATCHED THEN
	UPDATE SET Descripcion = Source.Descripcion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdMedico, IdEspecialidad, Descripcion)
	VALUES (Source.IdMedico, Source.IdEspecialidad, Source.Descripcion);
GO
