USE Registro;
GO

-- =============================================
-- Author: Jorge Arturo Reyes Marin	
-- Create date: 25/05/2020
-- Description:	Muestra todas aquellas secciones que ya no poseen cupos
-- y muestra el numero de solicitudes en espera en dicha seccion
-- =============================================

CREATE VIEW smregistro.cuposSecciones AS 
    SELECT Asig.nombreAsignatura, 
           Sec.codSeccion,
           CONCAT(Em.primerNombre, ' ', Em.apellidoMaterno) 'Catedratico',
           Dep.nombreDepartamento,
           Cor.Correo 'Correo Institucional',
           COUNT(Mat.cuentaEstudiante) 'Cupos Solicitados'
           FROM Registro.smregistro.Seccion Sec
           INNER JOIN Registro.smregistro.Asignatura Asig
           ON Asig.codAsignatura = Sec.codAsignatura
           INNER JOIN Registro.smregistro.MatriculaClase Mat 
           ON Mat.codSeccionClase = Sec.codSeccion
           INNER JOIN Registro.smregistro.Catedratico Ca
           ON Ca.codCatedratico = Sec.codCatedratico
           INNER JOIN Registro.smregistro.Empleado Em
           ON Ca.codEmpleado = Em.codEmpleado
           INNER JOIN Registro.smregistro.DepartamentosCarrera Dep 
           ON Dep.codDepartamento = Asig.codDepartamentoFF
           INNER JOIN Registro.smregistro.CorreoEmpleado Cor 
           ON Cor.codUsuario = Em.codEmpleado
           WHERE cupos = 0
                AND Cor.tipo = 'Personal'
                AND Mat.codAsignatura = Sec.codAsignatura
                AND Mat.espera = 1
           GROUP BY Asig.nombreAsignatura,
                    Sec.codSeccion,
                    CONCAT(Em.primerNombre, ' ', Em.apellidoMaterno),
                    Dep.nombreDepartamento,
                    Cor.Correo,
                    Mat.cuentaEstudiante
           

/*
    USE Registro;
    GO
     
     SELECT * FROM smregistro.cuposSecciones
*/