-- =============================================
-- Author:		Jorge Marin
-- Create date: 09/4/2020
-- Description:	Calcula el Indice del Ultimo Periodo matriculado
--por un alumno con su numero de carrera y numero de cuenta
/*
	1. Multiplica las unidades valorativas por la nota obtenida en cada una de las asignaturas para obtener 
	el producto o resultado de la multiplicaci�n. Espa�ol - 4 x 90 = 360. ...
	2. Suma el total de resultados y el total de unidades valorativas. ...
	3. Divide el total de resultados entre el total de unidades valorativas.
*/
-- =============================================
CREATE PROCEDURE [smregistro].[spIndicePeriodo]
	@codCarrera VARCHAR(7),
	@numeroCuenta VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ultimoPeriodo DATE; 
	DECLARE @indicePeriodo INT;
	DECLARE @codPeriodo INT

	/*Extrae la fecha del ultimo periodo para promediar su ultimo 
	periodo estudiado*/
	SELECT TOP(1) @ultimoPeriodo = fechaInicioPeriodo, @codPeriodo = codPeriodo
		FROM Registro.smregistro.HistorialAcademico 
		WHERE codCarrera = @codCarrera
			AND cuentaEstudiante = @numeroCuenta
		ORDER BY fechaInicioPeriodo DESC

	/*Retorna el Promedio del ultimo periodo estudiado*/
	RETURN ISNULL((SELECT (SUM(Ha.calificacion * Ag.unidadesValorativas)/SUM(Ag.unidadesValorativas)) [Indice del Periodo] 
							FROM Registro.smregistro.HistorialAcademico Ha
								INNER JOIN Registro.smregistro.Asignatura Ag
								ON Ha.codAsignatura = Ag.codAsignatura
									WHERE codCarrera = @codCarrera
										AND cuentaEstudiante = @numeroCuenta
										AND fechaInicioPeriodo = CAST(@ultimoPeriodo AS VARCHAR(15))),0);
		
END
GO

