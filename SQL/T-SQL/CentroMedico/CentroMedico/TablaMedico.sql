IF OBJECT_ID(N'dbo.Medico', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Medico
	(
		IdMedico dbo.idMedico IDENTITY(1,1) NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Apellido VARCHAR(50) NOT NULL,

		CONSTRAINT PK_Medico
			PRIMARY KEY CLUSTERED (IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD IdMedico dbo.idMedico IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'Nombre') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD Nombre VARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Medico', N'Apellido') IS NULL
BEGIN
	ALTER TABLE dbo.Medico ADD Apellido VARCHAR(50) NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Medico')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Medico
		ADD CONSTRAINT PK_Medico PRIMARY KEY CLUSTERED (IdMedico);
END;
GO

SET IDENTITY_INSERT dbo.Medico ON;

MERGE dbo.Medico AS Target
USING (VALUES
	(1, 'Alfredo', 'Molina'),
	(2, 'Beatriz', 'Santos'),
	(3, 'Carlos', 'Herrera'),
	(4, 'Diana', 'Lorenzo'),
	(5, 'Esteban', 'Rivas'),
	(6, 'Fiordaliza', 'Mejia'),
	(7, 'German', 'Suarez'),
	(8, 'Helena', 'Paredes'),
	(9, 'Ignacio', 'Cruz'),
	(10, 'Julissa', 'Valdez'),
	(11, 'Kevin', 'Rosario'),
	(12, 'Lorena', 'Figueroa'),
	(13, 'Mariano', 'Arias'),
	(14, 'Nadia', 'Tejada'),
	(15, 'Omar', 'Polanco'),
	(16, 'Paola', 'Brito'),
	(17, 'Ruben', 'Cabrera'),
	(18, 'Silvia', 'Guzman')
) AS Source (IdMedico, Nombre, Apellido)
	ON Target.IdMedico = Source.IdMedico
WHEN MATCHED THEN
	UPDATE SET
		Nombre = Source.Nombre,
		Apellido = Source.Apellido
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdMedico, Nombre, Apellido)
	VALUES (Source.IdMedico, Source.Nombre, Source.Apellido);

SET IDENTITY_INSERT dbo.Medico OFF;
GO
