CREATE DATABASE universidad_db;
GO

USE universidad_db;
GO

/* =========================================================
   CARRERAS
   ========================================================= */
CREATE TABLE Carreras (
    Id INT IDENTITY(1,1) NOT NULL,
    Codigo NVARCHAR(10) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Facultad NVARCHAR(100) NOT NULL,
    Creditos INT NOT NULL,
    Duracion INT NOT NULL,
    Modalidad NVARCHAR(20) NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Carreras_Estado DEFAULT 1,

    CONSTRAINT PK_Carreras
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Carreras_Codigo
        UNIQUE (Codigo),

    CONSTRAINT CK_Carreras_Creditos
        CHECK (Creditos > 0),

    CONSTRAINT CK_Carreras_Duracion
        CHECK (Duracion > 0),

    CONSTRAINT CK_Carreras_Modalidad
        CHECK (Modalidad IN ('Presencial', 'Virtual', 'Hibrida'))
);
GO


/* =========================================================
   ESTUDIANTES
   ========================================================= */
CREATE TABLE Estudiantes (
    Id INT IDENTITY(1,1) NOT NULL,
    IdCarrera INT NOT NULL,
    Matricula NVARCHAR(9) NOT NULL,
    Nombres NVARCHAR(25) NOT NULL,
    Apellidos NVARCHAR(25) NOT NULL,
    Cedula NVARCHAR(14) NOT NULL,
    Correo NVARCHAR(50) NOT NULL,
    Telefono NVARCHAR(15) NULL,
    FechaNacimiento DATE NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Estudiantes_Estado DEFAULT 1,

    CONSTRAINT PK_Estudiantes
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Estudiantes_Matricula
        UNIQUE (Matricula),

    CONSTRAINT UQ_Estudiantes_Cedula
        UNIQUE (Cedula),

    CONSTRAINT UQ_Estudiantes_Correo
        UNIQUE (Correo),

    CONSTRAINT FK_Estudiantes_Carreras
        FOREIGN KEY (IdCarrera)
        REFERENCES Carreras(Id),

    CONSTRAINT CK_Estudiantes_FechaNacimiento
        CHECK (FechaNacimiento < GETDATE()),

    CONSTRAINT CK_Estudiantes_Correo
        CHECK (Correo LIKE '%_@_%._%')
);
GO


/* =========================================================
   PROFESORES
   ========================================================= */
CREATE TABLE Profesores (
    Id INT IDENTITY(1,1) NOT NULL,
    Nombres NVARCHAR(25) NOT NULL,
    Apellidos NVARCHAR(25) NOT NULL,
    Cedula NVARCHAR(14) NOT NULL,
    Correo NVARCHAR(50) NOT NULL,
    Telefono NVARCHAR(15) NULL,
    Especialidad NVARCHAR(100) NOT NULL,
    Salario DECIMAL(12,2) NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Profesores_Estado DEFAULT 1,

    CONSTRAINT PK_Profesores
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Profesores_Cedula
        UNIQUE (Cedula),

    CONSTRAINT UQ_Profesores_Correo
        UNIQUE (Correo),

    CONSTRAINT CK_Profesores_Salario
        CHECK (Salario >= 0),

    CONSTRAINT CK_Profesores_Correo
        CHECK (Correo LIKE '%_@_%._%')
);
GO


/* =========================================================
   ASIGNATURAS
   ========================================================= */
CREATE TABLE Asignaturas (
    Id INT IDENTITY(1,1) NOT NULL,
    IdCarrera INT NOT NULL,
    Codigo NVARCHAR(10) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Creditos INT NOT NULL,
    HorasTeoricas INT NOT NULL,
    HorasPracticas INT NOT NULL,
    Semestre INT NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Asignaturas_Estado DEFAULT 1,

    CONSTRAINT PK_Asignaturas
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Asignaturas_Codigo
        UNIQUE (Codigo),

    CONSTRAINT FK_Asignaturas_Carreras
        FOREIGN KEY (IdCarrera)
        REFERENCES Carreras(Id),

    CONSTRAINT CK_Asignaturas_Creditos
        CHECK (Creditos > 0),

    CONSTRAINT CK_Asignaturas_HorasTeoricas
        CHECK (HorasTeoricas >= 0),

    CONSTRAINT CK_Asignaturas_HorasPracticas
        CHECK (HorasPracticas >= 0),

    CONSTRAINT CK_Asignaturas_Semestre
        CHECK (Semestre BETWEEN 1 AND 15)
);
GO


/* =========================================================
   AULAS
   ========================================================= */
CREATE TABLE Aulas (
    Id INT IDENTITY(1,1) NOT NULL,
    Codigo NVARCHAR(10) NOT NULL,
    Edificio NVARCHAR(50) NOT NULL,
    Piso INT NOT NULL,
    Capacidad INT NOT NULL,
    Tipo NVARCHAR(30) NOT NULL,
    Proyector BIT NOT NULL
        CONSTRAINT DF_Aulas_Proyector DEFAULT 0,
    Internet BIT NOT NULL
        CONSTRAINT DF_Aulas_Internet DEFAULT 0,
    Estado BIT NOT NULL
        CONSTRAINT DF_Aulas_Estado DEFAULT 1,

    CONSTRAINT PK_Aulas
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Aulas_Codigo
        UNIQUE (Codigo),

    CONSTRAINT CK_Aulas_Piso
        CHECK (Piso >= 0),

    CONSTRAINT CK_Aulas_Capacidad
        CHECK (Capacidad > 0),

    CONSTRAINT CK_Aulas_Tipo
        CHECK (Tipo IN ('Aula', 'Laboratorio', 'Auditorio'))
);
GO


