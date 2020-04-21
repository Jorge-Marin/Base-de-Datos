-- =============================================
-- Author:		Jorge Marin
-- Create date: 08/04/2020
-- Description:	Muestra todos los alumnos que hay en una carrera 
-- en especifico a partir del codigo carrera
-- =============================================
CREATE PROCEDURE  [smregistro].[spAlumnosCarrera]
	@codigoCarrera VARCHAR(7)
AS
BEGIN
		
		SELECT * FROM Registro.smregistro.Estudiante Es
		INNER JOIN Registro.smregistro.Municipio Mu
		ON Es.municipioNac = Mu.codMunicipio
		WHERE numCuenta IN (SELECT cuentaEstudiante FROM Registro.smregistro.MatriculaCarrera
		WHERE codCarrera = @codigoCarrera)
END
GO