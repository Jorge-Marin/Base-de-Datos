-- =============================================
-- Author:		Jorge Marin
-- Create date: 21/04/2020
-- Description:	Calcula el indice del ultimo periodo estudiado, resiviendo la 
-- el codigo de la carrera y el numero de cuenta
-- =============================================
CREATE FUNCTION  smregistro.getIndexPeriod
(	
	@codCarrera VARCHAR(7),
	@numeroCuenta VARCHAR(15)
)
RETURNS INT 
AS
	BEGIN 

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
