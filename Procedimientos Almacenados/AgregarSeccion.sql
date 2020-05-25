-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 13-04-2020
-- Description:	/*Agregar una secci�n*/
-- =============================================
/*smregistro.spAgregarSeccion 900,'FS-100','9:00','10:00',30,10,'105','LuMaMi','103'
INSERT INTO smregistro.Seccion VALUES(900,'FS-100','9:00','10:00',30,10,'105','LuMaMi','102',1,'2020-04-20')
select * from smregistro.Seccion
select * from smregistro.Periodo
delete smregistro.Seccion where codSeccion = 900*/

ALTER PROCEDURE smregistro.spAgregarSeccion
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
		/*Inicio de transacci�n y declaraci�n de variables*/
		
		BEGIN TRANSACTION
			BEGIN TRY

				DECLARE @cantidadClases INT --aumentarlo a catedratico en caso de agregarlo
				DECLARE @activo BIT --activarlo en catedratico en caso de agregar la seccion
				DECLARE @cantidadSecciones INT
				DECLARE @codPeriodo INT
				DECLARE @fechaPeriodo DATE

				SET @codPeriodo = (SELECT codPeriodo
									FROM smregistro.Periodo
										WHERE activo = 1)

				SET @fechaPeriodo = (SELECT fechaInicio
									FROM smregistro.Periodo
										WHERE activo = 1)


			
				SET @cantidadSecciones = ((SELECT COUNT(codSeccion) FROM Registro.smregistro.Seccion) 
										+ (SELECT COUNT(*) FROM [smregistro].[SeccionLab]))
								
				/*Crear tablas temporales para traslape de aulas*/
				IF(@codAsignatura IN (SELECT codAsignatura FROM Registro.smregistro.Asignatura))
					BEGIN
					
						CREATE TABLE #DiasAsignaturaSeccionNueva (codDia INT PRIMARY KEY, 
															  	  Dia VARCHAR(2));
					
						INSERT INTO #DiasAsignaturaSeccionNueva EXEC [smregistro].[spTablaDias] 
																				 @diasImpartir;

						CREATE TABLE #Secciones (codSeccion INT, 
												diasImparte VARCHAR(10), 
												horaInicio TIME, 
												horaFinal TIME,
												codEdificio INT, 
												aula VARCHAR(20));
						
						INSERT INTO #Secciones SELECT codSeccion, 
													diaPresenciales,
													horaInicial,
													horaFinal,
													codEdificioFF,
													aula 
													FROM Registro.smregistro.Seccion

					--agregar las secciones de laboratorio
						INSERT INTO #Secciones	SELECT codSeccion, 
													   diaImparte,
													   horaInicial,
													   horaFinal, 
													   codEdificioFF, 
													   codAula 
														FROM smregistro.SeccionLab
				
						DECLARE @inicioSeccionExistente TIME;
						DECLARE @FinalSeccionExistente TIME;
						DECLARE @DiasPresencialesExistente VARCHAR(12);
						
						WHILE @cantidadSecciones>0
							BEGIN
								SELECT @inicioSeccionExistente = horaInicial, 
									@FinalSeccionExistente = horaFinal, 
									@DiasPresencialesExistente = diaPresenciales
									FROM Registro.smregistro.Seccion 
									WHERE codSeccion = (SELECT TOP(1) codSeccion
															FROM #Secciones)

								IF OBJECT_ID('tempdb.dbo.#DiasSeccion', 'U') IS NOT NULL
										DROP TABLE #DiasSeccion; 

									CREATE TABLE #DiasSeccion (codDia INT PRIMARY KEY, 
															Dia VARCHAR(2));

									INSERT INTO #DiasSeccion EXEC [smregistro].[spTablaDias] 
																@DiasPresencialesExistente;

						
									DECLARE @cantidadDias INT;
									SELECT @cantidadDias = COUNT(*) FROM #DiasSeccion;
									DECLARE @codDia INT;

									SAVE TRANSACTION Punto1
								WHILE @cantidadDias > 0
									BEGIN
										SELECT TOP(1) @codDia = codDia FROM #DiasSeccion
										IF((SELECT Dia FROM #DiasAsignaturaSeccionNueva 
													WHERE codDia = @codDia)=(SELECT Dia FROM #DiasSeccion 
																						WHERE codDia = @codDia))
											BEGIN
												IF(@aula IN (SELECT Au.aula FROM Registro.smregistro.Edificio Ed
																	INNER JOIN Registro.smregistro.Aula	Au
																	ON Ed.codEdificio = Au.codEdificioFF
																	WHERE Ed.codEdificio = @codEdificio 
																	AND Au.aula = @aula
																	AND Au.aula IN (SELECT aula FROM Registro.smregistro.Seccion
																									 WHERE codEdificioFF = @codEdificio 
																								     AND @horaInicio <= horaInicial   
																									 AND @horaFinal>=horaFinal
																									 AND @horaInicio<horaFinal)
													--verificar tambien las secciones de los laboratorios
													OR Au.aula IN (SELECT aula FROM Registro.smregistro.SeccionLab
														WHERE codEdificioFF = @codEdificio 
														AND @horaInicio <= horaInicial  
														AND @horaFinal>=horaFinal
														AND @horaInicio<horaFinal)))
													BEGIN

														PRINT 'El aula no est� disponible a esta hora y en este dia'
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


						-- No encontro problemas Aula Disponible
						-- Aqui insertar, aula disponible e iniciar lo del catedratico	
				
