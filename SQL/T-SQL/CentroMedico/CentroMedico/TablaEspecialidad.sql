DROP TABLE IF EXISTS dbo.Especialidad;

CREATE TABLE dbo.Especialidad 
(
	IdEspecialidad dbo.idEspecialidad IDENTITY(1,1) NOT NULL,
	Especialidad VARCHAR(30) NOT NULL,

	CONSTRAINT PK_Especialidad
		PRIMARY KEY CLUSTERED (IdEspecialidad),
);