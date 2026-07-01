DROP TABLE IF EXISTS dbo.MedicoEspecialidad;

CREATE TABLE dbo.MedicoEspecialidad 
(
	IdMedico dbo.idMedico NOT NULL,
	IdEspecialidad dbo.idEspecialidad NOT NULL,
	Descripcion VARCHAR(50) NULL,

	CONSTRAINT PK_MedicoEspecialidad 
		PRIMARY KEY CLUSTERED (idMedico, idEspecialidad)
);