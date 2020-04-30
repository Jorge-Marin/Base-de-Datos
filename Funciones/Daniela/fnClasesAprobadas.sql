-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 22-04-2020
-- Description:	Conteo de cuantas clases aprobadas lleva un estudiante y el porcentaje
-- =============================================
CREATE FUNCTION fnCantClasesAprobadas
(	
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15),
	@carrera VARCHAR(7)
)
RETURNS VARCHAR(100) 
AS
BEGIN
	DECLARE @retorno VARCHAR(100);
	DECLARE @porcentaje INT;
	
	SET @retorno = (SELECT COUNT([cuentaEstudiante]) 'Cantidad de Clases Aprobadas'
					FROM Registro.smregistro.HistorialAcademico 
						WHERE [cuentaEstudiante]= @cuentaEstudiante 
						AND [codCarrera]=@carrera AND 
						[calificacion]>=65);

	SET @porcentaje = (SELECT (@retorno*100)/COUNT(codCarreraFF) 
					FROM Registro.smregistro.PlanEstudio 
						WHERE codCarreraFF = @carrera);


	RETURN CONCAT('--Cantidad de asignaturas aprobadas: ',@retorno, ' --porcentaje de la carrera: ',@porcentaje,'%')
END
GO
--PRINT [dbo].[fnCantClasesAprobadas]('20171004244','IS01')

