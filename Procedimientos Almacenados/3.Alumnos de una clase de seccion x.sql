-- =============================================
-- Author:		Jorge Arturo Reyes Marin
-- Create date: 07/04/2020
-- Description:	Procedimiento almacenado que trae a todos los alumnos que hay en la seccion de una clase
-- =============================================
CREATE PROCEDURE  [smregistro].[spAlumnosSeccion]
	@codigoSeccion INT,
	@codAsignatura VARCHAR(7)
AS
BEGIN
	DECLARE @periodoActivo INT;
	SET @periodoActivo = (SELECT codPeriodo FROM Registro.smregistro.Periodo WHERE activo = 1);

	SELECT * FROM MatriculaClase Mc
		WHERE codAsignatura = @codAsignatura 
		AND codSeccionClase = @codigoSeccion
		AND codperiodo = @periodoActivo;
END
GO

[smregistro].[spAlumnosSeccion] '1200', 'MM-201';
