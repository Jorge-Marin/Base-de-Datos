-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Prematricula sin haber cancelado la matricula, y verifica 
-- si es su dia de matricula, tambien verifica si es tiempo de matricula y 
-- si ya ha cancelado el estado de cuenta, si no lo ha cancelado no podra 
-- matricular la asignatura.
-- =============================================
ALTER PROCEDURE  [smregistro].[Prematricula]
    @cuentaEstudiante AS VARCHAR(15),
	@codigoCarrera AS VARCHAR(7),
	@codAsigMatriculada AS VARCHAR(7),
	@codSeccion INT,
    @fechaPeriodo DATE,
    @codperiodo INT
	AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @inicioPrematricula AS DATE; 
    DECLARE @finalPrematricula AS DATE;
    DECLARE @inicioMatricula AS DATE;
    DECLARE @finalMatricula AS DATE;
    DECLARE @fechaInicio AS DATE;
    DECLARE @fechaFinal AS DATE;
    DECLARE @tipomatricula AS VARCHAR(20);


    SELECT @inicioPrematricula = Pe.inicioPrematricula,
           @finalPrematricula = Pe.finalPrematricula,
           @inicioMatricula = Pe.inicioMatricula,
           @finalMatricula = Pe.finalMatricula 
           FROM Registro.smregistro.Periodo Pe 
                WHERE activo = 1;

    IF(@inicioMatricula<= GETDATE() AND GETDATE()<= @finalMatricula)
        BEGIN
            DECLARE @estadoCuenta BIT;
            SET @estadoCuenta = (SELECT smregistro.accountStatus (@cuentaEstudiante));
            IF(@estadoCuenta = 0)
                BEGIN 
                    PRINT 'Aun no ha cancelado la matricula'
                    RETURN;
                END
            ELSE 
                BEGIN 
                    SET @fechaInicio = @inicioMatricula;
                    SET @fechaFinal = @finalMatricula;
                    SET @tipomatricula = 'Matricula';
                END
        END
    ELSE 
        BEGIN 
            SET @fechaInicio = @inicioPrematricula;
            SET @fechaFinal = @finalPrematricula;
            SET @tipomatricula = 'Prematricula';
        END


    IF(GETDATE()<CAST(@fechaInicio AS DATE))
        BEGIN
            PRINT CONCAT('El periodo de prematricula comezara en', 
                        DATEDIFF(DAY, GETDATE(), @fechaInicio),' Dias de 9:00 a.m. a 11:59 p.m.');
            RETURN
        END
    
    IF(GETDATE()>CAST(@fechaFinal AS DATE))
        BEGIN
            PRINT CONCAT('El periodo de prematricula acabo hace ', 
                            DATEDIFF(DAY, @fechaFinal, GETDATE()),' Dias');
            RETURN
        END


    IF(CONVERT(TIME, '09:00:00:00')<=CONVERT(TIME, GETDATE(), 108) AND CONVERT(TIME, GETDATE(), 108)<CONVERT(TIME, '23:59:00:00'))
        BEGIN 
            /*Procedimiento para calcular el indice global*/
            DECLARE @indiceGlobal INT
            SET @indiceGlobal = (SELECT [smregistro].[getGlobalIndex] (@cuentaEstudiante, @codigoCarrera));

            DECLARE @numAsignaturasAprobadas INT;
            SET @numAsignaturasAprobadas = (SELECT COUNT(DISTINCT(codAsignatura)) FROM Registro.smregistro.HistorialAcademico
                                                WHERE codCarrera = @codigoCarrera
                                                AND cuentaEstudiante = @cuentaEstudiante
                                                AND calificacion>= 65)
    
            
            /*Exelencia Academica*/
            IF(@indiceGlobal>=80 AND @numAsignaturasAprobadas>=10)
                BEGIN
                    EXECUTE [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1, @fechaInicio, @fechaFinal;
                    RETURN;
                END

            DECLARE @PROSENE INT;
            SET @PROSENE = (SELECT COUNT(DISTINCT(numeroCuentaFF)) FROM Registro.smregistro.PROSENE
                                        WHERE numeroCuentaFF = @cuentaEstudiante);

            /*Personas con Discapacidades*/
            IF(@PROSENE>0)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1,  @fechaInicio, @fechaFinal;
                    RETURN;
                END
            

            DECLARE @representanteUNAH INT;
            SET @representanteUNAH = (SELECT COUNT(DISTINCT(numeroCuentaFF)) FROM Registro.smregistro.RepresentanteUNAH
                                        WHERE numeroCuentaFF = @cuentaEstudiante)

            /*Representantes UNAH*/
            IF(@representanteUNAH>0)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1, @fechaInicio, @fechaFinal;
                    RETURN;
                END

            /*Primer Ingreso*/
            /*En caso de que su indice Global sea Cero*/
            /*Y que no tenga asignarutas en su historial academico*/
            /*y que el año de ingreso sea el año actual*/
            IF(@indiceGlobal=0 AND @numAsignaturasAprobadas=0 AND /*SUBSTRING (@cuentaEstudiante,1,4)*/2020=CAST(YEAR(GETDATE()) AS VARCHAR(4)))
                BEGIN  
                    PRINT 'Primer Ingreso';
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 2,  @fechaInicio, @fechaFinal;
                    RETURN;
                END

            /*Matricula por indice de Periodo*/
            DECLARE @indicePeriodo INT
            SET @indicePeriodo = (SELECT [smregistro].[getIndexPeriod] (@cuentaEstudiante, @codigoCarrera));

            /*Donde el indice este entre 81 a 100*/
            IF(81<=@indicePeriodo AND @indicePeriodo<=100)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, @codAsigMatriculada, 
                                        @codSeccion, @fechaPeriodo,@codperiodo, 3, @fechaInicio, @fechaFinal;
                    RETURN;
                END

            /*Donde el indice este entre 72 a 80*/
            IF(73<=@indicePeriodo AND @indicePeriodo<81)
                BEGIN
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 4,  @fechaInicio, @fechaFinal;
                    RETURN;
                END


            /*Donde el indice este entre 0 a 72*/
            IF(0<=@indicePeriodo AND @indicePeriodo<73)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 5,  @fechaInicio, @fechaFinal;
                    RETURN;
                END  
        END
    ELSE
        PRINT 'El periodo de prematricula estara habilitado de 9:00 a.m. a 11:59 p.m.'    
END
GO




[smregistro].[Prematricula] '20171004244', 'IS01', 'FS-100', 1200, '2020-04-20', 1;
USE Registro;

SELECT * FROM Registro.smregistro.Estudiante;


UPDATE Registro.smregistro.Estudiante 
SET unidadesValorativas = 25 WHERE numCuenta = '20171004244';

USE Registro;
SELECT * FROM Registro.smregistro.MatriculaClase;

UPDATE Registro.smregistro.Seccion SET cupos = 0 
	WHERE codSeccion = 800 
	AND codAsignatura = 'MM-110';

DELETE FROM Registro.smregistro.MatriculaClase 
	WHERE codSeccionClase = 800
	AND codAsignatura = 'MM-110'
	AND cuentaEstudiante = '20171004244';

DELETE FROM Registro.smregistro.MatriculaClase;

SELECT * FROM Registro.smregistro.Seccion;

SELECT * FROM Registro.smregistro.Periodo;

UPDATE Registro.smregistro.Periodo 
    SET inicioPrematricula = '2020-05-24',
        finalPrematricula = '2020-05-28'
    WHERE activo = 1;
    
SELECT * FROM Registro.smregistro.HistorialAcademico