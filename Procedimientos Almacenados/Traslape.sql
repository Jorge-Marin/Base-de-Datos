-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Verifica que no exista un traslape entre asignaturas
-- A matricular.
-- =============================================
ALTER PROCEDURE [smregistro].[spTraslapeClase]
	@codSeccion AS INT,
    @codAsignatura AS VARCHAR(7),
    @codCarrera AS VARCHAR(7),
    @cuentaEstudiante AS VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @asignaturaInicio AS TIME;
    DECLARE @asignaturaFinal AS TIME;
    DECLARE @DiasPresenciales AS VARCHAR(12);

    /*Necesito codPeriodo e fecha de inicio para especificar la clase en el actual 
    periodo activo*/
    DECLARE @codPeriodo INT;
    DECLARE @fechaInicio DATE;

    SELECT @codPeriodo = Pe.codPeriodo,
            @fechaInicio = Pe.fechaInicio 
            FROM Registro.smregistro.Periodo Pe
            WHERE Pe.activo = 1;


    /*Obteniendo la hora de inicio de la clase a matricular*/
    /*Conseguir la seccion del periodo activo*/
    SELECT @asignaturaInicio = Se.horaInicial,
           @asignaturaFinal = Se.horaFinal, 
           @DiasPresenciales = Se.diaPresenciales 
        FROM Registro.smregistro.Seccion Se
            WHERE Se.codSeccion = @codSeccion
            AND Se.codAsignatura =  @codAsignatura
            AND Se.codPeriodo = @codPeriodo
            AND Se.fechaPeriodo = @fechaInicio;


    /*Creando una tabla temporal de los dias que se impartira la clase
    a matricular mediante un procedimiento procedimiento almacenado que recive 
    los dias presenciales y los devuelve a una tabla de los dias de 
    la clase*/
    IF OBJECT_ID('tempdb.dbo.#DiasAsignaturaInteres', 'U') IS NOT NULL
            DROP TABLE #DiasAsignaturaInteres; 
        CREATE TABLE #DiasAsignaturaInteres (codDia INT PRIMARY KEY, Dia VARCHAR(2));
        INSERT INTO #DiasAsignaturaInteres EXEC [smregistro].[spTablaDias] @DiasPresenciales;

    /*Creando una tabla temporal de las asignaturas ya matriculadas
    en el periodo de matricula actual*/
    IF OBJECT_ID('tempdb.dbo.#claseMatriculadas', 'U') IS NOT NULL
                        DROP TABLE #claseMatriculadas; 
    CREATE TABLE #claseMatriculadas(codSeccion INT, codAsignatura VARCHAR(7));
    INSERT INTO #claseMatriculadas 
    SELECT Ma.codSeccionClase, Ma.codAsignatura FROM Registro.smregistro.MatriculaClase Ma
        WHERE Ma.codCarrera = @codCarrera
        AND Ma.cuentaEstudiante = @cuentaEstudiante
        AND Ma.fechaPeriodo = @fechaInicio
        AND Ma.codperiodo = @codPeriodo

    /*Inicializa la variable con la cantidad de elementos que haya en la tabla
    #clasesMatriculadas*/
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM #claseMatriculadas;

    /*Para las horas de inicio y fin, mas los dias presenciales de las 
    clases matriculadas*/
    DECLARE @inicioMatriculada TIME;
    DECLARE @finalMatriculada TIME;
    DECLARE @DiasPresencialesMatriculada VARCHAR(12);

    /*Ciclo para recorrer una tabla como una cola en un arreglo*/
    WHILE @cnt > 0
        BEGIN
            /*Inicializando las variables de las horas de las clases matriculadas
            y los dias en los que se da*/            
            SELECT @inicioMatriculada = Se.horaInicial, 
                   @finalMatriculada = Se.horaFinal, 
                   @DiasPresencialesMatriculada=Se.diaPresenciales 
                    FROM Registro.smregistro.Seccion Se
                    WHERE Se.codAsignatura = (SELECT TOP(1) codAsignatura FROM #claseMatriculadas)
                        AND Se.codSeccion = (SELECT TOP(1) codSeccion FROM #claseMatriculadas);

            /*Tabla temporal que se crea con el objetivo de obtener los dias 
            que se imparte la asignatura y a partir de ello recorrer la tabla y 
            verificar que no existe un traslape entre esas horas de clase*/
            IF OBJECT_ID('tempdb.dbo.#DiasAsignatura', 'U') IS NOT NULL
                    DROP TABLE #DiasAsignatura; 
                CREATE TABLE #DiasAsignatura (codDia INT PRIMARY KEY, Dia VARCHAR(2));
                INSERT INTO #DiasAsignatura EXEC [smregistro].[spTablaDias] @DiasPresencialesMatriculada;

            /*Inicializa la variable con el tamaño de la tabla de 
            #DiasAsignatura*/
            DECLARE @dayCnt INT;
            SELECT @dayCnt = COUNT(*) FROM #DiasAsignatura;
            DECLARE @codDia INT;

            /*Ciclo que verifica que la asignatura a matricular no comienze el mismo
            dia ni a la misma hora, ni que este entre el intervalo de horas de 
            inicio y final en caso de que se traslape retornara el valor de 1*/
            WHILE @dayCnt > 0
                BEGIN
                    SELECT TOP(1) @codDia = codDia FROM #DiasAsignatura
                    IF((SELECT Dia FROM #DiasAsignaturaInteres WHERE codDia = @codDia)=(SELECT Dia FROM #DiasAsignatura WHERE codDia = @codDia))
                        BEGIN 
                            IF(@asignaturaInicio = @inicioMatriculada OR @inicioMatriculada<@asignaturaInicio AND @asignaturaInicio<@finalMatriculada
                            OR @asignaturaInicio<@inicioMatriculada AND @finalMatriculada<@asignaturaFinal)
                                BEGIN 
                                    RETURN 1;
                                END
                        END
                    DELETE TOP(1) FROM #DiasAsignatura
                    SELECT @dayCnt = COUNT(*) FROM #DiasAsignatura
                END
            
            DELETE TOP (1) FROM #claseMatriculadas
            SELECT @cnt = COUNT(*) FROM #claseMatriculadas;
        END  

    /*No hay traslape retorna un 0*/
    RETURN 0      
END
GO

--Para pruebas
/*
DECLARE @response INT;
EXEC @response = [smregistro].[spTraslapeClase] 1000, 'IS-110', 'IS01', '20171004244'
PRINT CAST((@response) AS CHAR(5))


SELECT * FROM Registro.smregistro.MatriculaClase

*/