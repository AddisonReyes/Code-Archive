IF OBJECT_ID(N'dbo.HistoriaPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.HistoriaPaciente
	(
		IdHistoria dbo.idHistoria NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdMedico dbo.idMedico NOT NULL,

		CONSTRAINT PK_HistoriaPaciente
			PRIMARY KEY CLUSTERED (IdHistoria, IdPaciente, IdMedico)
	);
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdHistoria') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdHistoria dbo.idHistoria NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.HistoriaPaciente', N'IdMedico') IS NULL
BEGIN
	ALTER TABLE dbo.HistoriaPaciente ADD IdMedico dbo.idMedico NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT PK_HistoriaPaciente PRIMARY KEY CLUSTERED (IdHistoria, IdPaciente, IdMedico);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Historia'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Historia
		FOREIGN KEY (IdHistoria) REFERENCES dbo.Historia(IdHistoria);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.HistoriaPaciente')
		AND name = N'FK_HistoriaPaciente_Medico'
)
BEGIN
	ALTER TABLE dbo.HistoriaPaciente
		ADD CONSTRAINT FK_HistoriaPaciente_Medico
		FOREIGN KEY (IdMedico) REFERENCES dbo.Medico(IdMedico);
END;
GO
