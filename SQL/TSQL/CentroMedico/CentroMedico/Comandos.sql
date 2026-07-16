SELECT 'Hola mundo';

-- SELECT
SELECT * FROM paciente;
SELECT TOP 1 * FROM paciente ORDER BY FechaNacimiento ASC;
SELECT TOP 20 * FROM paciente WHERE Apellido = 'Perez';
SELECT * FROM paciente WHERE Nombre = 'Daniel' AND Apellido = 'Morales';
SELECT DISTINCT * FROM paciente;

SELECT Apellido, MAX(IdPaciente) FROM paciente GROUP BY Apellido;
SELECT COUNT(IdPaciente), Apellido FROM paciente GROUP BY Apellido;

SELECT * FROM paciente WHERE Apellido = 'Perez'
	AND ( Nombre = 'Roberto' OR IdPaciente = 7 OR IdPais = 'PER' )
	AND IdPaciente NOT IN (1, 2, 3);

SELECT * FROM turno WHERE IdEstado IN (1, 2, 3);

SELECT * FROM turno WHERE FechaTurno BETWEEN '2026-01-01' AND '2026-01-06';
SELECT * FROM turno WHERE IdEstado BETWEEN 3 AND 7

SELECT * FROM paciente WHERE Apellido NOT IN ('Perez', 'Ramirez', 'Gonzalez');
SELECT * FROM paciente WHERE Nombre NOT LIKE '%ober%';

SELECT * FROM pais;

-- ALTER
SELECT TOP 10 * FROM Paciente;
ALTER TABLE Paciente ADD estado SMALLINT;
ALTER TABLE Paciente ALTER COLUMN estado BIT;
ALTER TABLE Paciente DROP COLUMN estado;

ALTER TABLE Paciente ADD FOREIGN KEY (IdPais) REFERENCES Pais(IdPais);
ALTER TABLE HistoriaPaciente ADD FOREIGN KEY (IdPaciente) REFERENCES Paciente(IdPaciente);

-- CREATE
CREATE FUNCTION nombrefun(@var INT) RETURNS INT
AS BEGIN
	SET @var = @var * 6
	RETURN @var
END

SELECT dbo.nombrefun(67);

-- DROP & TRUNCATE
CREATE TABLE test (
	id INT IDENTITY(1, 1),
	campo1 INT,
	campo2 INT
)

DROP TABLE test;
SELECT * FROM test;

INSERT INTO test VALUES(2, 3);
INSERT INTO test VALUES(4, 5);
INSERT INTO test VALUES(6, 7);

TRUNCATE TABLE test;

-- STORE PROCEDURE
CREATE PROCEDURE SP_Pacientes (
	@IdPaciente dbo.idPaciente
) AS SELECT * FROM Paciente 
	WHERE IdPaciente = @IdPaciente;

EXEC SP_Pacientes 6;

SET NOCOUNT ON;

