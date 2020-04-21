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
	DECLARE @identidad VARCHAR(15)
	DECLARE @primerNombre VARCHAR(20)
	DECLARE @segundoNombre VARCHAR(20)
	DECLARE @primerApellido VARCHAR(20)
	DECLARE @segundoApellido VARCHAR(20)
	DECLARE @clave VARCHAR(15)
	DECLARE @fechaNac DATE
	DECLARE @indicePAA INT
	DECLARE @indiceExtaRequeridoObtenido INT
	DECLARE @estadoCuenta DECIMAL(5,2)
	DECLARE @codExtraRequerido INT
	DECLARE @municipioNac INT
	DECLARE @temp INT

	SET @cuenta = (SELECT [numCuenta] FROM inserted)
	SET @identidad = (SELECT [identidad] FROM inserted)
	SET @primerNombre = (SELECT [primerNombre] FROM inserted)
	SET @segundoNombre = (SELECT [segundoNombre] FROM inserted)
	SET @primerApellido = (SELECT [primerApellido] FROM inserted)
	SET @segundoApellido = (SELECT [segundoApellido] FROM inserted)
	SET @clave = (SELECT [clave] FROM inserted)
	SET @fechaNac = (SELECT [fechaNacimiento] FROM inserted)

	SET @indicePAA = (SELECT [indicePAA] FROM inserted)
	SET @indiceExtaRequeridoObtenido = (SELECT [indiceExtraRequeridoObtenido] FROM inserted)
	SET @estadoCuenta = (SELECT [estadoCuenta] FROM inserted)
	SET @codExtraRequerido = (SELECT [codExtraRequerido] FROM inserted)
	SET @municipioNac = (SELECT [municipioNac] FROM inserted)
	EXEC @temp = [dbo].[spverificarClave] @clave

	/*asignarle las uv*/
	UPDATE [smregistro].[Estudiante] SET [unidadesValorativas] = 25

	/*
	La clave debe tener estos requerimientos: tener mínimo 8 caracteres, incluyendo un numero, y
	un carácter especial
	*/

	IF(@clave <8  AND (SELECT CHARINDEX(' ',@clave))>0)
	BEGIN
		IF((SELECT CHARINDEX('_',@clave))>0 OR (SELECT CHARINDEX('-',@clave))>0 OR( SELECT CHARINDEX('.',@clave))>0
		OR (SELECT CHARINDEX('*',@clave))>0 OR (SELECT CHARINDEX('/',@clave))>0)
		BEGIN
			IF(@temp>0)
			BEGIN
			PRINT 'Validación de Clave Correcta'
			END
			ELSE
			BEGIN
				PRINT 'La clave debe tener al menos un número'
					DELETE [smregistro].[Estudiante] 
					WHERE @cuenta = [numCuenta] 
			END
			
		END		
		ELSE
		BEGIN
		PRINT 'La clave debe contener al menos un caracter especial (-_.*/)'
			DELETE [smregistro].[Estudiante] 
			WHERE @cuenta = [numCuenta] 
		END
	END
	ELSE 
	BEGIN
	PRINT 'La clave debe ser de al menos 8 caracteres y no debe contener espacios'
	DELETE [smregistro].[Estudiante] 
	WHERE @cuenta = [numCuenta] 
	END

	--Verificar el indice PAA
	DECLARE @carreras INT
	SET @carreras = (SELECT COUNT([codCarrera]) FROM [smregistro].[Carrera])
	IF OBJECT_ID('tempdb.dbo.#Carreras', 'U') IS NOT NULL
                    DROP TABLE #Carreras; 
                CREATE TABLE #Carreras (codCarrera INT PRIMARY KEY, indicePAA INT);
                INSERT INTO #Carreras SELECT [codCarrera],[indiceRequerido] FROM [smregistro].[Carrera];
	WHILE @carreras > 0
	BEGIN
	
		IF((SELECT TOP(1)[codCarrera] FROM #Carreras) < @indicePAA)
		PRINT 'El índice de la PAA no es suficiente para ninguna de las carreras disponibles'
		DELETE [smregistro].[Estudiante] 
					WHERE @cuenta = [numCuenta] 
		RETURN 

	DELETE TOP(1)#Carreras 
	SET @carreras = @carreras-1
	END
	
END
GO
