DROP TABLE IF EXISTS dbo.TurnoEstado;

CREATE TABLE dbo.TurnoEstado
(
	IdEstado dbo.idEstado NOT NULL,
	Descripcion VARCHAR(50) NULL,

	CONSTRAINT PK_TurnoEstado
		PRIMARY KEY CLUSTERED (IdEstado),
);

