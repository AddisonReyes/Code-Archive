CREATE TABLE dbo.HistoriaPaciente 
(
	IdHistoria INT NOT NULL,
	IdPaciente INT NOT NULL,
	IdMedico INT NOT NULL,

	CONSTRAINT PK_HistoriaPaciente 
		PRIMARY KEY CLUSTERED (idHistoria, idPaciente, idMedico),

	CONSTRAINT FK_HistoriaPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_HistoriaPaciente_Medico
        FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico),
);