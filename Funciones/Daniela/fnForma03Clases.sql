-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funci�n que retorne la forma 03 de un estudiante espec�fico
-- =============================================

CREATE FUNCTION FnForma03Clases
(	 
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT smregistro.MatriculaClase.codAsignatura 'Cod.',nombreAsignatura 'Asignatura',
	smregistro.MatriculaClase.codSeccionClase 'Secci�n',horaInicial 'HI',horaFinal 'HF',
	diaPresenciales 'Dias', nombreEdificio 'Edificio',smregistro.Seccion.aula 'Aula',unidadesValorativas 'UV',
	observacion 'OBS',(SELECT periodo FROM smregistro.Periodo WHERE activo = 1) 'Periodo'

	FROM smregistro.MatriculaClase 
		INNER JOIN smregistro.Asignatura 
			ON smregistro.MatriculaClase.codAsignatura = smregistro.Asignatura.codAsignatura
		INNER JOIN smregistro.Seccion 
			ON smregistro.Seccion.codSeccion = smregistro.MatriculaClase.codSeccionClase
		INNER JOIN smregistro.Edificio
			ON smregistro.Edificio.codEdificio = smregistro.Seccion.codEdificioFF
		INNER JOIN smregistro.Aula
			ON smregistro.Aula.aula = smregistro.Seccion.aula AND smregistro.Aula.codEdificioFF = smregistro.Seccion.codEdificioFF
	WHERE cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Clases]('20171004244')