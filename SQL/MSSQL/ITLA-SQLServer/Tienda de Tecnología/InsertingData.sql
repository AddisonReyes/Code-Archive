/*
    SQL Server / T-SQL conversion of the supplied MariaDB dump.
    Source database: tienda_tecnologia_db
    Converted for execution in SQL Server Management Studio (SSMS).
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF DB_ID(N'tienda_tecnologia_db') IS NULL
BEGIN
    CREATE DATABASE [tienda_tecnologia_db];
END;
GO

USE [tienda_tecnologia_db];
GO

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE [dbo].[categorias] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [nombre] NVARCHAR(100) NOT NULL,
        [descripcion] NVARCHAR(255) NULL,
        [fecha_creacion] DATE NULL,
        [estado] NVARCHAR(20) NULL,
        [observacion] NVARCHAR(255) NULL,
        CONSTRAINT [PK_categorias] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[clientes] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [nombres] NVARCHAR(100) NOT NULL,
        [apellidos] NVARCHAR(100) NOT NULL,
        [cedula] NVARCHAR(20) NOT NULL,
        [telefono] NVARCHAR(20) NULL,
        [correo] NVARCHAR(150) NULL,
        [direccion] NVARCHAR(255) NULL,
        [fecha_registro] DATE NULL,
        CONSTRAINT [PK_clientes] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[compras] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [id_proveedor] INT NOT NULL,
        [fecha] DATE NOT NULL,
        [subtotal] DECIMAL(10,2) NOT NULL,
        [impuestos] DECIMAL(10,2) NULL,
        [total] DECIMAL(10,2) NOT NULL,
        [metodo_pago] NVARCHAR(50) NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_compras] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[detalle_compras] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [id_compra] INT NOT NULL,
        [id_producto] INT NOT NULL,
        [cantidad] INT NOT NULL,
        [costo] DECIMAL(10,2) NOT NULL,
        [subtotal] DECIMAL(10,2) NOT NULL,
        [descuento] DECIMAL(10,2) NULL,
        CONSTRAINT [PK_detalle_compras] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[detalle_ventas] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [id_venta] INT NOT NULL,
        [id_producto] INT NOT NULL,
        [cantidad] INT NOT NULL,
        [precio] DECIMAL(10,2) NOT NULL,
        [descuento] DECIMAL(10,2) NULL,
        [subtotal] DECIMAL(10,2) NOT NULL,
        CONSTRAINT [PK_detalle_ventas] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[empleados] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [nombres] NVARCHAR(100) NOT NULL,
        [apellidos] NVARCHAR(100) NOT NULL,
        [cedula] NVARCHAR(20) NOT NULL,
        [cargo] NVARCHAR(100) NULL,
        [salario] DECIMAL(10,2) NULL,
        [telefono] NVARCHAR(20) NULL,
        [correo] NVARCHAR(150) NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_empleados] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[productos] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [codigo] NVARCHAR(50) NOT NULL,
        [nombre] NVARCHAR(150) NOT NULL,
        [marca] NVARCHAR(100) NULL,
        [id_categoria] INT NOT NULL,
        [precio] DECIMAL(10,2) NOT NULL,
        [existencia] INT NOT NULL,
        [garantia] NVARCHAR(100) NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_productos] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[proveedores] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [nombre] NVARCHAR(150) NOT NULL,
        [rnc] NVARCHAR(20) NOT NULL,
        [telefono] NVARCHAR(20) NULL,
        [correo] NVARCHAR(150) NULL,
        [direccion] NVARCHAR(255) NULL,
        [contacto] NVARCHAR(150) NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_proveedores] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[proveedores_productos] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [id_proveedor] INT NOT NULL,
        [id_producto] INT NOT NULL,
        [costo] DECIMAL(10,2) NULL,
        [fecha_registro] DATE NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_proveedores_productos] PRIMARY KEY ([id])
    );

    CREATE TABLE [dbo].[ventas] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [id_cliente] INT NOT NULL,
        [id_empleado] INT NOT NULL,
        [fecha] DATE NOT NULL,
        [subtotal] DECIMAL(10,2) NOT NULL,
        [impuestos] DECIMAL(10,2) NULL,
        [total] DECIMAL(10,2) NOT NULL,
        [metodo_pago] NVARCHAR(50) NULL,
        [estado] NVARCHAR(20) NULL,
        CONSTRAINT [PK_ventas] PRIMARY KEY ([id])
    );

    SET IDENTITY_INSERT [dbo].[categorias] ON;
    INSERT INTO [dbo].[categorias] ([id], [nombre], [descripcion], [fecha_creacion], [estado], [observacion]) VALUES
    (1, N'Computadoras', N'Computadoras de escritorio y portátiles', N'2026-09-09', N'Activo', N'Equipos informáticos'),
    (2, N'Celulares', N'Teléfonos inteligentes y dispositivos móviles', N'2026-09-09', N'Activo', N'Equipos móviles'),
    (3, N'Monitores', N'Monitores para computadoras', N'2026-09-09', N'Activo', N'Diferentes tamaños y resoluciones'),
    (4, N'Accesorios', N'Accesorios para computadoras y dispositivos', N'2026-09-09', N'Activo', N'Teclados, mouse y otros'),
    (5, N'Impresoras', N'Equipos de impresión', N'2026-09-09', N'Activo', N'Impresoras y multifuncionales'),
    (6, N'Mauses', N'Ratatones para computadores', N'2026-09-09', N'Activo', N'Ver antesd de comprar')
    ;
    SET IDENTITY_INSERT [dbo].[categorias] OFF;

    SET IDENTITY_INSERT [dbo].[clientes] ON;
    INSERT INTO [dbo].[clientes] ([id], [nombres], [apellidos], [cedula], [telefono], [correo], [direccion], [fecha_registro]) VALUES
    (1, N'Juan Carlos', N'Pérez Gómez', N'001-1234567-8', N'809-555-2001', N'juan.perez@gmail.com', N'Santo Domingo, Distrito Nacional', N'2026-01-15'),
    (2, N'María Elena', N'Rodríguez Santos', N'001-2345678-9', N'809-555-2002', N'maria.rodriguez@gmail.com', N'Santo Domingo Este', N'2026-02-10'),
    (3, N'Carlos Manuel', N'García López', N'001-3456789-0', N'829-555-2003', N'carlos.garcia@gmail.com', N'Santo Domingo Norte', N'2026-02-22'),
    (4, N'Ana Patricia', N'Martínez Díaz', N'001-4567890-1', N'849-555-2004', N'ana.martinez@gmail.com', N'Santiago de los Caballeros', N'2026-03-05'),
    (5, N'Luis Alberto', N'Sánchez Pérez', N'001-5678901-2', N'809-555-2005', N'luis.sanchez@gmail.com', N'San Cristóbal', N'2026-03-18'),
    (6, N'Carmen Rosa', N'Gómez Castillo', N'001-6789012-3', N'829-555-2006', N'carmen.gomez@gmail.com', N'La Vega', N'2026-04-02'),
    (7, N'Pedro Antonio', N'Fernández Reyes', N'001-7890123-4', N'849-555-2007', N'pedro.fernandez@gmail.com', N'Bonao, Monseñor Nouel', N'2026-04-14'),
    (8, N'Laura Isabel', N'Méndez Ramírez', N'001-8901234-5', N'809-555-2008', N'laura.mendez@gmail.com', N'Santo Domingo Oeste', N'2026-05-01'),
    (9, N'José Miguel', N'Ramírez Torres', N'001-9012345-6', N'829-555-2009', N'jose.ramirez@gmail.com', N'San Pedro de Macorís', N'2026-05-20'),
    (10, N'Daniela María', N'Castillo Herrera', N'001-0123456-7', N'849-555-2010', N'daniela.castillo@gmail.com', N'La Romana', N'2026-06-03'),
    (11, N'Miguel Ángel', N'Torres Jiménez', N'001-1122334-5', N'809-555-2011', N'miguel.torres@gmail.com', N'Puerto Plata', N'2026-06-17'),
    (12, N'Patricia Elena', N'Reyes Cruz', N'001-2233445-6', N'829-555-2012', N'patricia.reyes@gmail.com', N'Baní, Peravia', N'2026-07-01'),
    (13, N'Roberto José', N'Díaz Santana', N'001-3344556-7', N'849-555-2013', N'roberto.diaz@gmail.com', N'Santo Domingo Este', N'2026-07-19'),
    (14, N'Sofía Carolina', N'Herrera Núñez', N'001-4455667-8', N'809-555-2014', N'sofia.herrera@gmail.com', N'Santiago de los Caballeros', N'2026-08-04'),
    (15, N'Andrés Felipe', N'Núñez Vargas', N'001-5566778-9', N'829-555-2015', N'andres.nunez@gmail.com', N'Santo Domingo, Distrito Nacional', N'2026-08-25')
    ;
    SET IDENTITY_INSERT [dbo].[clientes] OFF;

    SET IDENTITY_INSERT [dbo].[compras] ON;
    INSERT INTO [dbo].[compras] ([id], [id_proveedor], [fecha], [subtotal], [impuestos], [total], [metodo_pago], [estado]) VALUES
    (11, 1, N'2026-01-10', 150000.00, 27000.00, 177000.00, N'Transferencia', N'Completada'),
    (12, 2, N'2026-01-22', 85000.00, 15300.00, 100300.00, N'Transferencia', N'Completada'),
    (13, 3, N'2026-02-05', 220000.00, 39600.00, 259600.00, N'Crédito', N'Completada'),
    (14, 4, N'2026-02-18', 95000.00, 17100.00, 112100.00, N'Efectivo', N'Completada'),
    (15, 5, N'2026-03-02', 125000.00, 22500.00, 147500.00, N'Transferencia', N'Completada'),
    (16, 1, N'2026-03-20', 180000.00, 32400.00, 212400.00, N'Crédito', N'Completada'),
    (17, 2, N'2026-04-08', 75000.00, 13500.00, 88500.00, N'Efectivo', N'Completada'),
    (18, 3, N'2026-05-15', 250000.00, 45000.00, 295000.00, N'Transferencia', N'Completada'),
    (19, 4, N'2026-06-12', 110000.00, 19800.00, 129800.00, N'Crédito', N'Completada'),
    (20, 5, N'2026-07-25', 140000.00, 25200.00, 165200.00, N'Transferencia', N'Completada')
    ;
    SET IDENTITY_INSERT [dbo].[compras] OFF;

    SET IDENTITY_INSERT [dbo].[detalle_compras] ON;
    INSERT INTO [dbo].[detalle_compras] ([id], [id_compra], [id_producto], [cantidad], [costo], [subtotal], [descuento]) VALUES
    (32, 11, 1, 3, 35000.00, 105000.00, 0.00),
    (33, 11, 7, 3, 10000.00, 30000.00, 0.00),
    (34, 11, 10, 6, 2500.00, 15000.00, 0.00),
    (35, 12, 2, 2, 30000.00, 60000.00, 0.00),
    (36, 12, 11, 10, 1000.00, 10000.00, 0.00),
    (37, 12, 12, 5, 3000.00, 15000.00, 0.00),
    (38, 13, 5, 4, 50000.00, 200000.00, 0.00),
    (39, 13, 10, 10, 2000.00, 20000.00, 0.00),
    (40, 14, 4, 3, 20000.00, 60000.00, 0.00),
    (41, 14, 6, 2, 15000.00, 30000.00, 0.00),
    (42, 14, 11, 5, 1000.00, 5000.00, 0.00),
    (43, 15, 13, 5, 12000.00, 60000.00, 0.00),
    (44, 15, 14, 3, 15000.00, 45000.00, 0.00),
    (45, 15, 15, 2, 10000.00, 20000.00, 0.00),
    (46, 16, 1, 3, 35000.00, 105000.00, 0.00),
    (47, 16, 3, 1, 40000.00, 40000.00, 0.00),
    (48, 16, 8, 2, 15000.00, 30000.00, 0.00),
    (49, 16, 11, 5, 1000.00, 5000.00, 0.00),
    (50, 17, 10, 10, 2000.00, 20000.00, 0.00),
    (51, 17, 11, 15, 1000.00, 15000.00, 0.00),
    (52, 17, 12, 10, 3000.00, 30000.00, 0.00),
    (53, 17, 9, 1, 10000.00, 10000.00, 0.00),
    (54, 18, 5, 4, 50000.00, 200000.00, 0.00),
    (55, 18, 4, 2, 20000.00, 40000.00, 0.00),
    (56, 18, 11, 10, 1000.00, 10000.00, 0.00),
    (57, 19, 7, 5, 10000.00, 50000.00, 0.00),
    (58, 19, 8, 2, 15000.00, 30000.00, 0.00),
    (59, 19, 9, 3, 10000.00, 30000.00, 0.00),
    (60, 20, 13, 5, 12000.00, 60000.00, 0.00),
    (61, 20, 14, 4, 15000.00, 60000.00, 0.00),
    (62, 20, 15, 2, 10000.00, 20000.00, 0.00)
    ;
    SET IDENTITY_INSERT [dbo].[detalle_compras] OFF;

    SET IDENTITY_INSERT [dbo].[detalle_ventas] ON;
    INSERT INTO [dbo].[detalle_ventas] ([id], [id_venta], [id_producto], [cantidad], [precio], [descuento], [subtotal]) VALUES
    (1, 1, 1, 1, 42500.00, 0.00, 42500.00),
    (2, 1, 11, 1, 1500.00, 0.00, 1500.00),
    (3, 2, 4, 1, 24500.00, 0.00, 24500.00),
    (4, 2, 11, 1, 1500.00, 0.00, 1500.00),
    (5, 3, 3, 1, 46500.00, 0.00, 46500.00),
    (6, 3, 7, 1, 12500.00, 0.00, 12500.00),
    (7, 4, 7, 1, 12500.00, 0.00, 12500.00),
    (8, 4, 10, 1, 2500.00, 0.00, 2500.00),
    (9, 5, 2, 1, 38500.00, 0.00, 38500.00),
    (10, 5, 10, 1, 2500.00, 0.00, 2500.00),
    (11, 5, 11, 4, 1500.00, 0.00, 6000.00),
    (12, 6, 5, 1, 62000.00, 0.00, 62000.00),
    (13, 6, 10, 1, 2500.00, 500.00, 2000.00),
    (14, 7, 6, 1, 16500.00, 0.00, 16500.00),
    (15, 7, 10, 1, 2500.00, 0.00, 2500.00),
    (16, 7, 11, 2, 1500.00, 0.00, 3000.00),
    (17, 8, 2, 1, 38500.00, 0.00, 38500.00),
    (18, 8, 11, 1, 1500.00, 1000.00, 500.00),
    (19, 9, 5, 1, 62000.00, 0.00, 62000.00),
    (20, 9, 10, 1, 2500.00, 0.00, 2500.00),
    (21, 9, 11, 4, 1500.00, 500.00, 5500.00),
    (22, 10, 6, 1, 16500.00, 0.00, 16500.00),
    (23, 10, 11, 1, 1500.00, 0.00, 1500.00)
    ;
    SET IDENTITY_INSERT [dbo].[detalle_ventas] OFF;

    SET IDENTITY_INSERT [dbo].[empleados] ON;
    INSERT INTO [dbo].[empleados] ([id], [nombres], [apellidos], [cedula], [cargo], [salario], [telefono], [correo], [estado]) VALUES
    (1, N'Ricardo Antonio', N'Méndez Pérez', N'001-1010101-1', N'Vendedor', 35000.00, N'809-555-3001', N'ricardo.mendez@tiendatech.com', N'Activo'),
    (2, N'Laura María', N'Gómez Rodríguez', N'001-2020202-2', N'Vendedor', 35000.00, N'809-555-3002', N'laura.gomez@tiendatech.com', N'Activo'),
    (3, N'Carlos José', N'Ramírez Santos', N'001-3030303-3', N'Vendedor', 38000.00, N'829-555-3003', N'carlos.ramirez@tiendatech.com', N'Activo'),
    (4, N'Patricia Elena', N'Fernández Díaz', N'001-4040404-4', N'Cajero', 32000.00, N'849-555-3004', N'patricia.fernandez@tiendatech.com', N'Activo'),
    (5, N'Miguel Ángel', N'Torres Castillo', N'001-5050505-5', N'Cajero', 32000.00, N'809-555-3005', N'miguel.torres@tiendatech.com', N'Activo'),
    (6, N'Ana Carolina', N'Martínez Reyes', N'001-6060606-6', N'Supervisora de Ventas', 48000.00, N'829-555-3006', N'ana.martinez@tiendatech.com', N'Activo'),
    (7, N'José Manuel', N'Sánchez Herrera', N'001-7070707-7', N'Encargado de Almacén', 42000.00, N'849-555-3007', N'jose.sanchez@tiendatech.com', N'Activo'),
    (8, N'Daniel Alberto', N'Pérez Núñez', N'001-8080808-8', N'Técnico', 40000.00, N'809-555-3008', N'daniel.perez@tiendatech.com', N'Activo'),
    (9, N'María Isabel', N'Rodríguez Vargas', N'001-9090909-9', N'Gerente', 75000.00, N'829-555-3009', N'maria.rodriguez@tiendatech.com', N'Activo'),
    (10, N'Roberto Luis', N'García Cruz', N'001-1112223-4', N'Vendedor', 36000.00, N'849-555-3010', N'roberto.garcia@tiendatech.com', N'Inactivo')
    ;
    SET IDENTITY_INSERT [dbo].[empleados] OFF;

    SET IDENTITY_INSERT [dbo].[productos] ON;
    INSERT INTO [dbo].[productos] ([id], [codigo], [nombre], [marca], [id_categoria], [precio], [existencia], [garantia], [estado]) VALUES
    (1, N'LAP001', N'Laptop Inspiron 15', N'Dell', 1, 42500.00, 10, N'1 año', N'Activo'),
    (2, N'LAP002', N'Laptop IdeaPad 3', N'Lenovo', 1, 38500.00, 8, N'1 año', N'Activo'),
    (3, N'LAP003', N'Laptop HP Pavilion 15', N'HP', 1, 46500.00, 5, N'1 año', N'Activo'),
    (4, N'CEL001', N'Galaxy A55', N'Samsung', 2, 24500.00, 15, N'1 año', N'Activo'),
    (5, N'CEL002', N'iPhone 15', N'Apple', 2, 62000.00, 7, N'1 año', N'Activo'),
    (6, N'CEL003', N'Redmi Note 13', N'Xiaomi', 2, 16500.00, 20, N'6 meses', N'Activo'),
    (7, N'MON001', N'Monitor 24 pulgadas', N'Dell', 3, 12500.00, 12, N'1 año', N'Activo'),
    (8, N'MON002', N'Monitor Gaming 27 pulgadas', N'AOC', 3, 18500.00, 6, N'1 año', N'Activo'),
    (9, N'MON003', N'Monitor 22 pulgadas', N'Samsung', 3, 10500.00, 10, N'1 año', N'Activo'),
    (10, N'ACC001', N'Teclado inalámbrico', N'Logitech', 4, 2500.00, 25, N'6 meses', N'Activo'),
    (11, N'ACC002', N'Mouse inalámbrico', N'Logitech', 4, 1500.00, 30, N'6 meses', N'Activo'),
    (12, N'ACC003', N'Audífonos USB', N'JBL', 4, 3200.00, 18, N'6 meses', N'Activo'),
    (13, N'IMP001', N'Impresora EcoTank L3250', N'Epson', 5, 14500.00, 8, N'1 año', N'Activo'),
    (14, N'IMP002', N'Impresora LaserJet', N'HP', 5, 18500.00, 5, N'1 año', N'Activo'),
    (15, N'IMP003', N'Impresora Multifuncional', N'Canon', 5, 13500.00, 4, N'1 año', N'Activo'),
    (17, N'IMP007', N'Mause para PC', N'HP', 6, 2000.00, 8, N'1 año', N'Activo')
    ;
    SET IDENTITY_INSERT [dbo].[productos] OFF;

    SET IDENTITY_INSERT [dbo].[proveedores] ON;
    INSERT INTO [dbo].[proveedores] ([id], [nombre], [rnc], [telefono], [correo], [direccion], [contacto], [estado]) VALUES
    (1, N'Tech Dominicana SRL', N'131456789', N'809-555-1001', N'ventas@techdominicana.com', N'Santo Domingo', N'Carlos Martínez', N'Activo'),
    (2, N'Compu Supply SRL', N'132567890', N'809-555-1002', N'ventas@compusupply.com', N'Santo Domingo', N'María Rodríguez', N'Activo'),
    (3, N'Importadora Digital SRL', N'130678901', N'809-555-1003', N'info@importadoradigital.com', N'Santiago', N'José Pérez', N'Activo'),
    (4, N'Caribbean Technology SRL', N'131789012', N'809-555-1004', N'ventas@caribbeantech.com', N'Santo Domingo', N'Ana Gómez', N'Activo'),
    (5, N'Soluciones Informáticas RD', N'132890123', N'809-555-1005', N'info@solucionesrd.com', N'La Vega', N'Pedro Sánchez', N'Activo')
    ;
    SET IDENTITY_INSERT [dbo].[proveedores] OFF;

    SET IDENTITY_INSERT [dbo].[ventas] ON;
    INSERT INTO [dbo].[ventas] ([id], [id_cliente], [id_empleado], [fecha], [subtotal], [impuestos], [total], [metodo_pago], [estado]) VALUES
    (1, 1, 1, N'2026-08-01', 44000.00, 7920.00, 51920.00, N'Tarjeta', N'Completada'),
    (2, 2, 2, N'2026-08-03', 26000.00, 4680.00, 30680.00, N'Efectivo', N'Completada'),
    (3, 3, 3, N'2026-08-05', 59000.00, 10620.00, 69620.00, N'Transferencia', N'Completada'),
    (4, 4, 1, N'2026-08-08', 15000.00, 2700.00, 17700.00, N'Tarjeta', N'Completada'),
    (5, 5, 2, N'2026-08-10', 47000.00, 8460.00, 55460.00, N'Efectivo', N'Completada'),
    (6, 6, 3, N'2026-08-12', 64000.00, 11520.00, 75520.00, N'Transferencia', N'Completada'),
    (7, 7, 4, N'2026-08-15', 22000.00, 3960.00, 25960.00, N'Tarjeta', N'Completada'),
    (8, 8, 5, N'2026-08-18', 39000.00, 7020.00, 46020.00, N'Efectivo', N'Completada'),
    (9, 9, 6, N'2026-08-21', 70000.00, 12600.00, 82600.00, N'Transferencia', N'Completada'),
    (10, 10, 1, N'2026-08-25', 18000.00, 3240.00, 21240.00, N'Tarjeta', N'Completada')
    ;
    SET IDENTITY_INSERT [dbo].[ventas] OFF;

    CREATE INDEX [IX_compras_id_proveedor] ON [dbo].[compras] ([id_proveedor]);
    CREATE INDEX [IX_detalle_compras_id_compra] ON [dbo].[detalle_compras] ([id_compra]);
    CREATE INDEX [IX_detalle_compras_id_producto] ON [dbo].[detalle_compras] ([id_producto]);
    CREATE INDEX [IX_detalle_ventas_id_venta] ON [dbo].[detalle_ventas] ([id_venta]);
    CREATE INDEX [IX_detalle_ventas_id_producto] ON [dbo].[detalle_ventas] ([id_producto]);
    CREATE INDEX [IX_productos_id_categoria] ON [dbo].[productos] ([id_categoria]);
    CREATE INDEX [IX_proveedores_productos_id_proveedor] ON [dbo].[proveedores_productos] ([id_proveedor]);
    CREATE INDEX [IX_proveedores_productos_id_producto] ON [dbo].[proveedores_productos] ([id_producto]);
    CREATE INDEX [IX_ventas_id_cliente] ON [dbo].[ventas] ([id_cliente]);
    CREATE INDEX [IX_ventas_id_empleado] ON [dbo].[ventas] ([id_empleado]);

    ALTER TABLE [dbo].[compras] WITH CHECK ADD CONSTRAINT [compras_ibfk_1] FOREIGN KEY ([id_proveedor]) REFERENCES [dbo].[proveedores] ([id]);
    ALTER TABLE [dbo].[compras] CHECK CONSTRAINT [compras_ibfk_1];

    ALTER TABLE [dbo].[detalle_compras] WITH CHECK ADD CONSTRAINT [detalle_compras_ibfk_1] FOREIGN KEY ([id_compra]) REFERENCES [dbo].[compras] ([id]);
    ALTER TABLE [dbo].[detalle_compras] CHECK CONSTRAINT [detalle_compras_ibfk_1];

    ALTER TABLE [dbo].[detalle_compras] WITH CHECK ADD CONSTRAINT [detalle_compras_ibfk_2] FOREIGN KEY ([id_producto]) REFERENCES [dbo].[productos] ([id]);
    ALTER TABLE [dbo].[detalle_compras] CHECK CONSTRAINT [detalle_compras_ibfk_2];

    ALTER TABLE [dbo].[detalle_ventas] WITH CHECK ADD CONSTRAINT [detalle_ventas_ibfk_1] FOREIGN KEY ([id_venta]) REFERENCES [dbo].[ventas] ([id]);
    ALTER TABLE [dbo].[detalle_ventas] CHECK CONSTRAINT [detalle_ventas_ibfk_1];

    ALTER TABLE [dbo].[detalle_ventas] WITH CHECK ADD CONSTRAINT [detalle_ventas_ibfk_2] FOREIGN KEY ([id_producto]) REFERENCES [dbo].[productos] ([id]);
    ALTER TABLE [dbo].[detalle_ventas] CHECK CONSTRAINT [detalle_ventas_ibfk_2];

    ALTER TABLE [dbo].[productos] WITH CHECK ADD CONSTRAINT [productos_ibfk_1] FOREIGN KEY ([id_categoria]) REFERENCES [dbo].[categorias] ([id]);
    ALTER TABLE [dbo].[productos] CHECK CONSTRAINT [productos_ibfk_1];

    ALTER TABLE [dbo].[proveedores_productos] WITH CHECK ADD CONSTRAINT [proveedores_productos_ibfk_1] FOREIGN KEY ([id_proveedor]) REFERENCES [dbo].[proveedores] ([id]);
    ALTER TABLE [dbo].[proveedores_productos] CHECK CONSTRAINT [proveedores_productos_ibfk_1];

    ALTER TABLE [dbo].[proveedores_productos] WITH CHECK ADD CONSTRAINT [proveedores_productos_ibfk_2] FOREIGN KEY ([id_producto]) REFERENCES [dbo].[productos] ([id]);
    ALTER TABLE [dbo].[proveedores_productos] CHECK CONSTRAINT [proveedores_productos_ibfk_2];

    ALTER TABLE [dbo].[ventas] WITH CHECK ADD CONSTRAINT [fk_ventas_empleados] FOREIGN KEY ([id_empleado]) REFERENCES [dbo].[empleados] ([id]);
    ALTER TABLE [dbo].[ventas] CHECK CONSTRAINT [fk_ventas_empleados];

    ALTER TABLE [dbo].[ventas] WITH CHECK ADD CONSTRAINT [ventas_ibfk_1] FOREIGN KEY ([id_cliente]) REFERENCES [dbo].[clientes] ([id]);
    ALTER TABLE [dbo].[ventas] CHECK CONSTRAINT [ventas_ibfk_1];

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
