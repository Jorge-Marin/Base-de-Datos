USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el correo de los empleados
-- =============================================

CREATE VIEW smregistro.ViewCorreoEmpleados AS
  SELECT DISTINCT (primerNombre+' '+segundoNombre+' '+apellidoPaterno+' '+apellidoMaterno) AS Nombre,
			codEmpleado AS Código,
			correo AS Correo,
			tipo AS TipoCorreo
	FROM smregistro.Empleado AS e
		INNER JOIN smregistro.CorreoEmpleado AS c
			ON e.codEmpleado = c.codUsuario
