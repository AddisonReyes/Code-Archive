USE [tienda_tecnologia_db];
GO

SELECT id, id_cliente, id_empleado, fecha, subtotal, impuestos, total, metodo_pago, estado
FROM dbo.ventas
WHERE 
	metodo_pago = N'Transferencia' AND
	total > 20000
