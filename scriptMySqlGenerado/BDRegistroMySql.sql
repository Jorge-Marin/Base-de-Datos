--
-- Base de datos: `registro`
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
-- Estructura de tabla para la tabla `carreradepartamento`
--

CREATE TABLE IF NOT EXISTS `carreradepartamento` (
  `codCarreraFF` varchar(7) NOT NULL,
  `codDepartamentoFF` varchar(7) NOT NULL,
  PRIMARY KEY (`codCarreraFF`,`codDepartamentoFF`),
  KEY `FK__CarreraDe__codDe__7A672E12` (`codDepartamentoFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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
-- Estructura de tabla para la tabla `correoempleado`
--

CREATE TABLE IF NOT EXISTS `correoempleado` (
  `codUsuario` varchar(7) NOT NULL,
  `correo` varchar(70) NOT NULL,
  `tipo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`codUsuario`,`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE IF NOT EXISTS `departamento` (
  `codDeptartamento` int(11) NOT NULL,
  `nombreDepartamento` varchar(30) NOT NULL,
  PRIMARY KEY (`codDeptartamento`),
  UNIQUE KEY `UQ__Departam__97ABAFF5023D5A04` (`nombreDepartamento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `laboratorio`
--

CREATE TABLE IF NOT EXISTS `laboratorio` (
  `codLaboratorio` varchar(7) NOT NULL,
  `codAsignatura` varchar(7) NOT NULL,
  PRIMARY KEY (`codLaboratorio`,`codAsignatura`),
  UNIQUE KEY `UQ__Laborato__5BD4F6965629CD9C` (`codAsignatura`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `modalidad`
--

CREATE TABLE IF NOT EXISTS `modalidad` (
  `codModalidad` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`codModalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `planestudio`
--

CREATE TABLE IF NOT EXISTS `planestudio` (
  `codCarreraFF` varchar(7) NOT NULL,
  `codAsignaturaFF` varchar(7) NOT NULL,
  `optativa` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`codCarreraFF`,`codAsignaturaFF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `telefonoempleado`
--

CREATE TABLE IF NOT EXISTS `telefonoempleado` (
  `codUsuario` varchar(7) NOT NULL,
  `telefono` int(11) NOT NULL,
  PRIMARY KEY (`codUsuario`,`telefono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Estructura de tabla para la tabla `telefonoestudiante`
--

CREATE TABLE IF NOT EXISTS `telefonoestudiante` (
  `codUsuario` varchar(15) NOT NULL,
  `telefono` int(11) NOT NULL,
  PRIMARY KEY (`codUsuario`,`telefono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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

