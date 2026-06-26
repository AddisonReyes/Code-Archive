CREATE TABLE dbo.TurnoPaciente (
	idTurno INT NOT NULL,
	idPaciente INT NOT NULL,
	idMedico INT NOT NULL,

	CONSTRAINT PK_TurnoPaciente PRIMARY KEY (idTurno, idPaciente, idMedico)
);