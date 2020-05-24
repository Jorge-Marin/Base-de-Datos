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
Cancelar una asignatura, puede cancelar una asignatura siempre y cuando se encuentre entre las fechas de
prematricula, matricula o adición y cancelación, si la clase tiene laboratorio, este también es cancelado
*/
-- =============================================
CREATE TRIGGER [smregistro].[tgCancelarClase]
   ON  [smregistro].[MatriculaClase]
   AFTER DELETE 
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
							FROM DELETED del)

		SET @ctaEstudiante = (SELECT cuentaEstudiante
								FROM DELETED del)

		SET @codSeccionClase = (SELECT codSeccionClase
									FROM DELETED del)

		SET @claseCancelar = (SELECT codAsignatura
								FROM DELETED del)

		SET @fecha = (SELECT fechaPeriodo
						FROM DELETED del)

		SET @codPeriodoActual = (SELECT codPeriodo
							FROM DELETED del)


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

				IF((SELECT [codSeccionClase] FROM DELETED del WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante] AND @codSeccionClase = [codSeccionClase]
					AND @claseCancelar = [codAsignatura] AND @fecha = [fechaPeriodo] ) IS NOT NULL)
					BEGIN 
		
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
	
						END
							ELSE
								BEGIN
									PRINT 'Asignatura cancelada con éxito'
								INSERT INTO [smregistro].[CancelacionClase] VALUES(@codCarrera, @ctaEstudiante, @codSeccionClase, @claseCancelar , @fecha, @codPeriodoActual,'')

								END
		
					/*
					Agregar la asignatura cancelada a lista de asignaturas canceladas
					*/
				
					END
						ELSE
						BEGIN
							PRINT 'Elija una clase de las que tiene matriculadas'
							INSERT INTO [smregistro].[MatriculaClase] (codCarrera, 												
																	cuentaEstudiante, 
																	codSeccionClase, 
																	codAsignatura, 
																	fechaPeriodo,
																	codperiodo) VALUES (
																			@codCarrera,
																			@ctaEstudiante,
																			@codSeccionClase,
																			@claseCancelar,
																			@fecha,
																			@codPeriodoActual
																			)
						END
					END
			ELSE
			BEGIN
				PRINT 'No es fecha de cancelación, o la hora aun no inicia revise el calendario'
							INSERT INTO [smregistro].[MatriculaClase] (codCarrera, 												
																	cuentaEstudiante, 
																	codSeccionClase, 
																	codAsignatura, 
																	fechaPeriodo,
																	codperiodo) VALUES (
																			@codCarrera,
																			@ctaEstudiante,
																			@codSeccionClase,
																			@claseCancelar,
																			@fecha,
																			@codPeriodoActual
																			)
			END
		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'Ha ocurrido un error en el proceso, no se ha cancelado la asignatura'
		END CATCH

END
GO
