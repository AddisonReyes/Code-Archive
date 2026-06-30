CREATE TABLE dbo.MedicoEspecialidad 
(
	IdMedico INT NOT NULL,
	IdEspecialidad INT NOT NULL,
	Descripcion VARCHAR(50) NULL,

	CONSTRAINT PK_MedicoEspecialidad 
		PRIMARY KEY CLUSTERED (idMedico, idEspecialidad)
);