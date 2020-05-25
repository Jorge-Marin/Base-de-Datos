USE Registro;
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 23-04-2020
-- Description:	Funci�n que retorne la forma 03 de un estudiante espec�fico
-- =============================================

CREATE FUNCTION smregistro.FnProgramacionAcademica
(	 
	@codCarrera Varchar(7)
)
RETURNS TABLE 
AS

RETURN

	SELECT D.nombreDepartamento 'Departamento', 
			A.nombreAsignatura 'Asignatura',
			S.diaPresenciales 'Dias', 
			S.codSeccion 'Secci�n', 
			S.horaInicial 'HoraInicial',
			S.horaFinal 'HoraFinal',
			Pe.periodo 'Periodo',
			YEAR(Pe.fechaInicio) 'A�o'
		FROM Registro.smregistro.DepartamentosCarrera AS D
			INNER JOIN Registro.smregistro.Asignatura AS A
				ON D.codDepartamento = A.codDepartamentoFF
			INNER JOIN Registro.smregistro.Seccion AS S
				ON A.codAsignatura = S.codAsignatura
			INNER JOIN Registro.smregistro.CarreraDepartamento AS C
				ON D.codDepartamento = C.codDepartamentoFF
			INNER JOIN Registro.smregistro.Periodo AS Pe
				ON Pe.codPeriodo = S.codPeriodo
			WHERE C.codCarreraFF = @codCarrera
				AND Pe.activo = 1
				/*
					Suponiendo que la programaci�n acad�mica est� disponible 15 dias antes de iniciar matricula
				*/
				AND DATEDIFF(DAY,GETDATE(),Pe.inicioPrematricula) <=15

				/*
					Suponiendo que el dia de inicio del periodo se desactiva la visualizaci�n de la programaci�n acad�mica
				*/
				AND GETDATE() <= Pe.fechaInicio
GO

--SELECT * FROM smregistro.FnProgramacionAcademica ('IS01')