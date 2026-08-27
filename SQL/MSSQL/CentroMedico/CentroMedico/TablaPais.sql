IF OBJECT_ID(N'dbo.Pais', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Pais
	(
		IdPais dbo.idPais NOT NULL,
		Pais VARCHAR(30) NOT NULL,

		CONSTRAINT PK_Pais
			PRIMARY KEY CLUSTERED (IdPais)
	);
END;
GO

IF COL_LENGTH(N'dbo.Pais', N'IdPais') IS NULL
BEGIN
	ALTER TABLE dbo.Pais ADD IdPais dbo.idPais NOT NULL;
END;
GO

IF COL_LENGTH(N'dbo.Pais', N'Pais') IS NULL
BEGIN
	ALTER TABLE dbo.Pais ADD Pais VARCHAR(30) NOT NULL;
END;
GO

IF NOT EXISTS (
	SELECT 1
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID(N'dbo.Pais')
		AND type = N'PK'
)
BEGIN
	ALTER TABLE dbo.Pais
		ADD CONSTRAINT PK_Pais PRIMARY KEY CLUSTERED (IdPais);
END;
GO

MERGE dbo.Pais AS Target
USING (VALUES
	('DOM', 'Republica Dominicana'),
	('USA', 'Estados Unidos'),
	('MEX', 'Mexico'),
	('COL', 'Colombia'),
	('VEN', 'Venezuela'),
	('ESP', 'Espana'),
	('ARG', 'Argentina'),
	('PRI', 'Puerto Rico')
) AS Source (IdPais, Pais)
	ON Target.IdPais = Source.IdPais
WHEN MATCHED THEN
	UPDATE SET Pais = Source.Pais
WHEN NOT MATCHED BY TARGET THEN
	INSERT (IdPais, Pais)
	VALUES (Source.IdPais, Source.Pais);
GO
