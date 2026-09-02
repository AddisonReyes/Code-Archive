USE universidad_db;
GO

ALTER TABLE estudiantes
ADD direccion NVARCHAR(200) NULL;

ALTER TABLE secciones
ALTER COLUMN horario NVARCHAR(200) NULL;