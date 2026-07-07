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