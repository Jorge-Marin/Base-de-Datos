USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el correo de los estudiantes
-- =============================================

CREATE VIEW smregistro.ViewCorreoEstudiantes AS
  SELECT DISTINCT (primerNombre+' '+segundoNombre+' '+primerApellido+' '+segundoApellido) AS Nombre,
			numCuenta AS Cuenta,
			correo AS Correo,
			tipo AS TipoCorreo
	FROM smregistro.Estudiante AS e
		INNER JOIN smregistro.CorreoEstudiante AS c
			ON e.numCuenta = c.codUsuario

	