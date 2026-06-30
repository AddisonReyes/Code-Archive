CREATE TABLE dbo.TurnoPaciente 
(
	IdTurno INT NOT NULL,
	IdPaciente INT NOT NULL,
	IdMedico INT NOT NULL,

	CONSTRAINT PK_TurnoPaciente 
		PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico),

	CONSTRAINT FK_TurnoPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_TurnoPaciente_Medico
        FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico),
);