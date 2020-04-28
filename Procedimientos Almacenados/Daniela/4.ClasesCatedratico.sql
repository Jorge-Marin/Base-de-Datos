USE [Registro]
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
USE [Registro]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description:	Mostrar que clases imparte un catedrático
-- =============================================
ALTER PROCEDURE [dbo].[clasesCatedratico]
	@catedratico VARCHAR(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF(@catedratico IN (SELECT codCatedratico FROM [smregistro].[Catedratico]))
		BEGIN 
			SELECT  smregistro.Empleado.primerNombre,
			smregistro.Empleado.apellidoPaterno,
			smregistro.Seccion.codAsignatura,
			nombreAsignatura,codSeccion FROM smregistro.Seccion
			INNER JOIN smregistro.Catedratico
			ON smregistro.Catedratico.codCatedratico = smregistro.Seccion.codCatedratico
			INNER JOIN smregistro.Empleado 
			ON smregistro.Empleado.codEmpleado = smregistro.Catedratico.codEmpleado
			INNER JOIN smregistro.Asignatura 
			ON smregistro.Asignatura.codAsignatura = smregistro.Seccion.codAsignatura
			WHERE smregistro.Seccion.codCatedratico = @catedratico 
		END
	ELSE
		BEGIN
		PRINT 'Código de catedrático inválido'
		END
END
GO