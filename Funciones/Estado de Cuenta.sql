-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 15/04/2020
-- Description:	Retorna el valor de la cuenta del estudiante
-- segun su numero de carreras o si es de primer ingreso
-- =============================================
ALTER FUNCTION smregistro.accountStatus
(
	@numeroCuenta VARCHAR(15)
)
RETURNS BIT
AS
BEGIN
		DECLARE @estadoCuenta DECIMAL(5,2);
		DECLARE @cantidadCarrera INT;
		DECLARE @primerIngreso INT;
		DECLARE @estado BIT;
		DECLARE @value DECIMAL(5,2);

		SET @estadoCuenta = (SELECT estadoCuenta 
							 FROM Registro.smregistro.Estudiante 
							 WHERE numCuenta = '20171004244');		

		SET @primerIngreso = (SELECT COUNT(cuentaEstudiante) FROM Registro.smregistro.HistorialAcademico 
								WHERE cuentaEstudiante= @numeroCuenta);


		SET @cantidadCarrera = (SELECT COUNT(DISTINCT(codCarrera)) FROM Registro.smregistro.MatriculaCarrera 
								WHERE cuentaEstudiante = @numeroCuenta);

		IF(@primerIngreso=0 AND SUBSTRING (@numeroCuenta,1,4) <= CAST(YEAR(GETDATE()) AS VARCHAR(4)))
			BEGIN 
				SET @value = 410;
			END

		IF(@cantidadCarrera=1 AND @primerIngreso>0)
			BEGIN 
				SET @value = 270;
			END

		IF(@cantidadCarrera=2 AND @primerIngreso>0)
			BEGIN 
				SET @value = 540;
			END

		IF(@estadoCuenta = @value)
			BEGIN 
				SET @estado = 1;
			END
		ELSE 
			BEGIN 
				SET @estado = 0;
			END
		
		RETURN @estado;
END
GO
