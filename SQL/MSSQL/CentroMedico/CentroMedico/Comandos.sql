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

SELECT TOP 2 * FROM Paciente
SELECT TOP 2 * FROM TurnoPaciente
SELECT TOP 2 * FROM Turno
SELECT TOP 2 * FROM MedicoEspecialidad

-- CREATE PROCEDURE SEL_TurnosPaciente(
ALTER PROCEDURE SEL_TurnosPaciente(
	@IdPaciente dbo.idPaciente
) AS SET NOCOUNT ON
	SELECT * FROM Paciente AS p
	INNER JOIN TurnoPaciente AS tp
		ON tp.IdPaciente = p.IdPaciente
	INNER JOIN Turno AS t
		ON t.IdTurno = tp.IdTurno
	INNER JOIN MedicoEspecialidad AS me
		ON tp.IdMedico = me.IdMedico
	WHERE 
		p.IdPaciente = @IdPaciente;

EXEC SELECT_TurnosPaciente 6;

---------------------------------------------------------

SELECT * FROM Historia
SELECT * FROM HistoriaPaciente

-- CREATE PROCEDURE SEL_TurnoPaciente(
ALTER PROCEDURE SEL_TurnoPaciente(
	@IdPaciente dbo.idPaciente
) AS SET NOCOUNT ON
	IF EXISTS (
		SELECT * FROM Paciente AS p
		INNER JOIN HistoriaPaciente AS hp
			ON p.IdPaciente = hp.IdPaciente
		INNER JOIN Historia AS h
			ON h.IdHistoria = hp.IdHistoria
		INNER JOIN MedicoEspecialidad AS me
			ON me.IdMedico = hp.IdMedico
		INNER JOIN Medico AS m
			ON m.IdMedico = me.IdMedico
		WHERE
			p.IdPaciente = @IdPaciente
	) BEGIN
		SELECT * FROM Paciente AS p
		INNER JOIN HistoriaPaciente AS hp
			ON p.IdPaciente = hp.IdPaciente
		INNER JOIN Historia AS h
			ON h.IdHistoria = hp.IdHistoria
		INNER JOIN MedicoEspecialidad AS me
			ON me.IdMedico = hp.IdMedico
		INNER JOIN Medico AS m
			ON m.IdMedico = me.IdMedico
		WHERE
			p.IdPaciente = @IdPaciente
	END
	ELSE BEGIN
		SELECT 'No existen historias clinicas para el paciente' AS Resultado
	END;

EXEC SEL_TurnoPaciente 6000000;
EXEC SEL_TurnoPaciente 37;

--------------------------------------

-- ALTER PROCEDURE SEL_EspecialidadMedica 
CREATE PROCEDURE SEL_EspecialidadMedica 
AS SET NOCOUNT ON
	IF EXISTS (SELECT * FROM Especialidad) BEGIN
		SELECT * FROM Especialidad
	END 
	ELSE BEGIN
		SELECT 0 AS Resultado
	END;

EXEC SEL_EspecialidadMedica;

-----------------------------------------

-- ALTER PROCEDURE UPD_Turno (
CREATE PROCEDURE UPD_Turno (
	@IdTurno dbo.IdTurno,
	@IdEstado dbo.IdEstado,
	@Observacion dbo.observacion
) AS SET NOCOUNT ON
	IF EXISTS (
		SELECT * FROM Turno WHERE IdTurno = @IdTurno
	) BEGIN
		UPDATE Turno SET
			IdEstado = @IdEstado,
			Observacion = @Observacion 
		WHERE IdTurno = @IdTurno
	END
	ELSE BEGIN
		SELECT 0 AS Resultado
	END;	

SELECT * FROM Turno AS t
INNER JOIN TurnoPaciente AS tp
	ON t.IdTurno = tp.IdTurno
WHERE t.IdTurno = 1;

EXEC UPD_Turno 1, 2, 'SP Test';

SELECT * FROM Turno AS t
INNER JOIN TurnoPaciente AS tp
	ON t.IdTurno = tp.IdTurno
WHERE t.IdTurno = 1;

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

-- TRANSACTIONS
SELECT * FROM Paciente

BEGIN TRANSACTION
	UPDATE Paciente SET Telefono = 444 WHERE IdPaciente <> 6

	IF @@ROWCOUNT = 1
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION

SELECT * FROM Turno

BEGIN TRANSACTION
	DELETE FROM Turno WHERE IdEstado = 0

	IF @@ROWCOUNT = 1
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION

-- JOINS & UNION

SELECT TOP 20 *
FROM Paciente AS p
INNER JOIN TurnoPaciente AS t
	ON p.IdPaciente = t.IdPaciente

SELECT TOP 10 
	m.Nombre, m.Apellido, e.Especialidad, me.Descripcion
FROM Medico AS m
LEFT JOIN MedicoEspecialidad AS me
	ON m.IdMedico = me.IdMedico
LEFT JOIN Especialidad AS e
	ON me.IdEspecialidad = e.IdEspecialidad

SELECT TOP 15
	p.Fecha, c.Descripcion, p.Monto, p.Observacion
FROM Pago AS p
RIGHT JOIN Concepto AS c
	ON p.IdConcepto = c.IdConcepto
ORDER BY p.Monto DESC

SELECT TOP 5 * FROM Turno
UNION 
SELECT TOP 5 * FROM Turno WHERE IdEstado = 2

SELECT TOP 5 * FROM Turno WHERE IdEstado = 1
UNION ALL
SELECT TOP 5 * FROM Turno WHERE IdEstado = 2

-- FUNCTIONS

CREATE OR ALTER FUNCTION nombrefun (@var int)
RETURNS INT AS
BEGIN
	SET @var = @var * 5
	RETURN @var
END

DECLARE @startVal INT = 1
DECLARE @endVal INT = 10

WHILE @startVal < @endVal BEGIN
	PRINT dbo.nombrefun(@startVal)
	SET @startVal = @startVal + 1
END
 

CREATE OR ALTER FUNCTION concatenar (
	@nombre varchar(50), @apellido varchar(50)
) RETURNS VARCHAR(100) AS
BEGIN
	DECLARE @resultado VARCHAR(100)
	SET @resultado = @apellido + ', ' + @nombre
	RETURN @resultado
END

SELECT dbo.concatenar('Addison', 'Reyes') AS Nombre
SELECT 
	Nombre, Apellido,
	dbo.concatenar(Nombre, Apellido) AS Concatenacion
FROM Paciente

CREATE OR ALTER FUNCTION ObtenerPais (
	@IdPaciente dbo.idPaciente
) RETURNS CHAR(60) AS BEGIN
	DECLARE @Pais CHAR(60)

	SELECT @Pais = p2.Pais 
	FROM Paciente AS p1
	INNER JOIN Pais AS p2
		ON p1.IdPais = p2.IdPais
	WHERE IdPaciente = @IdPaciente

	RETURN @Pais
END

SELECT * FROM Pais

DECLARE @id INT = 67
SELECT dbo.ObtenerPais(@id) 
SELECT * FROM Paciente WHERE IdPaciente = @id


CREATE OR ALTER FUNCTION PacientesPaises()
RETURNS @paises TABLE(
	IdPaciente dbo.idPaciente,
	Nombre VARCHAR(50),
	Apellido VARCHAR(50),
	IdPais dbo.idPais,
	Pais VARCHAR(60)
) AS BEGIN 
	INSERT INTO @paises (
		IdPaciente,
		Nombre,
		Apellido,
		IdPais,
		Pais
	)
	SELECT 
		p1.IdPaciente,
		p1.Nombre,
		p1.Apellido,
		p1.IdPais,
		p2.Pais
	FROM Paciente AS p1
	INNER JOIN Pais AS p2
		ON p1.IdPais = p2.IdPais

	RETURN
END

SELECT * FROM dbo.PacientesPaises();

-- Backups and Restores

-- USE CentroMedico;
USE Master;

BACKUP DATABASE CentroMedico 
TO DISK = N'D:\SQLBackups\CentroMedicol.bak'
WITH
    COPY_ONLY,
    INIT,
    COMPRESSION,
    CHECKSUM,
    STATS = 10;

RESTORE VERIFYONLY
FROM DISK = N'D:\SQLBackups\CentroMedicol.bak'
WITH CHECKSUM;

RESTORE FILELISTONLY
FROM DISK = N'D:\SQLBackups\CentroMedicol.bak';

RESTORE DATABASE CentroMedicoTesting
FROM DISK = N'D:\SQLBackups\CentroMedicol.bak'
WITH
    MOVE N'CentroMedico'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\CentroMedicoTesting.mdf',

    MOVE N'CentroMedico_log'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\CentroMedicoTesting_log.ldf',

    RECOVERY,
    STATS = 10;

DECLARE @Fecha CHAR(12)
DECLARE @Path NVARCHAR(100)
DECLARE @Name NVARCHAR(20)

SET @Fecha = CONVERT(CHAR(8), GETDATE(), 112) + REPLACE(CONVERT(CHAR(5), GETDATE(), 108), ':', '')
SET @Path = 'D:\SQLBackups\CentroMedico' + @Fecha + '.bak'
SET @Name = 'CentroMedico' + @Fecha

BACKUP DATABASE CentroMedico
TO DISK = @Path
WITH 
	COMPRESSION, 
	NAME=@Name;

-- Tabla temporal en memoria
DECLARE @tabla TABLE (
	id INT IDENTITY(1, 1),
	pais VARCHAR(50)
)

INSERT INTO @tabla VALUES('Inglaterra')
INSERT INTO @tabla VALUES('China')
INSERT INTO @tabla VALUES('Brasil')
INSERT INTO @tabla VALUES('Francia')

SELECT * FROM @tabla

-- Tabla temporal fisica
CREATE TABLE #tabla (
	id INT IDENTITY(1, 1),
	pais VARCHAR(50)
)

INSERT INTO #tabla VALUES('Colombia')
INSERT INTO #tabla VALUES('Colombia')
INSERT INTO #tabla VALUES('Rusia')
INSERT INTO #tabla VALUES('Alemania')

SELECT * FROM #tabla


SELECT * FROM Paciente
SELECT * FROM TurnoPaciente
DECLARE @turnos TABLE (
	Id INT IDENTITY(1, 1),
	IdTurno dbo.idTurno,
	IdPaciente dbo.idPaciente
)

INSERT INTO @turnos (IdTurno, IdPaciente)
	SELECT TOP 10
		tp.IdTurno, p.IdPaciente 
	FROM Paciente AS p
	INNER JOIN TurnoPaciente AS tp
		ON tp.IdPaciente = p.IdPaciente

DECLARE @i INT = 1
WHILE @i <= (SELECT COUNT(*) FROM @turnos) BEGIN
	IF (SELECT IdPaciente FROM @turnos WHERE id = @i) <> 6 BEGIN
		DELETE FROM @turnos WHERE id = @i
	END

	SET @i = @i + 1
END

SELECT * FROM @turnos


-- VIEWS

CREATE OR ALTER VIEW PacientesYTurnos AS (
	SELECT 
		p.IdPaciente,
		p.Cedula,
		p.Nombre,
		p.Domicilio,
		p.IdPais,
		p.Telefono,
		p.Email,
		p.Observacion,
		tp.IdTurno,
		tp.IdMedico,
		t.FechaTurno,
		t.Observacion AS ObservacionTurno,
		t.IdEstado
	FROM Paciente AS p
	INNER JOIN TurnoPaciente AS tp
		ON p.IdPaciente = tp.IdPaciente
	INNER JOIN Turno AS t
		ON tp.IdTurno = t.IdTurno 
	WHERE ISNULL(t.IdEstado, 0) <> 0
)

SELECT * FROM PacientesYTurnos

---------------------------------------------
	USE [CentroMedico]
	GO

	/****** Object:  Table [dbo].[PacienteLog]    Script Date: 8/3/2026 4:00:27 PM ******/
	SET ANSI_NULLS ON
	GO

	SET QUOTED_IDENTIFIER ON
	GO

	CREATE TABLE [dbo].[PacienteLog](
		[IdPaciente] [dbo].[idPaciente] NOT NULL,
		[IdPais] [dbo].[idPais] NULL,
		[FechaAlta] [datetime] NULL,
	 CONSTRAINT [PK_PacienteLog] PRIMARY KEY CLUSTERED 
	(
		[IdPaciente] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO
---------------------------------------------

-- TRIGGERS
CREATE TRIGGER PacientesCreados ON Paciente
AFTER INSERT AS
	IF (SELECT IdPais FROM inserted) = 'DOM' BEGIN
		INSERT INTO PacienteLog (IdPaciente, IdPais, FechaAlta)
		SELECT IdPaciente, IdPais, GETDATE() FROM inserted;
	END

SELECT TOP 6 * FROM Paciente

INSERT INTO Paciente (Cedula, Nombre, Apellido, FechaNacimiento, Domicilio, IdPais, Telefono, Email, Observacion)
VALUES ('235-9087267-7', 'Juana', 'Reyes', '12-01-2001', 'Calle 4 NO.27 Ensanche Ozama 2nd', 'DOM', NULL, 'juana.reyes@hotmail.com', NULL)

SELECT * FROM PacienteLog


ALTER TABLE PacienteLog ADD FechaModificacion DATETIME

CREATE TRIGGER PacientesActualizados ON Paciente
AFTER UPDATE AS
	IF EXISTS (
		SELECT IdPaciente FROM PacienteLog
		WHERE IdPaciente = (SELECT IdPaciente FROM Inserted)
	) BEGIN
		UPDATE PacienteLog SET FechaModificacion = GETDATE()
		WHERE IdPaciente = (SELECT IdPaciente FROM Inserted)
	END ELSE BEGIN
		INSERT INTO PacienteLog (IdPaciente, IdPais, FechaModificacion)
		SELECT IdPaciente, IdPais, GETDATE() FROM inserted;
	END

SELECT * FROM Paciente
WHERE IdPaciente = 6003

UPDATE Paciente SET Nombre = 'Maria'
WHERE IdPaciente = 6003

SELECT * FROM PacienteLog

SELECT * FROM Paciente
WHERE IdPaciente = 6003


ALTER TABLE PacienteLog ADD FechaBaja DATETIME
 
CREATE OR ALTER TRIGGER PacientesBorrados ON Paciente
FOR DELETE AS
	IF EXISTS (
		SELECT IdPaciente FROM PacienteLog
		WHERE IdPaciente = (SELECT IdPaciente FROM Deleted)
	) BEGIN
		UPDATE PacienteLog SET FechaBaja = GETDATE()
		WHERE IdPaciente = (SELECT IdPaciente FROM Deleted)
	END ELSE BEGIN
		INSERT INTO PacienteLog (IdPaciente, IdPais, FechaBaja)
		SELECT IdPaciente, IdPais, GETDATE() FROM Deleted;
	END


INSERT INTO Paciente (Cedula, Nombre, Apellido, FechaNacimiento, Domicilio, IdPais, Telefono, Email, Observacion)
VALUES ('235-9087267-7', 'Testing', 'Reyes', '12-01-2001', 'Calle 4 NO.27 Ensanche Ozama 2nd', 'DOM', NULL, 'juana.reyes@hotmail.com', NULL)

DELETE FROM Paciente
WHERE Nombre = 'Testing'

SELECT * FROM PacienteLog

-- VIEWS

CREATE VIEW VIEW_MedicosEspecialidades AS
SELECT 
	m.IdMedico,
	m.Nombre,
	m.Apellido,
	me.IdEspecialidad,
	me.Descripcion
FROM Medico AS m
INNER JOIN MedicoEspecialidad AS me
	ON m.IdMedico = me.IdMedico

SELECT * FROM VIEW_MedicosEspecialidades