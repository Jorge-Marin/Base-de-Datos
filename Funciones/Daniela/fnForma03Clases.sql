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
	
	SELECT M.codAsignatura 'Cod.',nombreAsignatura 'Asignatura',
	M.codSeccionClase 'Secci�n',S.horaInicial 'HI',S.horaFinal 'HF',
	S.diaPresenciales 'Dias', E.nombreEdificio 'Edificio',S.aula 'Aula',A.unidadesValorativas 'UV',
	A.observacion 'OBS',(SELECT periodo FROM Registro.smregistro.Periodo WHERE activo = 1) 'Periodo'

		FROM Registro.smregistro.MatriculaClase AS M
			INNER JOIN Registro.smregistro.Asignatura AS A
				ON M.codAsignatura = A.codAsignatura
			INNER JOIN Registro.smregistro.Seccion AS S
				ON S.codSeccion = M.codSeccionClase
			INNER JOIN Registro.smregistro.Edificio AS E
				ON E.codEdificio = S.codEdificioFF
			INNER JOIN Registro.smregistro.Aula AS Au
				ON Au.aula = S.aula AND Au.codEdificioFF = S.codEdificioFF
		WHERE M.cuentaEstudiante = @cuentaEstudiante
GO
--SELECT * FROM [dbo].[FnForma03Clases]('20171004244')