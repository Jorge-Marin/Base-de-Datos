-- =============================================
-- Author:		Jorge Marin
-- Create date: 09/04/2020
-- Description:	Calcula el Indice Global De Un Estudiante
-- =============================================
CREATE PROCEDURE [smregistro].[spIndiceGlobal] 
	@numeroCuenta VARCHAR(15),
	@codCarrera VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;

    RETURN ISNULL((SELECT (SUM(Ha.calificacion * Ag.unidadesValorativas)/SUM(Ag.unidadesValorativas)) [Indice del Periodo] 
							FROM Registro.smregistro.HistorialAcademico Ha
								INNER JOIN Registro.smregistro.Asignatura Ag
								ON Ha.codAsignatura = Ag.codAsignatura
									WHERE codCarrera = @codCarrera
										AND cuentaEstudiante = @numeroCuenta), 0);
END
GO
