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

-- STORE PROCEDURE
CREATE PROCEDURE SP_Pacientes (
	@IdPaciente dbo.idPaciente
) AS SELECT * FROM paciente 
	WHERE IdPaciente = @IdPaciente;

EXEC SP_Pacientes 6;

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