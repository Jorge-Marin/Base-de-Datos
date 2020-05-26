USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el correo de los empleados
-- =============================================

CREATE VIEW smregistro.ViewCorreoEmpleados AS
  SELECT DISTINCT (CONCAT(e.primerNombre,' ',
  						  e.segundoNombre,' ',
						  e.apellidoPaterno,' ',
						  e.apellidoMaterno)) AS Nombre,
			codEmpleado AS Codigo,
			correo AS Correo,
			tipo AS TipoCorreo
	FROM Registro.smregistro.Empleado AS e
		INNER JOIN Registro.smregistro.CorreoEmpleado AS c
			ON e.codEmpleado = c.codUsuario


/*
    USE Registro;
    GO
    
		SELECT * FROM smregistro.ViewCorreoEmpleados
*/		