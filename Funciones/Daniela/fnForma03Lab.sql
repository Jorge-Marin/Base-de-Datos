-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funci�n que retorne la forma 03 de laboratorios de un estudiante espec�fico
-- =============================================

CREATE FUNCTION smregistro.FnForma03Lab
(	 
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT  Mab.codLab 'Cod Lab.',
			Mab.codSeccionLab 'Secci�n',
			Mab.codAsignatura 'Cod.',
			Asig.nombreAsignatura 'Asignatura',
			Sec.horaInicial 'HI',
			Sec.horaFinal 'HF', 
			Sec.diaImparte 'Dias', 
			Ed.nombreEdificio 'Edificio',
			Sec.codAula 'Aula',
			Asig.unidadesValorativas 'UV',
			Asig.observacion 'OBS',
			(SELECT periodo FROM Registro.smregistro.Periodo WHERE activo = 1) 'Periodo'

	FROM Registro.smregistro.MatriculaLab AS Mab
		INNER JOIN Registro.smregistro.Asignatura AS Asig 
			ON Mab.codAsignatura = Asig.codAsignatura
		INNER JOIN Registro.smregistro.Laboratorio AS Lab
			ON Lab.codLaboratorio = Mab.codLab
		INNER JOIN Registro.smregistro.SeccionLab AS Sec
			ON Sec.codSeccion = Mab.codSeccionLab
		INNER JOIN Registro.smregistro.Edificio AS Ed
 			ON Ed.codEdificio = Sec.codEdificioFF
		INNER JOIN Registro.smregistro.Aula AS Au
			ON Au.aula = Sec.codAula 
			AND Au.codEdificioFF = Sec.codEdificioFF
	WHERE cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Lab]('20171004244')
