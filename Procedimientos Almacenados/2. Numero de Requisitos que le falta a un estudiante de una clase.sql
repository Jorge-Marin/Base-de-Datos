-- Create date: 12/04/2020
-- Description:	Devuelve la Cantidad de Requisitos los cuales faltan para 
-- para una asignatura
-- =============================================
CREATE PROCEDURE [smregistro].[spRequisitosClase]
	@cuentaEstudiante AS VARCHAR(15),
	@codigoCarrera AS VARCHAR(7),
	@codAsigMatriculada AS VARCHAR(7)
AS
BEGIN
	
	SET NOCOUNT ON;

   	SELECT Rc.codAsignarutaRequisitos 
		FROM (SELECT Ar.codAsignarutaRequisitos FROM Registro.smregistro.Requisitos AS Ar 
				WHERE Ar.codCarreraFFR = @codigoCarrera	AND Ar.codAsignaturaFFR = @codAsigMatriculada
					AND Ar.codAsignarutaRequisitos NOT IN (SELECT He.codAsignatura 
																FROM Registro.smregistro.HistorialAcademico AS He 
																WHERE cuentaEstudiante = @cuentaEstudiante AND 
																codCarrera = @codigoCarrera
																AND He.calificacion>65)) AS Rc;
END
GO



