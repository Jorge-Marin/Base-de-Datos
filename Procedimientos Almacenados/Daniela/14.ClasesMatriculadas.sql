USE [Registro]
GO
/****** Object:  StoredProcedure [dbo].[clasesCatedratico]    Script Date: 7/4/2020 9:57:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description:	Muestra las clases matriculadas de un estudiante en el periodo Actual
-- =============================================
CREATE PROCEDURE [dbo].[clasesMatriculadas]
	@cuentaEstudiante VARCHAR(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @codPeriodoActual int

	SET @codPeriodoActual = (SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1) --sabemos que es el periodo actual por su atributo activo


    IF(@cuentaEstudiante IN (SELECT [numCuenta] FROM [smregistro].[Estudiante]))
		BEGIN 
			SELECT  [cuentaEstudiante],[codAsignatura],[codSeccionClase],[codCarrera] FROM [smregistro].[MatriculaClase]
			WHERE @cuentaEstudiante = [cuentaEstudiante]
			AND @codPeriodoActual = [codperiodo]
		END
	ELSE
		BEGIN
		PRINT 'Cuenta de estudiante inválida'
		END
END
