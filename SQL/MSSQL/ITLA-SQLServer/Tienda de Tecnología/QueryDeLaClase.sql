SELECT *
FROM dbo.ventas
WHERE 
	metodo_pago = 'Transferencia' AND
	total > 20000