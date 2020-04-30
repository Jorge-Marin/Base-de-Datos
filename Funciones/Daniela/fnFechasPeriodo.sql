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
-- Create date: 24-04-2020
-- Description:	Retorna la fecha de inicio y final del periodo actual
-- =============================================
CREATE FUNCTION fnFechasPeriodo
(	
	-- Add the parameters for the function here

)
RETURNS TABLE 
AS
RETURN 
(	
	
	-- Add the SELECT statement with parameter references here
	SELECT periodo 'Periodo',YEAR(fechaInicio) 'año',fechaInicio 'Fecha de Inicio', fechaFinal 'Fecha Final' 
		FROM smregistro.Periodo
		WHERE activo = 1
)
GO
--SELECT * FROM [dbo].[fnFechasPeriodo]()