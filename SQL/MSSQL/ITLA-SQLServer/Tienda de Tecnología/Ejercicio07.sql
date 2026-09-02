USE tienda_tecnologia_db;

CREATE INDEX idx_producto_codigo
ON productos(codigo);

CREATE INDEX idx_producto_marca
ON productos(marca);

ALTER TABLE productos
ADD modelo VARCHAR(100);

ALTER TABLE productos
ALTER COLUMN precio DECIMAL(12,2);

---

CREATE INDEX idx_producto_categoria_temp
ON productos(categoria);

DROP INDEX idx_producto_categoria_temp
ON productos;