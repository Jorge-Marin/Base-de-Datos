-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 24-04-2020
-- Description:	Retorna la fecha de inicio y final del periodo actual
-- =============================================
CREATE FUNCTION fnFechasPeriodo
()
RETURNS TABLE 
AS
RETURN 
(	
	
	-- Add the SELECT statement with parameter references here
	SELECT periodo 'Periodo',YEAR(fechaInicio) 'a�o',fechaInicio 'Fecha de Inicio', fechaFinal 'Fecha Final' 
		FROM smregistro.Periodo
		WHERE activo = 1
)
GO
--SELECT * FROM [dbo].[fnFechasPeriodo]()