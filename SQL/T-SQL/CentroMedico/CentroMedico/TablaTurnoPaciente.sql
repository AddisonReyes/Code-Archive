DROP TABLE IF EXISTS dbo.TurnoPaciente;

CREATE TABLE dbo.TurnoPaciente 
(
	IdTurno dbo.idTurno NOT NULL,
	IdPaciente dbo.idPaciente NOT NULL,
	IdMedico dbo.idMedico NOT NULL,

	CONSTRAINT PK_TurnoPaciente 
		PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico),

	CONSTRAINT FK_TurnoPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_TurnoPaciente_Medico
        FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico),
);