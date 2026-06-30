CREATE TABLE dbo.PagoPaciente 
(
	IdPago INT NOT NULL,
	IdPaciente INT NOT NULL,
	IdTurno INT NOT NULL,

	CONSTRAINT PK_PagoPaciente 
		PRIMARY KEY CLUSTERED (idPago, idPaciente, idTurno),

	CONSTRAINT FK_PagoPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_PagoPaciente_Turno
        FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno),
);