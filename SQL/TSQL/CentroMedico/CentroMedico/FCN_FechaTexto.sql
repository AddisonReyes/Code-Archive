CREATE OR ALTER FUNCTION FCN_FechaTexto (@Fecha DATETIME) 
RETURNS NVARCHAR(40) AS
BEGIN
	DECLARE @Dia AS NVARCHAR(20)
	DECLARE @Mes AS NVARCHAR(20)
	DECLARE @FechaTexto AS NVARCHAR(40)

	--SET @Dia = DATENAME(WEEKDAY, @Fecha)
	SET @Dia = (CASE 
		WHEN DATEPART(DW, @Fecha) = 1 THEN 'Domingo ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 2 THEN 'Lunes ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 3 THEN 'Martes ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 4 THEN 'Miercoles ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 5 THEN 'Jueves ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 6 THEN 'Viernes ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
		WHEN DATEPART(DW, @Fecha) = 7 THEN 'Sabado ' + CONVERT(CHAR(2), DATEPART(dd, @Fecha))
	END)

	SET @Mes = (CASE 
		WHEN DATEPART(M, @Fecha) = 1 THEN 'de Enero'
		WHEN DATEPART(M, @Fecha) = 2 THEN 'de Febrero'
		WHEN DATEPART(M, @Fecha) = 3 THEN 'de Marzo'
		WHEN DATEPART(M, @Fecha) = 4 THEN 'de Abril'
		WHEN DATEPART(M, @Fecha) = 5 THEN 'de Mayo'
		WHEN DATEPART(M, @Fecha) = 6 THEN 'de Junio'
		WHEN DATEPART(M, @Fecha) = 7 THEN 'de Julio'
		WHEN DATEPART(M, @Fecha) = 8 THEN 'de Agosto'
		WHEN DATEPART(M, @Fecha) = 9 THEN 'de Septiembre'
		WHEN DATEPART(M, @Fecha) = 10 THEN 'de Octubre'
		WHEN DATEPART(M, @Fecha) = 11 THEN 'de Noviembre'
		WHEN DATEPART(M, @Fecha) = 12 THEN 'de Diciembre'
	END)

	SET @FechaTexto = @Dia + @Mes + ' del ' + CAST(YEAR(@Fecha) AS NVARCHAR(4))
	RETURN @FechaTexto
END
GO

PRINT dbo.FCN_FechaTexto('03/02/2002')