USE [Registro]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniel Zavala
-- Create date: 05-04-2020
-- Description:	
/*
Cancelar una asignatura, puede cancelar una asignatura siempre y cuando se encuentre entre las fechas de
prematricula, matricula o adición y cancelación, si la clase tiene laboratorio, este también es cancelado
*/
-- =============================================
ALTER TRIGGER [smregistro].[tgCancelarClase]
   ON  [smregistro].[CancelacionClase]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @codCarrera VARCHAR(7);
		DECLARE @ctaEstudiante VARCHAR(15);
		DECLARE @claseCancelar VARCHAR(7);
		DECLARE @codSeccionClase INT;
		DECLARE @descripcion VARCHAR(30);
		DECLARE @fecha DATETIME;
		DECLARE @codPeriodoActual INT;

		DECLARE @codSeccionLab INT;
		DECLARE @codLab VARCHAR(7);
		DECLARE @inicioPrematricula DATE;
		DECLARE @finalPrematricula DATE;
		DECLARE @inicioMatricula DATE;
		DECLARE @finalMatricula DATE;
		DECLARE @incioAdiciones DATE;
		DECLARE @finalAdiciones DATE;


		BEGIN TRY
		BEGIN TRANSACTION

		/*
		Inicio de transacción 
		*/
		SET @codCarrera = (SELECT codCarrera
							FROM inserted)

		SET @ctaEstudiante = (SELECT cuentaEstudiante
								FROM inserted)

		SET @claseCancelar = (SELECT codAsignatura
								FROM inserted)

		SET @codSeccionClase = (SELECT codSeccionClase
									FROM inserted)

		SET @descripcion = (SELECT descripcion
								FROM inserted)

		SET @codPeriodoActual = (SELECT [codPeriodo] 
									FROM inserted) --sabemos que es el periodo actual por su atributo activo
		
		SET @fecha = (SELECT fecha 
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
					AND  (datepart(hh,getdate())>=9 AND datepart(mi,getdate())>=00))
				OR ((GETDATE()>=@incioAdiciones AND GETDATE()<dateadd(day,1,@finalAdiciones)) 
					AND  (datepart(hh,getdate())>=9 AND datepart(mi,getdate())>=00)))
			BEGIN

			/*
			verificando que la clase que quiere cancelar efectivamente esté matriculada
			*/

				IF((SELECT [codSeccionClase] FROM [smregistro].[MatriculaClase] WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante] AND @codSeccionClase = [codSeccionClase]
					AND @claseCancelar = [codAsignatura] AND @fecha = [fechaPeriodo] ) IS NOT NULL)
					BEGIN 

					/*
					Eliminar la clase de la lista de asignaturas matriculadas
					*/

					DELETE [smregistro].[MatriculaClase]
						WHERE @codCarrera = [codCarrera] 
							AND @ctaEstudiante = [cuentaEstudiante] 
							AND @codSeccionClase = [codSeccionClase]
							AND @claseCancelar = [codAsignatura] 
							AND @fecha = [fechaPeriodo] 
		
					/*
					Verificar si la cLase a cancelar posee laboratorio
					*/
					IF((SELECT [codSeccionLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante]
						AND @claseCancelar = [codAsignatura] ) IS NOT NULL)
						BEGIN
							PRINT 'La clase tiene laboratorio Matriculado, este también se cancelará'

							/*
							Obtener el codigo del laboratorio perteneciente a la clase que tiene matriculada y desea cancelar
							*/
							SET @codLab = (SELECT [codLab] 
												FROM [smregistro].[MatriculaLab] 
													WHERE @codCarrera = [codCarrera] AND @ctaEstudiante =[cuentaEstudiante]
														AND @claseCancelar = [codAsignatura])

							SET @codSeccionLab = (SELECT [codSeccionLab] 
													FROM [smregistro].[MatriculaLab] 
														WHERE @codCarrera = [codCarrera] 
															AND @ctaEstudiante =[cuentaEstudiante]
															AND @claseCancelar = [codAsignatura] 
															AND @codLab = [codLab])

							/*
							Eliminar el lab de la lista de laboratorios matriculados
							*/
							DELETE [smregistro].[MatriculaLab]
								WHERE @codCarrera = [codCarrera] 
									AND @ctaEstudiante = [cuentaEstudiante] 
									AND @codSeccionLab = [codSeccionLab]
									AND @claseCancelar = [codAsignatura] 
									AND @codLab = [codLab]

							/*
							Agregar el lab a lista de laboratorios cancelados
							*/

							INSERT INTO [smregistro].[CancelacionLabClase] VALUES(@codCarrera, @ctaEstudiante, @codSeccionLab, @codLab, @claseCancelar , @fecha, @codPeriodoActual,'Cancelado por Coordinación')
	
						END
							ELSE
								BEGIN
									PRINT 'Asignatura cancelada con éxito'
								END
		
					/*
					Agregar la asignatura cancelada a lista de asignaturas canceladas
					*/
					--INSERT INTO Registro.smregistro.CancelacionClase VALUES(@codCarrera,@ctaEstudiante,@codSeccionClase,@claseCancelar,@fecha,@codPeriodoActual,@descripcion)
					END
						ELSE
						BEGIN
							PRINT 'La clase que desea cancelar no está matriculada'
						END
					END
			ELSE
			BEGIN
				PRINT 'No es fecha de cancelación, o la hora aun no inicia revise el calendario'
				DELETE [smregistro].[CancelacionClase]
					WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante] 
						AND @codSeccionClase = [codSeccionClase]
						AND @claseCancelar = [codAsignatura] 
						AND @fecha = [fecha] 
			END
			END
		ELSE
			BEGIN
				PRINT 'Periodo Inactivo'
					DELETE [smregistro].[CancelacionClase]
					WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante] 
						AND @codSeccionClase = [codSeccionClase]
						AND @claseCancelar = [codAsignatura] 
						AND @fecha = [fecha] 
			END
		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'DENEGADO'
		END CATCH

END
GO
