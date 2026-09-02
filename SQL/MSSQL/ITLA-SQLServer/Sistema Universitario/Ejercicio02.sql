USE universidad_db;
GO

CREATE INDEX idx_estudiante_matricula
ON estudiantes(matricula);

CREATE INDEX idx_profesor_cedula
ON profesores(cedula);

CREATE INDEX idx_asignatura_codigo
ON asignaturas(codigo);