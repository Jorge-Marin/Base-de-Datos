USE [Registro]
GO
-- =============================================
-- Author:		Bessy Daniela Zavala Licona
-- Create date: 26-04-2020
-- Description:	Mostrar los representantes de la UNAH
-- =============================================

CREATE VIEW smregistro.ViewEstudiantesRepresentantes AS
  SELECT ([primerNombre]+' '+[primerApellido]) AS Nombre,numCuenta AS Cuenta, nombreAspecto AS Aspecto 
	FROM smregistro.Estudiante AS e
		INNER JOIN smregistro.RepresentanteUNAH AS r
			ON r.numeroCuentaFF = e.numCuenta
		INNER JOIN smregistro.AspectoRepresentativo AS a
			ON r.codAspectoFF = a.codAspecto

