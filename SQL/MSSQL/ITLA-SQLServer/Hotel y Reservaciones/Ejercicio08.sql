CREATE DATABASE hotel_db;
GO

USE hotel_db;
GO


/* =========================================================
   HUESPEDES
   ========================================================= */
CREATE TABLE huespedes (
    id INT IDENTITY(1,1) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    documento NVARCHAR(20) NOT NULL,
    nacionalidad NVARCHAR(50) NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
    direccion NVARCHAR(200) NULL,

    CONSTRAINT PK_huespedes
        PRIMARY KEY (id),

    CONSTRAINT UQ_huespedes_documento
        UNIQUE (documento),

    CONSTRAINT UQ_huespedes_correo
        UNIQUE (correo),

    CONSTRAINT CK_huespedes_correo
        CHECK (
            correo IS NULL
            OR correo LIKE '%_@_%._%'
        )
);
GO


/* =========================================================
   HABITACIONES
   ========================================================= */
CREATE TABLE habitaciones (
    id INT IDENTITY(1,1) NOT NULL,
    numero NVARCHAR(10) NOT NULL,
    piso INT NOT NULL,
    tipo NVARCHAR(30) NOT NULL,
    capacidad INT NOT NULL,
    precio_noche DECIMAL(12,2) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_habitaciones_estado DEFAULT 'Disponible',
    descripcion NVARCHAR(255) NULL,

    CONSTRAINT PK_habitaciones
        PRIMARY KEY (id),

    CONSTRAINT UQ_habitaciones_numero
        UNIQUE (numero),

    CONSTRAINT CK_habitaciones_piso
        CHECK (piso >= 0),

    CONSTRAINT CK_habitaciones_capacidad
        CHECK (capacidad > 0),

    CONSTRAINT CK_habitaciones_precio_noche
        CHECK (precio_noche >= 0),

    CONSTRAINT CK_habitaciones_tipo
        CHECK (
            tipo IN (
                'Individual',
                'Doble',
                'Triple',
                'Suite',
                'Familiar'
            )
        ),

    CONSTRAINT CK_habitaciones_estado
        CHECK (
            estado IN (
                'Disponible',
                'Ocupada',
                'Reservada',
                'Mantenimiento',
                'Fuera de servicio'
            )
        )
);
GO


/* =========================================================
   RESERVAS
   ========================================================= */
CREATE TABLE reservas (
    id INT IDENTITY(1,1) NOT NULL,
    id_huesped INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_reserva DATETIME2 NOT NULL
        CONSTRAINT DF_reservas_fecha_reserva DEFAULT SYSDATETIME(),
    entrada DATE NOT NULL,
    salida DATE NOT NULL,
    cantidad_personas INT NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_reservas_estado DEFAULT 'Pendiente',

    CONSTRAINT PK_reservas
        PRIMARY KEY (id),

    CONSTRAINT FK_reservas_huespedes
        FOREIGN KEY (id_huesped)
        REFERENCES huespedes(id),

    CONSTRAINT FK_reservas_habitaciones
        FOREIGN KEY (id_habitacion)
        REFERENCES habitaciones(id),

    CONSTRAINT CK_reservas_fechas
        CHECK (salida > entrada),

    CONSTRAINT CK_reservas_cantidad_personas
        CHECK (cantidad_personas > 0),

    CONSTRAINT CK_reservas_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Confirmada',
                'Activa',
                'Completada',
                'Cancelada'
            )
        )
);
GO


/* =========================================================
   SERVICIOS
   ========================================================= */
CREATE TABLE servicios (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    precio DECIMAL(12,2) NOT NULL,
    categoria NVARCHAR(50) NOT NULL,
    disponible BIT NOT NULL
        CONSTRAINT DF_servicios_disponible DEFAULT 1,
    estado BIT NOT NULL
        CONSTRAINT DF_servicios_estado DEFAULT 1,

    CONSTRAINT PK_servicios
        PRIMARY KEY (id),

    CONSTRAINT UQ_servicios_nombre
        UNIQUE (nombre),

    CONSTRAINT CK_servicios_precio
        CHECK (precio >= 0),

    CONSTRAINT CK_servicios_categoria
        CHECK (
            categoria IN (
                'Restaurante',
                'Lavanderia',
                'Spa',
                'Transporte',
                'Minibar',
                'Habitacion',
                'Otro'
            )
        )
);
GO


