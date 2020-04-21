-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Prioridad de Matricula
-- =============================================
CREATE PROCEDURE  [smregistro].[spMatriculaPrioridad]
	@cuentaEstudiante AS VARCHAR(15),
	@codigoCarrera AS VARCHAR(7),
	@codAsigMatriculada AS VARCHAR(7),
	@codSeccion INT,
    @fechaPeriodo DATE,
    @codperiodo INT,
    @prioridad INT,
    @inicioPrematricula DATE, 
    @finalPrematricula DATE
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @fecha AS DATE;

    /*Tabla temporal que requiere una fecha de inicio y final de prematricula
    para generar las fechas entres dichas fechas*/
    IF OBJECT_ID('tempdb.dbo.#FechasPrioriMatricula', 'U') IS NOT NULL
                DROP TABLE #FechasPrioriMatricula; 
            CREATE TABLE #FechasPrioriMatricula (prioridad INT PRIMARY KEY,fecha DATE);
            INSERT INTO #FechasPrioriMatricula EXEC [smregistro].[FechasRangosPrioridad] 
                                                @inicioPrematricula,@finalPrematricula;

    /*Obtiene la fecha de la tabla generada pero filtra por prioridad*/    
    SET @fecha = CAST((SELECT fecha FROM #FechasPrioriMatricula WHERE prioridad = @prioridad) AS DATE);
    
    /*Comprueba que las fechas sean iguales, si no imprime un mensaje de su dia de matricula
    que le correspone a la persona*/
    IF(CAST(GETDATE() AS DATE) = @fecha)
        BEGIN
            EXEC [smregistro].[spMatriculaAsignatura] @cuentaEstudiante, @codigoCarrera, @codAsigMatriculada, @codSeccion, @fechaPeriodo,@codperiodo;
            RETURN
        END
    ELSE 
        BEGIN 
            PRINT CONCAT('Su fecha y hora de matricula es ',  @fecha,'de 9:00 a.m a 11:59 p.m');
            RETURN;
        END
END
GO

