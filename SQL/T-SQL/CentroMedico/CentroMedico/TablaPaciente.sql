DROP TABLE IF EXISTS dbo.Paciente;

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
		PRIMARY KEY CLUSTERED (IdPaciente),
	
	CONSTRAINT FK_Paciente_Pais 
		FOREIGN KEY (IdPais) REFERENCES dbo.Pais(IdPais),
);