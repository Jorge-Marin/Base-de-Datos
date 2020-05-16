-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 16-05-2020 a las 22:58:51
-- Versión del servidor: 5.5.24-log
-- Versión de PHP: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `registro`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignatura`
--

CREATE TABLE IF NOT EXISTS `asignatura` (
  `codAsignatura` varchar(7) NOT NULL,
  `nombreAsignatura` varchar(50) NOT NULL,
  `unidadesValorativas` int(11) NOT NULL,
  `observacion` varchar(50) DEFAULT NULL,
  `unificada` tinyint(3) unsigned DEFAULT NULL,
  `codDepartamentoFF` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`codAsignatura`),
  KEY `FK__Asignatur__codDe__4222D4EF` (`codDepartamentoFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `asignatura`
--

INSERT INTO `asignatura` (`codAsignatura`, `nombreAsignatura`, `unidadesValorativas`, `observacion`, `unificada`, `codDepartamentoFF`) VALUES
('FS-100', 'Física General I', 5, '', 0, '01FS'),
('IN-101', 'Inglés I', 4, '', 0, '01LE'),
('IN-102', 'Ingles II', 4, '', 0, '01LE'),
('IS-110', 'Introduccion a la Ingenieria en Sistemas', 3, '', 0, '02IS'),
('IS-210', 'Programación II', 5, '', 0, '02IS'),
('MM-110', 'Matematica I', 5, '', 1, '01M'),
('MM-111', 'Geometría y Trigonometría', 5, '', 1, '01M'),
('MM-201', 'Calculo I', 5, '', 1, '01M'),
('MM-202', 'Calculo II', 5, '', 1, '01M'),
('MM-211', 'Vectores y Matrices', 3, '', 0, '01M'),
('MM-314', 'Programación I', 3, '', 1, '01M'),
('SC-101', 'Sociologia', 4, '', 0, '03S');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aspectorepresentativo`
--

CREATE TABLE IF NOT EXISTS `aspectorepresentativo` (
  `codAspecto` int(11) NOT NULL,
  `nombreAspecto` varchar(20) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`codAspecto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aula`
--

CREATE TABLE IF NOT EXISTS `aula` (
  `aula` varchar(20) NOT NULL,
  `codEdificioFF` int(11) NOT NULL,
  PRIMARY KEY (`aula`,`codEdificioFF`),
  KEY `FK__Aula__codEdifici__145C0A3F` (`codEdificioFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `aula`
--

