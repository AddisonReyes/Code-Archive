CREATE TABLE dbo.Paciente (
	idPaciente INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	fechaNacimiento DATE NOT NULL,
	domicilio VARCHAR(50) NOT NULL,
	telefono VARCHAR(20),
	email VARCHAR(30) NOT NULL,
	observacion VARCHAR(1000)
);

DROP TABLE IF EXISTS dbo.Paciente;