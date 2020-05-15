USE [Registro]
GO
--Jorge, deberiamos poner como UNIQUE este campo

/*Indices Tabla Empleado*/
CREATE NONCLUSTERED INDEX IDX_NOMBREEMPLEADO
ON Registro.smregistro.Empleado (primerNombre, apellidoPaterno)

CREATE NONCLUSTERED INDEX IDX_IDENTIDAD 
ON Registro.smregistro.Empleado (identidad)

EXECUTE sp_helpindex 'Registro.smregistro.Empleado'

/*Indices Tabla Estudiante*/

CREATE NONCLUSTERED INDEX IND_NOMBREESTUDIANTE 
ON Registro.smregistro.Estudiante (primerNombre, primerApellido)

CREATE NONCLUSTERED INDEX IDX_IDENTIDAD
ON Registro.smregistro.Estudiante (identidad)

EXECUTE sp_helpindex 'Registro.smregistro.Estudiante';

/*Indice En La Tabla Asignatura*/
CREATE NONCLUSTERED INDEX IDX_NOMBREASIGNATURA
ON Registro.smregistro.Asignatura (nombreAsignatura)

EXECUTE sp_helpindex 'Registro.smregistro.Asignatura'

/*Indice en la tabla matricula*/
CREATE NONCLUSTERED INDEX IDX_MATRICULAESPERA
ON Registro.smregistro.MatriculaClase (espera)

EXECUTE sp_helpindex 'Registro.smregistro.MatriculaClase'