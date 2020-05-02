
USE [Registro]
GO
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
-- =============================================

-- Author:		Bessy Daniel Zavala
-- Create date: 20-04-2020
-- Description:	
/*
 Cancelar un laboratorio, puede cancelar un laboratorio siempre y cuando se encuentre entre las fechas de
premaCancelartricula, matricula o adición y cancelación
*/
-- =============================================
ALTER TRIGGER [smregistro].[tgCancelarLab]
   ON  [smregistro].[CancelacionLabClase]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
		DECLARE @codCarrera VARCHAR(7);
		DECLARE @ctaEstudiante VARCHAR(15);
		DECLARE @codLab VARCHAR(7);
		DECLARE @codSeccionLab INT;
		DECLARE @codAsignatura VARCHAR(7);
		DECLARE @descripcion VARCHAR(30)

		DECLARE @fecha DATETIME
		DECLARE @codPeriodoActual INT
		DECLARE @inicioPrematricula DATE
		DECLARE @finalPrematricula DATE
		DECLARE @inicioMatricula DATE
		DECLARE @finalMatricula DATE
		DECLARE @incioAdiciones DATE
		DECLARE @finalAdiciones DATE

		BEGIN TRY
		BEGIN TRANSACTION

		/*
		Inicio de transacción 
		*/
		SET @codCarrera = (SELECT codCarrera
								FROM inserted)

		SET @ctaEstudiante = (SELECT cuentaEstudiante
								FROM inserted)

		SET @codLab = (SELECT codLab 
							FROM inserted)

		SET @codSeccionLab = (SELECT codSeccionLab 
								FROM inserted)

		SET @descripcion = (SELECT descripcion
								FROM inserted)

		SET @codPeriodoActual = (SELECT [codPeriodo] 
									FROM inserted) --sabemos que es el periodo actual por su atributo activo
		
		SET @fecha = (SELECT fecha 
						FROM inserted)

		SET @codAsignatura = (SELECT [codAsignatura] 
								FROM inserted)

		/*
		Establecer las variables obteniendolas con consultas, de la tabla correspondiente
		*/

		SET @inicioPrematricula = (SELECT [inicioPrematricula] 
										FROM [smregistro].[Periodo] 
											WHERE @codPeriodoActual=[codPeriodo])

		SET @finalPrematricula = (SELECT [finalPrematricula] 
										FROM [smregistro].[Periodo] 
											WHERE @codPeriodoActual=[codPeriodo])

		SET @inicioMatricula = (SELECT [inicioMatricula] 
									FROM [smregistro].[Periodo] 
										WHERE @codPeriodoActual=[codPeriodo])

		SET @finalMatricula = (SELECT [finalMatricula] 
									FROM [smregistro].[Periodo] 
										WHERE @codPeriodoActual=[codPeriodo])

		SET @incioAdiciones = (SELECT [InicioAdiciones] 
									FROM [smregistro].[Periodo]
										WHERE @codPeriodoActual=[codPeriodo])

		SET @finalAdiciones = (SELECT [FinalizaAdiciones] 
									FROM [smregistro].[Periodo] 
										WHERE @codPeriodoActual=[codPeriodo])

				/*
		Condiciones que controlan si está cancelando en el rango de fechas establecidas según calendario
		*/
		IF(@codPeriodoActual=(SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1) 
				AND @fecha = (SELECT [fechaInicio] FROM [smregistro].[Periodo] WHERE [activo] = 1))
			BEGIN
				IF((GETDATE()>=@inicioPrematricula 
					AND GETDATE()<dateadd(day,1,@finalPrematricula)) 
					AND  (datepart(hh,getdate())>=9 
					AND datepart(mi,getdate())>=00)
					OR ((GETDATE()>=@inicioMatricula 
						AND GETDATE()<dateadd(day,1,@finalAdiciones))
						AND  (datepart(hh,getdate())>=9 
						AND datepart(mi,getdate())>=00))
					OR ((GETDATE()>=@incioAdiciones 
						AND GETDATE()<dateadd(day,1,@finalAdiciones)) 
						AND  (datepart(hh,getdate())>=9 
						AND datepart(mi,getdate())>=00)))
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
							WHERE @codCarrera = [codCarrera] 
								AND @ctaEstudiante = [cuentaEstudiante]
								AND @codAsignatura = [codAsignatura] 
								AND @codLab = [codLab] 
								AND @codSeccionLab = [codSeccionLab]

						PRINT 'Laboratorio Cancelado con éxito'
						/*
						Agregar la asignatura cancelada a lista de asignaturas canceladas
						*/

						--INSERT INTO [smregistro].[CancelacionLabClase] VALUES(@codCarrera, @ctaEstudiante, @codSeccionLab, @codLab, @codAsignatura , @fecha, @codPeriodoActual,@descripcion)

						END
					ELSE
						BEGIN
							PRINT 'No tiene matriculado ese laboratorio'
						END

					END
			ELSE
			BEGIN
			PRINT 'No es fecha de cancelación, o la hora aun no inicia revise el calendario'
				DELETE [smregistro].[CancelacionLabClase]
					WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante] 
						AND @codSeccionLab = [codSeccionLab]
						AND @codAsignatura = [codAsignatura] 
						AND @fecha = [fecha] AND @codLab = [codLab]

			END
			END
		ELSE
		BEGIN
		PRINT 'Periodo Inactivo'
			DELETE [smregistro].[CancelacionLabClase]
				WHERE @codCarrera = [codCarrera] 
					AND @ctaEstudiante = [cuentaEstudiante] 
					AND @codSeccionLab = [codSeccionLab]
					AND @codAsignatura = [codAsignatura] 
					AND @fecha = [fecha] 
					AND @codLab = [codLab]
		END
		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'Ha ocurrido un error en el proceso, no se ha cancelado el laboratorio'
		END CATCH

END
GO
