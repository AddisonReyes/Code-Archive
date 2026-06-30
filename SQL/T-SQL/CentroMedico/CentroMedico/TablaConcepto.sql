CREATE TABLE dbo.Concepto 
(
	IdConcepto TINYINT IDENTITY(1,1),
	Descripcion VARCHAR(100),

	CONSTRAINT PK_Concepto
		PRIMARY KEY CLUSTERED (IdConcepto),
);