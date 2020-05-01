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

CREATE FUNCTION smregistro.FnProgramacionAcademica
(	 
	-- Add the parameters for the function here
	@codCarrera Varchar(7)
)
RETURNS TABLE 
AS

RETURN
	
	SELECT D.nombreDepartamento 'Departamento', 
			A.nombreAsignatura 'Asignatura',
			S.diaPresenciales 'Dias', 
			S.codSeccion 'Sección', 
			S.horaInicial 'HoraInicial',
			S.horaFinal 'HoraFinal'
		FROM Registro.smregistro.DepartamentosCarrera AS D
			INNER JOIN Registro.smregistro.Asignatura AS A
				ON D.codDepartamento = A.codDepartamentoFF
			INNER JOIN Registro.smregistro.Seccion AS S
				ON A.codAsignatura = S.codAsignatura
			INNER JOIN Registro.smregistro.CarreraDepartamento AS C
				ON D.codDepartamento = C.codDepartamentoFF
			WHERE C.codCarreraFF = @codCarrera

GO