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
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 22-04-2020
-- Description:	Conteo de cuantas clases aprobadas lleva un estudiante
-- =============================================
CREATE FUNCTION fnCantClasesAprobadas
(	
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15),
	@carrera VARCHAR(7)
)
RETURNS VARCHAR(50) 
AS
BEGIN
	DECLARE @retorno INT 
	
	SET @retorno = (SELECT COUNT([cuentaEstudiante]) 'Cantidad de Clases Aprobadas'
					FROM  Registro.smregistro.HistorialAcademico AS r
						WHERE [cuentaEstudiante]=@cuentaEstudiante 
							AND  r.codCarrera=@carrera 
							AND r.calificacion>=65)
	RETURN CONCAT('Cantidad de asignaturas aprobadas: ',@retorno)
END
GO