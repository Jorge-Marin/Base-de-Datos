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
				telefono AS Teléfono
		FROM smregistro.Estudiante AS e
			INNER JOIN smregistro.TelefonoEstudiante AS t
				ON e.numCuenta = t.codUsuario

