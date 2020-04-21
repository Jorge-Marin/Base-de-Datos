-- =============================================
-- Author:		Jorge Marin
-- Create date: 07/04/2020
-- Description:	Muestra los Espacios Disponibles en Un Edificio.
-- =============================================
CREATE PROCEDURE [smregistro].[spEspaciosDisponibles] 
	@codEdificio INT, 
	@horaInicio TIME,
	@horaFinal TIME
AS
BEGIN
	
	SET NOCOUNT ON;

	PRINT 'Los espacios disponibles en el edificio a la hora especificada son:'
	SELECT Ed.nombreEdificio, Au.aula FROM Registro.smregistro.Edificio Ed
	INNER JOIN Registro.smregistro.Aula	Au
	ON Ed.codEdificio = Au.codEdificioFF
	WHERE Au.aula NOT IN (SELECT aula FROM Registro.smregistro.Seccion
		WHERE codEdificioFF = @codEdificio 
		AND horaInicial = @horaInicio
		AND horaFinal = @horaFinal)
		AND codEdificio = @codEdificio;

END
GO

