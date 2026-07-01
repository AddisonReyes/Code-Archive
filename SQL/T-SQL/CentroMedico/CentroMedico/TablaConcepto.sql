DROP TABLE IF EXISTS dbo.Concepto;

CREATE TABLE dbo.Concepto 
(
	IdConcepto dbo.idConcepto IDENTITY(1,1) NOT NULL,
	Descripcion VARCHAR(100) NOT NULL,

	CONSTRAINT PK_Concepto
		PRIMARY KEY CLUSTERED (IdConcepto),
);