/*
	1. Mostrar los estudiantes que aprobaron una la clase de MM-110 en el en año 2020 con nota mayor a 75
*/

SELECT Es.numCuenta 'Cuenta', 
		Es.primerNombre + ' ' +Es.primerApellido 'Nombre',
		Asi.codAsignatura 'Asignatura',
		Asi.nombreAsignatura 'NombreAsignatura',
		Hi.calificacion 'Calificación',
		YEAR(Hi.fechaInicioPeriodo) 'Año'
	FROM Registro.smregistro.Estudiante AS Es
		INNER JOIN Registro.smregistro.HistorialAcademico AS Hi
			ON Es.numCuenta = Hi.cuentaEstudiante
		INNER JOIN Registro.smregistro.Seccion AS Se
			ON Hi.seccion = Se.codSeccion
		INNER JOIN Registro.smregistro.Asignatura AS Asi
			ON Hi.codAsignatura = Asi.codAsignatura
				WHERE Asi.codAsignatura = 'MM-110'
					AND Hi.calificacion > 75
					AND YEAR(Hi.fechaInicioPeriodo) = 2020



/*
	2. Mostrar los estudiantes de prosene y que tengan indice global mayor a 80
*/

SELECT Est.numCuenta 'Cuenta', 
		Est.primerNombre + ' ' +Est.primerApellido 'Nombre',	
		Dis.nombreDiscapacidad 'Discapacidad'

	FROM Registro.smregistro.PROSENE AS Pro
								INNER JOIN Registro.smregistro.Discapacidad AS Dis
									ON Pro.codDiscapacidadFF = Dis.codDiscapacidad
								INNER JOIN Registro.smregistro.Estudiante AS Est
									ON Pro.numeroCuentaFF = Est.numCuenta
		WHERE Est.numCuenta IN (SELECT Es.numCuenta
							FROM Registro.smregistro.PROSENE AS Pro
								INNER JOIN Registro.smregistro.Discapacidad AS Dis
									ON Pro.codDiscapacidadFF = Dis.codDiscapacidad
								INNER JOIN Registro.smregistro.Estudiante AS Es
									ON Pro.numeroCuentaFF = Es.numCuenta)
			AND (SELECT (SUM(Ha.calificacion * Ag.unidadesValorativas)/SUM(Ag.unidadesValorativas)) AS [IndiceBlobal] 
							FROM Registro.smregistro.HistorialAcademico Ha
								INNER JOIN Registro.smregistro.Asignatura Ag
								ON Ha.codAsignatura = Ag.codAsignatura
									WHERE Ha.cuentaEstudiante = Est.numCuenta)>80

/*
	3. Mostrar el numero de veces que cursó la clase de MM-110, el estudiante con cuenta 20171004244
*/
	SELECT COUNT(*) AS 'Cantidad de veces cursada',
				Es.numCuenta,
				Es.primerNombre + ' '+Es.primerApellido 'Nombre'
		FROM Registro.smregistro.HistorialAcademico AS Ha
			INNER JOIN Registro.smregistro.Estudiante AS Es
				ON Es.numCuenta = Ha.cuentaEstudiante
			INNER JOIN Registro.smregistro.Asignatura AS Asi
				ON Asi.codAsignatura = Ha.codAsignatura
			WHERE Es.numCuenta = '20171004244'
				AND Asi.codAsignatura = 'MM-110'
				GROUP BY Es.numCuenta,
				Es.primerNombre+' '+Es.primerApellido


/*
	4.Mostrar todas las clases que imparten los docentes que sean del departamento de matematica
*/

	SELECT Asi.codAsignatura 'Código de Asignatura',
			Asi.nombreAsignatura 'Asignatura',
			De.nombreDepartamento 'Departamento',
			Em.primerNombre + Em.apellidoPaterno 'Nombre Catedratico'
		FROM Registro.smregistro.Catedratico AS Ca
			INNER JOIN Registro.smregistro.Empleado AS Em
				ON Ca.codEmpleado = Em.codEmpleado
			INNER JOIN Registro.smregistro.Seccion AS Se
				ON Ca.codCatedratico = Se.codCatedratico
			INNER JOIN  Registro.smregistro.Asignatura AS Asi
				ON Asi.codAsignatura = Se.codAsignatura
			INNER JOIN Registro.smregistro.DepartamentosCarrera AS De
				ON Asi.codDepartamentoFF = De.codDepartamento
				WHERE De.codDepartamento =  '01M'


/*
	Mostrar el estudiante con mejor promedio de la UNAH durante el año 2020
*/

	SELECT	TOP(1)
			Ha.cuentaEstudiante 'Cuenta',
			Es.primerNombre + Es.primerApellido 'Nombre de Estudiante'
			,(SUM(Ha.calificacion * Ag.unidadesValorativas)/SUM(Ag.unidadesValorativas)) AS [IndicePeriodo] 
							FROM Registro.smregistro.HistorialAcademico Ha
								INNER JOIN Registro.smregistro.Asignatura Ag
									ON Ha.codAsignatura = Ag.codAsignatura
								INNER JOIN Registro.smregistro.Estudiante AS Es
									ON Ha.cuentaEstudiante = Es.numCuenta
									GROUP BY Ha.cuentaEstudiante,
											Es.primerNombre + Es.primerApellido


