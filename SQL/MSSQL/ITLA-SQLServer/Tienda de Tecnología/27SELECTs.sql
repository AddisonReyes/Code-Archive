USE tienda_tecnologia_db;
GO

--- Productos ---
SELECT nombre, marca, existencia
FROM dbo.productos
WHERE existencia <= 10
ORDER BY existencia;

SELECT id, codigo, nombre, marca, id_categoria, precio, existencia, garantia, estado
FROM dbo.productos
WHERE marca IN (N'HP', N'Canon', N'Samsung')
ORDER BY nombre;

SELECT codigo, nombre, precio
FROM dbo.productos
WHERE nombre LIKE N'Monitor%';

--- Clientes ---
SELECT id, nombres, apellidos, cedula, telefono, correo, direccion, fecha_registro
FROM dbo.clientes
WHERE fecha_registro >= '20260301'
  AND fecha_registro < '20260701';

SELECT nombres, apellidos, direccion
FROM dbo.clientes
WHERE direccion LIKE N'Santo Domingo%'
ORDER BY apellidos;

SELECT DISTINCT TOP 10 correo
FROM dbo.clientes
WHERE correo IS NOT NULL;

--- Proveedores ---
SELECT id, nombre, telefono, estado
FROM dbo.proveedores
WHERE estado = N'Activo'
ORDER BY nombre;

SELECT id, nombre, rnc, telefono, correo, direccion, contacto, estado
FROM dbo.proveedores
WHERE direccion NOT IN (N'Santo Domingo', N'Santiago');

SELECT nombre, contacto
FROM dbo.proveedores
WHERE contacto LIKE N'%a%';

--- Empleados ---
SELECT nombres, apellidos, cargo, salario
FROM dbo.empleados
WHERE salario >= 40000
ORDER BY salario DESC;

SELECT id, nombres, apellidos, cedula, cargo, salario, telefono, correo, estado
FROM dbo.empleados
WHERE estado = N'Activo'
  AND cargo IN (N'Vendedor', N'Cajero');

SELECT cargo, COUNT(*) AS cantidad
FROM dbo.empleados
GROUP BY cargo
ORDER BY cargo;

--- Categorias ---
SELECT nombre, descripcion
FROM dbo.categorias
WHERE estado = N'Activo';

SELECT id, nombre, descripcion, fecha_creacion, estado, observacion
FROM dbo.categorias
WHERE fecha_creacion >= '20260101'
  AND fecha_creacion < '20270101'
ORDER BY fecha_creacion DESC;

SELECT id, nombre, observacion
FROM dbo.categorias
WHERE observacion IS NOT NULL;

--- Compras ---
SELECT id, fecha, total
FROM dbo.compras
WHERE total > 150000
ORDER BY total DESC;

SELECT id, id_proveedor, fecha, subtotal, impuestos, total, metodo_pago, estado
FROM dbo.compras
WHERE metodo_pago IN (N'Transferencia', N'Crédito');

SELECT id, id_proveedor, fecha, subtotal, impuestos, total, metodo_pago, estado
FROM dbo.compras
WHERE id_proveedor = 1
  AND fecha >= '20260101'
  AND fecha < '20260401';

--- Detalle compras ---
SELECT id_compra, id_producto, cantidad, subtotal
FROM dbo.detalle_compras
WHERE cantidad >= 5;

SELECT id, id_compra, id_producto, cantidad, costo, subtotal, descuento
FROM dbo.detalle_compras
WHERE descuento = 0
ORDER BY id_compra ASC;

SELECT id_compra, COUNT(*) AS cantidad_productos
FROM dbo.detalle_compras
GROUP BY id_compra;

--- Ventas ---
SELECT id, id_cliente, id_empleado, fecha, total
FROM dbo.ventas
WHERE fecha >= '20260801'
  AND fecha < '20260901';

SELECT id, id_cliente, id_empleado, fecha, subtotal, impuestos, total, metodo_pago, estado
FROM dbo.ventas
WHERE metodo_pago IN (N'Tarjeta', N'Transferencia')
  AND total >= 50000;

SELECT TOP 5 id, id_cliente, id_empleado, fecha, subtotal, impuestos, total, metodo_pago, estado
FROM dbo.ventas
ORDER BY fecha DESC;

--- Detalle ventas ---
SELECT id_venta, id_producto, cantidad, precio, descuento, subtotal
FROM dbo.detalle_ventas
WHERE descuento > 0;

SELECT id, id_venta, id_producto, cantidad, precio, descuento, subtotal
FROM dbo.detalle_ventas
WHERE id_producto IN (1, 5, 10, 11);

SELECT id_venta, COUNT(*) AS lineas_venta
FROM dbo.detalle_ventas
GROUP BY id_venta
ORDER BY id_venta DESC;
