DROP TABLE IF EXISTS dbo.PagoPaciente;

CREATE TABLE dbo.PagoPaciente 
(
	IdPago dbo.idPago NOT NULL,
	IdPaciente dbo.idPaciente NOT NULL,
	IdTurno dbo.idTurno NOT NULL,

	CONSTRAINT PK_PagoPaciente 
		PRIMARY KEY CLUSTERED (idPago, idPaciente, idTurno),

	CONSTRAINT FK_PagoPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_PagoPaciente_Turno
        FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno),
);