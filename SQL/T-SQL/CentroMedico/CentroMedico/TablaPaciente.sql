IF OBJECT_ID(N'dbo.Paciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Paciente
	(
		IdPaciente dbo.idPaciente IDENTITY(1,1) NOT NULL,
		Cedula NVARCHAR(20) NOT NULL,
		Nombre NVARCHAR(50) NOT NULL,
		Apellido NVARCHAR(50) NOT NULL,
		FechaNacimiento DATE NOT NULL,
		Domicilio NVARCHAR(50) NOT NULL,
		IdPais dbo.idPais NOT NULL,
		Telefono NVARCHAR(20) NULL,
		Email NVARCHAR(255) NOT NULL,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Paciente
			PRIMARY KEY CLUSTERED (IdPaciente)
	);
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD IdPaciente dbo.idPaciente IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Cedula') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Cedula NVARCHAR(20) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Nombre') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Nombre NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Apellido') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Apellido NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'FechaNacimiento') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD FechaNacimiento DATE NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Domicilio') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Domicilio NVARCHAR(50) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'IdPais') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD IdPais dbo.idPais NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Telefono') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Telefono NVARCHAR(20) NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Email') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Email NVARCHAR(255) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Paciente', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Paciente ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Paciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Paciente
		ADD CONSTRAINT PK_Paciente PRIMARY KEY CLUSTERED (IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.Paciente')
		AND name = N'FK_Paciente_Pais'
)
BEGIN
	ALTER TABLE dbo.Paciente
		ADD CONSTRAINT FK_Paciente_Pais
		FOREIGN KEY (IdPais) REFERENCES dbo.Pais(IdPais);
END;
GO

SET IDENTITY_INSERT dbo.Paciente ON;

