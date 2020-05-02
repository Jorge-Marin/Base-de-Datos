SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jorge Marin 20171003167
-- Create date: 07/04/2020
-- Description:	Matricula
-- =============================================
CREATE PROCEDURE [smregistro].[spMatriculaAsignatura] 
	@cuentaEstudiante AS VARCHAR(15),
	@codigoCarrera AS VARCHAR(7),
	@codAsigMatriculada AS VARCHAR(7),
	@codSeccion INT,
    @fechaPeriodo DATE,
    @codperiodo INT
AS
BEGIN
	SET NOCOUNT ON;

	/*Ejecucion de un procedimiento almacenado que verifica que la clase no interfiera
	a la misma de una matriculada, tambien considera traslapes con los dias sabados,
	y con clases que cuente con mas de una hora diaria*/
	DECLARE @traslapeClase int
	EXEC @traslapeClase = [smregistro].[spTraslapeClase] @codSeccion,  @codAsigMatriculada, @codigoCarrera, 
														@cuentaEstudiante, @fechaPeriodo;

	/*Si existe un traslape el procedimiento anterior respondera con un 1,
	en caso contrario respondera con un 0*/
	IF(@traslapeClase=1)
		BEGIN 
			RETURN 0;
		END
	ELSE
		BEGIN 
			/*Comienzo de la Transaccion*/
			BEGIN TRANSACTION
				BEGIN TRY
					
					/*Extrae las unidades valorativas de la asignatura que desea matricular*/
					DECLARE @uvAsignatura INT;
					SET @uvAsignatura = (SELECT Ag.unidadesValorativas FROM Registro.smregistro.Asignatura 
											AS Ag WHERE codAsignatura = @codAsigMatriculada);

					/*Extrae las unidades disponibles de un estudiante.*/
					DECLARE @uvDisponible INT;
					SET @uvDisponible = (SELECT unidadesValorativas FROM Registro.smregistro.Estudiante 
														WHERE numCuenta = @cuentaEstudiante)

					/*Verifica si ya aprobo la asignatura,
					por si acaso*/
					DECLARE @aprobada INT;
					SET @aprobada = (SELECT COUNT(DISTINCT(codAsignatura)) FROM Registro.smregistro.HistorialAcademico
												WHERE codCarrera = @codigoCarrera
													AND cuentaEstudiante = @cuentaEstudiante
													AND codAsignatura = @codAsigMatriculada
													AND calificacion >= 65);
													

					/*Crea una tabla temporal de los requisitos que aun le falta a la clase 
					matriculada*/
					IF OBJECT_ID('tempdb.dbo.#RequisitosFaltantes', 'U') IS NOT NULL
								DROP TABLE #RequisitosFaltantes; 
							CREATE TABLE #RequisitosFaltantes (codAsignatura VARCHAR(7));
							INSERT INTO #RequisitosFaltantes EXEC [smregistro].[spRequisitosClase] @cuentaEstudiante, @codigoCarrera, @codAsigMatriculada;
							DECLARE @requisitos INT;
							SET @requisitos = (SELECT COUNT(DISTINCT(codAsignatura)) FROM #RequisitosFaltantes);
							

					/*Extrae los cupos de la seccion a matricular, se controla 
					que la seccion exista, si no existe retornara 404 y no la matriculara*/
					DECLARE @cuposSeccion INT;
					SET @cuposSeccion = ISNULL((SELECT Se.cupos FROM Registro.smregistro.Seccion Se 
												WHERE codAsignatura = @codAsigMatriculada AND codSeccion = @codSeccion), 404)

					
					/*Verifica que: 
							1. El estudiante tenga unidades Valorativas Disponibles para matricular
								la asignatura
							2. Verifica que este matriculad@ en la carrera
							3. Y que no este matriculando una asignatura que ya aprobo*/
					IF((@uvDisponible-@uvAsignatura)>=0 AND @uvDisponible IS NOT NULL AND @aprobada = 0 AND @cuposSeccion!= 404)
						BEGIN
							
							/*Comprueba que no el estudiante cumpla con los requisitos para la clase*/
							IF(@requisitos=0)
								BEGIN
												
									/*Verifica que en la seccion existan cupos, si no hay cupos disponibles 
										la clase se matriculara en espera*/
									
									IF(@cuposSeccion>0)
										BEGIN 
											UPDATE Registro.smregistro.Estudiante SET unidadesValorativas = (unidadesValorativas - @uvAsignatura)
												WHERE numCuenta = @cuentaEstudiante;

											UPDATE Registro.smregistro.Seccion SET cupos = (cupos-1)	
												WHERE codAsignatura = @codAsigMatriculada 
												AND codSeccion = @codSeccion;
											
											/*Se ingresan los datos faltantes de la tabla matriculaclase 
												para una mejor UX desde este punto*/
											
											INSERT INTO Registro.smregistro.MatriculaClase(
														codCarrera,
														cuentaEstudiante,
														codSeccionClase,
														codAsignatura,
														fechaPeriodo,
														fechaMat,
														codperiodo, 
														calificacion,
														espera,
														observaciones)
														VALUES(
														@codigoCarrera,
														@cuentaEstudiante,
														@codSeccion,
														@codAsigMatriculada,
														@fechaPeriodo,
														GETDATE(),
														@codperiodo,
														0,
														0,
														'N/D')
											

											PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada');
										END
									ELSE 
										BEGIN
											/*Se ingresan los datos faltantes de la tabla matriculaclase 
												para una mejor UX desde este punto*/
											INSERT INTO Registro.smregistro.MatriculaClase(
														codCarrera,
														cuentaEstudiante,
														codSeccionClase,
														codAsignatura,
														fechaPeriodo,
														fechaMat,
														codperiodo, 
														calificacion,
														espera,
														observaciones)
														VALUES(
														@codigoCarrera,
														@cuentaEstudiante,
														@codSeccion,
														@codAsigMatriculada,
														@fechaPeriodo,
														GETDATE(),
														@codperiodo,
														0,
														1,
														'N/D')

											PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada En Espera');
										END
									DECLARE @laboratorioClase INT;
									SET @laboratorioClase = (SELECT COUNT(DISTINCT(codLaboratorio)) FROM Registro.smregistro.Laboratorio WHERE 
									codAsignatura = @codAsigMatriculada);

									/*Verifica si la clase tiene laboratorio para imprimir un mensaje que 
										informe sobre la existencia del laboratorio*/
									IF(@laboratorioClase=1)
										BEGIN 
											PRINT CONCAT('La clase ', @codAsigMatriculada,' Posee Laboratorio, Revise las Secciones Disponibles en Secciones Laboratorio')
										END
									ELSE 
										BEGIN 
											PRINT CONCAT('La clase ', @codAsigMatriculada,' No Posee Laboratorio')
										END


										/*Todo bien en la transaccion*/
									COMMIT TRANSACTION
								END    
							ELSE 
								BEGIN

									/*
										Si faltan requisitos ademas imprimira una tabla con los requisitos faltantes
									*/
									PRINT 'Faltan Requisitos para matricular esta asignatura';
									SELECT * FROM #RequisitosFaltantes;
									
									ROLLBACK TRANSACTION
								END	
						END	
					ELSE 
						BEGIN
							/*
								Muestra mensajes de unidades no suficientes o que la asignatura ya fue aprobada
							*/
							IF ((@uvDisponible-@uvAsignatura)<0)
								BEGIN
									PRINT 'No dispone de Unidades Valorativas para Matricular Esta Asignatura';
								END

							
							IF (@cuposSeccion = 404)
								BEGIN
									PRINT CONCAT('La Seccion ', @codSeccion,' para la Asignatura ', @codAsigMatriculada, ' No Existe');
								END

							IF (@aprobada != 0)
								BEGIN
									PRINT 'Esta Asignatura ya Fue Aprobada';
								END

							ROLLBACK TRANSACTION
					END
				END TRY 

				BEGIN CATCH

					/*Algo malo paso, regresa todos los registros a la normalidad*/
					PRINT 'Ha Ocurrido Un Error, Intente lo nuevamente';
					ROLLBACK TRANSACTION 
				END CATCH
				END
END
GO





