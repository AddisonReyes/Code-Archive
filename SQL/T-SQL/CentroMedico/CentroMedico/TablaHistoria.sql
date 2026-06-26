CREATE TABLE dbo.Historia (
	idHistoria INT PRIMARY KEY IDENTITY(1,1),
	fechaHistoria DATETIME NOT NULL,
	observacion VARCHAR(2000),
	-- idPaciente INT NOT NULL,
	-- idMedico INT NOT NULL,
);