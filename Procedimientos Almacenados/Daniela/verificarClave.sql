USE [Registro]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 20-4-2020
-- Description:	Verificar si la clave posee numeros
-- =============================================
ALTER PROCEDURE spverificarClave
	-- Add the parameters for the stored procedure here
	@clave varchar(100)
AS
BEGIN
	DECLARE @result VARCHAR(100)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @result='' 

 SELECT 
  @result=@result+ 
    CASE WHEN number like '[0-9]' THEN number ELSE '' END FROM 
  (
   SELECT substring(@clave,number,1) AS number FROM 
   (
    SELECT number FROM MASTER..spt_values 
    WHERE TYPE='p' and number BETWEEN 1 AND len(@clave) 
   ) AS t 
  ) AS t 
 --SELECT @result AS only_numbers 
 RETURN @result
END
GO
