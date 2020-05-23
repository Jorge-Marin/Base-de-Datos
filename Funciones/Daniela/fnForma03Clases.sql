USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funci�n que retorne la forma 03 de un estudiante espec�fico
-- =============================================

CREATE FUNCTION smregistro.FnForma03Clases
(	 
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT 	Ma.codAsignatura 'Cod.',
			Asig.nombreAsignatura 'Asignatura',
			Ma.codSeccionClase 'Secci�n',
			Se.horaInicial 'HI',
			Se.horaFinal 'HF',
			Se.diaPresenciales 'Dias', 
			Ed.nombreEdificio 'Edificio',
			Se.aula 'Aula',
			Asig.unidadesValorativas 'UV',
			Asig.observacion 'OBS',
			(SELECT periodo FROM Registro.smregistro.Periodo WHERE activo = 1) 'Periodo'

	FROM Registro.smregistro.MatriculaClase AS Ma 
		INNER JOIN Registro.smregistro.Asignatura AS Asig
			ON Ma.codAsignatura = Asig.codAsignatura
		INNER JOIN Registro.smregistro.Seccion AS Se
			ON Se.codSeccion = Ma.codSeccionClase
		INNER JOIN Registro.smregistro.Edificio AS Ed
			ON Ed.codEdificio = Se.codEdificioFF
		INNER JOIN Registro.smregistro.Aula AS Au
			ON Au.aula = Se.aula 
		AND Au.codEdificioFF = Se.codEdificioFF
	WHERE cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Clases]('20171004244')