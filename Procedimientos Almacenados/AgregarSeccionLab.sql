USE [Registro]
GO
/****** Object:  StoredProcedure [dbo].[cancelarClase]    Script Date: 15/4/2020 7:30:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 15-04-2020
-- Description:	
/*
Agregar una sección
*/
-- =============================================
CREATE PROCEDURE smregistro.spAgregarSeccionLab
		/*
		Parametros que recibe el procedimiento
		*/
		@codSeccionLab INT,
		@codLab VARCHAR(7),
		@codAsignatura VARCHAR(7),
		@horaInicio TIME,
		@horaFinal TIME,
		@cupos INT,
		@diasImpartir VARCHAR(12),
		@codEdificio INT,
		@aula VARCHAR(20),
		@codInstructor VARCHAR(15)
		
AS
BEGIN

	SET NOCOUNT ON;


		/*
		Inicio de transacción y declaración de variables
		*/
		BEGIN TRANSACTION
		BEGIN TRY
		

		DECLARE @cantidadClases INT --aumentarlo a Instructor en caso de agregarlo
		DECLARE @activo BIT --activarlo en Instructor en caso de agregar la seccion
		DECLARE @cantidadSecciones INT
		DECLARE @codPeriodo INT
		DECLARE @fechaPeriodo DATE

		SET @codPeriodo = (SELECT codPeriodo
									FROM smregistro.Periodo
										WHERE activo = 1)

		SET @fechaPeriodo = (SELECT fechaInicio
									FROM smregistro.Periodo
										WHERE activo = 1)

		
		SET @cantidadSecciones = (SELECT COUNT(codSeccion) FROM smregistro.Seccion) + (SELECT COUNT(*) FROM smregistro.SeccionLab) 

		/*
		Crear tablas temporales para traslape de aulas
		*/
		--
		IF((SELECT [codLaboratorio] FROM [smregistro].[Laboratorio] WHERE [codLaboratorio] = @codLab AND [codAsignatura] = @codAsignatura) IS NOT NULL)
			BEGIN
				IF((SELECT [codEdificioFF] FROM [smregistro].[Aula] WHERE [codEdificioFF] = @codEdificio AND [aula] = @aula) IS NOT NULL)
				BEGIN

					CREATE TABLE #DiasAsignaturaSeccionNueva (codDia INT PRIMARY KEY, Dia VARCHAR(2));
						INSERT INTO #DiasAsignaturaSeccionNueva EXEC [smregistro].[spTablaDias] @diasImpartir;

					CREATE TABLE #Secciones (codSeccion INT, diasImparte VARCHAR(10), horaInicio TIME, horaFinal TIME,codEdificio INT, aula VARCHAR(20));
					
					INSERT INTO #Secciones 
					SELECT codSeccion, diaPresenciales,horaInicial,horaFinal,codEdificioFF,aula 
						FROM smregistro.Seccion

					INSERT INTO #Secciones
					SELECT codSeccion, diaImparte,horaInicial,horaFinal, codEdificioFF, codAula 
						FROM smregistro.SeccionLab
		
					DECLARE @inicioSeccionExistente TIME;
					DECLARE @FinalSeccionExistente TIME;
					DECLARE @DiasPresencialesExistente VARCHAR(12);

					SAVE TRANSACTION Punto1
				WHILE @cantidadSecciones>0
				BEGIN
		
					SELECT @inicioSeccionExistente=horaInicial, @FinalSeccionExistente = horaFinal, @DiasPresencialesExistente=diaImparte
					FROM smregistro.SeccionLab WHERE codSeccion = (SELECT TOP(1) codSeccion FROM #Secciones)

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
								IF((SELECT Dia FROM #DiasAsignaturaSeccionNueva WHERE codDia = @codDia)
									=(SELECT Dia FROM #DiasSeccion WHERE codDia = @codDia))
									BEGIN
										IF(@aula IN (SELECT Au.aula FROM Registro.smregistro.Edificio Ed
											INNER JOIN Registro.smregistro.Aula	Au
											ON Ed.codEdificio = Au.codEdificioFF
											WHERE Ed.codEdificio = @codEdificio 
												AND Au.aula = @aula
												AND Au.aula IN (SELECT codAula FROM Registro.smregistro.SeccionLab
													WHERE codEdificioFF = @codEdificio 
														AND @horaInicio <= horaInicial   
														AND @horaFinal>=horaFinal			
														AND @horaInicio<horaFinal)

									  --verificar tambien las secciones de las clases
														OR Au.aula IN (SELECT aula FROM Registro.smregistro.Seccion
															WHERE codEdificioFF = @codEdificio 
																AND @horaInicio <= horaInicial   
																AND @horaFinal>=horaFinal
							
														AND @horaInicio<horaFinal))
								
											)
											BEGIN
												PRINT 'El aula no está disponible a esta hora y en este dia'
									
												COMMIT TRANSACTION
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
				--Aqui insertar, aula disponible e iniciar lo del instructor
		
		-------------------------------
		
				SET @cantidadClases = (SELECT COUNT([codSeccion]) 
											FROM [smregistro].[SeccionLab] 
											WHERE [codInstructor] = @codInstructor) 
				IF(@cantidadClases = 3 
					OR @codInstructor NOT IN (SELECT [codInstructor] 
												FROM smregistro.Instructor))
					BEGIN
					PRINT 'Código de Instructor no existente o ya tiene asignado el número límite de secciones que puede impartir'
					COMMIT TRANSACTION
					--ROLLBACK TRANSACTION
					END
				ELSE
				BEGIN 
				/*
				Verificar que el catedrático no tenga ningun traslape
				*/

				CREATE TABLE #SeccionesImpartiendo (codSeccion INT, diasImparte VARCHAR(10), horaInicio TIME, horaFinal TIME, codInstructor VARCHAR(15) 
					);

				INSERT INTO #SeccionesImpartiendo 
				SELECT codSeccion, diaImparte,horaInicial,horaFinal,codInstructor FROM smregistro.SeccionLab WHERE codInstructor = @codInstructor
		
				DECLARE @inicioSeccionInstructor TIME;
				DECLARE @FinalSeccionInstructor TIME;
				DECLARE @DiasPresencialesInstructor VARCHAR(12);
				DECLARE @cantidadImpartiendo INT
	
				SELECT @cantidadImpartiendo = COUNT(*) FROM #SeccionesImpartiendo;
					SAVE TRANSACTION Punto2
				WHILE @cantidadImpartiendo>0
					BEGIN
		
						SELECT @inicioSeccionInstructor=horaInicial, @FinalSeccionInstructor = horaFinal, @DiasPresencialesInstructor=diaImparte
							FROM smregistro.SeccionLab 
								WHERE codSeccion = (SELECT TOP(1) codSeccion FROM #SeccionesImpartiendo)
			
						IF OBJECT_ID('tempdb.dbo.#DiasSeccionImparte', 'U') IS NOT NULL
								DROP TABLE #DiasSeccionImparte; 

							CREATE TABLE #DiasSeccionImparte (codDia INT PRIMARY KEY, Dia VARCHAR(2));
							INSERT INTO #DiasSeccionImparte EXEC [smregistro].[spTablaDias] @DiasPresencialesInstructor;
				
						DECLARE @cantidadDiasImparte INT;
						SELECT @cantidadDiasImparte = COUNT(*) FROM #DiasSeccionImparte;
						DECLARE @codDiaImparte INT;

							SAVE TRANSACTION Punto3
						WHILE @cantidadDiasImparte > 0
							BEGIN
								SELECT TOP(1) @codDiaImparte = codDia FROM #DiasSeccionImparte
								IF((SELECT Dia 
										FROM #DiasAsignaturaSeccionNueva 
											WHERE codDia = @codDiaImparte)
											=(SELECT Dia 
												FROM #DiasSeccionImparte 
													WHERE codDia = @codDiaImparte))
									BEGIN					
									IF(@horaInicio <= @inicioSeccionInstructor   
										AND @horaFinal>=@FinalSeccionInstructor)
											BEGIN
												PRINT 'El Instructor tiene un traslape de horas'
													COMMIT TRANSACTION
												Return 0;
											END
									END
								DELETE TOP(1) FROM #DiasSeccionImparte
								SELECT @cantidadDiasImparte = COUNT(*) 
									FROM #DiasSeccionImparte
							END
			
					DELETE TOP (1) FROM #SeccionesImpartiendo

					SELECT @cantidadImpartiendo = COUNT(*) 
						FROM #SeccionesImpartiendo;

					END
				PRINT 'Todo está bien, Sección agregada'
				COMMIT TRANSACTION

				INSERT INTO [smregistro].[SeccionLab] 
					VALUES (@codSeccionLab,
							@codLab, 
							@codAsignatura, 
							@horaInicio, 
							@horaFinal, 
							@cupos,
							@diasImpartir, 
							@codEdificio,
							@aula, 
							@codInstructor,
							@codPeriodo,
							@fechaPeriodo)
		
				UPDATE [smregistro].[Instructor] 
					SET  [cantLaboratorios]= [cantLaboratorios] + 1
						WHERE [codInstructor] = @codInstructor
			
				END
				END
			ELSE
			BEGIN
				PRINT 'Edificio o aula no existente'
			END
			END
		ELSE
		BEGIN
		PRINT 'Laboratorio no existente'
		COMMIT TRANSACTION
		END
		/*
		Condiciones que controlan si está cancelando en el rango de fechas establecidas según calendario
		*/
		END TRY
		BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Ha ocurrido un error con los datos, la sección no se ha agregado'
		END CATCH
END
						/*Seccion de prueba*/
--SELECT * FROM Registro.smregistro.SeccionLab
--SELECT * FROM Registro.smregistro.Instructor
--UPDATE Registro.smregistro.Catedratico SET cantidadClases = 2 
--delete Registro.smregistro.Seccion where codSeccion = 800 and codAsignatura = 'FS-100'
--13-15
--smregistro.spAgregarSeccionLab 800, 'FS1LAB','FS-100', '8:00', '9:00', 15, 'LuMaMi',10, '105', '300'