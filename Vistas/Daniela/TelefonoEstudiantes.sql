USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el Telefono de los estudiantes
-- =============================================

CREATE VIEW smregistro.viewTelefonoEstudiantes AS
	SELECT DISTINCT (primerNombre+' '+segundoNombre+' '+primerApellido+' '+segundoApellido) AS Nombre,
				numCuenta AS Cuenta,
				telefono AS Tel�fono
		FROM Registro.smregistro.Estudiante AS e
			INNER JOIN Registro.smregistro.TelefonoEstudiante AS t
				ON e.numCuenta = t.codUsuario

