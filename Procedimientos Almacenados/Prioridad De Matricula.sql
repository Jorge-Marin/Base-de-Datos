-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Prioridad de Matricula
-- =============================================
ALTER PROCEDURE  [smregistro].[spMatriculaPrioridad]
	@cuentaEstudiante AS VARCHAR(15),
	@codigoCarrera AS VARCHAR(7),
	@codAsigMatriculada AS VARCHAR(7),
	@codSeccion INT,
    @fechaPeriodo DATE,
    @codperiodo INT,
    @prioridad INT,
    @inicioFecha DATE, 
    @finalFecha DATE
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @fecha AS DATE;
   
    /*Tabla temporal que requiere una fecha de inicio y final de
    para generar las fechas entre ese intervalo*/
    IF OBJECT_ID('tempdb.dbo.#FechasPrioriMatricula', 'U') IS NOT NULL
                DROP TABLE #FechasPrioriMatricula; 
            CREATE TABLE #FechasPrioriMatricula (prioridad INT PRIMARY KEY,fecha DATE);
            INSERT INTO #FechasPrioriMatricula EXEC [smregistro].[FechasRangosPrioridad] 
                                                                    @inicioFecha, @finalFecha;

    /*Obtiene la fecha de la tabla generada pero filtra por prioridad*/    
    SET @fecha = CAST((SELECT fecha FROM #FechasPrioriMatricula WHERE prioridad = @prioridad) AS DATE);
    
    /*Comprueba que las fechas sean iguales, si no imprime un mensaje de su dia de matricula
    que le correspone a la persona*/
    IF(/*CAST(GETDATE() AS DATE)*/  GETDATE()= GETDATE() /*@fecha*/)
        BEGIN
            /*Ejecucion de un procedimiento almacenado que verifica que la clase no interfiera
	        con la hora de una asignatura matriculada, tambien considera traslapes con los dias sabados,
	        y con clases que cuente con mas de una hora diaria*/
	        DECLARE @traslapeClase int
	        EXEC @traslapeClase = [smregistro].[spTraslapeClase] @codSeccion, 
                                                        @codAsigMatriculada, @codigoCarrera, 
														@cuentaEstudiante;
            IF(@traslapeClase=1)
                BEGIN 
                    PRINT 'Ya tiene una clase Matriculada en este horario';
                    RETURN 0;
                END
            ELSE
                BEGIN 
                    /*Extrae los cupos de la seccion a matricular, se controla 
					que la seccion exista, si no existe retornara 404 y no la matriculara*/
					DECLARE @cuposSeccion INT;
					SET @cuposSeccion = ISNULL((SELECT Se.cupos FROM Registro.smregistro.Seccion Se 
												WHERE codAsignatura = @codAsigMatriculada 
                                                AND codSeccion = @codSeccion), 404)
                    IF(@cuposSeccion = 404)
                        BEGIN 
                            PRINT 'La seccion que desea matricular no existe';
                            RETURN 0;
                        END
                    ELSE 
                        BEGIN
                            INSERT INTO Registro.smregistro.MatriculaClase (codAsignatura,
												cuentaEstudiante,
												codCarrera,
												codSeccionClase,
												fechaPeriodo,
												codperiodo)
											VALUES(
												@codAsigMatriculada,
												@cuentaEstudiante,
												@codigoCarrera,
												@codSeccion,
												@fechaPeriodo,
												@codperiodo
											)
                        END
                END
            RETURN
        END
    ELSE 
        BEGIN 
            PRINT CONCAT('Su fecha y hora de matricula es ',  @fecha,'de 9:00 a.m a 11:59 p.m');
            RETURN;
        END
END
GO						

