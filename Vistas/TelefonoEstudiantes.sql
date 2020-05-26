USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar el Telefono de los estudiantes
-- =============================================

CREATE VIEW smregistro.viewTelefonoEstudiantes AS
	SELECT DISTINCT (CONCAT(Es.primerNombre,' ',
							Es.segundoNombre,' ',
							Es.primerApellido,' ',
							Es.segundoApellido)) AS Nombre,
				numCuenta AS Cuenta,
				telefono AS Telofono
		FROM Registro.smregistro.Estudiante AS Es
			INNER JOIN Registro.smregistro.TelefonoEstudiante AS t
				ON Es.numCuenta = t.codUsuario

/*
    USE Registro;
    GO
	
	SELECT * FROM smregistro.viewTelefonoEstudiantes
*/