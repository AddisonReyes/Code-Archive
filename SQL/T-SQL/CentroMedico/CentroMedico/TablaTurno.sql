CREATE TABLE dbo.Turno (
	idTurno INT PRIMARY KEY IDENTITY(1,1),
	fechaTurno DATE NOT NULL,
	estado SMALLINT NOT NULL,
	observacion VARCHAR(300)
);