-- =============================================
-- Author:		Jorge Marin
-- Create date: 21/04/2020
-- Description:	Calcula el indice global de un estudiante, dado el numero de cuenta
-- y dado el codigo de carrera
-- =============================================
CREATE FUNCTION smregistro.getGlobalIndex
(
	@numeroCuenta VARCHAR(15),
	@codCarrera VARCHAR(7)
)
RETURNS INT
AS
	BEGIN
	
		 RETURN ISNULL((SELECT (SUM(Ha.calificacion * Ag.unidadesValorativas)/SUM(Ag.unidadesValorativas)) [Indice del Periodo] 
								FROM Registro.smregistro.HistorialAcademico Ha
									INNER JOIN Registro.smregistro.Asignatura Ag
									ON Ha.codAsignatura = Ag.codAsignatura
									WHERE codCarrera = @codCarrera
										AND cuentaEstudiante = @numeroCuenta), 0);

	END
GO
