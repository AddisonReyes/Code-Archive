/*
    Optimizaciones para tienda_tecnologia_db.
    Ejecutar despues de InsertingData.sql.
*/

USE [tienda_tecnologia_db];
GO

SET NOCOUNT ON;
GO

/* Unicidad de datos maestros */
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_clientes_cedula'
      AND object_id = OBJECT_ID(N'dbo.clientes')
)
    CREATE UNIQUE INDEX [UX_clientes_cedula]
    ON [dbo].[clientes] ([cedula]);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_clientes_correo'
      AND object_id = OBJECT_ID(N'dbo.clientes')
)
    CREATE UNIQUE INDEX [UX_clientes_correo]
    ON [dbo].[clientes] ([correo])
    WHERE [correo] IS NOT NULL;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_empleados_cedula'
      AND object_id = OBJECT_ID(N'dbo.empleados')
)
    CREATE UNIQUE INDEX [UX_empleados_cedula]
    ON [dbo].[empleados] ([cedula]);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_empleados_correo'
      AND object_id = OBJECT_ID(N'dbo.empleados')
)
    CREATE UNIQUE INDEX [UX_empleados_correo]
    ON [dbo].[empleados] ([correo])
    WHERE [correo] IS NOT NULL;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_productos_codigo'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE UNIQUE INDEX [UX_productos_codigo]
    ON [dbo].[productos] ([codigo]);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_proveedores_rnc'
      AND object_id = OBJECT_ID(N'dbo.proveedores')
)
    CREATE UNIQUE INDEX [UX_proveedores_rnc]
    ON [dbo].[proveedores] ([rnc]);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_proveedores_correo'
      AND object_id = OBJECT_ID(N'dbo.proveedores')
)
    CREATE UNIQUE INDEX [UX_proveedores_correo]
    ON [dbo].[proveedores] ([correo])
    WHERE [correo] IS NOT NULL;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_proveedores_productos_proveedor_producto'
      AND object_id = OBJECT_ID(N'dbo.proveedores_productos')
)
    CREATE UNIQUE INDEX [UX_proveedores_productos_proveedor_producto]
    ON [dbo].[proveedores_productos] ([id_proveedor], [id_producto]);
GO

/* Validaciones de integridad */
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_productos_precio_existencia'
      AND parent_object_id = OBJECT_ID(N'dbo.productos')
)
BEGIN
    ALTER TABLE [dbo].[productos] WITH CHECK
    ADD CONSTRAINT [CK_productos_precio_existencia]
    CHECK ([precio] >= 0 AND [existencia] >= 0);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_clientes_correo_formato'
      AND parent_object_id = OBJECT_ID(N'dbo.clientes')
)
BEGIN
    ALTER TABLE [dbo].[clientes] WITH CHECK
    ADD CONSTRAINT [CK_clientes_correo_formato]
    CHECK ([correo] IS NULL OR [correo] LIKE N'%_@_%._%');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_empleados_correo_formato'
      AND parent_object_id = OBJECT_ID(N'dbo.empleados')
)
BEGIN
    ALTER TABLE [dbo].[empleados] WITH CHECK
    ADD CONSTRAINT [CK_empleados_correo_formato]
    CHECK ([correo] IS NULL OR [correo] LIKE N'%_@_%._%');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_proveedores_correo_formato'
      AND parent_object_id = OBJECT_ID(N'dbo.proveedores')
)
BEGIN
    ALTER TABLE [dbo].[proveedores] WITH CHECK
    ADD CONSTRAINT [CK_proveedores_correo_formato]
    CHECK ([correo] IS NULL OR [correo] LIKE N'%_@_%._%');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_empleados_salario'
      AND parent_object_id = OBJECT_ID(N'dbo.empleados')
)
BEGIN
    ALTER TABLE [dbo].[empleados] WITH CHECK
    ADD CONSTRAINT [CK_empleados_salario]
    CHECK ([salario] IS NULL OR [salario] >= 0);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_compras_importes'
      AND parent_object_id = OBJECT_ID(N'dbo.compras')
)
BEGIN
    ALTER TABLE [dbo].[compras] WITH CHECK
    ADD CONSTRAINT [CK_compras_importes]
    CHECK (
        [subtotal] >= 0
        AND ([impuestos] IS NULL OR [impuestos] >= 0)
        AND [total] >= 0
        AND ([impuestos] IS NULL OR [total] = [subtotal] + [impuestos])
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_ventas_importes'
      AND parent_object_id = OBJECT_ID(N'dbo.ventas')
)
BEGIN
    ALTER TABLE [dbo].[ventas] WITH CHECK
    ADD CONSTRAINT [CK_ventas_importes]
    CHECK (
        [subtotal] >= 0
        AND ([impuestos] IS NULL OR [impuestos] >= 0)
        AND [total] >= 0
        AND ([impuestos] IS NULL OR [total] = [subtotal] + [impuestos])
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_detalle_compras_importes'
      AND parent_object_id = OBJECT_ID(N'dbo.detalle_compras')
)
BEGIN
    ALTER TABLE [dbo].[detalle_compras] WITH CHECK
    ADD CONSTRAINT [CK_detalle_compras_importes]
    CHECK (
        [cantidad] > 0
        AND [costo] >= 0
        AND ([descuento] IS NULL OR [descuento] >= 0)
        AND [subtotal] >= 0
        AND ([descuento] IS NULL OR [subtotal] = ([cantidad] * [costo]) - [descuento])
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_detalle_ventas_importes'
      AND parent_object_id = OBJECT_ID(N'dbo.detalle_ventas')
)
BEGIN
    ALTER TABLE [dbo].[detalle_ventas] WITH CHECK
    ADD CONSTRAINT [CK_detalle_ventas_importes]
    CHECK (
        [cantidad] > 0
        AND [precio] >= 0
        AND ([descuento] IS NULL OR [descuento] >= 0)
        AND [subtotal] >= 0
        AND ([descuento] IS NULL OR [subtotal] = ([cantidad] * [precio]) - [descuento])
    );
