/*
	1. Mostrar los estudiantes que aprobaron una la clase de MM-110 en el en a�o 2020 con nota mayor a 75
*/

SELECT Es.numCuenta 'Cuenta', 
		(Es.primerNombre + ' ' + Es.primerApellido) 'Nombre',
		Asi.codAsignatura 'Asignatura',
		Asi.nombreAsignatura 'NombreAsignatura',
		Hi.calificacion 'Calificaci�n',
		YEAR(Hi.fechaInicioPeriodo) 'A�o'
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
	3. Mostrar el numero de veces que curs� la clase de MM-110, el estudiante con cuenta 20171004244
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

	SELECT Asi.codAsignatura 'C�digo de Asignatura',
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
	5. Mostrar el estudiante con mejor promedio de la UNAH durante el a�o 2020
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

    /*
	 6.	Trae a los estudiantes de primer ingreso con sus respectivos correos de gmail
		y su lugar de nacimiento junto con la carrera que estudia
	*/

	SELECT Est.numCuenta, 
		   CONCAT(Est.primerNombre,' ', Est.segundoNombre, 
		   ' ',Est.primerApellido,' ', Est.segundoApellido) 'Nombre',
		   Ca.nombreCarrera,
		   Coe.correo 'Correo Personal',
		   Mu.nombreMunicipio,
		   Dep.nombreDepartamento
		   FROM Registro.smregistro.Estudiante AS Est
		   INNER JOIN Registro.smregistro.MatriculaCarrera Mac 
		   		ON Mac.cuentaEstudiante = Est.numCuenta
		   INNER JOIN Registro.smregistro.Carrera Ca
		   		ON Mac.codCarrera = Ca.codCarrera
		   INNER JOIN Registro.smregistro.Municipio Mu
		   		ON Mu.codMunicipio = Est.municipioNac
		   INNER JOIN Registro.smregistro.Departamento Dep 
		   		ON Dep.codDeptartamento = MU.codDeptartamentoFF
		   INNER JOIN Registro.smregistro.CorreoEstudiante Coe 
		   		ON Coe.codUsuario = Est.numCuenta
		   WHERE SUBSTRING(Est.numCuenta,1,4) = YEAR(GETDATE())
		   		AND Coe.tipo = 'Personal';

	/*
	 7.	Consulta que obtiene la ubicacion de las facultades respecto a sus edificios,
		y tambien el cordinador de la facultad.
	*/
	SELECT Ca.nombreCarrera,
		   Fac.nombreFacultad,
		   Edi.nombreEdificio,
		   CONCAT(Emp.primerNombre, ' ', Emp.segundoNombre,' ',
				Emp.apellidoMaterno, ' ', Emp.apellidoMaterno) 'Nombre Coordinador'
		   		FROM Registro.smregistro.Carrera Ca
				INNER JOIN Registro.smregistro.Facultad Fac
					ON Fac.codFacultad = Ca.codFacultadFF
				INNER JOIN Registro.smregistro.Edificio Edi
					ON Edi.codEdificio = Fac.codEdificioFF
				INNER JOIN Registro.smregistro.CordinaFacultad Corf
					ON Corf.codFacultadFF = Fac.codFacultad
				INNER JOIN Registro.smregistro.CoordinadorFacultad CordF
					ON Corf.codCoordinadorFF = CordF.codCoordinador
				INNER JOIN Registro.smregistro.Empleado Emp
					ON Emp.codEmpleado = CordF.codEmpleado


	/*
	 8.	Todos los numeros de cuenta que matricula en primer dia de clases
			Tomando en Cuenta que Matriculan el Primer Dia:
			-- Primer Ingreso
			-- Exelencia Academica
			-- PROSENE
			-- Representantes de la UNAH
	*/

	SELECT PrI.numCuenta 'Numero de Cuenta', 
		   CONCAT(PrI.primerNombre, ' ', PrI.segundoNombre, ' ',
		   PrI.primerApellido, ' ', PrI.segundoApellido) 'Nombre del Estudiante',
		   ('Primer Ingreso') 'Motivo de Matricula'
		   FROM Registro.smregistro.Estudiante PrI
		   WHERE SUBSTRING(numCuenta, 1, 4) = YEAR(GETDATE())
				AND Pri.numCuenta NOT IN (SELECT His.cuentaEstudiante 
												FROM Registro.smregistro.HistorialAcademico His)

		UNION

	SELECT Est.numCuenta 'Numero de Cuenta',
		   CONCAT(Est.primerNombre, ' ', Est.segundoNombre, ' ',
		   Est.primerApellido, ' ', Est.segundoApellido) 'Nombre del Estudiante',
		   ('PROSENE') 'Motivo de Matricula'
		   FROM Registro.smregistro.Estudiante Est
		   INNER JOIN Registro.smregistro.PROSENE Pros
				ON Pros.numeroCuentaFF = Est.numCuenta

		UNION 

	SELECT Est.numCuenta 'Numero de Cuenta',
		   CONCAT(Est.primerNombre, ' ', Est.segundoNombre, ' ',
		   Est.primerApellido, ' ', Est.segundoApellido) 'Nombre del Estudiante',
		   ('Representante UNAH') 'Motivo de Matricula' 
		   FROM Registro.smregistro.Estudiante Est
		   INNER JOIN Registro.smregistro.RepresentanteUNAH ReUNAH
			ON ReUNAH.numeroCuentaFF = Est.numCuenta
	
		UNION

	SELECT Est.numCuenta 'Numero de Cuenta',
		   CONCAT(Est.primerNombre, ' ', Est.segundoNombre, ' ',
		   Est.primerApellido, ' ', Est.segundoApellido) 'Nombre del Estudiante',
		   ('Excelencia Academica') 'Motivo de Matricula' 
		    FROM Registro.smregistro.Estudiante Est
			INNER JOIN Registro.smregistro.HistorialAcademico His
				ON His.cuentaEstudiante = Est.numCuenta
			WHERE calificacion >= 65
			GROUP BY Est.numCuenta, CONCAT(Est.primerNombre, ' ', Est.segundoNombre, ' ',
		   	Est.primerApellido, ' ', Est.segundoApellido)
				HAVING COUNT(Est.numCuenta) >= 10
					AND SUM(calificacion)/COUNT(Est.numCuenta) >= 80

				





		






	

	

	
		





		
	