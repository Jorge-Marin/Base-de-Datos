USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar los representantes de la UNAH
-- =============================================

CREATE VIEW smregistro.ViewEstudiantesRepresentantes AS
  SELECT (CONCAT([primerNombre],' ',[primerApellido])) AS Nombre,
  			numCuenta AS Cuenta,
			nombreAspecto AS Aspecto 
	FROM Registro.smregistro.Estudiante AS e
		INNER JOIN Registro.smregistro.RepresentanteUNAH AS r
			ON r.numeroCuentaFF = e.numCuenta
		INNER JOIN Registro.smregistro.AspectoRepresentativo AS a
			ON r.codAspectoFF = a.codAspecto

/*
    USE Registro;
    GO

	SELECT * FROM smregistro.ViewEstudiantesRepresentantes

*/