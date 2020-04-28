--Creacion Base de Datos Registro
--DROP DATABASE Registro
CREATE DATABASE Registro
GO

--Especificar el Uso de la Base Registro

USE Registro
GO

--Creacion de un Esquema (Simulacion Registro)
CREATE SCHEMA smregistro;
GO


--Departamentos De Honduras--
CREATE TABLE Registro.smregistro.Departamento(
					codDeptartamento int IDENTITY(1,1) PRIMARY KEY,
					nombreDepartamento VARCHAR(30) NOT NULL UNIQUE)
	
GO 

--Municipios de Honduras--
CREATE TABLE Registro.smregistro.Municipio(
					codMunicipio int IDENTITY(1,1) PRIMARY KEY,
					nombreMunicipio VARCHAR(30) NOT NULL,
					codDeptartamentoFF INT NOT NULL,
					FOREIGN KEY(codDeptartamentoFF) REFERENCES Registro.smregistro.Departamento(codDeptartamento)
)
GO


--La Tabla periodo sirve para dejar un Historial y para un posible disparador
CREATE TABLE Registro.smregistro.Periodo(
								codPeriodo INT IDENTITY,
								periodo VARCHAR(20) NOT NULL,
								observaciones VARCHAR(20) NULL,
								fechaInicio DATE NOT NULL, 
								fechaFinal DATE NOT NULL,
								inicioAdiciones DATE NOT NULL,
								finalizaAdiciones DATE NOT NULL,
								inicioPrematricula DATE NOT NULL,
								finalPrematricula DATE NOT NULL,
								inicioMatricula DATE NOT NULL,
								finalMatricula DATE NOT NULL,
								activo BIT,
								PRIMARY KEY(codPeriodo, fechaInicio)
)
GO

--Edificios CU--
CREATE TABLE Registro.smregistro.Edificio(
						codEdificio INT IDENTITY PRIMARY KEY,
						nombreEdificio VARCHAR(30)
						)
GO

--Aulas de los Edificios--
--Para el apartado de espacio disponible consideramos que entraria en procedimientos almacenados
CREATE TABLE Registro.smregistro.Aula(
							aula VARCHAR(20),
							codEdificioFF INT NOT NULL,
							PRIMARY KEY(aula,codEdificioFF),
							FOREIGN KEY(codEdificioFF) REFERENCES Registro.smregistro.Edificio(codEdificio)
)
GO

--Empleados
CREATE TABLE Registro.smregistro.Empleado(
							codEmpleado VARCHAR(7) PRIMARY KEY,
							identidad VARCHAR(15) NOT NULL,
							primerNombre VARCHAR(20) NOT NULL,
							segundoNombre VARCHAR(20),
							apellidoMaterno VARCHAR(20) NOT NULL,
							apellidoPaterno VARCHAR(20),
							gradoAcademico VARCHAR(50),
							fechaNacimiento date,
							municipioNac int FOREIGN KEY REFERENCES Registro.smregistro.Municipio(codMunicipio) NOT NULL,
)
GO
--Coordinador de la Facultad--
CREATE TABLE Registro.smregistro.CoordinadorFacultad(
								codCoordinador VARCHAR(15),
								codEmpleado VARCHAR(7),
								fechaInicioC DATE,
								fechaTerminoC DATE NULL,
								PRIMARY KEY(codCoordinador,fechaInicioC),
							    FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)
)
GO
--Facultad--
CREATE TABLE Registro.smregistro.Facultad(
									codFacultad INT PRIMARY KEY,
									nombreFacultad VARCHAR(50),
									codCoordinadorFF VARCHAR(15),
									codEdificioFF INT,
									FOREIGN KEY(codEdificioFF) REFERENCES Registro.smregistro.Edificio(codEdificio)
)
GO

--Tabla que crea la relacion uno a uno Entre Coordinador y Facultad--
CREATE TABLE Registro.smregistro.CordinaFacultad(
									codCoordinadorFF VARCHAR(15),
									fechaInicioCoordinador DATE,
									codFacultadFF INT NOT NULL UNIQUE,
									PRIMARY KEY(codCoordinadorFF, fechaInicioCoordinador),
									FOREIGN KEY(codCoordinadorFF,fechaInicioCoordinador) REFERENCES Registro.smregistro.CoordinadorFacultad(codCoordinador,fechaInicioC),
									FOREIGN KEY(codFacultadFF) REFERENCES Registro.smregistro.Facultad(codFacultad)

)
GO

