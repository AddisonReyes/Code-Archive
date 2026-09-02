CREATE DATABASE banco_db;
GO

USE banco_db;
GO


/* =========================================================
   CLIENTES
   ========================================================= */
CREATE TABLE clientes (
    id INT IDENTITY(1,1) NOT NULL,
    cedula NVARCHAR(14) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
    direccion NVARCHAR(200) NULL,
    fecha_registro DATETIME2 NOT NULL
        CONSTRAINT DF_clientes_fecha_registro DEFAULT SYSDATETIME(),
    estado BIT NOT NULL
        CONSTRAINT DF_clientes_estado DEFAULT 1,

    CONSTRAINT PK_clientes
        PRIMARY KEY (id),

    CONSTRAINT UQ_clientes_cedula
        UNIQUE (cedula),

    CONSTRAINT UQ_clientes_correo
        UNIQUE (correo),

    CONSTRAINT CK_clientes_correo
        CHECK (
            correo IS NULL
            OR correo LIKE '%_@_%._%'
        )
);
GO


/* =========================================================
   CUENTAS
   ========================================================= */
CREATE TABLE cuentas (
    id INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    numero_cuenta NVARCHAR(20) NOT NULL,
    tipo NVARCHAR(20) NOT NULL,
    balance DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_cuentas_balance DEFAULT 0,
    moneda CHAR(3) NOT NULL
        CONSTRAINT DF_cuentas_moneda DEFAULT 'DOP',
    fecha_apertura DATE NOT NULL
        CONSTRAINT DF_cuentas_fecha_apertura DEFAULT CAST(GETDATE() AS DATE),
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_cuentas_estado DEFAULT 'Activa',

    CONSTRAINT PK_cuentas
        PRIMARY KEY (id),

    CONSTRAINT UQ_cuentas_numero
        UNIQUE (numero_cuenta),

    CONSTRAINT FK_cuentas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id),

    CONSTRAINT CK_cuentas_tipo
        CHECK (
            tipo IN (
                'Ahorro',
                'Corriente',
                'Nomina'
            )
        ),

    CONSTRAINT CK_cuentas_balance
        CHECK (balance >= 0),

    CONSTRAINT CK_cuentas_moneda
        CHECK (
            moneda IN ('DOP', 'USD', 'EUR')
        ),

    CONSTRAINT CK_cuentas_estado
        CHECK (
            estado IN (
                'Activa',
                'Bloqueada',
                'Cerrada'
            )
        )
);
GO


/* =========================================================
   TRANSACCIONES
   ========================================================= */
CREATE TABLE transacciones (
    id INT IDENTITY(1,1) NOT NULL,
    id_cuenta INT NOT NULL,
    tipo NVARCHAR(30) NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_transacciones_fecha DEFAULT SYSDATETIME(),
    referencia NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_transacciones_estado DEFAULT 'Completada',

    CONSTRAINT PK_transacciones
        PRIMARY KEY (id),

    CONSTRAINT UQ_transacciones_referencia
        UNIQUE (referencia),

    CONSTRAINT FK_transacciones_cuentas
        FOREIGN KEY (id_cuenta)
        REFERENCES cuentas(id),

    CONSTRAINT CK_transacciones_tipo
        CHECK (
            tipo IN (
                'Deposito',
                'Retiro',
                'Transferencia',
                'Pago',
                'Cargo',
                'Interes'
            )
        ),

    CONSTRAINT CK_transacciones_monto
        CHECK (monto > 0),

    CONSTRAINT CK_transacciones_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Completada',
                'Rechazada',
                'Anulada'
            )
        )
);
GO


/* =========================================================
   PRESTAMOS
   ========================================================= */
CREATE TABLE prestamos (
    id INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    tasa DECIMAL(6,3) NOT NULL,
    plazo_meses INT NOT NULL,
    cuota DECIMAL(18,2) NOT NULL,
    fecha_inicio DATE NOT NULL
        CONSTRAINT DF_prestamos_fecha_inicio DEFAULT CAST(GETDATE() AS DATE),
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_prestamos_estado DEFAULT 'Activo',

    CONSTRAINT PK_prestamos
        PRIMARY KEY (id),

    CONSTRAINT FK_prestamos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id),

    CONSTRAINT CK_prestamos_monto
        CHECK (monto > 0),

    CONSTRAINT CK_prestamos_tasa
        CHECK (tasa >= 0),

    CONSTRAINT CK_prestamos_plazo
        CHECK (plazo_meses > 0),

    CONSTRAINT CK_prestamos_cuota
        CHECK (cuota > 0),

    CONSTRAINT CK_prestamos_estado
        CHECK (
            estado IN (
                'Activo',
                'Pagado',
                'Mora',
                'Cancelado'
            )
        )
);
GO


