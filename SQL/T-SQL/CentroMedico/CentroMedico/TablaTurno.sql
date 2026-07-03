IF OBJECT_ID(N'dbo.Turno', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Turno
	(
		IdTurno dbo.idTurno IDENTITY(1,1) NOT NULL,
		FechaTurno DATE NOT NULL,
		IdEstado dbo.idEstado NOT NULL,
		Observacion dbo.observacion NULL,

		CONSTRAINT PK_Turno
			PRIMARY KEY CLUSTERED (IdTurno)
	);
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdTurno') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD IdTurno dbo.idTurno IDENTITY(1,1) NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'FechaTurno') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD FechaTurno DATE NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NULL
	AND COL_LENGTH(N'dbo.Turno', N'Estado') IS NOT NULL
BEGIN
	EXEC sys.sp_rename N'dbo.Turno.Estado', N'IdEstado', N'COLUMN';
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD IdEstado dbo.idEstado NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'Estado') IS NOT NULL
	AND COL_LENGTH(N'dbo.Turno', N'IdEstado') IS NOT NULL
BEGIN
	EXEC sys.sp_executesql N'
IF EXISTS (SELECT 1 FROM dbo.Turno WHERE Estado <> IdEstado)
BEGIN
	THROW 51001, ''dbo.Turno has both Estado and IdEstado with different values. Resolve manually before dropping Estado.'', 1;
END;
ELSE
BEGIN
	ALTER TABLE dbo.Turno DROP COLUMN Estado;
END;';
END;
GO

IF COL_LENGTH(N'dbo.Turno', N'Observacion') IS NULL
BEGIN
	ALTER TABLE dbo.Turno ADD Observacion dbo.observacion NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Turno')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Turno
		ADD CONSTRAINT PK_Turno PRIMARY KEY CLUSTERED (IdTurno);
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.foreign_keys
	WHERE parent_object_id = OBJECT_ID(N'dbo.Turno')
		AND name = N'FK_Turno_TurnoEstado'
)
BEGIN
	ALTER TABLE dbo.Turno
		ADD CONSTRAINT FK_Turno_TurnoEstado
		FOREIGN KEY (IdEstado) REFERENCES dbo.TurnoEstado(IdEstado);
END;
GO
