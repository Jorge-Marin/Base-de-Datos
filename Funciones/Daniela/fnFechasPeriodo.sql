USE Registro
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 24-04-2020
-- Description:	Retorna la fecha de inicio y final del periodo actual
-- =============================================
CREATE FUNCTION smregistro.fnFechasPeriodo
()
RETURNS TABLE 
AS
RETURN 
(	
	
	SELECT Pe.periodo 'Periodo', 
	       YEAR(Pe.fechaInicio) 'año',
		   Pe.fechaInicio 'Fecha de Inicio', 
		   Pe.fechaFinal 'Fecha Final' 
		FROM Registro.smregistro.Periodo AS Pe
		WHERE activo = 1
)
GO
--SELECT * FROM smregistro.fnFechasPeriodo()