INSERT INTO `aula` (`aula`, `codEdificioFF`) VALUES
('101', 1),
('102', 1),
('103', 1),
('101', 2),
('102', 2),
('103', 2),
('101', 4),
('102', 4),
('103', 4),
('105', 4),
('203', 4),
('Laboratorio 1 (IS)', 4),
('Laboratorio 2 (IS)', 4),
('305', 9),
('105', 10),
('203', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cancelacionclase`
--

CREATE TABLE IF NOT EXISTS `cancelacionclase` (
  `codCarrera` varchar(7) NOT NULL,
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codSeccionClase` int(11) NOT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  `fecha` date NOT NULL,
  `codPeriodo` int(11) DEFAULT NULL,
  `descripcion` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codCarrera`,`cuentaEstudiante`,`codSeccionClase`,`codAsignatura`,`fecha`),
  KEY `FK__CancelacionClase__57DD0BE4` (`codSeccionClase`,`codAsignatura`),
  KEY `FK__CancelacionClase__58D1301D` (`codPeriodo`,`fecha`),
  KEY `FK__Cancelaci__cuent__56E8E7AB` (`cuentaEstudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cancelacionlabclase`
--

CREATE TABLE IF NOT EXISTS `cancelacionlabclase` (
  `codCarrera` varchar(7) NOT NULL,
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codSeccionLab` int(11) NOT NULL,
  `codLab` varchar(7) DEFAULT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  `fecha` date NOT NULL,
  `codPeriodo` int(11) DEFAULT NULL,
  `descripcion` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codCarrera`,`cuentaEstudiante`,`codSeccionLab`,`codAsignatura`,`fecha`),
  KEY `FK__CancelacionLabCl__5F7E2DAC` (`codSeccionLab`,`codLab`),
  KEY `FK__CancelacionLabCl__607251E5` (`codPeriodo`,`fecha`),
  KEY `FK__Cancelaci__cuent__5E8A0973` (`cuentaEstudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrera`
--

CREATE TABLE IF NOT EXISTS `carrera` (
  `codCarrera` varchar(7) NOT NULL,
  `nombreCarrera` varchar(50) NOT NULL,
  `duracion` int(11) NOT NULL,
  `indiceRequerido` int(11) DEFAULT NULL,
  `codRequisitoExtraRequerido` int(11) DEFAULT NULL,
  `indiceExtraRequerido` int(11) DEFAULT NULL,
  `disponible` tinyint(3) unsigned NOT NULL,
  `titulo` varchar(30) DEFAULT NULL,
  `codFacultadFF` int(11) DEFAULT NULL,
  `cuposDisponibles` int(11) DEFAULT NULL,
  PRIMARY KEY (`codCarrera`),
  KEY `FK__Carrera__codFacu__73BA3083` (`codFacultadFF`),
  KEY `FK__Carrera__codRequ__74AE54BC` (`codRequisitoExtraRequerido`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `carrera`
--

INSERT INTO `carrera` (`codCarrera`, `nombreCarrera`, `duracion`, `indiceRequerido`, `codRequisitoExtraRequerido`, `indiceExtraRequerido`, `disponible`, `titulo`, `codFacultadFF`, `cuposDisponibles`) VALUES
('AQ01', 'Arquitectura', 6, 1000, NULL, NULL, 1, 'Lic en Arquitectura', 101, 800),
('CJ01', 'Derecho', 5, 900, NULL, NULL, 1, 'Lic. en Derecho', 103, 1500),
('IS01', 'Ingeniería en sistemas', 5, 1000, 1, 750, 1, 'Lic. en Sistemas', 100, 1000),
('MM01', 'Matemática', 4, 800, NULL, NULL, 1, 'Lic. en Matemática', 104, 800),
('SC01', 'Sociología', 4, 700, NULL, NULL, 1, 'Lic. en Sociología', 102, 1200);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreradepartamento`
--

CREATE TABLE IF NOT EXISTS `carreradepartamento` (
  `codCarreraFF` varchar(7) NOT NULL,
  `codDepartamentoFF` varchar(7) NOT NULL,
  PRIMARY KEY (`codCarreraFF`,`codDepartamentoFF`),
  KEY `FK__CarreraDe__codDe__7A672E12` (`codDepartamentoFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `carreradepartamento`
--

INSERT INTO `carreradepartamento` (`codCarreraFF`, `codDepartamentoFF`) VALUES
('IS01', '01M'),
('MM01', '01M'),
('IS01', '02IS'),
('SC01', '03S');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `catedratico`
--

CREATE TABLE IF NOT EXISTS `catedratico` (
  `codCatedratico` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `cantidadClases` int(11) DEFAULT NULL,
  `activo` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`codCatedratico`),
  KEY `FK__Catedrati__codEm__46E78A0C` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `catedratico`
--

INSERT INTO `catedratico` (`codCatedratico`, `codEmpleado`, `cantidadClases`, `activo`) VALUES
('102', '030', NULL, NULL),
('103', '020', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coordinadorasignatura`
--

CREATE TABLE IF NOT EXISTS `coordinadorasignatura` (
  `codCatedraticoFF` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `fechaInicioCargoFF` date NOT NULL,
  `fechaFinalCargoFF` date DEFAULT NULL,
  `codasignaturaFF` varchar(7) NOT NULL,
  PRIMARY KEY (`codCatedraticoFF`,`fechaInicioCargoFF`),
  UNIQUE KEY `UQ__Coordina__62F65DD74CA06362` (`codasignaturaFF`),
  KEY `FK__Coordinad__codEm__5070F446` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `coordinadorasignatura`
--

INSERT INTO `coordinadorasignatura` (`codCatedraticoFF`, `codEmpleado`, `fechaInicioCargoFF`, `fechaFinalCargoFF`, `codasignaturaFF`) VALUES
('102', '040', '2001-03-02', '1900-01-01', 'MM-110');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coordinadorcarrera`
--

CREATE TABLE IF NOT EXISTS `coordinadorcarrera` (
  `codCoordinador` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `fechaInicioC` date NOT NULL,
  `fechaFinalC` date DEFAULT NULL,
  PRIMARY KEY (`codCoordinador`,`fechaInicioC`),
  KEY `FK__Coordinad__codEm__7F2BE32F` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `coordinadorcarrera`
--

INSERT INTO `coordinadorcarrera` (`codCoordinador`, `codEmpleado`, `fechaInicioC`, `fechaFinalC`) VALUES
('001', '010', '2020-02-03', '1900-01-01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coordinadorfacultad`
--

CREATE TABLE IF NOT EXISTS `coordinadorfacultad` (
  `codCoordinador` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `fechaInicioC` date NOT NULL,
  `fechaTerminoC` date DEFAULT NULL,
  PRIMARY KEY (`codCoordinador`,`fechaInicioC`),
  KEY `FK__Coordinad__codEm__1DE57479` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `coordinadorfacultad`
--

INSERT INTO `coordinadorfacultad` (`codCoordinador`, `codEmpleado`, `fechaInicioC`, `fechaTerminoC`) VALUES
('001', '010', '2000-02-01', '1900-01-01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cordinacarrera`
--

CREATE TABLE IF NOT EXISTS `cordinacarrera` (
  `codCoordinadorFF` varchar(15) NOT NULL,
  `fechaInicioCoordinador` date NOT NULL,
  `codCarreradFF` varchar(7) NOT NULL,
  PRIMARY KEY (`codCoordinadorFF`,`fechaInicioCoordinador`),
  UNIQUE KEY `UQ__CordinaC__44F8575704E4BC85` (`codCarreradFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cordinacarrera`
--

INSERT INTO `cordinacarrera` (`codCoordinadorFF`, `fechaInicioCoordinador`, `codCarreradFF`) VALUES
('001', '2020-02-03', 'AQ01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cordinafacultad`
--

CREATE TABLE IF NOT EXISTS `cordinafacultad` (
  `codCoordinadorFF` varchar(15) NOT NULL,
  `fechaInicioCoordinador` date NOT NULL,
  `codFacultadFF` int(11) NOT NULL,
  PRIMARY KEY (`codCoordinadorFF`,`fechaInicioCoordinador`),
  UNIQUE KEY `UQ__CordinaF__90F04BD3286302EC` (`codFacultadFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cordinafacultad`
--

INSERT INTO `cordinafacultad` (`codCoordinadorFF`, `fechaInicioCoordinador`, `codFacultadFF`) VALUES
('001', '2000-02-01', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correoempleado`
--

CREATE TABLE IF NOT EXISTS `correoempleado` (
  `codUsuario` varchar(7) NOT NULL,
  `correo` varchar(70) NOT NULL,
  `tipo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`codUsuario`,`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `correoempleado`
--

INSERT INTO `correoempleado` (`codUsuario`, `correo`, `tipo`) VALUES
('010', 'BJuan29z@unah.hn', 'Instirucional'),
('010', 'juan29z@gmail.com', 'Personal'),
('020', 'jorge9z@gmail.com', 'Personal'),
('030', 'isaac29z@gmail.com', 'Personal'),
('040', 'bessy29z@gmail.com', 'Personal');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correoestudiante`
--

CREATE TABLE IF NOT EXISTS `correoestudiante` (
  `codUsuario` varchar(15) NOT NULL,
  `correo` varchar(70) NOT NULL,
  `tipo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`codUsuario`,`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `correoestudiante`
--

INSERT INTO `correoestudiante` (`codUsuario`, `correo`, `tipo`) VALUES
('20171004244', 'daniela29z@gmail.com', 'Personal'),
('20171004244', 'daniela29z@outlook.com', 'Institucional');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE IF NOT EXISTS `departamento` (
  `codDeptartamento` int(11) NOT NULL,
  `nombreDepartamento` varchar(30) NOT NULL,
  PRIMARY KEY (`codDeptartamento`),
  UNIQUE KEY `UQ__Departam__97ABAFF5023D5A04` (`nombreDepartamento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`codDeptartamento`, `nombreDepartamento`) VALUES
(1, 'Atlántida'),
(2, 'Choluteca'),
(3, 'Colón'),
(4, 'Comayagua'),
(5, 'Copán'),
(6, 'Cortes'),
(7, 'El Paraíso, '),
(8, 'Francisco Morazán'),
(9, 'Gracias a Dios'),
(10, 'Intibucá'),
(11, 'Islas de la Bahía'),
(12, 'La Paz'),
(13, 'Lempira'),
(14, 'Ocotepeque'),
(15, 'Olancho'),
(16, 'Santa Bárbara'),
(17, 'Valle'),
(18, 'Yoro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentojefe`
--

CREATE TABLE IF NOT EXISTS `departamentojefe` (
  `codJefeDepartamentoFF` varchar(15) NOT NULL,
  `fechaInicioCargoFF` date NOT NULL,
  `codDepartamentoFF` varchar(7) NOT NULL,
  PRIMARY KEY (`codJefeDepartamentoFF`,`fechaInicioCargoFF`),
  UNIQUE KEY `UQ__Departam__CB568C353A81B327` (`codDepartamentoFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentoscarrera`
--

CREATE TABLE IF NOT EXISTS `departamentoscarrera` (
  `codDepartamento` varchar(7) NOT NULL,
  `nombreDepartamento` varchar(50) DEFAULT NULL,
  `codEdificioFF` int(11) DEFAULT NULL,
  PRIMARY KEY (`codDepartamento`),
  KEY `FK__Departame__codEd__34C8D9D1` (`codEdificioFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `departamentoscarrera`
--

INSERT INTO `departamentoscarrera` (`codDepartamento`, `nombreDepartamento`, `codEdificioFF`) VALUES
('01CE', 'Ciencias Económicas', 5),
('01FS', 'Fisica', 11),
('01LE', 'Lenguas Extranjeras', 8),
('01M', 'Matematica', 9),
('02IS', 'Ingeniería en Sistemas', 4),
('03S', 'Sociología', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `discapacidad`
--

CREATE TABLE IF NOT EXISTS `discapacidad` (
  `codDiscapacidad` int(11) NOT NULL,
  `nombreDiscapacidad` varchar(20) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`codDiscapacidad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `edificio`
--

CREATE TABLE IF NOT EXISTS `edificio` (
  `codEdificio` int(11) NOT NULL,
  `nombreEdificio` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codEdificio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `edificio`
--

INSERT INTO `edificio` (`codEdificio`, `nombreEdificio`) VALUES
(1, 'A1'),
(2, 'A2'),
(3, 'B1'),
(4, 'B2'),
(5, 'C1'),
(6, 'C2'),
(7, 'C3'),
(8, 'D1'),
(9, 'F1'),
(10, 'E1'),
(11, 'Polideportivo'),
(12, 'A1'),
(13, 'A2'),
(14, 'B1'),
(15, 'B2'),
(16, 'C1'),
(17, 'C2'),
(18, 'C3'),
(19, 'D1'),
(20, 'F1'),
(21, 'E1'),
(22, 'Polideportivo'),
(23, 'A1'),
(24, 'A2'),
(25, 'B1'),
(26, 'B2'),
(27, 'C1'),
(28, 'C2'),
(29, 'C3'),
(30, 'D1'),
(31, 'F1'),
(32, 'E1'),
(33, 'Polideportivo'),
(34, 'A1'),
(35, 'A2'),
(36, 'B1'),
(37, 'B2'),
(38, 'C1'),
(39, 'C2'),
(40, 'C3'),
(41, 'D1'),
(42, 'F1'),
(43, 'E1'),
(44, 'Polideportivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE IF NOT EXISTS `empleado` (
  `codEmpleado` varchar(7) NOT NULL,
  `identidad` varchar(15) NOT NULL,
  `primerNombre` varchar(20) NOT NULL,
  `segundoNombre` varchar(20) DEFAULT NULL,
  `apellidoMaterno` varchar(20) NOT NULL,
  `apellidoPaterno` varchar(20) DEFAULT NULL,
  `gradoAcademico` varchar(50) DEFAULT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `municipioNac` int(11) NOT NULL,
  PRIMARY KEY (`codEmpleado`),
  KEY `FK__Empleado__munici__1920BF5C` (`municipioNac`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`codEmpleado`, `identidad`, `primerNombre`, `segundoNombre`, `apellidoMaterno`, `apellidoPaterno`, `gradoAcademico`, `fechaNacimiento`, `municipioNac`) VALUES
('010', '0801197300675', 'Juan', 'Mario', 'López', 'Pérez', 'Ing Sistemas', '1974-02-01', 1),
('020', '0811197300675', 'Jorge', 'Arturo', 'Marin', '', 'Lic. Matemática', '1984-12-01', 2),
('030', '0812197300675', 'Isaac', 'Fernando', 'Zavala', '', 'Lic. Sociología', '1994-02-06', 3),
('040', '0412197300675', 'Bessy', 'Daniela', 'Zavala', 'Licona', 'Lic. Fisica', '1994-02-02', 4),
('050', '0112197300675', 'Marcos', '', 'López', '', 'Lic. Derecho', '1994-02-04', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE IF NOT EXISTS `estudiante` (
  `numCuenta` varchar(15) NOT NULL,
  `identidad` varchar(15) NOT NULL,
  `primerNombre` varchar(20) NOT NULL,
  `segundoNombre` varchar(20) DEFAULT NULL,
  `primerApellido` varchar(20) NOT NULL,
  `segundoApellido` varchar(20) DEFAULT NULL,
  `clave` varchar(15) NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `indicePAA` int(11) NOT NULL,
  `indiceExtraRequeridoObtenido` int(11) DEFAULT NULL,
  `estadoCuenta` decimal(5,2) DEFAULT NULL,
  `unidadesValorativas` int(11) DEFAULT NULL,
  `codExtraRequerido` int(11) DEFAULT NULL,
  `municipioNac` int(11) NOT NULL,
  PRIMARY KEY (`numCuenta`),
  KEY `FK__Estudiant__codEx__208CD6FA` (`codExtraRequerido`),
  KEY `FK__Estudiant__munic__2180FB33` (`municipioNac`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`numCuenta`, `identidad`, `primerNombre`, `segundoNombre`, `primerApellido`, `segundoApellido`, `clave`, `fechaNacimiento`, `indicePAA`, `indiceExtraRequeridoObtenido`, `estadoCuenta`, `unidadesValorativas`, `codExtraRequerido`, `municipioNac`) VALUES
('20171004244', '0813199800412', 'Bessy', 'Daniela', 'Zavala', 'Licona', 'Dan_2J2', '1998-05-15', 1200, 750, '270.00', 25, 1, 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facultad`
--

CREATE TABLE IF NOT EXISTS `facultad` (
  `codFacultad` int(11) NOT NULL,
  `nombreFacultad` varchar(50) DEFAULT NULL,
  `codCoordinadorFF` varchar(15) DEFAULT NULL,
  `codEdificioFF` int(11) DEFAULT NULL,
  PRIMARY KEY (`codFacultad`),
  KEY `FK__Facultad__codEdi__22AA2996` (`codEdificioFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `facultad`
--

INSERT INTO `facultad` (`codFacultad`, `nombreFacultad`, `codCoordinadorFF`, `codEdificioFF`) VALUES
(100, 'Ingeniería', '1', 4),
(101, 'Arquitectura', '2', 4),
(102, 'Sociología', '3', 1),
(103, 'Ciencias Jurídicas', '4', 2),
(104, 'Matemática', '5', 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialacademico`
--

CREATE TABLE IF NOT EXISTS `historialacademico` (
  `codCarrera` varchar(7) NOT NULL,
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  `seccion` int(11) DEFAULT NULL,
  `codPeriodo` int(11) NOT NULL,
  `fechaInicioPeriodo` date NOT NULL,
  `calificacion` int(11) NOT NULL,
  `observacion` varchar(25) NOT NULL,
  PRIMARY KEY (`codCarrera`,`cuentaEstudiante`,`codAsignatura`,`fechaInicioPeriodo`),
  KEY `FK__HistorialAcademi__3F115E1A` (`codPeriodo`,`fechaInicioPeriodo`),
  KEY `FK__HistorialAcademi__42E1EEFE` (`seccion`,`codAsignatura`),
  KEY `FK__Historial__codAs__41EDCAC5` (`codAsignatura`),
  KEY `FK__Historial__cuent__40F9A68C` (`cuentaEstudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `historialacademico`
--

INSERT INTO `historialacademico` (`codCarrera`, `cuentaEstudiante`, `codAsignatura`, `seccion`, `codPeriodo`, `fechaInicioPeriodo`, `calificacion`, `observacion`) VALUES
('IS01', '20171004244', 'MM-110', 800, 1, '2020-04-20', 80, 'Aprobado'),
('IS01', '20171004244', 'SC-101', 700, 1, '2020-04-20', 90, 'Aprobado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instructor`
--

CREATE TABLE IF NOT EXISTS `instructor` (
  `codInstructor` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `cantLaboratorios` int(11) DEFAULT NULL,
  PRIMARY KEY (`codInstructor`),
  KEY `FK__Instructo__codEm__5CD6CB2B` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `instructor`
--

INSERT INTO `instructor` (`codInstructor`, `codEmpleado`, `cantLaboratorios`) VALUES
('300', '050', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jefedepartamento`
--

CREATE TABLE IF NOT EXISTS `jefedepartamento` (
  `codJefeDepartamento` varchar(15) NOT NULL,
  `codEmpleado` varchar(7) DEFAULT NULL,
  `fechaInicioCargo` date NOT NULL,
  `fechaFinalCargo` date DEFAULT NULL,
  PRIMARY KEY (`codJefeDepartamento`,`fechaInicioCargo`),
  KEY `FK__JefeDepar__codEm__300424B4` (`codEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `jefedepartamento`
--

INSERT INTO `jefedepartamento` (`codJefeDepartamento`, `codEmpleado`, `fechaInicioCargo`, `fechaFinalCargo`) VALUES
('100', '020', '2001-03-02', '1900-01-01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `laboratorio`
--

CREATE TABLE IF NOT EXISTS `laboratorio` (
  `codLaboratorio` varchar(7) NOT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  PRIMARY KEY (`codLaboratorio`,`codAsignatura`),
  UNIQUE KEY `UQ__Laborato__5BD4F6965629CD9C` (`codAsignatura`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `laboratorio`
--

INSERT INTO `laboratorio` (`codLaboratorio`, `codAsignatura`) VALUES
('FS1LAB', 'FS-100');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matriculacarrera`
--

CREATE TABLE IF NOT EXISTS `matriculacarrera` (
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codCarrera` varchar(7) NOT NULL,
  PRIMARY KEY (`cuentaEstudiante`,`codCarrera`),
  KEY `FK__Matricula__codCa__3A4CA8FD` (`codCarrera`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matriculacarrera`
--

INSERT INTO `matriculacarrera` (`cuentaEstudiante`, `codCarrera`) VALUES
('20171004244', 'AQ01'),
('20171004244', 'IS01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matriculaclase`
--

CREATE TABLE IF NOT EXISTS `matriculaclase` (
  `codCarrera` varchar(7) NOT NULL,
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codSeccionClase` int(11) NOT NULL,
  `codAsignatura` varchar(7) DEFAULT NULL,
  `fechaPeriodo` date NOT NULL,
  `fechaMat` datetime DEFAULT NULL,
  `codperiodo` int(11) DEFAULT NULL,
  `calificacion` int(11) DEFAULT NULL,
  `espera` tinyint(3) unsigned DEFAULT NULL,
  `observaciones` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`codCarrera`,`cuentaEstudiante`,`codSeccionClase`,`fechaPeriodo`),
  KEY `FK__MatriculaClase__498EEC8D` (`codSeccionClase`,`codAsignatura`),
  KEY `FK__MatriculaClase__4A8310C6` (`codperiodo`,`fechaPeriodo`),
  KEY `FK__Matricula__cuent__489AC854` (`cuentaEstudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matriculalab`
--

CREATE TABLE IF NOT EXISTS `matriculalab` (
  `codCarrera` varchar(7) NOT NULL,
  `cuentaEstudiante` varchar(15) NOT NULL,
  `codLab` varchar(7) NOT NULL,
  `codAsignatura` varchar(7) DEFAULT NULL,
  `codSeccionLab` int(11) DEFAULT NULL,
  PRIMARY KEY (`codCarrera`,`cuentaEstudiante`,`codLab`),
  KEY `FK__MatriculaLab__51300E55` (`codSeccionLab`,`codLab`),
  KEY `FK__Matricula__cuent__503BEA1C` (`cuentaEstudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matriculalab`
--

INSERT INTO `matriculalab` (`codCarrera`, `cuentaEstudiante`, `codLab`, `codAsignatura`, `codSeccionLab`) VALUES
('IS01', '20171004244', 'FS1LAB', 'FS-100', 1000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modalidad`
--

CREATE TABLE IF NOT EXISTS `modalidad` (
  `codModalidad` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`codModalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `modalidad`
--

INSERT INTO `modalidad` (`codModalidad`, `nombre`) VALUES
(1, 'Presencial'),
(2, 'Distancia'),
(3, 'Virtual');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modalidadcarrera`
--

CREATE TABLE IF NOT EXISTS `modalidadcarrera` (
  `codCarreraFF` varchar(7) NOT NULL,
  `codModalidadFF` int(11) NOT NULL,
  PRIMARY KEY (`codCarreraFF`,`codModalidadFF`),
  KEY `FK__Modalidad__codMo__1BC821DD` (`codModalidadFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `modalidadcarrera`
--

INSERT INTO `modalidadcarrera` (`codCarreraFF`, `codModalidadFF`) VALUES
('AQ01', 1),
('CJ01', 1),
('IS01', 1),
('MM01', 1),
('SC01', 1),
('CJ01', 2),
('MM01', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipio`
--

CREATE TABLE IF NOT EXISTS `municipio` (
  `codMunicipio` int(11) NOT NULL,
  `nombreMunicipio` varchar(30) NOT NULL,
  `codDeptartamentoFF` int(11) NOT NULL,
  PRIMARY KEY (`codMunicipio`),
  KEY `FK__Municipio__codDe__07F6335A` (`codDeptartamentoFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `municipio`
--

INSERT INTO `municipio` (`codMunicipio`, `nombreMunicipio`, `codDeptartamentoFF`) VALUES
(1, 'La Ceiba', 1),
(2, 'Tela', 1),
(3, 'Jutiapa', 1),
(4, 'Apacilagua', 2),
(5, 'Concepción de María', 2),
(6, 'Duyure', 2),
(7, 'Trujillo', 3),
(8, 'Balfate', 3),
(9, 'Iriona', 3),
(10, 'Ajuterique', 4),
(11, 'Esquías', 4),
(12, 'Humuya', 4),
(13, 'La Ceiba', 1),
(14, 'Tela', 1),
(15, 'Jutiapa', 1),
(16, 'Apacilagua', 2),
(17, 'Concepción de María', 2),
(18, 'Duyure', 2),
(19, 'Trujillo', 3),
(20, 'Balfate', 3),
(21, 'Iriona', 3),
(22, 'Ajuterique', 4),
(23, 'Esquías', 4),
(24, 'Humuya', 4),
(25, 'La Ceiba', 1),
(26, 'Tela', 1),
(27, 'Jutiapa', 1),
(28, 'Apacilagua', 2),
(29, 'Concepción de María', 2),
(30, 'Duyure', 2),
(31, 'Trujillo', 3),
(32, 'Balfate', 3),
(33, 'Iriona', 3),
(34, 'Ajuterique', 4),
(35, 'Esquías', 4),
(36, 'Humuya', 4),
(37, 'La Ceiba', 1),
(38, 'Tela', 1),
(39, 'Jutiapa', 1),
(40, 'Apacilagua', 2),
(41, 'Concepción de María', 2),
(42, 'Duyure', 2),
(43, 'Trujillo', 3),
(44, 'Balfate', 3),
(45, 'Iriona', 3),
(46, 'Ajuterique', 4),
(47, 'Esquías', 4),
(48, 'Humuya', 4),
(49, 'La Ceiba', 1),
(50, 'Tela', 1),
(51, 'Jutiapa', 1),
(52, 'Apacilagua', 2),
(53, 'Concepción de María', 2),
(54, 'Duyure', 2),
(55, 'Trujillo', 3),
(56, 'Balfate', 3),
(57, 'Iriona', 3),
(58, 'Ajuterique', 4),
(59, 'Esquías', 4),
(60, 'Humuya', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodo`
--

CREATE TABLE IF NOT EXISTS `periodo` (
  `codPeriodo` int(11) NOT NULL,
  `periodo` varchar(20) NOT NULL,
  `observaciones` varchar(20) DEFAULT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFinal` date NOT NULL,
  `inicioAdiciones` date NOT NULL,
  `finalizaAdiciones` date NOT NULL,
  `inicioPrematricula` date NOT NULL,
  `finalPrematricula` date NOT NULL,
  `inicioMatricula` date NOT NULL,
  `finalMatricula` date NOT NULL,
  `activo` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`codPeriodo`,`fechaInicio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `periodo`
--

INSERT INTO `periodo` (`codPeriodo`, `periodo`, `observaciones`, `fechaInicio`, `fechaFinal`, `inicioAdiciones`, `finalizaAdiciones`, `inicioPrematricula`, `finalPrematricula`, `inicioMatricula`, `finalMatricula`, `activo`) VALUES
(1, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(2, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(3, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(4, 'II', 'Periodo Corto', '2020-05-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-04-01', '2020-04-05', '2020-04-07', '2020-04-12', 0),
(5, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(6, 'II', 'Periodo Corto', '2020-05-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-04-01', '2020-04-05', '2020-04-07', '2020-04-12', 0),
(7, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(8, 'II', 'Periodo Corto', '2020-05-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-04-01', '2020-04-05', '2020-04-07', '2020-04-12', 0),
(9, 'I', 'Periodo Corto', '2020-04-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-05-15', '2020-04-05', '2020-04-07', '2020-04-12', 1),
(10, 'II', 'Periodo Corto', '2020-05-20', '2020-10-01', '2020-04-15', '2020-04-20', '2020-04-01', '2020-04-05', '2020-04-07', '2020-04-12', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planestudio`
--

CREATE TABLE IF NOT EXISTS `planestudio` (
  `codCarreraFF` varchar(7) NOT NULL,
  `codAsignaturaFF` varchar(7) NOT NULL,
  `optativa` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`codCarreraFF`,`codAsignaturaFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `planestudio`
--

INSERT INTO `planestudio` (`codCarreraFF`, `codAsignaturaFF`, `optativa`) VALUES
('CJ01', 'IN-101', 1),
('IS01', 'FS-100', 0),
('IS01', 'IN-102', 0),
('IS01', 'IS-110', 0),
('IS01', 'IS-210', 0),
('IS01', 'MM-110', 0),
('IS01', 'MM-111', 0),
('IS01', 'MM-201', 0),
('IS01', 'MM-202', 0),
('IS01', 'MM-211', 0),
('IS01', 'MM-314', 0),
('IS01', 'SC-101', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prosene`
--

CREATE TABLE IF NOT EXISTS `prosene` (
  `codDiscapacidadFF` int(11) NOT NULL,
  `numeroCuentaFF` varchar(15) NOT NULL,
  PRIMARY KEY (`codDiscapacidadFF`,`numeroCuentaFF`),
  KEY `FK__PROSENE__numeroC__339FAB6E` (`numeroCuentaFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `representanteunah`
--

CREATE TABLE IF NOT EXISTS `representanteunah` (
  `codAspectoFF` int(11) NOT NULL,
  `numeroCuentaFF` varchar(15) NOT NULL,
  PRIMARY KEY (`codAspectoFF`,`numeroCuentaFF`),
  KEY `FK__Represent__numer__2A164134` (`numeroCuentaFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requisitoextrarequerido`
--

CREATE TABLE IF NOT EXISTS `requisitoextrarequerido` (
  `codRequisito` int(11) NOT NULL,
  `nombre` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`codRequisito`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `requisitoextrarequerido`
--

INSERT INTO `requisitoextrarequerido` (`codRequisito`, `nombre`) VALUES
(1, 'PAM'),
(2, 'PCCNS'),
(3, 'PAM'),
(4, 'PCCNS'),
(5, 'PAM'),
(6, 'PCCNS'),
(7, 'PAM'),
(8, 'PCCNS');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requisitos`
--

CREATE TABLE IF NOT EXISTS `requisitos` (
  `codCarreraFFR` varchar(7) NOT NULL,
  `codAsignaturaFFR` varchar(7) NOT NULL,
  `codAsignarutaRequisitos` varchar(7) NOT NULL,
  PRIMARY KEY (`codCarreraFFR`,`codAsignaturaFFR`,`codAsignarutaRequisitos`),
  KEY `FK__Requisito__codAs__123EB7A3` (`codAsignarutaRequisitos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `requisitos`
--

INSERT INTO `requisitos` (`codCarreraFFR`, `codAsignaturaFFR`, `codAsignarutaRequisitos`) VALUES
('IS01', 'IN-102', 'IN-101'),
('IS01', 'MM-314', 'IS-110'),
('IS01', 'MM-201', 'MM-110'),
('IS01', 'MM-211', 'MM-110'),
('IS01', 'MM-314', 'MM-110'),
('IS01', 'MM-201', 'MM-111'),
('IS01', 'FS-100', 'MM-201'),
('IS01', 'MM-202', 'MM-201'),
('IS01', 'FS-100', 'MM-211'),
('IS01', 'IS-210', 'MM-314');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seccion`
--

CREATE TABLE IF NOT EXISTS `seccion` (
  `codSeccion` int(11) NOT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  `horaInicial` time DEFAULT NULL,
  `horaFinal` time DEFAULT NULL,
  `cupos` int(11) DEFAULT NULL,
  `codEdificioFF` int(11) DEFAULT NULL,
  `aula` varchar(20) DEFAULT NULL,
  `diaPresenciales` varchar(10) NOT NULL,
  `codCatedratico` varchar(15) DEFAULT NULL,
  `codPeriodo` int(11) DEFAULT NULL,
  `fechaPeriodo` date DEFAULT NULL,
  PRIMARY KEY (`codSeccion`,`codAsignatura`),
  KEY `FK__Seccion__6A30C649` (`aula`,`codEdificioFF`),
  KEY `FK__Seccion__codAsig__693CA210` (`codAsignatura`),
  KEY `FK__Seccion__codCate__6B24EA82` (`codCatedratico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `seccion`
--

INSERT INTO `seccion` (`codSeccion`, `codAsignatura`, `horaInicial`, `horaFinal`, `cupos`, `codEdificioFF`, `aula`, `diaPresenciales`, `codCatedratico`, `codPeriodo`, `fechaPeriodo`) VALUES
(700, 'SC-101', '07:00:00', '08:00:00', 50, 10, '105', 'LuMaMiJu', '102', 1, '2020-04-20'),
(800, 'MM-110', '08:00:00', '09:00:00', 35, 10, '203', 'LuMaMiJuVi', '102', 1, '2020-04-20'),
(1200, 'FS-100', '12:00:00', '13:00:00', 30, 10, '105', 'LuMaMiJuVi', '102', 1, '2020-04-20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seccionlab`
--

CREATE TABLE IF NOT EXISTS `seccionlab` (
  `codSeccion` int(11) NOT NULL,
  `codLab` varchar(7) NOT NULL,
  `codAsignatura` varchar(7) DEFAULT NULL,
  `horaInicial` time DEFAULT NULL,
  `horaFinal` time DEFAULT NULL,
  `cupos` int(11) DEFAULT NULL,
  `diaImparte` varchar(10) NOT NULL,
  `codEdificioFF` int(11) DEFAULT NULL,
  `codAula` varchar(20) DEFAULT NULL,
  `codInstructor` varchar(15) DEFAULT NULL,
  `codPeriodo` int(11) DEFAULT NULL,
  `fechaPeriodo` date DEFAULT NULL,
  PRIMARY KEY (`codSeccion`,`codLab`),
  KEY `FK__SeccionLab__619B8048` (`codLab`,`codAsignatura`),
  KEY `FK__SeccionLab__628FA481` (`codAula`,`codEdificioFF`),
  KEY `FK__SeccionLab__6477ECF3` (`codPeriodo`,`fechaPeriodo`),
  KEY `FK__SeccionLa__codIn__6383C8BA` (`codInstructor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `seccionlab`
--

INSERT INTO `seccionlab` (`codSeccion`, `codLab`, `codAsignatura`, `horaInicial`, `horaFinal`, `cupos`, `diaImparte`, `codEdificioFF`, `codAula`, `codInstructor`, `codPeriodo`, `fechaPeriodo`) VALUES
(1000, 'FS1LAB', 'FS-100', '10:00:00', '11:00:00', 15, 'Lu', 10, '203', '300', 1, '2020-04-20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telefonoempleado`
--

CREATE TABLE IF NOT EXISTS `telefonoempleado` (
  `codUsuario` varchar(7) NOT NULL,
  `telefono` int(11) NOT NULL,
  PRIMARY KEY (`codUsuario`,`telefono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `telefonoempleado`
--

INSERT INTO `telefonoempleado` (`codUsuario`, `telefono`) VALUES
('010', 98765432),
('020', 98643235);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telefonoestudiante`
--

CREATE TABLE IF NOT EXISTS `telefonoestudiante` (
  `codUsuario` varchar(15) NOT NULL,
  `telefono` int(11) NOT NULL,
  PRIMARY KEY (`codUsuario`,`telefono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `telefonoestudiante`
--

INSERT INTO `telefonoestudiante` (`codUsuario`, `telefono`) VALUES
('20171004244', 87654326),
('20171004244', 98463756);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignatura`
--
ALTER TABLE `asignatura`
  ADD CONSTRAINT `FK__Asignatur__codDe__4222D4EF` FOREIGN KEY (`codDepartamentoFF`) REFERENCES `departamentoscarrera` (`codDepartamento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `aula`
--
ALTER TABLE `aula`
  ADD CONSTRAINT `FK__Aula__codEdifici__145C0A3F` FOREIGN KEY (`codEdificioFF`) REFERENCES `edificio` (`codEdificio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cancelacionclase`
--
ALTER TABLE `cancelacionclase`
  ADD CONSTRAINT `FK__Cancelaci__cuent__56E8E7AB` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CancelacionClase__57DD0BE4` FOREIGN KEY (`codSeccionClase`, `codAsignatura`) REFERENCES `seccion` (`codSeccion`, `codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CancelacionClase__58D1301D` FOREIGN KEY (`codPeriodo`, `fecha`) REFERENCES `periodo` (`codPeriodo`, `fechaInicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Cancelaci__codCa__55F4C372` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cancelacionlabclase`
--
ALTER TABLE `cancelacionlabclase`
  ADD CONSTRAINT `FK__Cancelaci__cuent__5E8A0973` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CancelacionLabCl__5F7E2DAC` FOREIGN KEY (`codSeccionLab`, `codLab`) REFERENCES `seccionlab` (`codSeccion`, `codLab`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CancelacionLabCl__607251E5` FOREIGN KEY (`codPeriodo`, `fecha`) REFERENCES `periodo` (`codPeriodo`, `fechaInicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Cancelaci__codCa__5D95E53A` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `carrera`
--
ALTER TABLE `carrera`
  ADD CONSTRAINT `FK__Carrera__codRequ__74AE54BC` FOREIGN KEY (`codRequisitoExtraRequerido`) REFERENCES `requisitoextrarequerido` (`codRequisito`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Carrera__codFacu__73BA3083` FOREIGN KEY (`codFacultadFF`) REFERENCES `facultad` (`codFacultad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `carreradepartamento`
--
ALTER TABLE `carreradepartamento`
  ADD CONSTRAINT `FK__CarreraDe__codDe__7A672E12` FOREIGN KEY (`codDepartamentoFF`) REFERENCES `departamentoscarrera` (`codDepartamento`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CarreraDe__codCa__797309D9` FOREIGN KEY (`codCarreraFF`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `catedratico`
--
ALTER TABLE `catedratico`
  ADD CONSTRAINT `FK__Catedrati__codEm__46E78A0C` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `coordinadorasignatura`
--
ALTER TABLE `coordinadorasignatura`
  ADD CONSTRAINT `FK__Coordinad__codEm__5070F446` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Coordinad__codas__4F7CD00D` FOREIGN KEY (`codasignaturaFF`) REFERENCES `asignatura` (`codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Coordinad__codCa__4E88ABD4` FOREIGN KEY (`codCatedraticoFF`) REFERENCES `catedratico` (`codCatedratico`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `coordinadorcarrera`
--
ALTER TABLE `coordinadorcarrera`
  ADD CONSTRAINT `FK__Coordinad__codEm__7F2BE32F` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `coordinadorfacultad`
--
ALTER TABLE `coordinadorfacultad`
  ADD CONSTRAINT `FK__Coordinad__codEm__1DE57479` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cordinacarrera`
--
ALTER TABLE `cordinacarrera`
  ADD CONSTRAINT `FK__CordinaCa__codCa__07C12930` FOREIGN KEY (`codCarreradFF`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CordinaCarrera__06CD04F7` FOREIGN KEY (`codCoordinadorFF`, `fechaInicioCoordinador`) REFERENCES `coordinadorcarrera` (`codCoordinador`, `fechaInicioC`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cordinafacultad`
--
ALTER TABLE `cordinafacultad`
  ADD CONSTRAINT `FK__CordinaFa__codFa__2B3F6F97` FOREIGN KEY (`codFacultadFF`) REFERENCES `facultad` (`codFacultad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__CordinaFacultad__2A4B4B5E` FOREIGN KEY (`codCoordinadorFF`, `fechaInicioCoordinador`) REFERENCES `coordinadorfacultad` (`codCoordinador`, `fechaInicioC`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `correoempleado`
--
ALTER TABLE `correoempleado`
  ADD CONSTRAINT `FK__CorreoEmp__codUs__65370702` FOREIGN KEY (`codUsuario`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `correoestudiante`
--
ALTER TABLE `correoestudiante`
  ADD CONSTRAINT `FK__CorreoEst__codUs__69FBBC1F` FOREIGN KEY (`codUsuario`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `departamentojefe`
--
ALTER TABLE `departamentojefe`
  ADD CONSTRAINT `FK__Departame__codDe__3D5E1FD2` FOREIGN KEY (`codDepartamentoFF`) REFERENCES `departamentoscarrera` (`codDepartamento`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__DepartamentoJefe__3C69FB99` FOREIGN KEY (`codJefeDepartamentoFF`, `fechaInicioCargoFF`) REFERENCES `jefedepartamento` (`codJefeDepartamento`, `fechaInicioCargo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `departamentoscarrera`
--
ALTER TABLE `departamentoscarrera`
  ADD CONSTRAINT `FK__Departame__codEd__34C8D9D1` FOREIGN KEY (`codEdificioFF`) REFERENCES `edificio` (`codEdificio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `FK__Empleado__munici__1920BF5C` FOREIGN KEY (`municipioNac`) REFERENCES `municipio` (`codMunicipio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `FK__Estudiant__munic__2180FB33` FOREIGN KEY (`municipioNac`) REFERENCES `municipio` (`codMunicipio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Estudiant__codEx__208CD6FA` FOREIGN KEY (`codExtraRequerido`) REFERENCES `requisitoextrarequerido` (`codRequisito`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `facultad`
--
ALTER TABLE `facultad`
  ADD CONSTRAINT `FK__Facultad__codEdi__22AA2996` FOREIGN KEY (`codEdificioFF`) REFERENCES `edificio` (`codEdificio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `historialacademico`
--
ALTER TABLE `historialacademico`
  ADD CONSTRAINT `FK__Historial__cuent__40F9A68C` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__HistorialAcademi__3F115E1A` FOREIGN KEY (`codPeriodo`, `fechaInicioPeriodo`) REFERENCES `periodo` (`codPeriodo`, `fechaInicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__HistorialAcademi__42E1EEFE` FOREIGN KEY (`seccion`, `codAsignatura`) REFERENCES `seccion` (`codSeccion`, `codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Historial__codAs__41EDCAC5` FOREIGN KEY (`codAsignatura`) REFERENCES `asignatura` (`codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Historial__codCa__40058253` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `instructor`
--
ALTER TABLE `instructor`
  ADD CONSTRAINT `FK__Instructo__codEm__5CD6CB2B` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `jefedepartamento`
--
ALTER TABLE `jefedepartamento`
  ADD CONSTRAINT `FK__JefeDepar__codEm__300424B4` FOREIGN KEY (`codEmpleado`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `laboratorio`
--
ALTER TABLE `laboratorio`
  ADD CONSTRAINT `FK__Laborator__codAs__5812160E` FOREIGN KEY (`codAsignatura`) REFERENCES `asignatura` (`codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `matriculacarrera`
--
ALTER TABLE `matriculacarrera`
  ADD CONSTRAINT `FK__Matricula__cuent__395884C4` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Matricula__codCa__3A4CA8FD` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `matriculaclase`
--
ALTER TABLE `matriculaclase`
  ADD CONSTRAINT `FK__Matricula__cuent__489AC854` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__MatriculaClase__498EEC8D` FOREIGN KEY (`codSeccionClase`, `codAsignatura`) REFERENCES `seccion` (`codSeccion`, `codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__MatriculaClase__4A8310C6` FOREIGN KEY (`codperiodo`, `fechaPeriodo`) REFERENCES `periodo` (`codPeriodo`, `fechaInicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Matricula__codCa__47A6A41B` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `matriculalab`
--
ALTER TABLE `matriculalab`
  ADD CONSTRAINT `FK__Matricula__cuent__503BEA1C` FOREIGN KEY (`cuentaEstudiante`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__MatriculaLab__51300E55` FOREIGN KEY (`codSeccionLab`, `codLab`) REFERENCES `seccionlab` (`codSeccion`, `codLab`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Matricula__codCa__4F47C5E3` FOREIGN KEY (`codCarrera`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `modalidadcarrera`
--
ALTER TABLE `modalidadcarrera`
  ADD CONSTRAINT `FK__Modalidad__codMo__1BC821DD` FOREIGN KEY (`codModalidadFF`) REFERENCES `modalidad` (`codModalidad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Modalidad__codCa__1AD3FDA4` FOREIGN KEY (`codCarreraFF`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD CONSTRAINT `FK__Municipio__codDe__07F6335A` FOREIGN KEY (`codDeptartamentoFF`) REFERENCES `departamento` (`codDeptartamento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `planestudio`
--
ALTER TABLE `planestudio`
  ADD CONSTRAINT `FK__PlanEstud__codCa__0C85DE4D` FOREIGN KEY (`codCarreraFF`) REFERENCES `carrera` (`codCarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `prosene`
--
ALTER TABLE `prosene`
  ADD CONSTRAINT `FK__PROSENE__numeroC__339FAB6E` FOREIGN KEY (`numeroCuentaFF`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__PROSENE__codDisc__3493CFA7` FOREIGN KEY (`codDiscapacidadFF`) REFERENCES `discapacidad` (`codDiscapacidad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `representanteunah`
--
ALTER TABLE `representanteunah`
  ADD CONSTRAINT `FK__Represent__numer__2A164134` FOREIGN KEY (`numeroCuentaFF`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Represent__codAs__2B0A656D` FOREIGN KEY (`codAspectoFF`) REFERENCES `aspectorepresentativo` (`codAspecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `requisitos`
--
ALTER TABLE `requisitos`
  ADD CONSTRAINT `FK__Requisito__codAs__123EB7A3` FOREIGN KEY (`codAsignarutaRequisitos`) REFERENCES `asignatura` (`codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Requisitos__114A936A` FOREIGN KEY (`codCarreraFFR`, `codAsignaturaFFR`) REFERENCES `planestudio` (`codCarreraFF`, `codAsignaturaFF`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `seccion`
--
ALTER TABLE `seccion`
  ADD CONSTRAINT `FK__Seccion__codCate__6B24EA82` FOREIGN KEY (`codCatedratico`) REFERENCES `catedratico` (`codCatedratico`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Seccion__6A30C649` FOREIGN KEY (`aula`, `codEdificioFF`) REFERENCES `aula` (`aula`, `codEdificioFF`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__Seccion__codAsig__693CA210` FOREIGN KEY (`codAsignatura`) REFERENCES `asignatura` (`codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `seccionlab`
--
ALTER TABLE `seccionlab`
  ADD CONSTRAINT `FK__SeccionLa__codIn__6383C8BA` FOREIGN KEY (`codInstructor`) REFERENCES `instructor` (`codInstructor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__SeccionLab__619B8048` FOREIGN KEY (`codLab`, `codAsignatura`) REFERENCES `laboratorio` (`codLaboratorio`, `codAsignatura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__SeccionLab__628FA481` FOREIGN KEY (`codAula`, `codEdificioFF`) REFERENCES `aula` (`aula`, `codEdificioFF`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__SeccionLab__6477ECF3` FOREIGN KEY (`codPeriodo`, `fechaPeriodo`) REFERENCES `periodo` (`codPeriodo`, `fechaInicio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `telefonoempleado`
--
ALTER TABLE `telefonoempleado`
  ADD CONSTRAINT `FK__TelefonoE__codUs__6EC0713C` FOREIGN KEY (`codUsuario`) REFERENCES `empleado` (`codEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `telefonoestudiante`
--
ALTER TABLE `telefonoestudiante`
  ADD CONSTRAINT `FK__TelefonoE__codUs__73852659` FOREIGN KEY (`codUsuario`) REFERENCES `estudiante` (`numCuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