/* =========================================================
   SECCIONES
   ========================================================= */
CREATE TABLE Secciones (
    Id INT IDENTITY(1,1) NOT NULL,
    Codigo NVARCHAR(15) NOT NULL,
    IdAsignatura INT NOT NULL,
    IdProfesor INT NOT NULL,
    IdAula INT NULL,
    Periodo NVARCHAR(10) NOT NULL,
    Horario NVARCHAR(100) NOT NULL,
    Cupo INT NOT NULL,
    Modalidad NVARCHAR(20) NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Secciones_Estado DEFAULT 1,

    CONSTRAINT PK_Secciones
        PRIMARY KEY (Id),

    CONSTRAINT UQ_Secciones_Codigo_Periodo
        UNIQUE (Codigo, Periodo),

    CONSTRAINT FK_Secciones_Asignaturas
        FOREIGN KEY (IdAsignatura)
        REFERENCES Asignaturas(Id),

    CONSTRAINT FK_Secciones_Profesores
        FOREIGN KEY (IdProfesor)
        REFERENCES Profesores(Id),

    CONSTRAINT FK_Secciones_Aulas
        FOREIGN KEY (IdAula)
        REFERENCES Aulas(Id),

    CONSTRAINT CK_Secciones_Cupo
        CHECK (Cupo > 0),

    CONSTRAINT CK_Secciones_Modalidad
        CHECK (Modalidad IN ('Presencial', 'Virtual', 'Hibrida'))
);
GO


/* =========================================================
   INSCRIPCIONES
   ========================================================= */
CREATE TABLE Inscripciones (
    Id INT IDENTITY(1,1) NOT NULL,
    IdEstudiante INT NOT NULL,
    IdSeccion INT NOT NULL,
    Fecha DATE NOT NULL
        CONSTRAINT DF_Inscripciones_Fecha DEFAULT CAST(GETDATE() AS DATE),
    Periodo NVARCHAR(10) NOT NULL,
    Tipo NVARCHAR(20) NOT NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Inscripciones_Estado DEFAULT 1,
    Observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_Inscripciones
        PRIMARY KEY (Id),

    CONSTRAINT FK_Inscripciones_Estudiantes
        FOREIGN KEY (IdEstudiante)
        REFERENCES Estudiantes(Id),

    CONSTRAINT FK_Inscripciones_Secciones
        FOREIGN KEY (IdSeccion)
        REFERENCES Secciones(Id),

    /* Evita inscribir al mismo estudiante dos veces
       en la misma sección */
    CONSTRAINT UQ_Inscripciones_Estudiante_Seccion
        UNIQUE (IdEstudiante, IdSeccion),

    CONSTRAINT CK_Inscripciones_Tipo
        CHECK (Tipo IN ('Normal', 'Reingreso', 'Extraordinaria'))
);
GO


/* =========================================================
   CALIFICACIONES
   ========================================================= */
CREATE TABLE Calificaciones (
    Id INT IDENTITY(1,1) NOT NULL,
    IdEstudiante INT NOT NULL,
    IdAsignatura INT NOT NULL,
    Practica DECIMAL(5,2) NULL,
    Parcial DECIMAL(5,2) NULL,
    [Final] DECIMAL(5,2) NULL,
    Promedio DECIMAL(5,2) NULL,
    Literal CHAR(2) NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Calificaciones_Estado DEFAULT 1,

    CONSTRAINT PK_Calificaciones
        PRIMARY KEY (Id),

    CONSTRAINT FK_Calificaciones_Estudiantes
        FOREIGN KEY (IdEstudiante)
        REFERENCES Estudiantes(Id),

    CONSTRAINT FK_Calificaciones_Asignaturas
        FOREIGN KEY (IdAsignatura)
        REFERENCES Asignaturas(Id),

    CONSTRAINT UQ_Calificaciones_Estudiante_Asignatura
        UNIQUE (IdEstudiante, IdAsignatura),

    CONSTRAINT CK_Calificaciones_Practica
        CHECK (Practica BETWEEN 0 AND 100),

    CONSTRAINT CK_Calificaciones_Parcial
        CHECK (Parcial BETWEEN 0 AND 100),

    CONSTRAINT CK_Calificaciones_Final
        CHECK ([Final] BETWEEN 0 AND 100),

    CONSTRAINT CK_Calificaciones_Promedio
        CHECK (Promedio BETWEEN 0 AND 100),

    CONSTRAINT CK_Calificaciones_Literal
        CHECK (
            Literal IS NULL
            OR Literal IN ('A', 'B', 'C', 'D', 'F')
        )
);
GO


/* =========================================================
   PAGOS
   ========================================================= */
CREATE TABLE Pagos (
    Id INT IDENTITY(1,1) NOT NULL,
    IdEstudiante INT NOT NULL,
    Concepto NVARCHAR(100) NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaPago DATE NOT NULL
        CONSTRAINT DF_Pagos_FechaPago DEFAULT CAST(GETDATE() AS DATE),
    MetodoPago NVARCHAR(30) NOT NULL,
    Referencia NVARCHAR(50) NULL,
    Estado BIT NOT NULL
        CONSTRAINT DF_Pagos_Estado DEFAULT 1,
    Observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_Pagos
        PRIMARY KEY (Id),

    CONSTRAINT FK_Pagos_Estudiantes
        FOREIGN KEY (IdEstudiante)
        REFERENCES Estudiantes(Id),

    CONSTRAINT CK_Pagos_Monto
        CHECK (Monto > 0),

    CONSTRAINT CK_Pagos_MetodoPago
        CHECK (
            MetodoPago IN (
                'Efectivo',
                'Tarjeta',
                'Transferencia',
                'Cheque'
            )
        )
);
GO