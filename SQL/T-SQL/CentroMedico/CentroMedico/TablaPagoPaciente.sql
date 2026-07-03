IF OBJECT_ID(N'dbo.PagoPaciente', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.PagoPaciente
	(
		IdPago dbo.idPago NOT NULL,
		IdPaciente dbo.idPaciente NOT NULL,
		IdTurno dbo.idTurno NOT NULL,

		CONSTRAINT PK_PagoPaciente
			PRIMARY KEY CLUSTERED (IdPago, IdPaciente, IdTurno)
	);
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdPago') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdPago dbo.idPago NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdPaciente') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdPaciente dbo.idPaciente NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.PagoPaciente', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.PagoPaciente ADD IdTurno dbo.idTurno NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT PK_PagoPaciente PRIMARY KEY CLUSTERED (IdPago, IdPaciente, IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Pago'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Pago
		FOREIGN KEY (IdPago) REFERENCES dbo.Pago(IdPago);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Paciente'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Paciente
		FOREIGN KEY (IdPaciente) REFERENCES dbo.Paciente(IdPaciente);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.PagoPaciente')
		AND name = N'FK_PagoPaciente_Turno'
)
BEGIN
	ALTER TABLE dbo.PagoPaciente
		ADD CONSTRAINT FK_PagoPaciente_Turno
		FOREIGN KEY (IdTurno) REFERENCES dbo.Turno(IdTurno);
END;
GO
