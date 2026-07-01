DROP TABLE IF EXISTS dbo.HistoriaPaciente;

CREATE TABLE dbo.HistoriaPaciente 
(
	IdHistoria dbo.idHistoria NOT NULL,
	IdPaciente dbo.idPaciente NOT NULL,
	IdMedico dbo.idMedico NOT NULL,

	CONSTRAINT PK_HistoriaPaciente 
		PRIMARY KEY CLUSTERED (idHistoria, idPaciente, idMedico),

	CONSTRAINT FK_HistoriaPaciente_Paciente
        FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente),

    CONSTRAINT FK_HistoriaPaciente_Medico
        FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico),
);