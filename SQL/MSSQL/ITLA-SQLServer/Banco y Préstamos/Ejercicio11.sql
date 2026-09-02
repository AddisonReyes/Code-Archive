CREATE INDEX idx_cliente_cedula
ON clientes(cedula);

CREATE INDEX idx_cuenta_numero
ON cuentas(numero_cuenta);

ALTER TABLE prestamos
ADD garantia VARCHAR(200);