/*
Consulta que retorna los datos del historial acad�mico de un estudiante proporcionando su n�mero de cuenta
*/ 

SELECT Es.numCuenta 'Cuenta',
		Es.primerNombre+ ' '+Es.segundoNombre AS 'Nombres',
		Es.primerApellido+' '+Es.segundoApellido AS 'Apellidos',
		Asi.codAsignatura 'C�digo de asignatura',
		Asi.nombreAsignatura 'Nombre Clase',
		S.codSeccion 'Secci�n',
		Pe.periodo 'Periodo',
		YEAR(Pe.fechaInicio) 'A�o',
		HA.calificacion 'Calificaci�n',
		Em.primerNombre+' '+Em.apellidoPaterno AS 'Profesor'
	FROM Registro.smregistro.HistorialAcademico AS HA
		INNER JOIN Registro.smregistro.Periodo AS Pe
			ON HA.codPeriodo = Pe.codPeriodo
		INNER JOIN Registro.smregistro.Asignatura AS Asi
			ON HA.codAsignatura = Asi.codAsignatura
		INNER JOIN Registro.smregistro.Estudiante AS Es
			ON HA.cuentaEstudiante = Es.numCuenta
		INNER JOIN Registro.smregistro.Seccion AS S
			ON HA.seccion = S.codSeccion
		INNER JOIN Registro.smregistro.Catedratico AS Ca
			ON S.codCatedratico = Ca.codCatedratico
		INNER JOIN Registro.smregistro.Empleado AS Em
			ON Em.codEmpleado = Ca.codEmpleado
		WHERE S.fechaPeriodo = HA.fechaInicioPeriodo
			AND HA.cuentaEstudiante = '20171004244'

select * from Registro.smregistro.Seccion
select * from Registro.smregistro.Catedratico
select * from Registro.smregistro.Empleado