-- ALTER PROCEDURE SP_Alta_Pacientes (
CREATE PROCEDURE SP_Alta_Pacientes (
	@Cedula NVARCHAR(20),
	@Nombre NVARCHAR(50),
	@Apellido NVARCHAR(50),
	@FechaNacimiento NVARCHAR(8),
	@Domicilio NVARCHAR(50),
	@IdPais dbo.idPais,
	@Telefono NVARCHAR(20),
	@Email NVARCHAR(255),
	@Observacion dbo.observacion
) AS
IF NOT EXISTS(SELECT * FROM Paciente WHERE Cedula = @Cedula) 
	BEGIN
		INSERT INTO 
			paciente(Cedula, Nombre, Apellido, FechaNacimiento, Domicilio, IdPais, Telefono, Email, Observacion)
		VALUES 
			(@Cedula, @Nombre, @Apellido, @FechaNacimiento, @Domicilio, @IdPais, @Telefono, @Email, @Observacion)

		PRINT 'El paciente se agrego correctamente.'
		RETURN
	END
ELSE
	BEGIN
		PRINT 'El paciente ya existe.'
		RETURN
	END;

EXEC SP_Alta_Pacientes 
	'135-9828462-7', 'Antonio', 'Gomez', '20020306', 
	'Calle No se #67 22', 'DOM', '829-439-8492', 
	'antonio.gomez@gmail.com', '';


SELECT TOP 10 * FROM Turno;
SELECT * FROM Turno ORDER BY FechaTurno DESC;
SELECT TOP 10 * FROM Paciente;
SELECT * FROM Medico;

ALTER PROCEDURE SP_Alta_Turno (
--CREATE PROCEDURE SP_Alta_Turno (
	@FechaTurno CHAR(14),
	@IdPaciente dbo.idPaciente,
	@IdMedico dbo.idMedico,
	@IdEstado dbo.idEstado,
	@Observacion dbo.observacion
) AS
IF NOT EXISTS(SELECT TOP 1 * FROM turno WHERE FechaTurno = @FechaTurno) 
	BEGIN
		INSERT INTO Turno(FechaTurno, IdEstado, Observacion)
		VALUES (@FechaTurno, @IdEstado, @Observacion)

		DECLARE @IdTurno dbo.idTurno
		SET @IdTurno = @@IDENTITY

		INSERT INTO TurnoPaciente(IdTurno, IdPaciente, IdMedico)
		VALUES (@IdTurno, @IdPaciente, @IdMedico)

		PRINT 'El turno se agrego correctamente.'
		RETURN
	END
ELSE
	BEGIN
		PRINT 'El turno ya existe.'
		RETURN
	END;

EXEC SP_Alta_Turno '20260606 08:15', 6, 7, 1, 'El paciente tiene que estar en ayunas';

sp_help Pais;
sp_help SP_Alta_Turno;
sp_help Paciente;

sp_helptext SP_Alta_Pacientes;

-- CONDITIONALS AND LOOPS
DECLARE @idpaciente INT
SET @idpaciente = 67

IF @idpaciente = 67 
BEGIN
	SET @idturno = 20

	SELECT * FROM paciente WHERE IdPaciente = @idpaciente

	PRINT @idturno
	
	IF EXISTS( SELECT * FROM paciente WHERE IdPaciente = 10000 )
		PRINT 'Existe'
END


DECLARE @contador INT = 0

WHILE @contador <= 10
BEGIN
	PRINT @contador
	SET @contador = @contador + 1

	IF @contador = 6 
		BREAK
END

BEGIN TRY
	SET @contador = 'texto'
END TRY
BEGIN CATCH
	PRINT 'No es posible asignar un texto a la variable contador'
END CATCH


DECLARE @valor INT = 20
DECLARE @resultado CHAR(10)

SET @resultado = (
	CASE 
		WHEN @valor = 10 THEN 'Rojo'
		WHEN @valor = 20 THEN 'Verde'
		WHEN @valor = 30 THEN 'Azul'
		ELSE 'Negro'
	END
)

PRINT @resultado

SELECT 
	*, 
	CASE 
		WHEN IdEstado = 1 THEN 'Amarillo'
		WHEN IdEstado = 2 THEN 'Verde'
		WHEN IdEstado = 3 THEN 'Marron'
		WHEN IdEstado = 4 THEN 'Rojo'
		WHEN IdEstado = 5 THEN 'Negro'
		ELSE 'Gris'
	END AS ColorTurno
FROM turno

-- STRINGS FUNCTIONS
DECLARE @var1 VARCHAR(20);
SET @var1 = 'Juan';

DECLARE @var2 VARCHAR(20);
SET @var2 = 'Ramirez';

PRINT LEFT(@var1, 2);
PRINT RIGHT(@var1, 2);

SELECT LEFT(@var1, 1) + LEFT(@var2, 1) AS Iniciales;
SELECT LEN(@var1 + @var2) AS Longitud;
SELECT LOWER(@var1 + @var2) AS [Lower];
SELECT UPPER(@var1 + @var2) AS [Upper];

PRINT REPLICATE('*', 1);
PRINT REPLICATE('*', 3);
PRINT REPLICATE('*', 5);
PRINT REPLICATE('*', 7);
PRINT REPLICATE('*', 9);
PRINT REPLICATE('*', 11);

DECLARE @Nombre VARCHAR(20);
DECLARE @Apellido VARCHAR(20);

SET @Nombre = '            Addison    ';
SET @Apellido = '   Reyes             ';
SELECT CONCAT_WS(' ', @Nombre, @Apellido, '*');
SELECT CONCAT(@Nombre, ' ', @Apellido, ' *');

SELECT CONCAT_WS(' ', LTRIM(RTRIM(@Nombre)), LTRIM(RTRIM(@Apellido)), '*');
SELECT CONCAT( LTRIM(RTRIM(@Nombre)), ' ', LTRIM(RTRIM(@Apellido)), '*');

SELECT GETDATE();
SELECT GETUTCDATE();

SELECT DATEADD(DAY, 67, GETDATE());
SELECT DATEDIFF(MONTH, GETDATE(), DATEADD(DAY, 67, GETDATE()));
SELECT DATEPART(DAY, GETDATE());

PRINT ISDATE('15-07-2026');
PRINT ISDATE('20260715');

SELECT 
	CAST(REPLACE(Cedula, '-', '') AS BIGINT) AS CedulaNumCast,
	CONVERT(BIGINT, REPLACE(Cedula, '-', '')) AS CedulaNumConvert
FROM Paciente

SELECT
	GETDATE(),
	CONVERT(char(8), GETDATE()),
	CONVERT(char(20), GETDATE()),
	CONVERT(char(20), GETDATE(), 104)
	