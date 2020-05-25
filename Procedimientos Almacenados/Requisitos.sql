
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description: Mostrar todos los requisitos que posee una clase dependiendo su carrera
-- =============================================
CREATE PROCEDURE smregistro.spRequisitos
	@codCarrera VARCHAR(7),
	@codClase VARCHAR(7)
AS
BEGIN

	SET NOCOUNT ON;

	IF(@codCarrera IN (SELECT [codCarrera] FROM [smregistro].[Carrera]) 
			AND @codClase IN (SELECT [codAsignatura] FROM [smregistro].[Asignatura]))
		BEGIN 
			SELECT Re.codAsignaturaFFR,Re.[codAsignarutaRequisitos], Asi.nombreAsignatura
				FROM [smregistro].[Requisitos] AS Re
					INNER JOIN smregistro.Asignatura AS Asi
						ON Asi.codAsignatura = Re.codAsignarutaRequisitos
				WHERE @codCarrera = [codCarreraFFR] AND @codClase = [codAsignaturaFFR]
		END
	ELSE
		BEGIN
			PRINT 'Verifique que sus codigos de carrera y asignatura sean los correctos';
		END
END
GO
/*smregistro.spRequisitos 'IS01','MM-201'*