--Jefe de un Departamento--
CREATE TABLE Registro.smregistro.JefeDepartamento(
							codJefeDepartamento VARCHAR(15),
							codEmpleado VARCHAR(7),
							fechaInicioCargo DATE,
							fechaFinalCargo DATE,
							PRIMARY KEY(codJefeDepartamento, fechaInicioCargo),
							FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)
)
GO


--Departamentos de la Carrera--
CREATE TABLE Registro.smregistro.DepartamentosCarrera(
							codDepartamento VARCHAR(7) PRIMARY KEY,
							nombreDepartamento VARCHAR(50),
							codEdificioFF INT,
							FOREIGN KEY (codEdificioFF) REFERENCES Registro.smregistro.Edificio(codEdificio)
)
GO


--Tabla que crea la relacion uno a uno Entre Coordinador y Facultad--
CREATE TABLE Registro.smregistro.DepartamentoJefe(
									codJefeDepartamentoFF VARCHAR(15),
									fechaInicioCargoFF DATE,
									codDepartamentoFF VARCHAR(7) NOT NULL UNIQUE,
									PRIMARY KEY(codJefeDepartamentoFF, fechaInicioCargoFF),
									FOREIGN KEY(codJefeDepartamentoFF,fechaInicioCargoFF) REFERENCES Registro.smregistro.JefeDepartamento(codJefeDepartamento,fechaInicioCargo),
									FOREIGN KEY(codDepartamentoFF) REFERENCES Registro.smregistro.DepartamentosCarrera(codDepartamento)

)
GO


--Tabla asignatura
CREATE TABLE Registro.smregistro.Asignatura(
							codAsignatura VARCHAR(7) PRIMARY KEY,
							nombreAsignatura VARCHAR(50) NOT NULL,
							unidadesValorativas INT NOT NULL,
							observacion VARCHAR(50),
							unificada bit,
							codDepartamentoFF VARCHAR(7),
							FOREIGN KEY (codDepartamentoFF) REFERENCES Registro.smregistro.DepartamentosCarrera(codDepartamento)
)
GO


--Tabla Catedratico
CREATE TABLE Registro.smregistro.Catedratico(
							codCatedratico VARCHAR(15),
							codEmpleado VARCHAR(7),
							cantidadClases int,
							activo bit
							PRIMARY KEY(codCatedratico),
							FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)
							)

GO

--Segun lo que investigamos solo aquellas clases unificadas poseen un coordinador de asignatura--
CREATE TABLE Registro.smregistro.CoordinadorAsignatura(
									codCatedraticoFF VARCHAR(15),
									codEmpleado VARCHAR(7),
									fechaInicioCargoFF DATE,
									fechaFinalCargoFF DATE,
									codasignaturaFF VARCHAR(7) NOT NULL UNIQUE,
									PRIMARY KEY(codCatedraticoFF, fechaInicioCargoFF),
									FOREIGN KEY(codCatedraticoFF) REFERENCES Registro.smregistro.Catedratico(codCatedratico),
									FOREIGN KEY(codasignaturaFF) REFERENCES Registro.smregistro.Asignatura(codAsignatura),
									FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)

)
GO


--Laboratorio de asignatura
CREATE TABLE Registro.smregistro.Laboratorio(
							codLaboratorio VARCHAR(7),
							codAsignatura VARCHAR(7) UNIQUE,
							PRIMARY KEY(codLaboratorio,codAsignatura),
							FOREIGN KEY (codAsignatura) REFERENCES Registro.smregistro.Asignatura(codAsignatura)
)
GO

CREATE TABLE Registro.smregistro.Instructor(
							codInstructor VARCHAR(15) PRIMARY KEY,
							codEmpleado VARCHAR(7),
							cantLaboratorios int,
							FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)
)
GO


--Seccion de laboratorios
CREATE TABLE Registro.smregistro.SeccionLab(
						codSeccion INT,
						codLab VARCHAR(7),
						codAsignatura VARCHAR(7),
						horaInicial TIME,
						horaFinal TIME,
						cupos INT,
						diaImparte VARCHAR(10) NOT NULL,
						codEdificioFF int,
						codAula VARCHAR(20),
						codInstructor VARCHAR(15),
						PRIMARY KEY(codSeccion,codLab),
						FOREIGN KEY(codLab,codAsignatura) REFERENCES Registro.smregistro.Laboratorio(codLaboratorio,codAsignatura),
						FOREIGN KEY(codAula,codEdificioFF) REFERENCES Registro.smregistro.Aula(aula,codEdificioFF),
						FOREIGN KEY(codInstructor) REFERENCES Registro.smregistro.Instructor(codInstructor)
)
GO

