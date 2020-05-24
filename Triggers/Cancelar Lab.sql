
USE [Registro]
GO

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
CREATE TRIGGER [smregistro].[tgCancelarLab]
   ON  [smregistro].[MatriculaLab]
	   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;
		DECLARE @codCarrera VARCHAR(7);
		DECLARE @ctaEstudiante VARCHAR(15);
		DECLARE @codLab VARCHAR(7);
		DECLARE @codSeccionLab INT;
		DECLARE @codAsignatura VARCHAR(7);
		DECLARE @fecha DATE;

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
								FROM DELETED del)

		SET @ctaEstudiante = (SELECT cuentaEstudiante
								FROM DELETED del)

		SET @codLab = (SELECT codLab 
							FROM DELETED del)

		SET @codSeccionLab = (SELECT codSeccionLab 
								FROM DELETED del )
	

		SET @codAsignatura = (SELECT [codAsignatura] 
								FROM DELETED del)

		/*
		Establecer las variables obteniendolas con consultas, de la tabla correspondiente
		*/
		SET @fecha = (SELECT fechaInicio
						FROM [smregistro].[Periodo] 
												WHERE activo =1)

		SET @codPeriodoActual = (SELECT [codPeriodo] 
											FROM [smregistro].[Periodo] 
												WHERE activo =1) --sabemos que es el periodo actual por su atributo activo 

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
						AND  (datepart(hh,getdate())>=9 
						AND datepart(mi,getdate())>=00))
					OR ((GETDATE()>=@incioAdiciones 
						AND GETDATE()<dateadd(day,1,@finalAdiciones)) 
						AND  (datepart(hh,getdate())>=9 
						AND datepart(mi,getdate())>=00)))
					BEGIN
		
					/*
					Verificar si la clase a cancelar posee laboratorio
					*/
						
					IF((SELECT [codSeccionLab] FROM DELETED del WHERE @codCarrera = [codCarrera] AND @ctaEstudiante = [cuentaEstudiante]
						AND @codAsignatura = [codAsignatura] AND @codLab = [codLab] AND @codSeccionLab = [codSeccionLab]) IS NOT NULL)

						BEGIN

						/*
						Agregar la asignatura a lista de asignaturas canceladas
						*/

						PRINT 'Laboratorio Cancelado con éxito'


						INSERT INTO [smregistro].[CancelacionLabClase] VALUES(@codCarrera, @ctaEstudiante, @codSeccionLab, @codLab, @codAsignatura , @fecha, @codPeriodoActual,' ')

						END
					ELSE
						BEGIN
							PRINT 'Elija un laboratorio de los que tiene matriculados'
							INSERT INTO [smregistro].[MatriculaLab] VALUES (@codCarrera,
															@ctaEstudiante,
															@codLab,
															@codAsignatura,
															@codSeccionLab)

						END

					END
			ELSE
			BEGIN
			PRINT 'No es fecha de cancelación, o la hora aun no inicia revise el calendario'
					INSERT INTO [smregistro].[MatriculaLab] VALUES (@codCarrera,
															@ctaEstudiante,
															@codLab,
															@codAsignatura,
															@codSeccionLab)
			END
			

		COMMIT TRAN
		END TRY

		BEGIN CATCH

		ROLLBACK TRANSACTION
		
		PRINT 'Ha ocurrido un error en el proceso, no se ha cancelado el laboratorio'
		END CATCH

END
GO
