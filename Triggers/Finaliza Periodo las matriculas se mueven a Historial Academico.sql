-- =============================================
-- Author:		Jorge Marin
-- Create date: 22/04/2020
-- Description: Cuando se terminen el periodo academico
-- se debe eliminar los registros de la tabla matricula 
-- y mudar los a la tabla historial academico
-- En combinacion con un Job
-- =============================================
CREATE TRIGGER [smregistro].[trFinalizePeriod]
   ON  [smregistro].[MatriculaClase]
   AFTER DELETE
AS 
BEGIN
	DECLARE @currentDate DATE;
	DECLARE @finalizaPeriodo DATE;
	DECLARE @obs VARCHAR(6);

	SET @currentDate = (SELECT GETDATE());
	SET @finalizaPeriodo = (SELECT fechaFinal FROM Registro.smregistro.Periodo 
								WHERE activo = 1)

	SET NOCOUNT ON;
	
	IF(CAST(@currentDate AS VARCHAR(12)) = @finalizaPeriodo)
		BEGIN
			/*
			El valor de observacion osea, APR, RPD, N/D, y otros
			se especifican desde un front end, y se actualizan en la tabla matricula, 
			y se pasa ese valor a observacion del Historial Academico.
			*/
			INSERT INTO Registro.smregistro.HistorialAcademico(
																codCarrera,
																cuentaEstudiante,
																codAsignatura, 
																seccion, 
																codPeriodo,
																fechaInicioPeriodo,
																calificacion, 
																observacion)
																SELECT De.codCarrera, 
																	   De.cuentaEstudiante,
																	   De.codAsignatura,
																	   codSeccionClase, 
																	   codperiodo,
																	   fechaPeriodo,
																	   calificacion,
																	   observaciones
																	FROM deleted As De

		END
END
GO