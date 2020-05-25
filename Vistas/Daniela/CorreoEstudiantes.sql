USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el correo de los estudiantes
-- =============================================

CREATE VIEW smregistro.ViewCorreoEstudiantes AS
  SELECT DISTINCT (CONCAT(Es.primerNombre,' ',
  					      Es.segundoNombre,' ',
						  Es.primerApellido,' ',
						  Es.segundoApellido)) AS Nombre,
			numCuenta AS Cuenta,
			correo AS Correo,
			tipo AS TipoCorreo
	FROM Registro.smregistro.Estudiante AS Es
		INNER JOIN Registro.smregistro.CorreoEstudiante AS c
			ON Es.numCuenta = c.codUsuario


/*
    USE Registro;
    GO
	
	SELECT * FROM smregistro.ViewCorreoEstudiantes
*/