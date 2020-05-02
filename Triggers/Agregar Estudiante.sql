USE [Registro]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
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
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 20-04-2020
-- Description:	
/*
Al agregar un estudiante verificar que la clave agregada cumpla ciertos criterios de seguridad, y asignarle la cantidad de UV, 
asi como verificar que el indice de PAA 
obtenido es suficiente para alguna de las carreas existentes, de lo contrario no es agregado
*/
-- =============================================

 ALTER TRIGGER [smregistro].[tgAgregarEstudiante]
   ON  [smregistro].[Estudiante]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for trigger here
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
			PRINT 'El índice de la PAA no es suficiente para ninguna de las carreras disponibles'
			DELETE [smregistro].[Estudiante] 
					WHERE @cuenta = [numCuenta] 
			RETURN 

		END
	
END
GO
