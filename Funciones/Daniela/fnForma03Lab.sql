<<<<<<< HEAD
USE [Registro]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Función que retorne la forma 03 de laboratorios de un estudiante específico
-- =============================================

CREATE FUNCTION FnForma03Lab
(	 
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT  smregistro.MatriculaLab.codLab 'Cod Lab.' ,smregistro.MatriculaLab.codSeccionLab 'Sección',
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
=======
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funciï¿½n que retorne la forma 03 de laboratorios de un estudiante especï¿½fico
-- =============================================

CREATE FUNCTION FnForma03Lab
(	 
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT  smregistro.MatriculaLab.codLab 'Cod Lab.' ,smregistro.MatriculaLab.codSeccionLab 'Secciï¿½n',
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
>>>>>>> 7c235eecb7af97d1c9d1a1a9c8b4946fe1f34bca