/* =========================================================
   CUOTAS
   ========================================================= */
CREATE TABLE cuotas (
    id INT IDENTITY(1,1) NOT NULL,
    id_prestamo INT NOT NULL,
    numero_cuota INT NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    fecha_pago DATE NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_cuotas_estado DEFAULT 'Pendiente',

    CONSTRAINT PK_cuotas
        PRIMARY KEY (id),

    CONSTRAINT FK_cuotas_prestamos
        FOREIGN KEY (id_prestamo)
        REFERENCES prestamos(id),

    CONSTRAINT UQ_cuotas_prestamo_numero
        UNIQUE (id_prestamo, numero_cuota),

    CONSTRAINT CK_cuotas_numero
        CHECK (numero_cuota > 0),

    CONSTRAINT CK_cuotas_monto
        CHECK (monto > 0),

    CONSTRAINT CK_cuotas_fecha_pago
        CHECK (
            fecha_pago IS NULL
            OR fecha_pago >= fecha_vencimiento
            OR fecha_pago < fecha_vencimiento
        ),

    CONSTRAINT CK_cuotas_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Pagada',
                'Vencida',
                'Parcial'
            )
        )
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
   SUCURSALES
   ========================================================= */
CREATE TABLE sucursales (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    codigo NVARCHAR(10) NOT NULL,
    ciudad NVARCHAR(50) NOT NULL,
    direccion NVARCHAR(200) NOT NULL,
    telefono NVARCHAR(15) NULL,
    gerente NVARCHAR(100) NULL,
    estado BIT NOT NULL
        CONSTRAINT DF_sucursales_estado DEFAULT 1,

    CONSTRAINT PK_sucursales
        PRIMARY KEY (id),

    CONSTRAINT UQ_sucursales_codigo
        UNIQUE (codigo)
);
GO


/* =========================================================
   TARJETAS
   ========================================================= */
CREATE TABLE tarjetas (
    id INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    numero_tarjeta NVARCHAR(19) NOT NULL,
    tipo NVARCHAR(20) NOT NULL,
    limite_credito DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_tarjetas_limite DEFAULT 0,
    fecha_emision DATE NOT NULL
        CONSTRAINT DF_tarjetas_fecha_emision DEFAULT CAST(GETDATE() AS DATE),
    fecha_vencimiento DATE NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_tarjetas_estado DEFAULT 'Activa',

    CONSTRAINT PK_tarjetas
        PRIMARY KEY (id),

    CONSTRAINT UQ_tarjetas_numero
        UNIQUE (numero_tarjeta),

    CONSTRAINT FK_tarjetas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id),

    CONSTRAINT CK_tarjetas_tipo
        CHECK (
            tipo IN (
                'Debito',
                'Credito'
            )
        ),

    CONSTRAINT CK_tarjetas_limite
        CHECK (limite_credito >= 0),

    CONSTRAINT CK_tarjetas_fechas
        CHECK (fecha_vencimiento > fecha_emision),

    CONSTRAINT CK_tarjetas_estado
        CHECK (
            estado IN (
                'Activa',
                'Bloqueada',
                'Vencida',
                'Cancelada'
            )
        )
);
GO


/* =========================================================
   SOLICITUDES
   ========================================================= */
CREATE TABLE solicitudes (
    id INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    tipo NVARCHAR(30) NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_solicitudes_fecha DEFAULT SYSDATETIME(),
    monto_solicitado DECIMAL(18,2) NULL,
    motivo NVARCHAR(255) NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_solicitudes_estado DEFAULT 'Pendiente',
    observacion NVARCHAR(500) NULL,

    CONSTRAINT PK_solicitudes
        PRIMARY KEY (id),

    CONSTRAINT FK_solicitudes_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id),

    CONSTRAINT CK_solicitudes_tipo
        CHECK (
            tipo IN (
                'Prestamo',
                'Tarjeta',
                'Cuenta',
                'Aumento de limite'
            )
        ),

    CONSTRAINT CK_solicitudes_monto
        CHECK (
            monto_solicitado IS NULL
            OR monto_solicitado > 0
        ),

    CONSTRAINT CK_solicitudes_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Aprobada',
                'Rechazada',
                'Cancelada'
            )
        )
);
GO