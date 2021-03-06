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
-- Description:Muestra el aula y edificio donde imparte o imparti� una determinada seccion un docente en un determinado periodo
-- =============================================================================================================================
CREATE PROCEDURE smregistro.spSeccionDocente
	@seccionClase int,
	@codAsignatura VARCHAR(7),
	@codCatedratico VARCHAR(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF((SELECT [codSeccion] 
		FROM [smregistro].[Seccion] 
			WHERE @codAsignatura =[codAsignatura] 
				AND @seccionClase = [codSeccion] 
				AND @codCatedratico = [codCatedratico]) IS NOT NULL)
		BEGIN 
			SELECT  S.codSeccion,
					S.codAsignatura,
					E.nombreEdificio,
					S.aula
				FROM smregistro.Seccion AS S
					INNER JOIN smregistro.Edificio AS E
						ON S.codEdificioFF = E.codEdificio
							WHERE @codCatedratico = [codCatedratico] 
								AND @seccionClase = [codSeccion]
								AND @codAsignatura = [codAsignatura]
		END	
	ELSE
		BEGIN
			PRINT 'El docente con el c�digo proporcionado no tiene clases asignadas en ese periodo'
		END
END



