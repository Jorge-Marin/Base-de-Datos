USE [Registro]
GO
/****** Object:  StoredProcedure [dbo].[clasesCatedratico]    Script Date: 7/4/2020 9:57:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description: Muestra el aula y edificio donde imparte o impartió una determinada seccion un docente en un determinado periodo
-- =============================================================================================================================
CREATE PROCEDURE [dbo].[seccionDocente]
	@seccionClase int,
	@codAsignatura VARCHAR(7),
	@codCatedratico VARCHAR(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF((SELECT [codSeccion] FROM [smregistro].[Seccion] WHERE @codAsignatura =[codAsignatura] AND @seccionClase = [codSeccion] AND 
		@codCatedratico = [codCatedratico]) IS NOT NULL)
		BEGIN 
			SELECT  [codSeccion],[codAsignatura],[nombreEdificio],[aula] FROM [smregistro].[Seccion] INNER JOIN [smregistro].[Edificio] 
			ON smregistro.Seccion.codEdificioFF = smregistro.Edificio.codEdificio
			WHERE @codCatedratico = [codCatedratico] AND @seccionClase = [codSeccion] AND @codAsignatura = [codAsignatura]
		END
	ELSE
		BEGIN
		PRINT 'El docente con el código proporcionado no tiene clases asignadas en ese periodo'
		END
END



