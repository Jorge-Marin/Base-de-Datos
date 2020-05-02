USE [Registro]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description:	Ubicar las facultades con sus respectivos edificios
-- =============================================
CREATE PROCEDURE smregistro.spFacultadesEdificios
	-- Add the parameters for the stored procedure here
	@codFacultad int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF(@codFacultad IN (SELECT [codFacultad] FROM [smregistro].[Facultad]))
		BEGIN 
			SELECT  [codFacultad],[codEdificioFF] 
				FROM [smregistro].[Facultad]
					WHERE @codFacultad = [codFacultad]
		END
	ELSE
		BEGIN
			PRINT 'Código de facultad inválido'
		END
	
END
GO
