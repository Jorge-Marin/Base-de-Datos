USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el telefono de los empleados
-- =============================================

CREATE VIEW smregistro.ViewTelefonoEmpleados AS
  SELECT DISTINCT (CONCAT(Es.primerNombre,' ',
  						  Es.segundoNombre,' ',
						  Es.apellidoPaterno,' ',
						  Es.apellidoMaterno)) AS Nombre,
			codEmpleado AS Codigo,
			telefono AS Telofono
	FROM Registro.smregistro.Empleado AS Es
		INNER JOIN Registro.smregistro.TelefonoEmpleado AS c
			ON Es.codEmpleado = c.codUsuario

/*
    USE Registro;
    GO

	SELECT * FROM smregistro.ViewTelefonoEmpleados

*/