USE [Registro]
GO
/****** Object:  StoredProcedure [dbo].[cancelarClase]    Script Date: 13/4/2020 6:20:18 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NOTA, cambiar el tamaño de los dias imparte en las secciones de 10 a 12
--PROBAR
--[dbo].[agregarSeccion] 700, 'FS-100', '9:00', '10:00', 30, 10, '203', 'LuMaMi', '102'
--SELECT * FROM Registro.smregistro.Seccion

-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 13-04-2020
-- Description:	
/*
Agregar una sección
*/
-- =============================================

ALTER PROCEDURE [dbo].[agregarSeccion]
		/*
		Parametros que recibe el procedimiento
		*/
		@codSeccion INT,
		@codAsignatura VARCHAR(7),
		@horaInicio TIME,
		@horaFinal TIME,
		@cupos INT,
		@codEdificio INT,
		@aula VARCHAR(20),
		@diasImpartir VARCHAR(12),
		@codCatedratico VARCHAR(15)
		
AS
BEGIN

	SET NOCOUNT ON;


		/*
		Inicio de transacción y declaración de variables
		*/
		

		DECLARE @cantidadClases INT --aumentarlo a atedratico en caso de agregarlo
		DECLARE @activo BIT --activarlo en catedratico en caso de agregar la seccion
		DECLARE @cantidadSecciones INT

		
		SET @cantidadSecciones = (SELECT COUNT(codSeccion) FROM smregistro.Seccion) 

		/*
		Crear tablas temporales para traslape de aulas
		*/
		--
		IF(@codAsignatura IN (SELECT codAsignatura FROM smregistro.Asignatura))
		BEGIN

		CREATE TABLE #DiasAsignaturaSeccionNueva (codDia INT PRIMARY KEY, Dia VARCHAR(2));
            INSERT INTO #DiasAsignaturaSeccionNueva EXEC [smregistro].[spTablaDias] @diasImpartir;

		CREATE TABLE #Secciones (codSeccion INT, diasImparte VARCHAR(10), horaInicio TIME, horaFinal TIME,codEdificio INT, aula VARCHAR(20));
		INSERT INTO #Secciones 
		SELECT codSeccion, diaPresenciales,horaInicial,horaFinal,codEdificioFF,aula FROM smregistro.Seccion
		
		DECLARE @inicioSeccionExistente TIME;
		DECLARE @FinalSeccionExistente TIME;
		DECLARE @DiasPresencialesExistente VARCHAR(12);

		WHILE @cantidadSecciones>0
		BEGIN
		
			SELECT @inicioSeccionExistente=horaInicial, @FinalSeccionExistente = horaFinal, @DiasPresencialesExistente=diaPresenciales
			FROM smregistro.Seccion WHERE codSeccion = (SELECT TOP(1) codSeccion FROM #Secciones)

			IF OBJECT_ID('tempdb.dbo.#DiasSeccion', 'U') IS NOT NULL
                    DROP TABLE #DiasSeccion; 
                CREATE TABLE #DiasSeccion (codDia INT PRIMARY KEY, Dia VARCHAR(2));
                INSERT INTO #DiasSeccion EXEC [smregistro].[spTablaDias] @DiasPresencialesExistente;

			
			DECLARE @cantidadDias INT;
            SELECT @cantidadDias = COUNT(*) FROM #DiasSeccion;
            DECLARE @codDia INT;

			WHILE @cantidadDias > 0
                BEGIN
                    SELECT TOP(1) @codDia = codDia FROM #DiasSeccion
                    IF((SELECT Dia FROM #DiasAsignaturaSeccionNueva WHERE codDia = @codDia)=(SELECT Dia FROM #DiasSeccion WHERE codDia = @codDia))
                        BEGIN
					
							IF(@aula IN (SELECT Au.aula FROM Registro.smregistro.Edificio Ed
							INNER JOIN Registro.smregistro.Aula	Au
							ON Ed.codEdificio = Au.codEdificioFF
							WHERE Ed.codEdificio = @codEdificio AND Au.aula = @aula
							AND Au.aula IN (SELECT aula FROM Registro.smregistro.Seccion
								WHERE codEdificioFF = @codEdificio 
								AND @horaInicio <= horaInicial   AND @horaFinal>=horaFinal
							
						 AND @horaInicio<horaFinal)
								AND codEdificio = @codEdificio))
                                BEGIN
									PRINT 'El aula no está disponible a esta hora y en este dia'
									
                                    RETURN 0;
                                END
                        END
                    DELETE TOP(1) FROM #DiasSeccion
                    SELECT @cantidadDias = COUNT(*) FROM #DiasSeccion
                END
			
		DELETE TOP (1) FROM #Secciones
		SELECT @cantidadSecciones = COUNT(*) FROM #Secciones;

		END
		--PRINT 'Aula disponible'
		--Aqui insertar, aula disponible e iniciar lo del catedratico
		
-------------------------------
		
		SET @cantidadClases = (SELECT COUNT([codSeccion]) FROM [smregistro].[Seccion] WHERE [codCatedratico]= @codCatedratico) 
		IF(@cantidadClases = 3 OR @codCatedratico NOT IN (SELECT [codCatedratico] FROM smregistro.Catedratico))
		BEGIN
		PRINT 'Código de catedrático no existente o ya tiene asignado el número límite de secciones que puede impartir'
		END
		ELSE
		BEGIN 
		/*
		Verificar que el catedrático no tenga ningun traslape
		*/

		CREATE TABLE #SeccionesImpartiendo (codSeccion INT, diasImparte VARCHAR(10), horaInicio TIME, horaFinal TIME, codCatedratico VARCHAR(15) 
			);
		INSERT INTO #SeccionesImpartiendo 
		SELECT codSeccion, diaPresenciales,horaInicial,horaFinal,codCatedratico FROM smregistro.Seccion WHERE codCatedratico = @codCatedratico
		

		DECLARE @inicioSeccionCatedratico TIME;
		DECLARE @FinalSeccionCatedratico TIME;
		DECLARE @DiasPresencialesCatedratico VARCHAR(12);
		DECLARE @cantidadImpartiendo INT
	
		SELECT @cantidadImpartiendo = COUNT(*) FROM #SeccionesImpartiendo;

		WHILE @cantidadImpartiendo>0
		BEGIN
		
			SELECT @inicioSeccionCatedratico=horaInicial, @FinalSeccionCatedratico = horaFinal, @DiasPresencialesCatedratico=diaPresenciales
			FROM smregistro.Seccion WHERE codSeccion = (SELECT TOP(1) codSeccion FROM #SeccionesImpartiendo)

			IF OBJECT_ID('tempdb.dbo.#DiasSeccionImparte', 'U') IS NOT NULL
                    DROP TABLE #DiasSeccionImparte; 
                CREATE TABLE #DiasSeccionImparte (codDia INT PRIMARY KEY, Dia VARCHAR(2));
                INSERT INTO #DiasSeccionImparte EXEC [smregistro].[spTablaDias] @DiasPresencialesCatedratico;
				
			DECLARE @cantidadDiasImparte INT;
            SELECT @cantidadDiasImparte = COUNT(*) FROM #DiasSeccionImparte;
            DECLARE @codDiaImparte INT;
			
			WHILE @cantidadDiasImparte > 0
                BEGIN
                    SELECT TOP(1) @codDiaImparte = codDia FROM #DiasSeccionImparte
                    IF((SELECT Dia FROM #DiasAsignaturaSeccionNueva WHERE codDia = @codDiaImparte)=(SELECT Dia FROM #DiasSeccionImparte WHERE codDia = @codDiaImparte))
						BEGIN					
						IF(@horaInicio <= @inicioSeccionCatedratico   AND @horaFinal>=@FinalSeccionCatedratico)
							BEGIN
							PRINT 'El Catedrático tiene un traslape de horas'							
                            RETURN 0;
							END
                        END
                    DELETE TOP(1) FROM #DiasSeccionImparte
                    SELECT @cantidadDiasImparte = COUNT(*) FROM #DiasSeccionImparte
                END
			
		DELETE TOP (1) FROM #SeccionesImpartiendo
		SELECT @cantidadImpartiendo = COUNT(*) FROM #SeccionesImpartiendo;

		END
		PRINT 'Todo está bien, Sección agregada'
		INSERT INTO [smregistro].[Seccion] VALUES (@codSeccion, @codAsignatura, @horaInicio , @horaFinal, @cupos, @codEdificio,
		@aula, @diasImpartir , @codCatedratico)

		UPDATE [smregistro].[Catedratico] SET [cantidadClases] = [cantidadClases] + 1, [activo] = 1
		WHERE codCatedratico = @codCatedratico
			
		END
		END
		ELSE
		BEGIN
		PRINT 'La asignatura indicada no es válida'
		END
		/*
		Condiciones que controlan si está cancelando en el rango de fechas establecidas según calendario
		*/

END
						/*Seccion de prueba*/
--SELECT * FROM Registro.smregistro.Seccion
--SELECT * FROM Registro.smregistro.Catedratico
--UPDATE Registro.smregistro.Catedratico SET cantidadClases = 2 
--delete Registro.smregistro.Seccion where codSeccion = 800 and codAsignatura = 'FS-100'
--13-15
--[dbo].[agregarSeccion] 800, 'FS-100', '8:00', '9:00', 30, 10, '105', 'LuMaMi', '102'