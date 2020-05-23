-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 20-04-2020
-- Description:	
/*
Al agregar un estudiante verificar que la clave agregada cumpla ciertos criterios de seguridad, 
y asignarle la cantidad de UV, asi como verificar que el indice de PAA obtenido es suficiente 
para alguna de las carreas existentes, de lo contrario no es agregado
*/
-- =============================================

CREATE TRIGGER [smregistro].[tgAgregarEstudiante]
   ON  [smregistro].[Estudiante]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
    
	DECLARE @cuenta VARCHAR(15) 
	DECLARE @indicePAA INT

	SET @indicePAA = (SELECT [indicePAA] 
						FROM inserted)

	--asignarle las uv
	UPDATE [smregistro].[Estudiante] 
		SET [unidadesValorativas] = 25 
			WHERE [numCuenta] = @cuenta

	--Verificar el indice PAA
	IF(@indicePAA<(SELECT MIN([indiceRequerido]) FROM [smregistro].[Carrera]))
		BEGIN
			PRINT 'El �ndice de la PAA no es suficiente para ninguna de las carreras disponibles'
			DELETE [smregistro].[Estudiante] 
					WHERE @cuenta = [numCuenta] 
			RETURN 

		END
	
END
GO
