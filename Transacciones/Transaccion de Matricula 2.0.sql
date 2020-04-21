-- =============================================
-- Author:		Jorge Arturo Reyes Marin 20171003167
-- Create date: 03/04/2020
-- Description:	Trigger con transaccion de Matricula
-- =============================================
CREATE TRIGGER trMatriculaAsignatura 
   ON  Registro.smregistro.MatriculaClase
   AFTER INSERT
AS 
BEGIN	
	/*No Mostrar Mensajes de Filas Afectadas*/
	SET NOCOUNT ON;
	
	/*Declaracion de Variables*/
	DECLARE @cuentaEstudiante AS VARCHAR(15);
	DECLARE @codigoCarrera AS VARCHAR(7);
	DECLARE @codAsigMatriculada AS VARCHAR(7);
	DECLARE @codSeccion INT;
	DECLARE @requisitos INT;
	
	/*Comienzo de la Transaccion*/
	BEGIN TRANSACTION
		BEGIN TRY
			SET @cuentaEstudiante = (SELECT cuentaEstudiante FROM inserted);
			SET @codigoCarrera = (SELECT codCarrera FROM inserted);
			SET @codAsigMatriculada = (SELECT codAsignatura FROM inserted);
			SET @codSeccion = (SELECT codSeccionClase FROM inserted);
			
			DECLARE @uvAsignatura INT;
			SET @uvAsignatura = (SELECT Ag.unidadesValorativas FROM Registro.smregistro.Asignatura AS Ag WHERE codAsignatura = @codAsigMatriculada);

			DECLARE @uvDisponible INT;
			SET @uvDisponible = (SELECT unidadesValorativas FROM Registro.smregistro.MatriculaCarrera 
												WHERE codCarrera = @codigoCarrera AND 
													  cuentaEstudiante = @cuentaEstudiante)

			DECLARE @aprobada INT;
			SET @aprobada = (SELECT COUNT(DISTINCT(codAsignatura)) FROM Registro.smregistro.MatriculaClase
										WHERE codCarrera = @codigoCarrera
											AND cuentaEstudiante = @cuentaEstudiante
											AND codAsignatura = @codAsigMatriculada
											AND calificacion >= 65);
			
			/*
				Verifica que: 
					1. El estudiante tenga unidades Valorativas Disponibles para matricular
						la asignatura
					2. Verifica que este matriculad@ en la carrera
					3. Y que no este matriculando una asignatura que ya aprobo
			*/
			IF((@uvDisponible-@uvAsignatura)>0 AND @uvDisponible IS NOT NULL AND @aprobada = 0)
				BEGIN 
					SET @requisitos = (SELECT COUNT(DISTINCT(Rc.codAsignarutaRequisitos)) 
							FROM (SELECT Ar.codAsignarutaRequisitos FROM Registro.smregistro.Requisitos AS Ar 
							WHERE Ar.codCarreraFFR = @codigoCarrera	AND Ar.codAsignaturaFFR = @codAsigMatriculada
								AND Ar.codAsignarutaRequisitos NOT IN (SELECT He.codAsignatura 
																			FROM Registro.smregistro.HistorialAcademico AS He 
																			WHERE cuentaEstudiante = @cuentaEstudiante AND 
																			codCarrera = @codigoCarrera
																			AND He.calificacion>64)) AS Rc);
			/*
				Comprueba que no el estudiante cumpla con los requisitos para la clase
			*/
					IF(@requisitos=0)
						BEGIN				
						
							DECLARE @cuposSeccion INT;
							SET @cuposSeccion = (SELECT Se.cupos FROM Registro.smregistro.Seccion Se 
														WHERE codAsignatura = @codAsigMatriculada AND codSeccion = @codSeccion)

							/*
								Verifica que en la seccion existan cupos, si no hay cupos disponibles 
								la clase se matriculara en espera
							*/
							IF(@cuposSeccion>0)
								BEGIN
									UPDATE Registro.smregistro.MatriculaCarrera SET unidadesValorativas = (unidadesValorativas - @uvAsignatura)
										WHERE cuentaEstudiante = @cuentaEstudiante
											AND codCarrera = @codigoCarrera;

									UPDATE Registro.smregistro.Seccion SET cupos = (cupos-1)	
										WHERE codAsignatura = @codAsigMatriculada 
										AND codSeccion = @codSeccion;
									
									/*
										Se ingresan los datos faltantes de la tabla matriculaclase 
										para una mejor UX desde este punto
									*/
									UPDATE Registro.smregistro.MatriculaClase SET espera = 0,
										calificacion = 0,
										observaciones = 'N/D',
										fechaMat = GETDATE()
										WHERE codCarrera = @codigoCarrera 
										AND cuentaEstudiante = @cuentaEstudiante
										AND codAsignatura = @codAsigMatriculada
										AND fechaPeriodo = (SELECT fechaPeriodo FROM inserted);

									PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada');
								END
							ELSE 
								BEGIN
								
									/*
										Se ingresan los datos faltantes de la tabla matriculaclase 
										para una mejor UX desde este punto
									*/
									UPDATE Registro.smregistro.MatriculaClase SET espera = 1,
										calificacion = 0,
										observaciones = 'N/D',
										fechaMat = GETDATE()
										WHERE codCarrera = @codigoCarrera 
										AND cuentaEstudiante = @cuentaEstudiante
										AND codAsignatura = @codAsigMatriculada

									PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada En Espera');
								END
						

							DECLARE @laboratorioClase INT;
							SET @laboratorioClase = (SELECT COUNT(DISTINCT(codLaboratorio)) FROM Registro.smregistro.Laboratorio WHERE codAsignatura = 'MM-201');

							/*	Verifica si la clase tiene laboratorio para imprimir un mensaje que 
								informe sobre la existencia del laboratorio
							*/
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

							(SELECT Rc.codAsignarutaRequisitos 
							FROM (SELECT Ar.codAsignarutaRequisitos FROM Registro.smregistro.Requisitos AS Ar 
							WHERE Ar.codCarreraFFR = @codigoCarrera	AND Ar.codAsignaturaFFR = @codAsigMatriculada
								AND Ar.codAsignarutaRequisitos NOT IN (SELECT He.codAsignatura 
																			FROM Registro.smregistro.HistorialAcademico AS He 
																			WHERE cuentaEstudiante = @cuentaEstudiante AND 
																			codCarrera = @codigoCarrera
																			AND He.calificacion>64)) AS Rc);
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
GO
