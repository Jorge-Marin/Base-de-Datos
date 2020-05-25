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
CREATE PROCEDURE smregistro.spClasesCatedratico
	@catedratico VARCHAR(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF(@catedratico IN (SELECT codCatedratico FROM [smregistro].[Catedratico]))
		BEGIN 
			SELECT  E.primerNombre,
					E.apellidoPaterno,
					S.codAsignatura,
					A.nombreAsignatura,
					S.codSeccion 
				FROM smregistro.Seccion AS S
					INNER JOIN smregistro.Catedratico AS C
						ON C.codCatedratico = S.codCatedratico
					INNER JOIN smregistro.Empleado AS E 
						ON E.codEmpleado = C.codEmpleado
					INNER JOIN smregistro.Asignatura AS A
						ON A.codAsignatura = S.codAsignatura
					WHERE S.codCatedratico = @catedratico 
		END
	ELSE
		BEGIN
			PRINT 'Código de catedrático inválido'
		END
END
GO