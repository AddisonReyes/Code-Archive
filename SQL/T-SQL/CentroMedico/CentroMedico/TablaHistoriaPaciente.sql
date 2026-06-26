CREATE TABLE dbo.HistoriaPaciente (
	idHistoria INT NOT NULL,
	idPaciente INT NOT NULL,
	idMedico INT NOT NULL,

	CONSTRAINT PK_HistoriaPaciente PRIMARY KEY (idHistoria, idPaciente, idMedico)
);