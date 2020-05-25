-- =============================================
-- Author:		Jorge Marin
-- Create date: 08/04/2020
-- Description:	Procedimiento almacenado que elimina todas mas asignaturas matriculadas 
--espera terminado el periodo de cancelaciones y adiciones de asignaturas
-- =============================================
CREATE PROCEDURE [smregistro].[spFinalizacionAdiciones] 
AS
BEGIN
	SET NOCOUNT ON;
	
	--Inicia La transaccion
	BEGIN TRANSACTION
		BEGIN TRY
			--Obteniendo la fecha en la que finaliza el periodo 
			DECLARE @validarFecha DATE;
			DECLARE @inicioAdiciones DATE;
			SELECT @validarFecha = Pe.FinalizaAdiciones,
				   @inicioAdiciones = Pe.inicioAdiciones
				FROM Registro.smregistro.Periodo AS Pe 
				WHERE activo=1;
			
			--Si validar fecha es igual a la fecha actual significa que hoy es el dia el cual se finaliza
			--el periodo de adiciones y cancelacion, se prosigue a limpiar la tabla registro de 
			--las asignaturas en espera
			IF(@validarFecha<= CAST(GETDATE() AS DATE))
				BEGIN
					--Elimina los registros donde espera es igual a 1, 
					--osea el indicador de asignaturas en esperas es verdadero
					DELETE Registro.smregistro.MatriculaClase WHERE espera = 1;

					/*Se Han Eliminados las matriculas que no alcanzaron a obtener cupo en x clase*/
					PRINT 'Las matriculas en Espera se han Eliminado'
					COMMIT TRANSACTION
				END
			ELSE
				BEGIN 
					--Aun no finaliza el periodo
					IF(@inicioAdiciones <= CAST(GETDATE() AS DATE) AND CAST(GETDATE() AS DATE) <= @validarFecha)
						BEGIN
							PRINT 'Aun no se ha finalizado el periodo de adiciones y cancelaciones';
						END
					ELSE
						BEGIN 
							PRINT 'Aun no inicia el periodo de adiciones y cancelaciones';
						END
					ROLLBACK TRANSACTION
				END
			
		END TRY
		
		--Capturando cualquier error
		BEGIN CATCH
			PRINT 'Ha Ocurrido un Error, Vuela a intentarlo';
			--Revirtiendo los cambios, al momento de eliminar 
			--algo salio mal
			ROLLBACK TRANSACTION;
		END CATCH
    
END
GO


[smregistro].[spFinalizacionAdiciones] 

