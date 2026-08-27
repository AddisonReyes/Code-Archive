-- =============================================
-- TABLA: estudiantes
-- =============================================
CREATE TABLE estudiantes (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL
);

INSERT INTO estudiantes (id_estudiante, nombre, correo)
VALUES
    (1, 'Ana Ruiz', 'ana@correo.com'),
    (2, 'Luis Peña', 'luis@correo.com'),
    (3, 'Sofía Díaz', 'sofia@correo.com');


-- =============================================
-- TABLA: cursos
-- =============================================
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    horas INT NOT NULL
);

INSERT INTO cursos (id_curso, nombre_curso, horas)
VALUES
    (10, 'Base de Datos I', 40),
    (11, 'Programación Web', 50);


-- =============================================
-- TABLA: matriculas
-- =============================================
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha DATE NOT NULL,

    CONSTRAINT FK_matriculas_estudiantes
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante),

    CONSTRAINT FK_matriculas_cursos
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso)
);

INSERT INTO matriculas (
    id_matricula,
    id_estudiante,
    id_curso,
    fecha
)
VALUES
    (1001, 1, 10, '2026-08-01'),
    (1002, 2, 10, '2026-08-02'),
    (1003, 3, 11, '2026-08-03');