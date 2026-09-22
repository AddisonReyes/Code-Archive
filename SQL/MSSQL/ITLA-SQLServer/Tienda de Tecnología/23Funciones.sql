-- Query #1
SELECT COUNT(*) AS cantidad_ventas
FROM ventas;

-- Query #2
SELECT SUM(total) AS total_vendido
FROM ventas;

-- Query #3
SELECT AVG(precio) AS precio_promedio
FROM productos;

-- Query #4
SELECT MAX(precio) AS precio_mayor
FROM productos;

-- Query #5
SELECT MIN(precio) AS precio_menor
FROM productos;

-- Query #6
SELECT CONCAT(nombres, ' ', apellidos) AS nombre_completo
FROM clientes;

-- Query #7
SELECT UPPER(nombre) AS producto
FROM productos;

-- Query #8
SELECT LOWER(nombre) AS producto
FROM productos;

-- Query #9
SELECT nombre, DATALENGTH(nombre) AS longitud
FROM productos;

-- Query #10
SELECT nombre, LEN(nombre) AS caracteres
FROM productos;

-- Query #11
SELECT TRIM(nombre) AS nombre_limpio
FROM productos;

-- Query #12
SELECT LTRIM(nombre) AS nombre_limpio
FROM productos;

-- Query #13
SELECT RTRIM(nombre) AS nombre_limpio
FROM productos;

-- Query #14
SELECT nombre, ROUND(precio, 0) AS precio_redondeado
FROM productos;

-- Query #15
SELECT fecha, YEAR(fecha) AS anio
FROM ventas;

-- Query #16
SELECT fecha, MONTH(fecha) AS mes
FROM ventas;

-- Query #17
SELECT fecha, DAY(fecha) AS dia
FROM ventas;

-- Query #18
SELECT GETDATE() AS fecha_hora_actual;

-- Query #19
SELECT CAST(GETDATE() AS date) AS fecha_actual;

-- Query #20
SELECT nombre, SUBSTRING(nombre, 1, 10) AS parte_nombre
FROM productos;

-- Query #21
SELECT nombre, LEFT(nombre, 5) AS inicio
FROM productos;

-- Query #22
SELECT codigo, RIGHT(codigo, 3) AS final_codigo
FROM productos;

-- Query #23
SELECT REPLACE(nombre, N'Laptop', N'Portátil') AS nombre_modificado
FROM productos;
