CREATE TABLE dbo.TurnoEstado
(
	IdEstado SMALLINT NOT NULL,
	Descripcion VARCHAR(50) NULL,

	CONSTRAINT PK_TurnoEstado
		PRIMARY KEY CLUSTERED (IdEstado),
);