--Secci�n de asignatura
CREATE TABLE Registro.smregistro.Seccion(
						codSeccion INT,
						codAsignatura VARCHAR(7),
						horaInicial TIME,
						horaFinal TIME,
						cupos INT,
						codEdificioFF INT,
						aula VARCHAR(20),
						diaPresenciales VARCHAR(10) NOT NULL,
						codCatedratico VARCHAR(15),
						PRIMARY KEY(codSeccion,codAsignatura),
						FOREIGN KEY(codAsignatura) REFERENCES Registro.smregistro.Asignatura(codAsignatura),
						FOREIGN KEY(aula,codEdificioFF) REFERENCES Registro.smregistro.Aula(aula,codEdificioFF),
						FOREIGN KEY(codCatedratico) REFERENCES Registro.smregistro.Catedratico(codCatedratico)			
						
)
GO

CREATE  TABLE Registro.smregistro.RequisitoExtraRequerido(
									codRequisito INT PRIMARY KEY IDENTITY(1,1),
									nombre VARCHAR(10)
)
GO

CREATE TABLE Registro.smregistro.Carrera(
									codCarrera VARCHAR(7) PRIMARY KEY,
									nombreCarrera VARCHAR(50) NOT NULL,
									duracion INT NOT NULL,
									indiceRequerido INT,
									codRequisitoExtraRequerido INT,
									indiceExtraRequerido INT,
									disponible BIT NOT NULL,
									titulo VARCHAR(30),
									codFacultadFF INT,
									cuposDisponibles INT,
									FOREIGN KEY (codFacultadFF) REFERENCES Registro.smregistro.Facultad(codFacultad),
									FOREIGN KEY(codRequisitoExtraRequerido) REFERENCES Registro.smregistro.RequisitoExtraRequerido(codRequisito)
)
GO



CREATE TABLE Registro.smregistro.CarreraDepartamento(
									codCarreraFF VARCHAR(7),
									codDepartamentoFF VARCHAR(7),
									PRIMARY KEY(codCarreraFF, codDepartamentoFF),
									FOREIGN KEY (codCarreraFF) REFERENCES Registro.smregistro.Carrera(codCarrera),
									FOREIGN KEY (codDepartamentoFF) REFERENCES Registro.smregistro.DepartamentosCarrera(codDepartamento)
)
GO

CREATE TABLE Registro.smregistro.CoordinadorCarrera(
									codCoordinador VARCHAR(15) NOT NULL,
									codEmpleado VARCHAR(7),
									fechaInicioC DATE,
									fechaFinalC DATE,
									PRIMARY KEY(codCoordinador, fechaInicioC),
							        FOREIGN KEY(codEmpleado) REFERENCES Registro.smregistro.Empleado(codEmpleado)
									
)
GO


CREATE TABLE Registro.smregistro.CordinaCarrera(
									codCoordinadorFF VARCHAR(15),
									fechaInicioCoordinador DATE,
									codCarreradFF VARCHAR(7) NOT NULL UNIQUE,
									PRIMARY KEY(codCoordinadorFF, fechaInicioCoordinador),
									FOREIGN KEY(codCoordinadorFF,fechaInicioCoordinador) REFERENCES Registro.smregistro.CoordinadorCarrera(codCoordinador,fechaInicioC),
									FOREIGN KEY(codCarreradFF) REFERENCES Registro.smregistro.Carrera(codCarrera)

)
GO

CREATE TABLE Registro.smregistro.PlanEstudio(
							codCarreraFF VARCHAR(7),
							codAsignaturaFF VARCHAR(7),
							optativa bit
							PRIMARY KEY(codCarreraFF, codAsignaturaFF),
							FOREIGN KEY(codCarreraFF) REFERENCES Registro.smregistro.Carrera(codCarrera)
)
GO

CREATE TABLE Registro.smregistro.Requisitos(
							codCarreraFFR VARCHAR(7),
							codAsignaturaFFR VARCHAR(7),
							codAsignarutaRequisitos VARCHAR(7),
							PRIMARY KEY (codCarreraFFR, codAsignaturaFFR, codAsignarutaRequisitos),
							FOREIGN KEY(codCarreraFFR, codAsignaturaFFR) REFERENCES Registro.smregistro.PlanEstudio(codCarreraFF,codAsignaturaFF),
							FOREIGN KEY(codAsignarutaRequisitos) REFERENCES Registro.smregistro.Asignatura(codAsignatura)
)
GO

