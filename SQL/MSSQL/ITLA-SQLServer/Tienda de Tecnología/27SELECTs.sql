USE tienda_tecnologia_db;
GO

--- Productos ---
SELECT nombre, marca, existencia
FROM dbo.productos
WHERE existencia <= 10
ORDER BY existencia;

SELECT *
FROM dbo.productos
WHERE marca IN ('HP', 'Canon', 'Samsung')
ORDER BY nombre;

SELECT codigo, nombre, precio
FROM dbo.productos
WHERE nombre LIKE '%Monitor%';

--- Clientes ---
SELECT *
FROM dbo.clientes
WHERE fecha_registro BETWEEN '03/01/2026' AND '06/30/2026';

SELECT nombres, apellidos, direccion
FROM dbo.clientes
WHERE direccion LIKE '%Santo Domingo%'
ORDER BY apellidos;

SELECT DISTINCT TOP 10 correo
FROM dbo.clientes
WHERE correo IS NOT NULL

--- Proveedores ---
SELECT id, nombre, telefono, estado
FROM dbo.proveedores
WHERE estado = 'Activo'
ORDER BY nombre;

SELECT *
FROM dbo.proveedores
WHERE direccion NOT IN ('Santo Domingo', 'Santiago');

SELECT nombre, contacto
FROM proveedores
WHERE contacto LIKE '%a%';

--- Empleados ---
SELECT nombres, apellidos, cargo, salario
FROM empleados
WHERE salario >= 40000
ORDER BY salario DESC;

SELECT *
FROM empleados
WHERE estado = 'Activo' AND 
	(cargo = 'Vendedor' OR cargo = 'Cajero');

SELECT cargo, COUNT(*) AS cantidad
FROM empleados
GROUP BY cargo
ORDER BY cargo;

--- Categorias ---
SELECT nombre, descripcion
FROM categorias
WHERE estado = 'Activo';

SELECT *
FROM categorias
WHERE fecha_creacion BETWEEN '01/01/2026' AND '12/31/2026'
ORDER BY fecha_creacion DESC;

SELECT id, nombre, observacion
FROM categorias
WHERE observacion IS NOT NULL;

--- Compras ---
SELECT id, fecha, total
FROM compras
WHERE total > 150000
ORDER BY total DESC;

SELECT *
FROM compras
WHERE metodo_pago IN ('Transferencia', 'Crédito');

SELECT *
FROM compras
WHERE id_proveedor = 1 AND 
	fecha BETWEEN '01/01/2026' AND '03/31/2026';

--- Detalle compras ---
SELECT id_compra, id_producto, cantidad, subtotal
FROM detalle_compras
WHERE cantidad >= 5;

SELECT *
FROM detalle_compras
WHERE descuento = 0
ORDER BY id_compra ASC;

SELECT id_compra, COUNT(*) AS cantidad_productos
FROM detalle_compras
GROUP BY id_compra;

--- Ventas ---
SELECT id, id_cliente, id_empleado, fecha, total
FROM ventas
WHERE fecha BETWEEN '08/01/2026' AND '08/31/2026';

SELECT *
FROM ventas
WHERE metodo_pago IN ('Tarjeta', 'Transferencia')
  AND total >= 50000;

SELECT TOP 5 *
FROM ventas
ORDER BY fecha DESC;

--- Detalle ventas ---
SELECT id_venta, id_producto, cantidad, precio, descuento, subtotal
FROM detalle_ventas
WHERE descuento > 0;

SELECT *
FROM detalle_ventas
WHERE id_producto IN (1, 5, 10, 11);

SELECT id_venta, COUNT(*) AS lineas_venta
FROM detalle_ventas
GROUP BY id_venta
ORDER BY id_venta DESC;