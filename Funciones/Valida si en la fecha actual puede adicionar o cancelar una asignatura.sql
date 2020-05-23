USE Registro
GO
-- =============================================
-- Author:		Jorge Marin
-- Create date: 21/04/2020
-- Description:	Verifica si el periodo de adiciones o cancelacion esta habilitado
-- si no lo esta retornara 0 si lo esta retornara un 1
-- =============================================
CREATE FUNCTION [smregistro].[validDateCancelAsignature]
(
	@currentDate DATE
)
RETURNS BIT
AS
BEGIN
	
	DECLARE @beginAditions DATE;
	DECLARE @endAditios DATE;

	SELECT @beginAditions=inicioAdiciones, 
		   @endAditios=finalizaAdiciones 
		   FROM Registro.smregistro.Periodo 
		   WHERE activo = 1;

	IF(@beginAditions<=@currentDate AND @currentDate<=@endAditios)
		BEGIN 
			RETURN 1
		END

		
	RETURN 0
END
GO


