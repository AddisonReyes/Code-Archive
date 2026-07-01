DROP TABLE IF EXISTS dbo.Turno;

CREATE TABLE dbo.Turno 
(
	IdTurno dbo.idTurno IDENTITY(1,1) NOT NULL,
	FechaTurno DATE NOT NULL,
	Estado SMALLINT NOT NULL,
	Observacion dbo.observacion NULL,

	CONSTRAINT PK_Turno
		PRIMARY KEY CLUSTERED (IdTurno),
);