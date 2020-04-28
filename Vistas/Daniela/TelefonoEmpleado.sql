USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el telefono de los empleados
-- =============================================

CREATE VIEW view_TelefonoEmpleados AS
  SELECT DISTINCT (primerNombre+' '+segundoNombre+' '+apellidoPaterno+' '+apellidoMaterno) AS Nombre,
			codEmpleado AS Código,
			telefono AS Teléfono
	FROM smregistro.Empleado AS e
		INNER JOIN smregistro.TelefonoEmpleado AS c
			ON e.codEmpleado = c.codUsuario