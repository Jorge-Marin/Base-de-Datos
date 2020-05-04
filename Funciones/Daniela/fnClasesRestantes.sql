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
-- Description:	cantidad y porcentaje de asignaturas restantes de un estudiante
-- =============================================

CREATE FUNCTION smregistro.fnCantClasesRestantes
(	
	-- Add the parameters for the function here
	@cuentaEstudiante VARCHAR(15),
	@carrera VARCHAR(7)
)
RETURNS VARCHAR(100) 
AS
BEGIN
	DECLARE @aprobadas INT 
	DECLARE @porcentaje FLOAT
	DECLARE @clasesRestantes INT
	
	
	SET @aprobadas = (SELECT COUNT([cuentaEstudiante]) 'Cantidad de Clases Aprobadas'
					FROM Registro.smregistro.HistorialAcademico AS H
						WHERE H.cuentaEstudiante=@cuentaEstudiante 
							AND H.codCarrera=@carrera 
							AND H.calificacion>=65);

	SET @porcentaje = (SELECT (@aprobadas*100)/COUNT(codCarreraFF) 
					FROM Registro.smregistro.PlanEstudio AS P
						WHERE P.codCarreraFF = @carrera);
	
	SET @clasesRestantes = (SELECT COUNT(*) 
					FROM Registro.smregistro.PlanEstudio AS P
						WHERE P.codCarreraFF = @carrera) - @aprobadas

	RETURN CONCAT('--Cantidad de asignaturas restantes: ',@clasesRestantes, ' --porcentaje de la carrera restante: ',100-@porcentaje,'%')
END
GO
--PRINT [dbo].[fnCantClasesAprobadas]('20171004244','IS01')
