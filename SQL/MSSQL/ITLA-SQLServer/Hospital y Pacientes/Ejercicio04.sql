CREATE DATABASE hospital_db;
GO

USE hospital_db;
GO


/* =========================================================
   PACIENTES
   ========================================================= */
CREATE TABLE pacientes (
    Id INT IDENTITY(1,1) NOT NULL,
    cedula NVARCHAR(14) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    telefono NVARCHAR(15) NULL,
    direccion NVARCHAR(200) NULL,
    seguro NVARCHAR(100) NULL,
    
    CONSTRAINT PK_pacientes
        PRIMARY KEY (Id),

    CONSTRAINT UQ_pacientes_cedula
        UNIQUE (cedula),

    CONSTRAINT CK_pacientes_sexo
        CHECK (sexo IN ('M', 'F')),

    CONSTRAINT CK_pacientes_fecha_nacimiento
        CHECK (fecha_nacimiento <= GETDATE())
);
GO


/* =========================================================
   MEDICOS
   ========================================================= */
CREATE TABLE medicos (
    Id INT IDENTITY(1,1) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    cedula NVARCHAR(14) NOT NULL,
    especialidad NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NOT NULL,
    consultorio NVARCHAR(20) NULL,
    estado BIT NOT NULL
        CONSTRAINT DF_medicos_estado DEFAULT 1,

    CONSTRAINT PK_medicos
        PRIMARY KEY (Id),

    CONSTRAINT UQ_medicos_cedula
        UNIQUE (cedula),

    CONSTRAINT UQ_medicos_correo
        UNIQUE (correo),

    CONSTRAINT CK_medicos_correo
        CHECK (correo LIKE '%_@_%._%')
);
GO


/* =========================================================
   CITAS
   ========================================================= */
CREATE TABLE citas (
    Id INT IDENTITY(1,1) NOT NULL,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo NVARCHAR(255) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_citas_estado DEFAULT 'Pendiente',
    observacion NVARCHAR(500) NULL,

    CONSTRAINT PK_citas
        PRIMARY KEY (Id),

    CONSTRAINT FK_citas_pacientes
        FOREIGN KEY (id_paciente)
        REFERENCES pacientes(Id),

    CONSTRAINT FK_citas_medicos
        FOREIGN KEY (id_medico)
        REFERENCES medicos(Id),

    CONSTRAINT CK_citas_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Confirmada',
                'Completada',
                'Cancelada'
            )
        ),

    /* Evita que el mismo médico tenga dos citas
       exactamente a la misma fecha y hora */
    CONSTRAINT UQ_citas_medico_fecha_hora
        UNIQUE (id_medico, fecha, hora)
);
GO


/* =========================================================
   CONSULTAS
   ========================================================= */
CREATE TABLE consultas (
    Id INT IDENTITY(1,1) NOT NULL,
    id_cita INT NOT NULL,
    diagnostico NVARCHAR(500) NOT NULL,
    tratamiento NVARCHAR(500) NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_consultas_fecha DEFAULT SYSDATETIME(),
    peso DECIMAL(5,2) NULL,
    presion NVARCHAR(10) NULL,
    observacion NVARCHAR(500) NULL,

    CONSTRAINT PK_consultas
        PRIMARY KEY (Id),

    CONSTRAINT FK_consultas_citas
        FOREIGN KEY (id_cita)
        REFERENCES citas(Id),

    /* Una cita genera como máximo una consulta */
    CONSTRAINT UQ_consultas_id_cita
        UNIQUE (id_cita),

    CONSTRAINT CK_consultas_peso
        CHECK (peso IS NULL OR peso > 0)
);
GO


/* =========================================================
   MEDICAMENTOS
   ========================================================= */
CREATE TABLE medicamentos (
    Id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    laboratorio NVARCHAR(100) NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    existencia INT NOT NULL
        CONSTRAINT DF_medicamentos_existencia DEFAULT 0,
    fecha_vencimiento DATE NOT NULL,
    estado BIT NOT NULL
        CONSTRAINT DF_medicamentos_estado DEFAULT 1,

    CONSTRAINT PK_medicamentos
        PRIMARY KEY (Id),

    CONSTRAINT CK_medicamentos_precio
        CHECK (precio >= 0),

    CONSTRAINT CK_medicamentos_existencia
        CHECK (existencia >= 0)
);
GO


/* =========================================================
   RECETAS
   ========================================================= */
