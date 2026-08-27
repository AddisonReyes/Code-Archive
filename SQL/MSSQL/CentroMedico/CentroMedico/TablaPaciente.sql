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

WITH Numeros AS
(
	SELECT TOP (6000)
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS IdPaciente
	FROM sys.all_objects AS A
	CROSS JOIN sys.all_objects AS B
),
Nombres AS
(
	SELECT *
	FROM (VALUES
		(1, 'Ana'), (2, 'Luis'), (3, 'Maria'), (4, 'Carlos'), (5, 'Laura'),
		(6, 'Jose'), (7, 'Carmen'), (8, 'Miguel'), (9, 'Patricia'), (10, 'Rafael'),
		(11, 'Sofia'), (12, 'Daniel'), (13, 'Elena'), (14, 'Jorge'), (15, 'Lucia'),
		(16, 'Pedro'), (17, 'Gabriela'), (18, 'Fernando'), (19, 'Valeria'), (20, 'Roberto'),
		(21, 'Paola'), (22, 'Andres'), (23, 'Natalia'), (24, 'Hector'), (25, 'Adriana'),
		(26, 'Emilio'), (27, 'Isabel'), (28, 'Victor'), (29, 'Camila'), (30, 'Oscar'),
		(31, 'Diana'), (32, 'Alberto'), (33, 'Marta'), (34, 'Ricardo'), (35, 'Julia'),
		(36, 'Manuel'), (37, 'Rosa'), (38, 'Eduardo'), (39, 'Monica'), (40, 'Samuel')
	) AS Lista (IdNombre, Nombre)
),
Apellidos AS
(
	SELECT *
	FROM (VALUES
		(1, 'Perez'), (2, 'Garcia'), (3, 'Rodriguez'), (4, 'Martinez'), (5, 'Sanchez'),
		(6, 'Ramirez'), (7, 'Gomez'), (8, 'Diaz'), (9, 'Fernandez'), (10, 'Torres'),
		(11, 'Reyes'), (12, 'Morales'), (13, 'Castillo'), (14, 'Vargas'), (15, 'Mendez'),
		(16, 'Ortiz'), (17, 'Nunez'), (18, 'Herrera'), (19, 'Cruz'), (20, 'Jimenez'),
		(21, 'Alvarez'), (22, 'Suarez'), (23, 'Rojas'), (24, 'Medina'), (25, 'Silva'),
		(26, 'Pena'), (27, 'Flores'), (28, 'Acosta'), (29, 'Guerrero'), (30, 'Navarro'),
		(31, 'Molina'), (32, 'Campos'), (33, 'Santos'), (34, 'Cabrera'), (35, 'Bautista'),
		(36, 'Rosario'), (37, 'Matos'), (38, 'Luna'), (39, 'Arias'), (40, 'Leon')
	) AS Lista (IdApellido, Apellido)
),
Paises AS
(
	SELECT *
	FROM (VALUES
		(1, 'DOM'), (2, 'DOM'), (3, 'DOM'), (4, 'DOM'),
		(5, 'USA'), (6, 'MEX'), (7, 'COL'), (8, 'VEN'),
		(9, 'ESP'), (10, 'ARG'), (11, 'PRI')
	) AS Lista (IdPaisOrden, IdPais)
),
PacientesBase AS
(
	SELECT *
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
),
Datos AS
(
	SELECT
		Numeros.IdPaciente,
		ISNULL(PacientesBase.Nombre, Nombres.Nombre) AS Nombre,
		ISNULL(PacientesBase.Apellido, Apellidos.Apellido) AS Apellido,
		ISNULL(PacientesBase.IdPais, Paises.IdPais) AS IdPais
	FROM Numeros
	LEFT JOIN PacientesBase
		ON PacientesBase.IdPaciente = Numeros.IdPaciente
	LEFT JOIN Nombres
		ON Nombres.IdNombre = ((Numeros.IdPaciente - 1) % 40) + 1
	LEFT JOIN Apellidos
		ON Apellidos.IdApellido = (((Numeros.IdPaciente - 1) / 40) % 40) + 1
	LEFT JOIN Paises
		ON Paises.IdPaisOrden = ((Numeros.IdPaciente - 1) % 11) + 1
),
Source AS
(
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
	FROM Datos
)
MERGE dbo.Paciente AS Target
USING Source
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
