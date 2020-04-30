-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funci�n que retorne la forma 03 de laboratorios de un estudiante espec�fico
-- =============================================

CREATE FUNCTION FnForma03Lab
(	 
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT  smregistro.MatriculaLab.codLab 'Cod Lab.' ,smregistro.MatriculaLab.codSeccionLab 'Secci�n',
	smregistro.MatriculaLab.codAsignatura 'Cod.',nombreAsignatura 'Asignatura',
	horaInicial 'HI',horaFinal 'HF', diaImparte 'Dias', nombreEdificio 'Edificio',
	smregistro.SeccionLab.codAula 'Aula',unidadesValorativas 'UV',
	observacion 'OBS',(SELECT periodo FROM smregistro.Periodo WHERE activo = 1) 'Periodo'

	FROM smregistro.MatriculaLab
		INNER JOIN smregistro.Asignatura 
			ON smregistro.MatriculaLab.codAsignatura = smregistro.Asignatura.codAsignatura
		INNER JOIN smregistro.Laboratorio
			ON smregistro.Laboratorio.codLaboratorio = smregistro.MatriculaLab.codLab
		INNER JOIN smregistro.SeccionLab
			ON smregistro.SeccionLab.codSeccion = smregistro.MatriculaLab.codSeccionLab
		INNER JOIN smregistro.Edificio
			ON smregistro.Edificio.codEdificio = smregistro.SeccionLab.codEdificioFF
		INNER JOIN smregistro.Aula
			ON smregistro.Aula.aula = smregistro.SeccionLab.codAula AND smregistro.Aula.codEdificioFF = smregistro.SeccionLab.codEdificioFF
	WHERE cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Lab]('20171004244')
