CREATE TABLE Paciente (
	idPaciente INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	fechaNacimiento DATE NOT NULL,
	domicilio VARCHAR(50),
	telefono VARCHAR(20),
	email VARCHAR(30),
	observacion VARCHAR(1000)
);