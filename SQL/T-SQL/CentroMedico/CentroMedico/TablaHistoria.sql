CREATE TABLE dbo.Historia 
(
	IdHistoria INT IDENTITY(1,1),
	FechaHistoria DATETIME NOT NULL,
	Observacion VARCHAR(2000),

	CONSTRAINT PK_Historia
		PRIMARY KEY CLUSTERED (IdHistoria),
);