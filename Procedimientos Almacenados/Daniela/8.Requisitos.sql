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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description: Mostrar todos los requisitos que posee una clase dependiendo su carrera
-- =============================================
CREATE PROCEDURE [dbo].[requisitos]
	-- Add the parameters for the stored procedure here
	@codCarrera VARCHAR(7),
	@codClase VARCHAR(7)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@codCarrera IN (SELECT [codCarrera] FROM [smregistro].[Carrera]) AND @codClase IN (SELECT [codAsignatura] FROM [smregistro].[Asignatura]))
	BEGIN 
		SELECT [codAsignarutaRequisitos] FROM [smregistro].[Requisitos]
		WHERE @codCarrera = [codCarreraFFR] AND @codClase = [codAsignaturaFFR]
	END
	ELSE
	BEGIN
	PRINT 'Uno de los códigos ingresados no es válido'
	END
END
GO