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

	BEGIN TRANSACTION
		BEGIN TRY
			DECLARE @validarFecha DATE;
			SET @validarFecha = (SELECT FinalizaAdiciones FROM Registro.smregistro.Periodo WHERE activo=1);
			

			IF(@validarFecha = CAST(GETDATE() AS DATE))
				BEGIN
					DELETE Registro.smregistro.MatriculaClase WHERE espera = 1;

					/*Se Han Eliminados las matriculas que no alcanzaron a obtener cupo en x clase*/
					PRINT 'Las matriculas en Espera se han Eliminado'
					COMMIT TRANSACTION
				END
			ELSE
				BEGIN 
					PRINT 'Aun no Termina el Periodo de Adiciones y Cancelaciones';
					ROLLBACK TRANSACTION
				END
			
		END TRY
		
		BEGIN CATCH
			PRINT 'Ha Ocurrido un Error, Vuela a intentarlo';
			ROLLBACK TRANSACTION;
		END CATCH
    
END
GO

[smregistro].[spFinalizacionAdiciones]