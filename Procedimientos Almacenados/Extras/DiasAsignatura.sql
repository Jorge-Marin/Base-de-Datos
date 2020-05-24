-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 12/04/2020
-- Description:	Realiza una tabla con los dias de una asignatura
-- =============================================
CREATE PROCEDURE  [smregistro].[spTablaDias]
	@dia AS VARCHAR(12)
AS
BEGIN
	SET NOCOUNT ON;

    IF OBJECT_ID('tempdb.dbo.#DiasClase', 'U') IS NOT NULL
        DROP TABLE #DiasClase; 
    CREATE TABLE #DiasClase (codDia INT PRIMARY KEY,Dia VARCHAR(2));
    
    DECLARE @cnt INT = 1;
    DECLARE @day INT = 1;
    DECLARE @value VARCHAR(2);
    WHILE @cnt < 12
        BEGIN
            SET @value = SUBSTRING (@dia, @day, 2)
            SET @day = 2*@cnt+1;
            SET @cnt = @cnt + 1;
            
            IF(@value='Lu')
                BEGIN
                    INSERT INTO #DiasClase VALUES(1, @value)                
                END
            ELSE IF(@value='Ma')
                BEGIN
                    INSERT INTO #DiasClase VALUES(2, @value)
                END
            ELSE IF(@value='Mi')
                BEGIN
                    INSERT INTO #DiasClase VALUES(3, @value)
                END
            ELSE IF(@value='Ju')
                BEGIN
                    INSERT INTO #DiasClase VALUES(4, @value)
                END
            ELSE IF(@value='Vi')
                BEGIN
                    INSERT INTO #DiasClase VALUES(5, @value)
                END
            ELSE IF(@value='Sa')
                BEGIN
                    INSERT INTO #DiasClase VALUES(6, @value)
                END
        END;

    SELECT * FROM #DiasClase;
END
GO


