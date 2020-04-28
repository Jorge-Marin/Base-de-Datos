USE [Registro]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 05-04-2020
-- Description:	
/*
 Cancelar un laboratorio, puede cancelar un laboratorio siempre y cuando se encuentre entre las fechas de
premaCancelartricula, matricula o adición y cancelación
*/

--[dbo].[cancelarLaboratorio] 'IS01','20171004244','FS1LAB',1000,'FS-100',''

--SELECT * FROM [smregistro].[MatriculaLab]
--SELECT * FROM [smregistro].[CancelacionLabClase]
--SELECT * FROM smregistro.Periodo
--SELECT * FROM smregistro.SeccionLab
--INSERT INTO [smregistro].[MatriculaLab] VALUES('IS01','20171004244','FS1LAB','FS-100',1000)
-- =============================================

ALTER PROCEDURE [dbo].[cancelarLaboratorio]
		/*
		Parametros que recibe el procedimiento
		*/

		@codCarrera VARCHAR(7),
		@ctaEstudiante VARCHAR(15),
		@codLab VARCHAR(7),
		@codSeccionLab INT,
		@codAsignatura VARCHAR(7),
		@descripcion VARCHAR(30)
		
AS
BEGIN

	SET NOCOUNT ON;
		BEGIN TRY
		BEGIN TRANSACTION

		/*
		Inicio de transacción y declaración de variables
		*/

		DECLARE @fecha DATETIME
		DECLARE @codPeriodoActual INT
		DECLARE @inicioPrematricula DATE
		DECLARE @finalPrematricula DATE
		DECLARE @inicioMatricula DATE
		DECLARE @finalMatricula DATE
		DECLARE @incioAdiciones DATE
		DECLARE @finalAdiciones DATE

		/*
		Establecer las variables obteniendolas con consultas, de la tabla correspondiente
		*/

		SET @codPeriodoActual = (SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1) --sabemos que es el periodo actual por su atributo activo
		SET @fecha = (SELECT [fechaInicio] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @inicioPrematricula = (SELECT [inicioPrematricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalPrematricula = (SELECT [finalPrematricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @inicioMatricula = (SELECT [inicioMatricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalMatricula = (SELECT [finalMatricula] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @incioAdiciones = (SELECT [InicioAdiciones] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		SET @finalAdiciones = (SELECT [FinalizaAdiciones] FROM [smregistro].[Periodo] WHERE @codPeriodoActual=[codPeriodo])
		
		/*
		Condiciones que controlan si está cancelando en el rango de fechas establecidas según calendario
		*/
		
		IF((GETDATE()>=@inicioPrematricula AND GETDATE()<dateadd(day,1,@finalPrematricula)) AND  (datepart(hh,getdate())>=9 AND datepart(mi,getdate())>=00)
		OR ((GETDATE()>=@inicioMatricula AND GETDATE()<dateadd(day,1,@finalAdiciones)) AND  (datepart(hh,getdate())>=9 AND datepart(mi,getdate())>=00))
		OR ((GETDATE()>=@incioAdiciones AND GETDATE()<dateadd(day,1,@finalAdiciones)) AND  (datepart(hh,getdate())>=9 AND datepart(mi,getdate())>=00)))
		BEGIN
		
		/*
		Verificar si la calse a cancelar posee laboratorio
		*/
		IF((SELECT [codSeccionLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante]
		AND @codAsignatura = [codAsignatura] AND @codLab = [codLab] AND @codSeccionLab = [codSeccionLab]) IS NOT NULL)

		BEGIN

		/*
		Eliminar el lab de la lista de laboratorios matriculados
		*/
		DELETE [smregistro].[MatriculaLab]
		WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante]
		AND @codAsignatura = [codAsignatura] AND @codLab = [codLab] AND @codSeccionLab = [codSeccionLab]

		PRINT 'Laboratorio Cancelado con éxito'
		/*
		Agregar la asignatura cancelada a lista de asignaturas canceladas
		*/

		INSERT INTO [smregistro].[CancelacionLabClase] VALUES(@codCarrera, @ctaEstudiante, @codSeccionLab, @codLab, @codAsignatura , @fecha, @codPeriodoActual,@descripcion)

		END
		ELSE
		BEGIN
		PRINT 'No tiene matriculado ese laboratorio'
		END

	
	
		END
		ELSE
		BEGIN
		PRINT 'No es fecha de cancelación, o la hora aun no inicia revise el calendario'
		END
		
		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'Ha ocurrido un error en el proceso, no se ha cancelado el laboratorio'
		END CATCH
END