CREATE TABLE recetas (
    Id INT IDENTITY(1,1) NOT NULL,
    id_consulta INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosis NVARCHAR(50) NOT NULL,
    frecuencia NVARCHAR(100) NOT NULL,
    dias INT NOT NULL,
    indicaciones NVARCHAR(500) NULL,
    fecha DATE NOT NULL
        CONSTRAINT DF_recetas_fecha DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT PK_recetas
        PRIMARY KEY (Id),

    CONSTRAINT FK_recetas_consultas
        FOREIGN KEY (id_consulta)
        REFERENCES consultas(Id),

    CONSTRAINT FK_recetas_medicamentos
        FOREIGN KEY (id_medicamento)
        REFERENCES medicamentos(Id),

    CONSTRAINT CK_recetas_dias
        CHECK (dias > 0)
);
GO


/* =========================================================
   HABITACIONES
   ========================================================= */
CREATE TABLE habitaciones (
    Id INT IDENTITY(1,1) NOT NULL,
    numero NVARCHAR(10) NOT NULL,
    piso INT NOT NULL,
    tipo NVARCHAR(30) NOT NULL,
    capacidad INT NOT NULL,
    precio_dia DECIMAL(10,2) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_habitaciones_estado DEFAULT 'Disponible',
    observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_habitaciones
        PRIMARY KEY (Id),

    CONSTRAINT UQ_habitaciones_numero
        UNIQUE (numero),

    CONSTRAINT CK_habitaciones_piso
        CHECK (piso >= 0),

    CONSTRAINT CK_habitaciones_capacidad
        CHECK (capacidad > 0),

    CONSTRAINT CK_habitaciones_precio
        CHECK (precio_dia >= 0),

    CONSTRAINT CK_habitaciones_tipo
        CHECK (
            tipo IN (
                'General',
                'Privada',
                'UCI',
                'Emergencia'
            )
        ),

    CONSTRAINT CK_habitaciones_estado
        CHECK (
            estado IN (
                'Disponible',
                'Ocupada',
                'Mantenimiento',
                'Fuera de servicio'
            )
        )
);
GO


/* =========================================================
   INGRESOS
   ========================================================= */
CREATE TABLE ingresos (
    Id INT IDENTITY(1,1) NOT NULL,
    id_paciente INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_ingreso DATETIME2 NOT NULL
        CONSTRAINT DF_ingresos_fecha_ingreso DEFAULT SYSDATETIME(),
    fecha_salida DATETIME2 NULL,
    motivo NVARCHAR(255) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_ingresos_estado DEFAULT 'Activo',
    observacion NVARCHAR(500) NULL,

    CONSTRAINT PK_ingresos
        PRIMARY KEY (Id),

    CONSTRAINT FK_ingresos_pacientes
        FOREIGN KEY (id_paciente)
        REFERENCES pacientes(Id),

    CONSTRAINT FK_ingresos_habitaciones
        FOREIGN KEY (id_habitacion)
        REFERENCES habitaciones(Id),

    CONSTRAINT CK_ingresos_fechas
        CHECK (
            fecha_salida IS NULL
            OR fecha_salida >= fecha_ingreso
        ),

    CONSTRAINT CK_ingresos_estado
        CHECK (
            estado IN (
                'Activo',
                'Alta',
                'Cancelado'
            )
        )
);
GO


/* =========================================================
   FACTURAS
   ========================================================= */
CREATE TABLE facturas (
    Id INT IDENTITY(1,1) NOT NULL,
    id_paciente INT NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_facturas_fecha DEFAULT SYSDATETIME(),
    subtotal DECIMAL(12,2) NOT NULL,
    impuestos DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_facturas_impuestos DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    metodo_pago NVARCHAR(30) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_facturas_estado DEFAULT 'Pendiente',

    CONSTRAINT PK_facturas
        PRIMARY KEY (Id),

    CONSTRAINT FK_facturas_pacientes
        FOREIGN KEY (id_paciente)
        REFERENCES pacientes(Id),

    CONSTRAINT CK_facturas_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT CK_facturas_impuestos
        CHECK (impuestos >= 0),

    CONSTRAINT CK_facturas_total
        CHECK (total >= 0),

    CONSTRAINT CK_facturas_metodo_pago
        CHECK (
            metodo_pago IN (
                'Efectivo',
                'Tarjeta',
                'Transferencia',
                'Seguro'
            )
        ),

    CONSTRAINT CK_facturas_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Pagada',
                'Cancelada'
            )
        )
);
GO
