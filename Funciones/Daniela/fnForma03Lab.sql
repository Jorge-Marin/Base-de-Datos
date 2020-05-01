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
	
	SELECT  M.codLab 'Cod Lab.' ,M.codSeccionLab 'Sección',
	M.codAsignatura 'Cod.',A.nombreAsignatura 'Asignatura',
	S.horaInicial 'HI',S.horaFinal 'HF', S.diaImparte 'Dias', E.nombreEdificio 'Edificio',
	S.codAula 'Aula',A.unidadesValorativas 'UV',
	A.observacion 'OBS',(SELECT periodo FROM Registro.smregistro.Periodo WHERE activo = 1) 'Periodo'

		FROM  Registro.smregistro.MatriculaLab AS M
			INNER JOIN  Registro.smregistro.Asignatura AS A
				ON M.codAsignatura = A.codAsignatura
			INNER JOIN  Registro.smregistro.Laboratorio AS L
				ON L.codLaboratorio = M.codLab
			INNER JOIN  Registro.smregistro.SeccionLab AS S
				ON S.codSeccion = M.codSeccionLab
			INNER JOIN  Registro.smregistro.Edificio AS E
				ON E.codEdificio = S.codEdificioFF
			INNER JOIN  Registro.smregistro.Aula AS Au
				ON Au.aula = S.codAula AND Au.codEdificioFF = S.codEdificioFF
		WHERE M.cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Lab]('20171004244')