/*----------------------------------- Se procede a Agregar la Seccion ----------------------------*/
				
					SET @cantidadClases = (SELECT COUNT(codSeccion) 
										   			FROM Registro.smregistro.Seccion 
										   			WHERE codCatedratico= @codCatedratico) 

					IF(@cantidadClases = 3 OR @codCatedratico NOT IN (SELECT codCatedratico FROM Registro.smregistro.Catedratico))
						BEGIN
							PRINT 'C�digo de catedr�tico no existente o ya tiene asignado el n�mero l�mite de secciones que puede impartir'
							COMMIT TRANSACTION
						END
					ELSE
						BEGIN
						
						/*Verificar que el catedr�tico no tenga ningun traslape*/
						CREATE TABLE #SeccionesImpartiendo (codSeccion INT, 
															diasImparte VARCHAR(10), 
															horaInicio TIME, 
															horaFinal TIME, 
															codCatedratico VARCHAR(15));

						INSERT INTO #SeccionesImpartiendo SELECT codSeccion, 
																 diaPresenciales,
																 horaInicial,
																 horaFinal,
																 codCatedratico FROM smregistro.Seccion 
																 WHERE codCatedratico = @codCatedratico
				

						DECLARE @inicioSeccionCatedratico TIME;
						DECLARE @FinalSeccionCatedratico TIME;
						DECLARE @DiasPresencialesCatedratico VARCHAR(12);
						DECLARE @cantidadImpartiendo INT
			
						SELECT @cantidadImpartiendo = COUNT(*) FROM #SeccionesImpartiendo;
							SAVE TRANSACTION Punto2

						WHILE @cantidadImpartiendo>0
							BEGIN
				
								SELECT @inicioSeccionCatedratico = horaInicial, 
									   @FinalSeccionCatedratico = horaFinal, 
									   @DiasPresencialesCatedratico = diaPresenciales
									   FROM Registro.smregistro.Seccion 
									   WHERE codSeccion = (SELECT TOP(1) codSeccion 
									   					   FROM #SeccionesImpartiendo)

								IF OBJECT_ID('tempdb.dbo.#DiasSeccionImparte', 'U') IS NOT NULL
									DROP TABLE #DiasSeccionImparte; 
									CREATE TABLE #DiasSeccionImparte (codDia INT PRIMARY KEY, 
																	  Dia VARCHAR(2));
									INSERT INTO #DiasSeccionImparte EXEC [smregistro].[spTablaDias] 
																		@DiasPresencialesCatedratico;
						
								DECLARE @cantidadDiasImparte INT;
								SELECT @cantidadDiasImparte = COUNT(*) FROM #DiasSeccionImparte;
								DECLARE @codDiaImparte INT;
					
								WHILE @cantidadDiasImparte > 0
									BEGIN
										SELECT TOP(1) @codDiaImparte = codDia FROM #DiasSeccionImparte

										IF((SELECT Dia FROM #DiasAsignaturaSeccionNueva 
												WHERE codDia = @codDiaImparte)=(SELECT Dia FROM #DiasSeccionImparte 
																								WHERE codDia = @codDiaImparte))
											BEGIN					
												IF(@horaInicio <= @inicioSeccionCatedratico   AND @horaFinal>=@FinalSeccionCatedratico)
													BEGIN
														PRINT 'El Catedr�tico tiene un traslape de horas'	
														COMMIT TRANSACTION
														RETURN 0;
													END
											END
										DELETE TOP(1) FROM #DiasSeccionImparte
										SELECT @cantidadDiasImparte = COUNT(*) FROM #DiasSeccionImparte
									END
					
							DELETE TOP (1) FROM #SeccionesImpartiendo
							SELECT @cantidadImpartiendo = COUNT(*) FROM #SeccionesImpartiendo;

						END
						
						PRINT 'Todo est� bien, Secci�n agregada'
						COMMIT TRANSACTION
						INSERT INTO Registro.smregistro.Seccion 
							VALUES (
								@codSeccion, 
								@codAsignatura, 
								@horaInicio , 
								@horaFinal, 
								@cupos, 
								@codEdificio,
								@aula, 
								@diasImpartir , 
								@codCatedratico,
								@codPeriodo,
								@fechaPeriodo)

						UPDATE Registro.smregistro.Catedratico 
							SET cantidadClases = (cantidadClases + 1), activo = 1
								WHERE codCatedratico = @codCatedratico
						END
					END
				ELSE
					BEGIN
						PRINT 'La asignatura indicada no es v�lida'
						COMMIT TRANSACTION
					END
			/*
				Condiciones que controlan si est� cancelando en el rango de fechas establecidas 
				seg�n calendario
			*/
			END TRY
			
			BEGIN CATCH
				PRINT 'Ha ocurrido un error con los datos, la secci�n no se ha agregado'
				ROLLBACK TRANSACTION
			END CATCH
END
