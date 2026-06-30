CREATE TABLE dbo.Especialidad 
(
	IdEspecialidad INT IDENTITY(1,1),
	Especialidad VARCHAR(30) NOT NULL,

	CONSTRAINT PK_Especialidad
		PRIMARY KEY CLUSTERED (IdEspecialidad),
);