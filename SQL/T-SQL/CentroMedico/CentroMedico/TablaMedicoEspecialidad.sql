CREATE TABLE MedicoEspecialidad (
	idMedico INT NOT NULL,
	idEspecialidad INT NOT NULL,
	descripcion VARCHAR(50) NULL,

	CONSTRAINT PK_MedicoEspecialidad PRIMARY KEY (idMedico, idEspecialidad)
);