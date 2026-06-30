CREATE TABLE PagoPaciente (
	idPago INT NOT NULL,
	idPaciente INT NOT NULL,
	idTurno INT NOT NULL,

	CONSTRAINT PK_PagoPaciente PRIMARY KEY (idPago, idPaciente, idTurno)
);