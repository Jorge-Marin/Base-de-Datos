USE [Registro]
GO
/****** Object:  StoredProcedure [dbo].[spTransferencia]    Script Date: 7/4/2020 11:54:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 05-04-2020
-- Description:	Cancelar una asignatura 
-- =============================================
--[dbo].[cancelarClase] 'uxbs','23425','scdc',2122,''
ALTER PROCEDURE [dbo].[cancelarClase]
	-- Add the parameters for the stored procedure here
		@codCarrera VARCHAR(7),
		@ctaEstudiante VARCHAR(15),
		@claseCancelar VARCHAR(7),
		@codSeccionClase INT,
		@descripcion VARCHAR(30)
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
		BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @fecha DATETIME
		DECLARE @codPeriodoActual INT
		DECLARE @codSeccionLab INT
		DECLARE @codLab VARCHAR(7)
		DECLARE @inicioPrematricula DATE
		DECLARE @finalPrematricula DATE
		DECLARE @inicioMatricula DATE
		DECLARE @finalMatricula DATE
		DECLARE @incioAdiciones DATE
		DECLARE @finalAdiciones DATE

		DECLARE @indiceGlobal INT
		DECLARE @indicePeriodo INT
		DECLARE @cantidadClasesAprobadas INT
		
		/*Criterios para cancelacion FECHAS*/

		EXEC @indiceGlobal = [smregistro].[spIndiceGlobal] @ctaEstudiante, @codCarrera
		EXEC @indicePeriodo = [smregistro].[spIndicePeriodo] @codCarrera, @ctaEstudiante


		SET @codPeriodoActual = (SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1)
		SET @fecha = (SELECT [fechaInicio] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @inicioPrematricula = (SELECT [inicioPrematricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalPrematricula = (SELECT [finalPrematricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @inicioMatricula = (SELECT [inicioMatricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalMatricula = (SELECT [finalMatricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @incioAdiciones = (SELECT [InicioAdiciones] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalAdiciones = (SELECT [FinalizaAdiciones] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @cantidadClasesAprobadas = (SELECT COUNT([codAsignatura]) FROM [smregistro].[HistorialAcademico] WHERE @codCarrera=[codCarrera]
		AND @ctaEstudiante = [cuentaEstudiante] AND @claseCancelar = [codAsignatura] AND @codPeriodoActual =[codPeriodo])

		--Tabla para llenar con las fechas de pre y matricula, se llena en otro procedimiento
		CREATE TABLE #TempPrematricula(prioridad INT IDENTITY PRIMARY KEY,fecha DATE)
		CREATE TABLE #TempMatricula(prioridad INT IDENTITY PRIMARY KEY,fecha DATE)

		--Insertar las fechas de prematricula
		EXEC [smregistro].[FechasRangosPrioridad] @inicioPrematricula, @finalPrematricula
		--SELECT * FROM #TempPrematricula
		--Insertar las fechas de matricula
		
		--INSERT INTO #TempMatricula(matricula) VALUES(1)
		EXEC [smregistro].[FechasRangosPrioridad] @inicioMatricula, @finalMatricula
		--SELECT * FROM #TempMatricula

		/*Definición de calendario, en caso de ser modificado las prioridades el siguiente periodo, se debe modificar este procedimiento*/
		/*
		PREMATRICULA Y 
		Prioridad	fecha
		1			Excelencia Academica, PROSENNE, Representantes de UNAH
		2			Primer Ingreso
		3			Indice del último periodo que estudió: 85-100
		4			65-84
		5			0-64
		*/
		--dia que le toca matricula dependiendo el indice y clases aprobadas
		
		IF((@indiceGlobal >=80 AND @cantidadClasesAprobadas >=10 AND (GETDATE()=(SELECT fecha FROM #TempPrematricula WHERE prioridad=1) OR 
		GETDATE()=(SELECT fecha FROM #TempMatricula WHERE prioridad=1)) OR (@indicePeriodo>=79 AND GETDATE()=@fecha2)
		OR (@indicePeriodo<79 AND GETDATE()=@fecha3)
		--Tomando en cuenta las fechas de adiciones
		OR (GETDATE()>=@incioAdiciones AND GETDATE()<dateadd(day,1,@finalAdiciones)) AND  (datepart(hh,getdate())=9 AND datepart(mi,getdate())=00))
		BEGIN
		IF((SELECT [codSeccionClase] FROM [smregistro].[MatriculaClase] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante] AND @codSeccionClase = [codSeccionClase]
		AND @claseCancelar = [codAsignatura] AND @fecha = [fechaPeriodo] ) IS NOT NULL)
		BEGIN 

		DELETE [smregistro].[MatriculaClase]
		WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante] AND @codSeccionClase = [codSeccionClase]
		AND @claseCancelar = [codAsignatura] AND @fecha = [fechaPeriodo] 
		

		IF((SELECT [codSeccionLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante]
		AND @claseCancelar = [codAsignatura] ) IS NOT NULL)
		BEGIN
		PRINT 'La clase tiene laboratorio Matriculado, este también se cancelará'
		SET @codLab = (SELECT [codLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante =[cuentaEstudiante]
		AND @claseCancelar = [codAsignatura])

		SET @codSeccionLab = (SELECT [codSeccionLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante =[cuentaEstudiante]
		AND @claseCancelar = [codAsignatura] AND @codLab = [codLab])


		DELETE [smregistro].[MatriculaLab]
		WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante] AND @codSeccionLab = [codSeccionLab]
		AND @claseCancelar = [codAsignatura] AND @codLab = [codLab]

		END
			ELSE
			BEGIN
			PRINT 'Asignatura cancelada con éxito'
			END

		--Agregar a asignaturas canceladas
		INSERT INTO Registro.smregistro.CancelacionClase VALUES(@codCarrera,@ctaEstudiante,@codSeccionClase,@claseCancelar,@fecha,@codPeriodoActual,@descripcion)
		END
			ELSE
			BEGIN
			PRINT 'La clase que desea cancelar no está matriculada'
			END
		END
		ELSE
		BEGIN
		PRINT 'Hoy no es su día de matricula,o la hora aun no inicia revise el calendario'
		END
		
		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'DENEGADO'
		END CATCH
END

--[dbo].[cancelarClase] 'IS01','20171004244','SC-101',700,'';
--SELECT * FROM Registro.smregistro.CancelacionClase
--SELECT * FROM Registro.smregistro.MatriculaClase

--delete Registro.smregistro.CancelacionClase