END;
GO

/* Indices orientados a los SELECTs del proyecto */
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_productos_existencia_estado'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX [IX_productos_existencia_estado]
    ON [dbo].[productos] ([existencia], [estado])
    INCLUDE ([nombre], [marca], [precio]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_productos_marca_nombre'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX [IX_productos_marca_nombre]
    ON [dbo].[productos] ([marca], [nombre])
    INCLUDE ([codigo], [precio], [existencia], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_productos_nombre'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX [IX_productos_nombre]
    ON [dbo].[productos] ([nombre])
    INCLUDE ([codigo], [marca], [precio], [existencia], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_clientes_fecha_registro'
      AND object_id = OBJECT_ID(N'dbo.clientes')
)
    CREATE INDEX [IX_clientes_fecha_registro]
    ON [dbo].[clientes] ([fecha_registro])
    INCLUDE ([nombres], [apellidos], [direccion], [correo]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_clientes_direccion_apellidos'
      AND object_id = OBJECT_ID(N'dbo.clientes')
)
    CREATE INDEX [IX_clientes_direccion_apellidos]
    ON [dbo].[clientes] ([direccion], [apellidos])
    INCLUDE ([nombres]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_proveedores_estado_nombre'
      AND object_id = OBJECT_ID(N'dbo.proveedores')
)
    CREATE INDEX [IX_proveedores_estado_nombre]
    ON [dbo].[proveedores] ([estado], [nombre])
    INCLUDE ([telefono]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_proveedores_direccion'
      AND object_id = OBJECT_ID(N'dbo.proveedores')
)
    CREATE INDEX [IX_proveedores_direccion]
    ON [dbo].[proveedores] ([direccion])
    INCLUDE ([nombre], [telefono], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_empleados_salario'
      AND object_id = OBJECT_ID(N'dbo.empleados')
)
    CREATE INDEX [IX_empleados_salario]
    ON [dbo].[empleados] ([salario])
    INCLUDE ([nombres], [apellidos], [cargo]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_empleados_estado_cargo'
      AND object_id = OBJECT_ID(N'dbo.empleados')
)
    CREATE INDEX [IX_empleados_estado_cargo]
    ON [dbo].[empleados] ([estado], [cargo])
    INCLUDE ([nombres], [apellidos], [salario]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_compras_total'
      AND object_id = OBJECT_ID(N'dbo.compras')
)
    CREATE INDEX [IX_compras_total]
    ON [dbo].[compras] ([total])
    INCLUDE ([fecha], [metodo_pago], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_compras_metodo_pago_total'
      AND object_id = OBJECT_ID(N'dbo.compras')
)
    CREATE INDEX [IX_compras_metodo_pago_total]
    ON [dbo].[compras] ([metodo_pago], [total])
    INCLUDE ([fecha], [id_proveedor], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_compras_proveedor_fecha'
      AND object_id = OBJECT_ID(N'dbo.compras')
)
    CREATE INDEX [IX_compras_proveedor_fecha]
    ON [dbo].[compras] ([id_proveedor], [fecha])
    INCLUDE ([subtotal], [impuestos], [total], [metodo_pago], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_detalle_compras_cantidad'
      AND object_id = OBJECT_ID(N'dbo.detalle_compras')
)
    CREATE INDEX [IX_detalle_compras_cantidad]
    ON [dbo].[detalle_compras] ([cantidad])
    INCLUDE ([id_compra], [id_producto], [subtotal]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_detalle_compras_descuento'
      AND object_id = OBJECT_ID(N'dbo.detalle_compras')
)
    CREATE INDEX [IX_detalle_compras_descuento]
    ON [dbo].[detalle_compras] ([descuento])
    INCLUDE ([id_compra], [id_producto], [cantidad], [subtotal]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_ventas_fecha_total'
      AND object_id = OBJECT_ID(N'dbo.ventas')
)
    CREATE INDEX [IX_ventas_fecha_total]
    ON [dbo].[ventas] ([fecha], [total])
    INCLUDE ([id_cliente], [id_empleado], [subtotal], [impuestos], [metodo_pago], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_ventas_metodo_pago_total'
      AND object_id = OBJECT_ID(N'dbo.ventas')
)
    CREATE INDEX [IX_ventas_metodo_pago_total]
    ON [dbo].[ventas] ([metodo_pago], [total])
    INCLUDE ([id_cliente], [id_empleado], [fecha], [subtotal], [impuestos], [estado]);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_detalle_ventas_descuento'
      AND object_id = OBJECT_ID(N'dbo.detalle_ventas')
)
    CREATE INDEX [IX_detalle_ventas_descuento]
    ON [dbo].[detalle_ventas] ([descuento])
    INCLUDE ([id_venta], [id_producto], [cantidad], [precio], [subtotal]);
GO

EXEC sys.sp_updatestats;
GO
