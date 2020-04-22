-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION smregistro.accountStatus
(
	@numeroCuenta VARCHAR(15)
)
RETURNS DECIMAL(5,2)
AS
BEGIN
		DECLARE @cantidadCarrera INT;
		DECLARE @primerIngreso INT;
		DECLARE @value DECIMAL(5,2);

		SET @primerIngreso = (SELECT COUNT(cuentaEstudiante) FROM Registro.smregistro.HistorialAcademico 
								WHERE cuentaEstudiante= @numeroCuenta);


		SET @cantidadCarrera = (SELECT COUNT(DISTINCT(codCarrera)) FROM Registro.smregistro.MatriculaCarrera 
								WHERE cuentaEstudiante = '20171004244');

		IF(@primerIngreso=0 AND SUBSTRING (@numeroCuenta,1,4) = CAST(YEAR(GETDATE()) AS VARCHAR(4)))
			BEGIN 
				SET @value = 410;
				RETURN @value;
			END

		IF(@cantidadCarrera=1 AND @primerIngreso>0)
			BEGIN 
				SET @value = 270;
				RETURN @value;
			END

		IF(@cantidadCarrera=2 AND @primerIngreso>0)
			BEGIN 
				SET @value = 540;
				RETURN @value;
			END
		
		RETURN 404;
END
GO


PRINT CAST([smregistro].[accountStatus] ('20171004244') AS CHAR(7));