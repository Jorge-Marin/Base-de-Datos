-- =============================================
-- Author: Bessy Daniela Zavala Licona 20171004244
-- Create date: 04/04/2020
-- Description: 
/*	Trigger con transaccion de Matricula Carrera, en el se matricula a un estudiante en caso que cumppla con los requisitos
requeridos de la carrera a la que quiere matricular, seguidamente actualiza los cupos disponibles de estudiantes en la carrera
de la misma manera controla la cantidad de carreras que el estudiante tiene matriculadas, ya que no pueder matricular maximo 2 carreras
*/
-- =============================================
		
CREATE TRIGGER [smregistro].[tgControMatriculaCarrera]
	ON  [Registro].[smregistro].[MatriculaCarrera] AFTER INSERT AS
	BEGIN
	/*No Mostrar Mensajes de Filas Afectadas*/
	SET NOCOUNT ON;
	/*Declaracion de Variables*/
		DECLARE @Cta VARCHAR(15);
		DECLARE @CodCarrera VARCHAR(7);
		DECLARE @indiceRequeridoPAA int;
		DECLARE @indiceObtenidoPAA int;
		DECLARE @indiceExtraRequerido int;
		DECLARE @indiceExtraObtenido int;
		DECLARE @codRequisitoExtraRequerido int; --carrera
		DECLARE @codExtraRequerido int; --estudiante
		DECLARE @cantidadCarreras int;
		DECLARE @cuposDisponibles int;
	
	BEGIN TRANSACTION
		BEGIN TRY
			SELECT @Cta = cuentaEstudiante,
				   @CodCarrera = codCarrera 
				   FROM inseted;

			SELECT @indiceRequeridoPAA = indiceRequerido,
				   @indiceExtraRequerido = indiceExtraRequerido,
				   @cuposDisponibles = cuposDisponibles
				FROM Registro.smregistro.Carrera 
				WHERE codCarrera = @CodCarrera;

			SELECT @indiceObtenidoPAA = indicePAA, 
				   @indiceExtraObtenido = indiceExtraRequeridoObtenido
				   FROM Registro.smregistro.Estudiante
				   WHERE numCuenta = @Cta;

			SELECT @cantidadCarreras = COUNT(cuentaEstudiante) 
				FROM Registro.smregistro.MatriculaCarrera
				WHERE cuentaEstudiante = @Cta;

		--Iniciamos la transacci�n
		IF(@cuposDisponibles>0) --verifica que la carrera tenga cupos disponibles
			BEGIN
				IF(@cantidadCarreras>2) --esta condicion es porque el estudiante no puede matricular mas de 2 carreras
					BEGIN
						PRINT '-----No puede matricular m�s de 2 carreras-----'
							DELETE MatriculaCarrera
								WHERE codCarrera = @CodCarrera
								AND cuentaEstudiante= @Cta

					END 
				ELSE
					BEGIN
						IF(@indiceObtenidoPAA<@indiceRequeridoPAA)  --verifica que cumpla el requisito de la PAA
							BEGIN
								PRINT '-----Lo sentimos, no ha alcanzado el suficiente promedio de PAA para la carrera a la que dese aplicar-----'
								DELETE MatriculaCarrera
									WHERE codCarrera = @CodCarrera
									AND cuentaEstudiante= @Cta
							END
						ELSE
							If(@indiceExtraRequerido IS NOT NULL ) --en caso de que la carrera tenga algun requsito extra, verifica que el estudiante cumpla con �l, como en el caso de IS con la PAM
								BEGIN
									IF( @indiceExtraObtenido IS NULL)
										BEGIN
											PRINT '-----Lo sentimos, debe realizar la prueba solicitada por la carrera a la que dese aplicar-----'
											DELETE MatriculaCarrera
												WHERE codCarrera = @CodCarrera
												AND cuentaEstudiante= @Cta
										END	
							ELSE IF(@indiceExtraObtenido<@indiceExtraRequerido) 
								BEGIN
									PRINT '-----Lo sentimos, no ha alcanzado el suficiente promedio de la prueba requerida  para la carrera a la que dese aplicar-----'
									DELETE MatriculaCarrera
										WHERE codCarrera = @CodCarrera
										AND cuentaEstudiante= @Cta
								END

							ELSE
								BEGIN
									UPDATE Carrera SET cuposDisponibles = (@cuposDisponibles-1) --en caso que el estudiante cumpla con todos los requisitos de la carrera, lo matricula y resta los cupos disponibles en la tabla carrera
									WHERE codCarrera = @codCarrera
								END
			
						END
				END

			END
		ELSE
			BEGIN
				PRINT '-----Lo sentimos, la carrera a la que desea aplicar no tiene cupos disponibles-----'
				DELETE MatriculaCarrera
					WHERE codCarrera = @CodCarrera
					AND cuentaEstudiante= @Cta

			END

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			--Si ha ocurrido alg�n error llegamos hasta aqui
			PRINT 'Ha ocurrido un error, no se ha matriculado a la carrera deseada'
			ROLLBACK TRAN
		END CATCH
END
