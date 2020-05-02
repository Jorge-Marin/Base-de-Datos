-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Prematricula
-- =============================================
CREATE PROCEDURE  [smregistro].[Prematricula]
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

    SET @inicioPrematricula = (SELECT Pe.inicioPrematricula FROM Registro.smregistro.Periodo Pe WHERE activo = 1);
    SET @finalPrematricula = (SELECT Pe.finalPrematricula FROM Registro.smregistro.Periodo Pe WHERE activo = 1);

    IF(GETDATE()<CAST(@inicioPrematricula AS DATE))
        BEGIN
            PRINT CONCAT('El periodo de prematricula comezara en', 
                        DATEDIFF(DAY, GETDATE(), @inicioPrematricula),' Dias de 9:00 a.m. a 11:59 p.m.');
            RETURN
        END
    
    IF(GETDATE()>CAST(@finalPrematricula AS DATE))
        BEGIN
            PRINT CONCAT('El periodo de prematricula acabo hace ', 
                            DATEDIFF(DAY, @finalPrematricula, GETDATE()),' Dias');
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
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1, @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END

            DECLARE @PROSENE INT;
            SET @PROSENE = (SELECT COUNT(DISTINCT(numeroCuentaFF)) FROM Registro.smregistro.PROSENE
                                        WHERE numeroCuentaFF = @cuentaEstudiante);

            /*Personas con Discapacidades*/
            IF(@PROSENE>0)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1,  @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END
            

            DECLARE @representanteUNAH INT;
            SET @representanteUNAH = (SELECT COUNT(DISTINCT(numeroCuentaFF)) FROM Registro.smregistro.RepresentanteUNAH
                                        WHERE numeroCuentaFF = @cuentaEstudiante)

            /*Representantes UNAH*/
            IF(@representanteUNAH>0)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 1, @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END

            /*Primer Ingreso*/
            /*En caso de que su indice Global sea Cero*/
            /*Y que no tenga asignarutas en su historial academico*/
            /*y que el año de ingreso sea el año actual*/
            IF(@indiceGlobal=0 AND @numAsignaturasAprobadas=0 AND SUBSTRING (@cuentaEstudiante,1,4)=CAST(YEAR(GETDATE()) AS VARCHAR(4)))
                BEGIN  
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 2,  @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END

            /*Matricula por indice de Periodo*/
            DECLARE @indicePeriodo INT
            SET @indicePeriodo = (SELECT [smregistro].[getIndexPeriod] (@cuentaEstudiante, @codigoCarrera));

            /*Donde el indice este entre 81 a 100*/
            IF(81<=@indicePeriodo AND @indicePeriodo<=100)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, @codAsigMatriculada, 
                                        @codSeccion, @fechaPeriodo,@codperiodo, 3, @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END

            /*Donde el indice este entre 72 a 80*/
            IF(73<=@indicePeriodo AND @indicePeriodo<81)
                BEGIN
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                        @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 4,  @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END


            /*Donde el indice este entre 0 a 72*/
            IF(0<=@indicePeriodo AND @indicePeriodo<73)
                BEGIN 
                    EXEC [smregistro].[spMatriculaPrioridad] @cuentaEstudiante, @codigoCarrera, 
                    @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo, 5,  @inicioPrematricula, @finalPrematricula;
                    RETURN;
                END  
        END
    ELSE
        PRINT 'El periodo de prematricula estara habilitado de 9:00 a.m. a 11:59 p.m.'    
END
GO

[smregistro].[Prematricula] '20171004244', 'IS01', 'IS-110', 1000, '2020-05-05', 3;
