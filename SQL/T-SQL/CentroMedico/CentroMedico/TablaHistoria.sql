DROP TABLE IF EXISTS dbo.Historia;

CREATE TABLE dbo.Historia 
(
	IdHistoria dbo.idHistoria IDENTITY(1,1) NOT NULL,
	FechaHistoria DATETIME NOT NULL,
	Observacion dbo.observacion NULL,

	CONSTRAINT PK_Historia
		PRIMARY KEY CLUSTERED (IdHistoria),
);