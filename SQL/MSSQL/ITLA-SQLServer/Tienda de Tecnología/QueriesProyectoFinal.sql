-- 1. Obtener todos los productos disponibles en la tienda. --
SELECT *
FROM productos
WHERE existencia > 0;

-- 2. Obtener el producto con mayor cantidad en stock. --
SELECT TOP 1 *
FROM productos
ORDER BY existencia DESC;

-- 3. Obtener el producto más caro. --
SELECT TOP 1 *
FROM productos
ORDER BY precio DESC;

-- 4. Calcular el precio promedio de todos los productos. --
SELECT AVG(precio) AS precio_promedio
FROM productos;

-- 5. Obtener los productos cuya marca sea "Samsung". --
SELECT *
FROM productos
WHERE marca = 'Samsung';

-- 6. Obtener los productos que tienen un precio entre $500 y $1000. --
SELECT *
FROM productos
WHERE precio BETWEEN 500 AND 1000;

-- 7. Calcular el número total de productos disponibles en la tienda. --
SELECT SUM(existencia) AS total_productos_disponibles
FROM productos;

-- 8. Obtener los productos que fueron ingresados al inventario en el año 2023. --
SELECT DISTINCT p.*
FROM productos AS p
INNER JOIN proveedores_productos AS pp
    ON p.id = pp.id_producto
WHERE YEAR(pp.fecha_registro) = 2023;

-- 9. Obtener el producto con el menor precio en la tabla de productos. --
SELECT TOP 1 *
FROM productos
ORDER BY precio ASC;

-- 10. Mostrar los productos cuyo nombre comienza con la letra 'A'. --
SELECT *
FROM productos
WHERE nombre LIKE 'A%';