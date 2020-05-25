USE [Registro]
GO
-- =============================================
-- Author:		
-- Create date: 26-04-2020
-- Description:	Muestra el plan de estudio de una carrera
-- =============================================

CREATE VIEW smregistro.PlanDeEstudio AS
	SELECT PE.codCarreraFF 'Carrera',
			PE.codAsignaturaFF 'Codido Asignatura',
			Asi.nombreAsignatura 'Asignatura',
			PE.optativa,
			RE.codAsignarutaRequisitos 'Requisito'
				FROM smregistro.PlanEstudio PE
					INNER JOIN smregistro.Asignatura AS Asi
						ON Asi.codAsignatura = PE.codAsignaturaFF
					INNER JOIN smregistro.Requisitos AS RE
						ON RE.codAsignaturaFFR = Asi.codAsignatura
							WHERE codCarreraFF = 'IS01'


/*
    USE Registro;
    GO
	
	SELECT * FROM smregistro.PlanDeEstudio

*/