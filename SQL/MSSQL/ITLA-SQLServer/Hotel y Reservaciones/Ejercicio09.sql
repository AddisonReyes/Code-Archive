CREATE INDEX idx_huesped_documento
ON huespedes(documento);

CREATE INDEX idx_habitacion_numero
ON habitaciones(numero);

ALTER TABLE reservas
ADD observacion VARCHAR(255);

ALTER TABLE habitaciones
ALTER COLUMN descripcion VARCHAR(300);