IF OBJECT_ID(N'dbo.TurnoPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.TurnoPaciente
	(
		IdTurno dbo.idTurno NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdMedico dbo.idMedico NOT NULL,

		CONSTRAINT PK_TurnoPaciente
			PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdTurno dbo.idTurno NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.TurnoPaciente', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.TurnoPaciente ADD IdMedico dbo.idMedico NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT PK_TurnoPaciente PRIMARY KEY CLUSTERED (IdTurno, IdPaciente, IdMedico);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Turno'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Turno
		FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.TurnoPaciente')
		AND name = N'FK_TurnoPaciente_Medico'
)
BEGIN
	ALTER TABLE dbo.TurnoPaciente
		ADD CONSTRAINT FK_TurnoPaciente_Medico
		FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico);
END;
GO