CREATE TABLE Registro.smregistro.Modalidad(
									codModalidad int PRIMARY KEY,
									nombre VARCHAR(30) NOT NULL
)
GO


CREATE TABLE Registro.smregistro.ModalidadCarrera(
							  codCarreraFF VARCHAR(7),
							  codModalidadFF INT,
							  PRIMARY KEY(codCarreraFF,codModalidadFF),
							  FOREIGN KEY(codCarreraFF) REFERENCES Registro.smregistro.Carrera(codCarrera),
							  FOREIGN KEY(codModalidadFF) REFERENCES Registro.smregistro.Modalidad(codModalidad)
)
GO


CREATE TABLE Registro.smregistro.Estudiante(
							numCuenta VARCHAR(15) PRIMARY KEY,
							identidad VARCHAR(15) NOT NULL,
							primerNombre VARCHAR(20) NOT NULL,
							segundoNombre VARCHAR(20),
							primerApellido VARCHAR(20) NOT NULL,
							segundoApellido VARCHAR(20),
							clave VARCHAR(15) NOT NULL,
							fechaNacimiento DATE NOT NULL,
							indicePAA INT NOT NULL,
							indiceExtraRequeridoObtenido INT,
							estadoCuenta DECIMAL(5,2) NULL,
							unidadesValorativas INT,
							codExtraRequerido int FOREIGN KEY REFERENCES Registro.smregistro.RequisitoExtraRequerido(codRequisito),
							municipioNac int FOREIGN KEY REFERENCES Registro.smregistro.Municipio(codMunicipio) NOT NULL)
						
GO

CREATE TABLE Registro.smregistro.AspectoRepresentativo(
						codAspecto INT IDENTITY PRIMARY KEY,
						nombreAspecto VARCHAR(20),
						descripcion  VARCHAR(200),
)
GO


--Representantes UNAH
CREATE TABLE Registro.smregistro.RepresentanteUNAH(
						codAspectoFF INT, 
						numeroCuentaFF VARCHAR(15),
						PRIMARY KEY(codAspectoFF, numeroCuentaFF),
						FOREIGN KEY (numeroCuentaFF) REFERENCES Registro.smregistro.Estudiante(numCuenta),
						FOREIGN KEY (codAspectoFF) REFERENCES Registro.smregistro.AspectoRepresentativo(codAspecto)
)
GO

CREATE TABLE Registro.smregistro.Discapacidad(
						codDiscapacidad INT IDENTITY PRIMARY KEY,
						nombreDiscapacidad VARCHAR(20),
						descripcion VARCHAR(250)
)
GO

--Estudiantes que son discapacitados
CREATE TABLE Registro.smregistro.PROSENE(
						codDiscapacidadFF INT, 
						numeroCuentaFF VARCHAR(15),
						PRIMARY KEY(codDiscapacidadFF, numeroCuentaFF),
						FOREIGN KEY (numeroCuentaFF) REFERENCES Registro.smregistro.Estudiante(numCuenta),
						FOREIGN KEY (codDiscapacidadFF) REFERENCES Registro.smregistro.Discapacidad(codDiscapacidad)
)
GO



CREATE TABLE Registro.smregistro.MatriculaCarrera(
						   cuentaEstudiante VARCHAR(15),
						   codCarrera VARCHAR(7),
						   PRIMARY KEY(cuentaEstudiante,codCarrera),
						   FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
						   FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera))
GO

CREATE TABLE Registro.smregistro.HistorialAcademico(
									codCarrera VARCHAR(7),
									cuentaEstudiante VARCHAR(15),
									codAsignatura VARCHAR(7),
									seccion INT,
									codPeriodo int NOT NULL,
									fechaInicioPeriodo date,
									calificacion int NOT NULL,
									observacion VARCHAR(25) NOT NULL,
									PRIMARY KEY(codCarrera,cuentaEstudiante,codAsignatura,fechaInicioPeriodo),
									FOREIGN KEY(codPeriodo,fechaInicioPeriodo) REFERENCES Registro.smregistro.Periodo(codPeriodo,fechaInicio),
									FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera),
									FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
									FOREIGN KEY(codAsignatura) REFERENCES Registro.smregistro.Asignatura(codAsignatura),
									FOREIGN KEY (seccion, codAsignatura) REFERENCES Registro.smregistro.Seccion(codSeccion,codAsignatura)
)
GO


