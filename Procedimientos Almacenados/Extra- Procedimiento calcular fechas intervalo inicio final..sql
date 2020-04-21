-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 11/04/2020
-- Description:	Retorna una tabla con la prioridad de las fechas. (Las Prioridades se autoincrementan)
-- si en el siguiente periodo se cambia el horario de Matriculas debera de cambiar los privilegios en
-- en el procedimiento de matricula
-- =============================================
CREATE PROCEDURE [smregistro].[FechasRangosPrioridad]
	@FechaInicio DATE,
    @FechaCierre DATE
AS
BEGIN
    SET NOCOUNT ON;
 

    -- Tabla temporal con las fechas de inicio y cierre
    CREATE TABLE #Temp(prioridad INT IDENTITY PRIMARY KEY,fecha DATE)
    DECLARE @date DATE   
    SET @date = @FechaInicio
    WHILE @date < DATEADD(DAY, 1, @FechaCierre)
		BEGIN
			INSERT INTO #Temp
			VALUES(@date)
			SET @date = DATEADD(DAY, 1, @date)
		END

    SELECT * FROM #Temp;
END
GO


