USE tienda_tecnologia_db;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'idx_producto_codigo'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX idx_producto_codigo
    ON dbo.productos(codigo);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'idx_producto_marca'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX idx_producto_marca
    ON dbo.productos(marca);
GO

IF COL_LENGTH(N'dbo.productos', N'modelo') IS NULL
    ALTER TABLE dbo.productos
    ADD modelo NVARCHAR(100) NULL;
GO

ALTER TABLE dbo.productos
ALTER COLUMN precio DECIMAL(12,2) NOT NULL;
GO

---

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'idx_producto_categoria_temp'
      AND object_id = OBJECT_ID(N'dbo.productos')
)
    CREATE INDEX idx_producto_categoria_temp
    ON dbo.productos(id_categoria);
GO

DROP INDEX idx_producto_categoria_temp
ON dbo.productos;
