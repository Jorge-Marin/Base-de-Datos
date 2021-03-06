-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description:	Muestra las clases matriculadas de un estudiante en el periodo Actual
-- =============================================
CREATE PROCEDURE smregistro.spClasesMatriculadas
	@cuentaEstudiante VARCHAR(15)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @codPeriodoActual INT;
	SET @codPeriodoActual = (SELECT [codPeriodo] 
								FROM [smregistro].[Periodo] 
									WHERE [activo] = 1) --sabemos que es el periodo actual por su atributo activo


    IF(@cuentaEstudiante IN (SELECT [numCuenta] FROM [smregistro].[Estudiante]))
		BEGIN 
			SELECT  [cuentaEstudiante],
					[codAsignatura],
					[codSeccionClase],
					[codCarrera] 
				FROM [smregistro].[MatriculaClase]
					WHERE @cuentaEstudiante = [cuentaEstudiante]
					AND @codPeriodoActual = [codperiodo]
		END
	ELSE
		BEGIN
			PRINT 'Cuenta de estudiante inválida'
		END
END

smregistro.spClasesMatriculadas '20171004244'

select * from smregistro.MatriculaClase