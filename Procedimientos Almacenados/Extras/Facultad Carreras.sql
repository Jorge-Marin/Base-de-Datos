USE [Registro]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bessy Daniela Zavala
-- Create date: 6-4-2020
-- Description:	Ver las carreras de las que dispone la facultad
-- =============================================
CREATE PROCEDURE [dbo].[facultadCarreras]
	-- Add the parameters for the stored procedure here
	@codFacultad int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@codFacultad IN (SELECT [codFacultad] FROM [smregistro].[Facultad]))
		BEGIN 
			SELECT  [codCarrera], [nombreCarrera]
				FROM [smregistro].[Carrera]
					WHERE @codFacultad = [codFacultadFF]
		END
	ELSE
		BEGIN
			PRINT 'C�digo de facultad inv�lido'
		END
END
GO
