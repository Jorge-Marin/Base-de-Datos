 -- =============================================
-- Author:		Bessy Daniel Zavala
-- Create date: 20-04-2020
-- Description:	
/*
 Cancelar un laboratorio, puede cancelar un laboratorio siempre y cuando se encuentre entre las fechas de
premaCancelartricula, matricula o adici�n y cancelaci�n
*/
-- =============================================
CREATE TRIGGER [smregistro].[tgCancelarLab]
   ON  [smregistro].[CancelacionLabClase]
   AFTER INSERT --Al eliminar un registro de la MatriculaLab, no Insertar un registro que vas a eliminar.
AS 
BEGIN
	
	SET NOCOUNT ON;

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

		BEGIN TRANSACTION
		BEGIN TRY
		
		/*Inicio de transacci�n */

		SELECT @codCarrera = codCarrera,
			   @ctaEstudiante = cuentaEstudiante,
			   @codLab = codLab,
			   @codSeccionLab = codSeccionLab,
			   @descripcion = descripcion, 
			   @codPeriodoActual = codPeriodo,
			   @fecha = fecha,
			   @codAsignatura = codAsignatura	   
			FROM inserted;
		
		/*Establecer las variables obteniendolas con consultas, de la tabla correspondiente*/

		SELECT @inicioPrematricula = inicioPrematricula,
		       @finalPrematricula = finalPrematricula,
			   @inicioMatricula = inicioMatricula,
			   @finalMatricula = finalMatricula, 
			   @InicioAdiciones = InicioAdiciones,
			   @finalAdiciones = FinalizaAdiciones
			FROM Registro.smregistro.Periodo
			WHERE @codPeriodoActual = codPeriodo;

		/*
			Condiciones que controlan si est� cancelando en el rango de fechas establecidas seg�n calendario
		*/
		IF(@codPeriodoActual=(SELECT [codPeriodo] FROM [smregistro].[Periodo] WHERE [activo] = 1) 
				AND @fecha = (SELECT [fechaInicio] FROM [smregistro].[Periodo] WHERE [activo] = 1))
			BEGIN
				IF((GETDATE()>=@inicioPrematricula 
					AND GETDATE()<DATEADD(DAY,1,@finalPrematricula)) 
					AND  (DATEPART(hh,GETDATE())>=9 
					AND DATEPART(mi,GETDATE())>=00)
					OR ((GETDATE()>=@inicioMatricula 
						AND GETDATE()<DATEADD(DAY,1,@finalMatricula))
						AND  (DATEPART(hh,GETDATE())>=9 
 						AND DATEPART(mi,GETDATE())>=00))
					OR ((GETDATE()>=@incioAdiciones 
						AND GETDATE()<DATEADD(DAY,1,@finalAdiciones)) 
						AND  (DATEPART(hh,GETDATE())>=9 
						AND DATEPART(mi,GETDATE())>=00)))
					BEGIN
		
					/*Verificar si la clase a cancelar posee laboratorio*/
					IF((SELECT [codSeccionLab] 
						FROM [smregistro].[MatriculaLab] 
						WHERE @codCarrera = [codCarrera] 
						AND @ctaEstudiante = [cuentaEstudiante]
						AND @codAsignatura = [codAsignatura] 
						AND @codLab = [codLab] 
						AND @codSeccionLab = [codSeccionLab]) IS NOT NULL)

						BEGIN

						/*Eliminar el lab de la lista de laboratorios matriculados*/
						DELETE [smregistro].[MatriculaLab]
							WHERE @codCarrera = [codCarrera] 
								AND @ctaEstudiante = [cuentaEstudiante]
								AND @codAsignatura = [codAsignatura] 
								AND @codLab = [codLab] 
								AND @codSeccionLab = [codSeccionLab]

						PRINT 'Laboratorio Cancelado con Exito'

		 				END
					ELSE
						BEGIN
							PRINT 'No tiene matriculado ese laboratorio'
						END
					END
			ELSE
				BEGIN
					PRINT 'No es fecha de cancelaci�n, o la hora aun no inicia revise el calendario'
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
		 	PRINT 'Ha ocurrido un error en el proceso, no se ha cancelado el laboratorio'
			ROLLBACK TRANSACTION
		END CATCH

END
GO