/* =========================================================
   CONSUMOS
   ========================================================= */
CREATE TABLE consumos (
    id INT IDENTITY(1,1) NOT NULL,
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_consumos_fecha DEFAULT SYSDATETIME(),
    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_consumos
        PRIMARY KEY (id),

    CONSTRAINT FK_consumos_reservas
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id),

    CONSTRAINT FK_consumos_servicios
        FOREIGN KEY (id_servicio)
        REFERENCES servicios(id),

    CONSTRAINT CK_consumos_cantidad
        CHECK (cantidad > 0),

    CONSTRAINT CK_consumos_precio
        CHECK (precio >= 0),

    CONSTRAINT CK_consumos_subtotal
        CHECK (subtotal >= 0)
);
GO


/* =========================================================
   EMPLEADOS
   ========================================================= */
CREATE TABLE empleados (
    id INT IDENTITY(1,1) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    cedula NVARCHAR(14) NOT NULL,
    cargo NVARCHAR(50) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
    salario DECIMAL(12,2) NOT NULL,
    estado BIT NOT NULL
        CONSTRAINT DF_empleados_estado DEFAULT 1,

    CONSTRAINT PK_empleados
        PRIMARY KEY (id),

    CONSTRAINT UQ_empleados_cedula
        UNIQUE (cedula),

    CONSTRAINT UQ_empleados_correo
        UNIQUE (correo),

    CONSTRAINT CK_empleados_salario
        CHECK (salario >= 0),

    CONSTRAINT CK_empleados_correo
        CHECK (
            correo IS NULL
            OR correo LIKE '%_@_%._%'
        )
);
GO


/* =========================================================
   TURNOS
   ========================================================= */
CREATE TABLE turnos (
    id INT IDENTITY(1,1) NOT NULL,
    id_empleado INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    area NVARCHAR(50) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_turnos_estado DEFAULT 'Programado',

    CONSTRAINT PK_turnos
        PRIMARY KEY (id),

    CONSTRAINT FK_turnos_empleados
        FOREIGN KEY (id_empleado)
        REFERENCES empleados(id),

    CONSTRAINT CK_turnos_horas
        CHECK (hora_fin > hora_inicio),

    CONSTRAINT CK_turnos_estado
        CHECK (
            estado IN (
                'Programado',
                'En curso',
                'Completado',
                'Cancelado'
            )
        )
);
GO


/* =========================================================
   PAGOS
   ========================================================= */
CREATE TABLE pagos (
    id INT IDENTITY(1,1) NOT NULL,
    id_reserva INT NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_pagos_fecha DEFAULT SYSDATETIME(),
    monto DECIMAL(12,2) NOT NULL,
    metodo NVARCHAR(30) NOT NULL,
    referencia NVARCHAR(50) NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_pagos_estado DEFAULT 'Pendiente',
    observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_pagos
        PRIMARY KEY (id),

    CONSTRAINT FK_pagos_reservas
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id),

    CONSTRAINT CK_pagos_monto
        CHECK (monto > 0),

    CONSTRAINT CK_pagos_metodo
        CHECK (
            metodo IN (
                'Efectivo',
                'Tarjeta',
                'Transferencia',
                'Cheque'
            )
        ),

    CONSTRAINT CK_pagos_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Pagado',
                'Rechazado',
                'Anulado'
            )
        )
);
GO


/* =========================================================
   MANTENIMIENTOS
   ========================================================= */
CREATE TABLE mantenimientos (
    id INT IDENTITY(1,1) NOT NULL,
    id_habitacion INT NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_mantenimientos_fecha DEFAULT SYSDATETIME(),
    descripcion NVARCHAR(500) NOT NULL,
    costo DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_mantenimientos_costo DEFAULT 0,
    responsable NVARCHAR(100) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_mantenimientos_estado DEFAULT 'Pendiente',
    observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_mantenimientos
        PRIMARY KEY (id),

    CONSTRAINT FK_mantenimientos_habitaciones
        FOREIGN KEY (id_habitacion)
        REFERENCES habitaciones(id),

    CONSTRAINT CK_mantenimientos_costo
        CHECK (costo >= 0),

    CONSTRAINT CK_mantenimientos_estado
        CHECK (
            estado IN (
                'Pendiente',
                'En proceso',
                'Completado',
                'Cancelado'
            )
        )
);
GO