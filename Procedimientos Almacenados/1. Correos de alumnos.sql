-- =============================================
-- Author:		Jorge Marin
-- Create date: 07/04/2020
-- Description:	Este procedimiento obtiene todos los correos de los estudiantes de una seccion,
-- Se puede diferenciar entre correo institucional y correo personal mediante los el campo 
--tipo donde un 0 representa correo institucional y donde un 1 representa correo personal
-- =============================================
CREATE PROCEDURE [smregistro].[CorreosEstudiantes] 
	@codigoSeccion INT,
	@codMateria VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @periodoActivo INT;
	SET @periodoActivo = (SELECT Pe.codPeriodo FROM Registro.smregistro.Periodo Pe WHERE Pe.activo = 1);

	SELECT Ce.codUsuario, Ce.correo, Ce.tipo FROM Registro.smregistro.CorreoEstudiante Ce
	INNER JOIN Registro.smregistro.Estudiante Es
	ON Es.numCuenta = Ce.codUsuario
	WHERE Ce.codUsuario IN (SELECT cuentaEstudiante FROM Registro.smregistro.MatriculaClase
		WHERE codSeccionClase = @codigoSeccion
			AND codAsignatura = @codMateria
			AND codperiodo = @periodoActivo);
END
GO


