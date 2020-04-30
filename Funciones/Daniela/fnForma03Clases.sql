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
-- Description:	Función que retorne la forma 03 de un estudiante específico
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
	smregistro.MatriculaClase.codSeccionClase 'Sección',horaInicial 'HI',horaFinal 'HF',
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
=======
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funciï¿½n que retorne la forma 03 de un estudiante especï¿½fico
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
	smregistro.MatriculaClase.codSeccionClase 'Secciï¿½n',horaInicial 'HI',horaFinal 'HF',
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
>>>>>>> 7c235eecb7af97d1c9d1a1a9c8b4946fe1f34bca
--SELECT * FROM [dbo].[FnForma03Clases]('20171004244')