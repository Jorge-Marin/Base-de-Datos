-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 03/04/2020
-- Description:	Trigger con transaccion de Matricula
-- =============================================
CREATE TRIGGER trMatriculaAsignatura 
   ON  Registro.smregistro.MatriculaClase
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;

	DECLARE @cuentaEstudiante AS VARCHAR(15);
	DECLARE @codigoCarrera AS VARCHAR(7);
	DECLARE @codAsigMatriculada AS VARCHAR(7);
	DECLARE @codSeccion INT;
	DECLARE @requisitos INT;
	
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
											AND calificacion >= 65)
			

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
					IF(@requisitos=0)
						BEGIN				
						
							DECLARE @cuposSeccion INT;
							SET @cuposSeccion = (SELECT Se.cupos FROM Registro.smregistro.Seccion Se 
														WHERE codAsignatura = @codAsigMatriculada AND codSeccion = @codSeccion)
							IF(@cuposSeccion>0)
								BEGIN
									UPDATE Registro.smregistro.MatriculaCarrera SET unidadesValorativas = (unidadesValorativas - @uvAsignatura)
										WHERE cuentaEstudiante = @cuentaEstudiante
											AND codCarrera = @codigoCarrera;

									UPDATE Registro.smregistro.Seccion SET cupos = (cupos-1)	
										WHERE codAsignatura = @codAsigMatriculada 
										AND codSeccion = @codSeccion;

									UPDATE Registro.smregistro.MatriculaClase SET espera = 0,
										fechaMat = GETDATE(),
										calificacion = 0
										WHERE codCarrera = @codigoCarrera 
										AND cuentaEstudiante = @cuentaEstudiante
										AND codAsignatura = @codAsigMatriculada
										AND fechaPeriodo = (SELECT fechaPeriodo FROM inserted);

									PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada');
								END
							ELSE 
								BEGIN 
									UPDATE Registro.smregistro.MatriculaClase SET espera = 1
										WHERE codCarrera = @codigoCarrera 
										AND cuentaEstudiante = @cuentaEstudiante
										AND codAsignatura = @codAsigMatriculada
										AND fechaPeriodo IN (SELECT fechaMat FROM inserted);

									PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada En Espera');
								END
						

							DECLARE @laboratorioClase INT;
							SET @laboratorioClase = (SELECT COUNT(DISTINCT(codLaboratorio)) FROM Registro.smregistro.Laboratorio WHERE codAsignatura = 'MM-201');

							IF(@laboratorioClase=1)
								BEGIN 
									PRINT CONCAT('La clase ', @codAsigMatriculada,' Posee Laboratorio, Revise las Secciones Disponibles en Secciones Laboratorio')
								END
							ELSE 
								BEGIN 
									PRINT CONCAT('La clase ', @codAsigMatriculada,' No Posee Laboratorio')
								END

							COMMIT TRANSACTION
						END
					ELSE 
						BEGIN
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
			PRINT 'Ha Ocurrido Un Error, Intente lo nuevamente';
			ROLLBACK TRANSACTION 
		END CATCH

END
GO