CREATE TABLE Registro.smregistro.MatriculaClase(
								codCarrera VARCHAR(7),
								cuentaEstudiante VARCHAR(15),
								codSeccionClase int,
								codAsignatura VARCHAR(7),
								fechaPeriodo DATE,
								fechaMat DATETIME,
								codperiodo INT, 
								calificacion INT,
								espera BIT,
								observaciones VARCHAR(5),
								PRIMARY KEY(codCarrera,cuentaEstudiante,codSeccionClase,fechaPeriodo),
								FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera),
								FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
								FOREIGN KEY(codSeccionClase,codAsignatura) REFERENCES Registro.smregistro.Seccion(codSeccion,codAsignatura),
								FOREIGN KEY(codPeriodo,fechaPeriodo) REFERENCES Registro.smregistro.Periodo(codPeriodo,fechaInicio)
)
GO

CREATE TABLE Registro.smregistro.MatriculaLab(
								codCarrera VARCHAR(7),
								cuentaEstudiante VARCHAR(15),
								codLab VARCHAR(7),
								codAsignatura VARCHAR(7),
								codSeccionLab INT,
								PRIMARY KEY(codCarrera,cuentaEstudiante,codLab),
								FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera),
								FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
								FOREIGN KEY(codSeccionLab,codLab) REFERENCES Registro.smregistro.SeccionLab(codSeccion,codLab),
								
)
GO
--Tabla de cancelacion de clases--
CREATE TABLE Registro.smregistro.CancelacionClase(
								codCarrera VARCHAR(7),
								cuentaEstudiante VARCHAR(15),
								codSeccionClase INT,
								codAsignatura VARCHAR(7),
								fecha DATE,
								codPeriodo INT,
								descripcion VARCHAR(30),
								PRIMARY KEY(codCarrera,cuentaEstudiante,codSeccionClase,codAsignatura,fecha),
								FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera),
								FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
								FOREIGN KEY(codSeccionClase,codAsignatura) REFERENCES Registro.smregistro.Seccion(codSeccion,codAsignatura),
								FOREIGN KEY(codPeriodo,fecha) REFERENCES Registro.smregistro.Periodo(codPeriodo,fechaInicio)
								)
GO

CREATE TABLE Registro.smregistro.CancelacionLabClase(
								codCarrera VARCHAR(7),
								cuentaEstudiante VARCHAR(15),
								codSeccionLab INT,
								codLab VARCHAR(7),
								codAsignatura VARCHAR(7),
								fecha DATE,
								codPeriodo INT,
								descripcion VARCHAR(30)
								PRIMARY KEY(codCarrera,cuentaEstudiante,codSeccionLab,codAsignatura,fecha),
								FOREIGN KEY(codCarrera) REFERENCES Registro.smregistro.Carrera(codCarrera),
								FOREIGN KEY(cuentaEstudiante) REFERENCES Registro.smregistro.Estudiante(numCuenta),
								FOREIGN KEY(codSeccionLab,codLab) REFERENCES Registro.smregistro.SeccionLab(codSeccion,codLab),
								FOREIGN KEY(codPeriodo,fecha) REFERENCES Registro.smregistro.Periodo(codPeriodo,fechaInicio)
								)
GO

--2 Tablas Correo Para almacenar los correos de las entidades que necesiten o poseean Uno
CREATE TABLE Registro.smregistro.CorreoEmpleado(
								codUsuario VARCHAR(7),
								correo VARCHAR(70),
								tipo VARCHAR(15), -- 0 correo institucional , 1 correo personal
								PRIMARY KEY(codUsuario,correo),
								FOREIGN KEY(codUsuario) REFERENCES Registro.smregistro.Empleado(codEmpleado)
							
)
GO

CREATE TABLE Registro.smregistro.CorreoEstudiante(
								codUsuario VARCHAR(15),
								correo VARCHAR(70),
								tipo VARCHAR(15),
								PRIMARY KEY(codUsuario,correo),
								FOREIGN KEY(codUsuario) REFERENCES Registro.smregistro.Estudiante(numCuenta)
							
)
GO

--Una Sola Tabla Para Telefono almacenar los Telefonos de las entidades que necesiten o poseean Uno
CREATE TABLE Registro.smregistro.TelefonoEmpleado(
								codUsuario VARCHAR(7),
								telefono INT,
								PRIMARY KEY(codUsuario, telefono),
								FOREIGN KEY(codUsuario) REFERENCES Registro.smregistro.Empleado(codEmpleado)				
)
GO

CREATE TABLE Registro.smregistro.TelefonoEstudiante(
								codUsuario VARCHAR(15),
								telefono INT,
								PRIMARY KEY(codUsuario, telefono),
								FOREIGN KEY(codUsuario) REFERENCES Registro.smregistro.Estudiante(numCuenta)				
)
GO

