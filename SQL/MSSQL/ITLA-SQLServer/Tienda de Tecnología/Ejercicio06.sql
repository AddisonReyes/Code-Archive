CREATE DATABASE tienda_tecnologia_db;
USE tienda_tecnologia_db;


/* =========================================================
   CLIENTES
   ========================================================= */
CREATE TABLE clientes (
    id INT IDENTITY(1,1) NOT NULL,
    nombres NVARCHAR(50) NOT NULL,
    apellidos NVARCHAR(50) NOT NULL,
    cedula NVARCHAR(14) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
    direccion NVARCHAR(200) NULL,
    fecha_registro DATETIME2 NOT NULL
        CONSTRAINT DF_clientes_fecha_registro DEFAULT SYSDATETIME(),

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
   CATEGORIAS
   ========================================================= */
CREATE TABLE categorias (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    fecha_creacion DATETIME2 NOT NULL
        CONSTRAINT DF_categorias_fecha_creacion DEFAULT SYSDATETIME(),
    estado BIT NOT NULL
        CONSTRAINT DF_categorias_estado DEFAULT 1,
    observacion NVARCHAR(255) NULL,

    CONSTRAINT PK_categorias
        PRIMARY KEY (id),

    CONSTRAINT UQ_categorias_nombre
        UNIQUE (nombre)
);
GO


/* =========================================================
   PRODUCTOS
   ========================================================= */
CREATE TABLE productos (
    id INT IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    marca NVARCHAR(100) NULL,
    id_categoria INT NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    existencia INT NOT NULL
        CONSTRAINT DF_productos_existencia DEFAULT 0,
    garantia INT NOT NULL
        CONSTRAINT DF_productos_garantia DEFAULT 0,
    estado BIT NOT NULL
        CONSTRAINT DF_productos_estado DEFAULT 1,

    CONSTRAINT PK_productos
        PRIMARY KEY (id),

    CONSTRAINT UQ_productos_codigo
        UNIQUE (codigo),

    CONSTRAINT FK_productos_categorias
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id),

    CONSTRAINT CK_productos_precio
        CHECK (precio >= 0),

    CONSTRAINT CK_productos_existencia
        CHECK (existencia >= 0),

    /* Garantía expresada en meses */
    CONSTRAINT CK_productos_garantia
        CHECK (garantia >= 0)
);
GO


/* =========================================================
   PROVEEDORES
   ========================================================= */
CREATE TABLE proveedores (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    rnc NVARCHAR(11) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
    direccion NVARCHAR(200) NULL,
    contacto NVARCHAR(100) NULL,
    estado BIT NOT NULL
        CONSTRAINT DF_proveedores_estado DEFAULT 1,

    CONSTRAINT PK_proveedores
        PRIMARY KEY (id),

    CONSTRAINT UQ_proveedores_rnc
        UNIQUE (rnc),

    CONSTRAINT UQ_proveedores_correo
        UNIQUE (correo),

    CONSTRAINT CK_proveedores_correo
        CHECK (
            correo IS NULL
            OR correo LIKE '%_@_%._%'
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
    cargo NVARCHAR(100) NOT NULL,
    salario DECIMAL(12,2) NOT NULL,
    telefono NVARCHAR(15) NULL,
    correo NVARCHAR(100) NULL,
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
   COMPRAS
   ========================================================= */
CREATE TABLE compras (
    id INT IDENTITY(1,1) NOT NULL,
    id_proveedor INT NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_compras_fecha DEFAULT SYSDATETIME(),
    subtotal DECIMAL(12,2) NOT NULL,
    impuestos DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_compras_impuestos DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    metodo_pago NVARCHAR(30) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_compras_estado DEFAULT 'Pendiente',

    CONSTRAINT PK_compras
        PRIMARY KEY (id),

    CONSTRAINT FK_compras_proveedores
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedores(id),

    CONSTRAINT CK_compras_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT CK_compras_impuestos
        CHECK (impuestos >= 0),

    CONSTRAINT CK_compras_total
        CHECK (total >= 0),

    CONSTRAINT CK_compras_metodo_pago
        CHECK (
            metodo_pago IN (
                'Efectivo',
                'Tarjeta',
                'Transferencia',
                'Cheque',
                'Credito'
            )
        ),

    CONSTRAINT CK_compras_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Completada',
                'Cancelada'
            )
        )
);
GO


/* =========================================================
   DETALLE DE COMPRAS
   ========================================================= */
CREATE TABLE detalle_compras (
    id INT IDENTITY(1,1) NOT NULL,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    costo DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_detalle_compras_descuento DEFAULT 0,

    CONSTRAINT PK_detalle_compras
        PRIMARY KEY (id),

    CONSTRAINT FK_detalle_compras_compras
        FOREIGN KEY (id_compra)
        REFERENCES compras(id),

    CONSTRAINT FK_detalle_compras_productos
        FOREIGN KEY (id_producto)
        REFERENCES productos(id),

    CONSTRAINT CK_detalle_compras_cantidad
        CHECK (cantidad > 0),

    CONSTRAINT CK_detalle_compras_costo
        CHECK (costo >= 0),

    CONSTRAINT CK_detalle_compras_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT CK_detalle_compras_descuento
        CHECK (descuento >= 0),

    /* Evita repetir el mismo producto dentro
       de una misma compra */
    CONSTRAINT UQ_detalle_compras_compra_producto
        UNIQUE (id_compra, id_producto)
);
GO


/* =========================================================
   VENTAS
   ========================================================= */
CREATE TABLE ventas (
    id INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    fecha DATETIME2 NOT NULL
        CONSTRAINT DF_ventas_fecha DEFAULT SYSDATETIME(),
    subtotal DECIMAL(12,2) NOT NULL,
    impuestos DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_ventas_impuestos DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    metodo_pago NVARCHAR(30) NOT NULL,
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_ventas_estado DEFAULT 'Pendiente',

    CONSTRAINT PK_ventas
        PRIMARY KEY (id),

    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id),

    CONSTRAINT CK_ventas_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT CK_ventas_impuestos
        CHECK (impuestos >= 0),

    CONSTRAINT CK_ventas_total
        CHECK (total >= 0),

    CONSTRAINT CK_ventas_metodo_pago
        CHECK (
            metodo_pago IN (
                'Efectivo',
                'Tarjeta',
                'Transferencia',
                'Credito'
            )
        ),

    CONSTRAINT CK_ventas_estado
        CHECK (
            estado IN (
                'Pendiente',
                'Completada',
                'Cancelada'
            )
        )
);
GO


/* =========================================================
   DETALLE DE VENTAS
   ========================================================= */
CREATE TABLE detalle_ventas (
    id INT IDENTITY(1,1) NOT NULL,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) NOT NULL
        CONSTRAINT DF_detalle_ventas_descuento DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_detalle_ventas
        PRIMARY KEY (id),

    CONSTRAINT FK_detalle_ventas_ventas
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id),

    CONSTRAINT FK_detalle_ventas_productos
        FOREIGN KEY (id_producto)
        REFERENCES productos(id),

    CONSTRAINT CK_detalle_ventas_cantidad
        CHECK (cantidad > 0),

    CONSTRAINT CK_detalle_ventas_precio
        CHECK (precio >= 0),

    CONSTRAINT CK_detalle_ventas_descuento
        CHECK (descuento >= 0),

    CONSTRAINT CK_detalle_ventas_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT UQ_detalle_ventas_venta_producto
        UNIQUE (id_venta, id_producto)
);
GO