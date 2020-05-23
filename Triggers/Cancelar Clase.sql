-- =============================================
-- Author:		Bessy Daniel Zavala
-- Create date: 05-04-2020
-- Description:	
/*
Cancelar una asignatura, puede cancelar una asignatura siempre y cuando se encuentre entre las fechas de
prematricula, matricula o adici�n y cancelaci�n, si la clase tiene laboratorio, este tambi�n es cancelado
*/
-- =============================================
CREATE TRIGGER [smregistro].[tgCancelarClase]
   ON  [smregistro].[CancelacionClase]
   AFTER INSERT
AS 
BEGIN

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

		BEGIN TRANSACTION
		BEGIN TRY

		/*Inicio de transacci�n*/
		SELECT @codCarrera = codCarrera,
			   @ctaEstudiante = cuentaEstudiante,
			   @claseCancelar = codAsignatura,
			   @codSeccionClase = codSeccionClase,
			   @descripcion = descripcion, 
			   @codPeriodoActual = codPeriodo,
			   @fecha = fecha 
		FROM inserted;
		
		/*Establecer las variables obteniendolas con consultas, 
		de la tabla correspondiente*/

		SELECT @inicioPrematricula = inicioPrematricula,
			   @finalPrematricula = finalPrematricula, 
			   @inicioMatricula = inicioMatricula, 
			   @finalMatricula = finalMatricula,
			   @incioAdiciones = InicioAdiciones,
			   @finalAdiciones = FinalizaAdiciones
			FROM Registro.smregistro.Periodo
			WHERE @codPeriodoActual = codPeriodo;

	
		/*Condiciones que controlan si est� cancelando en el rango de fechas 
		establecidas seg�n calendario*/
		IF(@codPeriodoActual=(SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1) 
			AND @fecha = (SELECT [fechaInicio] FROM [smregistro].[Periodo] WHERE [activo] = 1))
			BEGIN

			IF((GETDATE()>=@inicioPrematricula 
				AND GETDATE()<DATEADD(DAY,1,@finalPrematricula)) 
				AND  (DATEPART(hh,GETDATE())>=9 
				AND DATEPART(mi,GETDATE())>=00)
				OR ((GETDATE()>=@inicioMatricula 
					AND GETDATE()<DATEADD(DAY,1,@finalPrematricula)) 
					AND  (DATEPART(hh,GETDATE())>=9 
					AND DATEPART(mi,GETDATE())>=00))
				OR ((GETDATE()>=@incioAdiciones 
					AND GETDATE()<DATEADD(DAY,1,@finalAdiciones)) 
					AND  (DATEPART(hh,GETDATE())>=9 
					AND DATEPART(mi,GETDATE())>=00)))
			BEGIN

			/*Verificando que la clase que quiere cancelar efectivamente est� matriculada*/

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
		
					/*Verificar si la cLase a cancelar posee laboratorio*/
					IF((SELECT [codSeccionLab] FROM [smregistro].[MatriculaLab] WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante]
						AND @claseCancelar = [codAsignatura] ) IS NOT NULL)
						BEGIN
							PRINT 'La clase tiene laboratorio Matriculado, este tambi�n se cancelar�'

							/*Obtener el codigo del laboratorio perteneciente a la clase que tiene matriculada y desea cancelar
							*/
							SET @codLab = (SELECT [codLab] 
												FROM [smregistro].[MatriculaLab] 
												WHERE @codCarrera = [codCarrera] 
												AND @ctaEstudiante =[cuentaEstudiante]
												AND @claseCancelar = [codAsignatura])

							SET @codSeccionLab = (SELECT [codSeccionLab] 
													FROM [smregistro].[MatriculaLab] 
													WHERE @codCarrera = [codCarrera] 
													AND @ctaEstudiante =[cuentaEstudiante]
													AND @claseCancelar = [codAsignatura] 
													AND @codLab = [codLab])

							
							/*Eliminar el lab de la lista de laboratorios matriculados*/
							DELETE [smregistro].[MatriculaLab]
								WHERE @codCarrera = [codCarrera] 
									AND @ctaEstudiante = [cuentaEstudiante] 
									AND @codSeccionLab = [codSeccionLab]
									AND @claseCancelar = [codAsignatura] 
									AND @codLab = [codLab]

							/*Agregar el lab a lista de laboratorios cancelados*/

							INSERT INTO [smregistro].[CancelacionLabClase] VALUES(@codCarrera, 
																				  @ctaEstudiante, 
																				  @codSeccionLab, 
																				  @codLab, 
																				  @claseCancelar, 
																				  @fecha, 
																				  @codPeriodoActual,
																				  'Cancelado por Coordinaci�n')
	
						END
							ELSE
								BEGIN
									PRINT 'Asignatura cancelada con �xito'
								END
		
					/*Agregar la asignatura cancelada a lista de asignaturas canceladas*/
					END
						ELSE
							BEGIN
								PRINT 'La clase que desea cancelar no est� matriculada'
							END
					END
			ELSE
			BEGIN
				PRINT 'No es fecha de cancelaci�n, o la hora aun no inicia revise el calendario'
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