MERGE dbo.Paciente AS Target
USING (
	SELECT
		Datos.IdPaciente,
		CONCAT('001-', RIGHT(CONCAT('0000000', 1000000 + Datos.IdPaciente), 7), '-', RIGHT(CONCAT('000', Datos.IdPaciente), 3)) AS Cedula,
		Datos.Nombre,
		Datos.Apellido,
		DATEADD(DAY, Datos.IdPaciente * 97, CONVERT(DATE, '1965-01-01')) AS FechaNacimiento,
		CONCAT('Calle Salud ', Datos.IdPaciente, ', Ensanche Medico') AS Domicilio,
		Datos.IdPais,
		CONCAT('809-555-', RIGHT(CONCAT('0000', Datos.IdPaciente), 4)) AS Telefono,
		LOWER(CONCAT(Datos.Nombre, '.', Datos.Apellido, Datos.IdPaciente, '@centromedico.local')) AS Email,
		CASE Datos.IdPaciente % 8
			WHEN 0 THEN 'Refiere alergia a penicilina'
			WHEN 1 THEN 'Control anual recomendado'
			WHEN 2 THEN 'Antecedente familiar de hipertension'
			WHEN 3 THEN 'Seguimiento por dolor lumbar ocasional'
			WHEN 4 THEN 'Paciente con actividad fisica regular'
			WHEN 5 THEN 'Requiere control de glucosa'
			WHEN 6 THEN 'Sin observaciones relevantes'
			ELSE NULL
		END AS Observacion
	FROM (VALUES
		(1, 'Ana', 'Perez', 'DOM'),
		(2, 'Luis', 'Garcia', 'DOM'),
		(3, 'Maria', 'Rodriguez', 'DOM'),
		(4, 'Carlos', 'Martinez', 'DOM'),
		(5, 'Laura', 'Sanchez', 'DOM'),
		(6, 'Jose', 'Ramirez', 'DOM'),
		(7, 'Carmen', 'Gomez', 'DOM'),
		(8, 'Miguel', 'Diaz', 'DOM'),
		(9, 'Patricia', 'Fernandez', 'DOM'),
		(10, 'Rafael', 'Torres', 'DOM'),
		(11, 'Sofia', 'Reyes', 'DOM'),
		(12, 'Daniel', 'Morales', 'DOM'),
		(13, 'Elena', 'Castillo', 'DOM'),
		(14, 'Jorge', 'Vargas', 'DOM'),
		(15, 'Lucia', 'Mendez', 'DOM'),
		(16, 'Pedro', 'Ortiz', 'DOM'),
		(17, 'Gabriela', 'Nunez', 'DOM'),
		(18, 'Fernando', 'Herrera', 'DOM'),
		(19, 'Valeria', 'Cruz', 'DOM'),
		(20, 'Roberto', 'Jimenez', 'DOM'),
		(21, 'Paola', 'Alvarez', 'USA'),
		(22, 'Andres', 'Suarez', 'USA'),
		(23, 'Natalia', 'Rojas', 'MEX'),
		(24, 'Hector', 'Medina', 'MEX'),
		(25, 'Adriana', 'Silva', 'COL'),
		(26, 'Emilio', 'Pena', 'COL'),
		(27, 'Isabel', 'Flores', 'VEN'),
		(28, 'Victor', 'Acosta', 'VEN'),
		(29, 'Camila', 'Guerrero', 'ESP'),
		(30, 'Oscar', 'Navarro', 'ESP'),
		(31, 'Diana', 'Molina', 'ARG'),
		(32, 'Alberto', 'Campos', 'ARG'),
		(33, 'Marta', 'Santos', 'PRI'),
		(34, 'Ricardo', 'Cabrera', 'PRI'),
		(35, 'Julia', 'Pena', 'DOM'),
		(36, 'Manuel', 'Bautista', 'DOM'),
		(37, 'Rosa', 'Rosario', 'DOM'),
		(38, 'Eduardo', 'Matos', 'DOM'),
		(39, 'Monica', 'Luna', 'DOM'),
		(40, 'Samuel', 'Arias', 'DOM'),
		(41, 'Beatriz', 'Leon', 'DOM'),
		(42, 'Francisco', 'Gil', 'DOM'),
		(43, 'Claudia', 'Vega', 'DOM'),
		(44, 'Ramona', 'Mejia', 'DOM'),
		(45, 'Enrique', 'Cordero', 'DOM'),
		(46, 'Carolina', 'Mora', 'DOM'),
		(47, 'Pablo', 'Lorenzo', 'DOM'),
		(48, 'Alicia', 'Paredes', 'DOM'),
		(49, 'Gustavo', 'Soto', 'DOM'),
		(50, 'Veronica', 'Rivas', 'DOM'),
		(51, 'Marcos', 'Cespedes', 'USA'),
		(52, 'Iris', 'Valdez', 'MEX'),
		(53, 'Felix', 'Brito', 'COL'),
		(54, 'Sandra', 'Peralta', 'VEN'),
		(55, 'Nelson', 'Franco', 'ESP'),
		(56, 'Teresa', 'Duran', 'ARG'),
		(57, 'Cristian', 'Soler', 'PRI'),
		(58, 'Yolanda', 'Espinal', 'DOM'),
		(59, 'Raul', 'Polanco', 'DOM'),
		(60, 'Lidia', 'Marte', 'DOM'),
		(61, 'Ivan', 'Liriano', 'DOM'),
		(62, 'Noelia', 'Figueroa', 'DOM'),
		(63, 'Arturo', 'Ramos', 'DOM'),
		(64, 'Milagros', 'Tejada', 'DOM'),
		(65, 'Benjamin', 'Santana', 'DOM'),
		(66, 'Esther', 'Contreras', 'DOM'),
		(67, 'Tomas', 'Delgado', 'DOM')
	) AS Datos (IdPaciente, Nombre, Apellido, IdPais)
) AS Source
	ON Target.IdPaciente = Source.IdPaciente
WHEN MATCHED THEN
	UPDATE SET
		Cedula = Source.Cedula,
		Nombre = Source.Nombre,
		Apellido = Source.Apellido,
		FechaNacimiento = Source.FechaNacimiento,
		Domicilio = Source.Domicilio,
		IdPais = Source.IdPais,
		Telefono = Source.Telefono,
		Email = Source.Email,
		Observacion = Source.Observacion
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdPaciente, Cedula, Nombre, Apellido, FechaNacimiento, Domicilio, IdPais, Telefono, Email, Observacion)
	VALUES (Source.IdPaciente, Source.Cedula, Source.Nombre, Source.Apellido, Source.FechaNacimiento, Source.Domicilio, Source.IdPais, Source.Telefono, Source.Email, Source.Observacion);

SET IDENTITY_INSERT dbo.Paciente OFF;
GO
