-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: Registro
-- Source Schemata: Registro
-- Created: Fri May 22 18:36:01 2020
-- Workbench Version: 8.0.18
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema Registro
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `Registro` ;
CREATE SCHEMA IF NOT EXISTS `Registro` ;

-- ----------------------------------------------------------------------------
-- Table Registro.Estudiante
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Estudiante` (
  `numCuenta` VARCHAR(15) NOT NULL,
  `identidad` VARCHAR(15) NOT NULL,
  `primerNombre` VARCHAR(20) NOT NULL,
  `segundoNombre` VARCHAR(20) NULL,
  `primerApellido` VARCHAR(20) NOT NULL,
  `segundoApellido` VARCHAR(20) NULL,
  `clave` VARCHAR(15) NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `indicePAA` INT NOT NULL,
  `indiceExtraRequeridoObtenido` INT NULL,
  `estadoCuenta` DECIMAL(5,2) NULL,
  `unidadesValorativas` INT NULL,
  `codExtraRequerido` INT NULL,
  `municipioNac` INT NOT NULL,
  PRIMARY KEY (`numCuenta`),
  INDEX `IND_NOMBREESTUDIANTE` (`primerNombre` ASC, `primerApellido` ASC) VISIBLE,
  INDEX `IDX_IDENTIDAD` (`identidad` ASC) VISIBLE,
  CONSTRAINT `FK__Estudiant__codEx__02084FDA`
    FOREIGN KEY (`codExtraRequerido`)
    REFERENCES `Registro`.`RequisitoExtraRequerido` (`codRequisito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Estudiant__munic__02FC7413`
    FOREIGN KEY (`municipioNac`)
    REFERENCES `Registro`.`Municipio` (`codMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.AspectoRepresentativo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`AspectoRepresentativo` (
  `codAspecto` INT NOT NULL,
  `nombreAspecto` VARCHAR(20) NULL,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`codAspecto`));

-- ----------------------------------------------------------------------------
-- Table Registro.RepresentanteUNAH
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`RepresentanteUNAH` (
  `codAspectoFF` INT NOT NULL,
  `numeroCuentaFF` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`codAspectoFF`, `numeroCuentaFF`),
  CONSTRAINT `FK__Represent__numer__07C12930`
    FOREIGN KEY (`numeroCuentaFF`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Represent__codAs__08B54D69`
    FOREIGN KEY (`codAspectoFF`)
    REFERENCES `Registro`.`AspectoRepresentativo` (`codAspecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Discapacidad
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Discapacidad` (
  `codDiscapacidad` INT NOT NULL,
  `nombreDiscapacidad` VARCHAR(20) NULL,
  `descripcion` VARCHAR(250) NULL,
  PRIMARY KEY (`codDiscapacidad`));

-- ----------------------------------------------------------------------------
-- Table Registro.PROSENE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`PROSENE` (
  `codDiscapacidadFF` INT NOT NULL,
  `numeroCuentaFF` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`codDiscapacidadFF`, `numeroCuentaFF`),
  CONSTRAINT `FK__PROSENE__numeroC__0D7A0286`
    FOREIGN KEY (`numeroCuentaFF`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__PROSENE__codDisc__0E6E26BF`
    FOREIGN KEY (`codDiscapacidadFF`)
    REFERENCES `Registro`.`Discapacidad` (`codDiscapacidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.MatriculaCarrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`MatriculaCarrera` (
  `cuentaEstudiante` VARCHAR(15) NOT NULL,
  `codCarrera` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`cuentaEstudiante`, `codCarrera`),
  CONSTRAINT `FK__Matricula__cuent__114A936A`
    FOREIGN KEY (`cuentaEstudiante`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Matricula__codCa__123EB7A3`
    FOREIGN KEY (`codCarrera`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.HistorialAcademico
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`HistorialAcademico` (
  `codCarrera` VARCHAR(7) NOT NULL,
  `cuentaEstudiante` VARCHAR(15) NOT NULL,
  `codAsignatura` VARCHAR(7) NOT NULL,
  `seccion` INT NULL,
  `codPeriodo` INT NOT NULL,
  `fechaInicioPeriodo` DATE NOT NULL,
  `calificacion` INT NOT NULL,
  `observacion` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`codCarrera`, `cuentaEstudiante`, `codAsignatura`, `fechaInicioPeriodo`),
  CONSTRAINT `FK__HistorialAcademi__151B244E`
    FOREIGN KEY (`codPeriodo` , `fechaInicioPeriodo`)
    REFERENCES `Registro`.`Periodo` (`codPeriodo` , `fechaInicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Historial__codCa__160F4887`
    FOREIGN KEY (`codCarrera`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Historial__cuent__17036CC0`
    FOREIGN KEY (`cuentaEstudiante`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Historial__codAs__17F790F9`
    FOREIGN KEY (`codAsignatura`)
    REFERENCES `Registro`.`Asignatura` (`codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__HistorialAcademi__18EBB532`
    FOREIGN KEY (`seccion` , `codAsignatura`)
    REFERENCES `Registro`.`Seccion` (`codSeccion` , `codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.MatriculaClase
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`MatriculaClase` (
  `codCarrera` VARCHAR(7) NOT NULL,
  `cuentaEstudiante` VARCHAR(15) NOT NULL,
  `codSeccionClase` INT NOT NULL,
  `codAsignatura` VARCHAR(7) NULL,
  `fechaPeriodo` DATE NOT NULL,
  `fechaMat` DATETIME(6) NULL,
  `codperiodo` INT NULL,
  `calificacion` INT NULL,
  `espera` TINYINT(1) NULL,
  `observaciones` VARCHAR(5) NULL,
  PRIMARY KEY (`codCarrera`, `cuentaEstudiante`, `codSeccionClase`, `fechaPeriodo`),
  INDEX `IDX_MATRICULAESPERA` (`espera` ASC) VISIBLE,
  CONSTRAINT `FK__Matricula__codCa__1BC821DD`
    FOREIGN KEY (`codCarrera`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Matricula__cuent__1CBC4616`
    FOREIGN KEY (`cuentaEstudiante`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__MatriculaClase__1DB06A4F`
    FOREIGN KEY (`codSeccionClase` , `codAsignatura`)
    REFERENCES `Registro`.`Seccion` (`codSeccion` , `codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__MatriculaClase__1EA48E88`
    FOREIGN KEY (`codperiodo` , `fechaPeriodo`)
    REFERENCES `Registro`.`Periodo` (`codPeriodo` , `fechaInicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.MatriculaLab
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`MatriculaLab` (
  `codCarrera` VARCHAR(7) NOT NULL,
  `cuentaEstudiante` VARCHAR(15) NOT NULL,
  `codLab` VARCHAR(7) NOT NULL,
  `codAsignatura` VARCHAR(7) NULL,
  `codSeccionLab` INT NULL,
  PRIMARY KEY (`codCarrera`, `cuentaEstudiante`, `codLab`),
  CONSTRAINT `FK__Matricula__codCa__2180FB33`
    FOREIGN KEY (`codCarrera`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Matricula__cuent__22751F6C`
    FOREIGN KEY (`cuentaEstudiante`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__MatriculaLab__236943A5`
    FOREIGN KEY (`codSeccionLab` , `codLab`)
    REFERENCES `Registro`.`SeccionLab` (`codSeccion` , `codLab`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Departamento
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Departamento` (
  `codDeptartamento` INT NOT NULL,
  `nombreDepartamento` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`codDeptartamento`),
  UNIQUE INDEX `UQ__Departam__97ABAFF5F5C56CDA` (`nombreDepartamento` ASC) VISIBLE);

-- ----------------------------------------------------------------------------
-- Table Registro.CancelacionClase
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CancelacionClase` (
  `codCarrera` VARCHAR(7) NOT NULL,
  `cuentaEstudiante` VARCHAR(15) NOT NULL,
  `codSeccionClase` INT NOT NULL,
  `codAsignatura` VARCHAR(7) NOT NULL,
  `fecha` DATE NOT NULL,
  `codPeriodo` INT NULL,
  `descripcion` VARCHAR(30) NULL,
  PRIMARY KEY (`codCarrera`, `cuentaEstudiante`, `codSeccionClase`, `codAsignatura`, `fecha`),
  CONSTRAINT `FK__Cancelaci__codCa__2645B050`
    FOREIGN KEY (`codCarrera`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Cancelaci__cuent__2739D489`
    FOREIGN KEY (`cuentaEstudiante`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__CancelacionClase__282DF8C2`
    FOREIGN KEY (`codSeccionClase` , `codAsignatura`)
    REFERENCES `Registro`.`Seccion` (`codSeccion` , `codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__CancelacionClase__29221CFB`
    FOREIGN KEY (`codPeriodo` , `fecha`)
    REFERENCES `Registro`.`Periodo` (`codPeriodo` , `fechaInicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Municipio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Municipio` (
  `codMunicipio` INT NOT NULL,
  `nombreMunicipio` VARCHAR(30) NOT NULL,
  `codDeptartamentoFF` INT NOT NULL,
  PRIMARY KEY (`codMunicipio`),
  CONSTRAINT `FK__Municipio__codDe__276EDEB3`
    FOREIGN KEY (`codDeptartamentoFF`)
    REFERENCES `Registro`.`Departamento` (`codDeptartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Periodo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Periodo` (
  `codPeriodo` INT NOT NULL,
  `periodo` VARCHAR(20) NOT NULL,
  `observaciones` VARCHAR(20) NULL,
  `fechaInicio` DATE NOT NULL,
  `fechaFinal` DATE NOT NULL,
  `inicioAdiciones` DATE NOT NULL,
  `finalizaAdiciones` DATE NOT NULL,
  `inicioPrematricula` DATE NOT NULL,
  `finalPrematricula` DATE NOT NULL,
  `inicioMatricula` DATE NOT NULL,
  `finalMatricula` DATE NOT NULL,
  `activo` TINYINT(1) NULL,
  PRIMARY KEY (`codPeriodo`, `fechaInicio`));

-- ----------------------------------------------------------------------------
-- Table Registro.CorreoEmpleado
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CorreoEmpleado` (
  `codUsuario` VARCHAR(7) NOT NULL,
  `correo` VARCHAR(70) NOT NULL,
  `tipo` VARCHAR(15) NULL,
  PRIMARY KEY (`codUsuario`, `correo`),
  CONSTRAINT `FK__CorreoEmp__codUs__2BFE89A6`
    FOREIGN KEY (`codUsuario`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Edificio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Edificio` (
  `codEdificio` INT NOT NULL,
  `nombreEdificio` VARCHAR(30) NULL,
  PRIMARY KEY (`codEdificio`));

-- ----------------------------------------------------------------------------
-- Table Registro.Aula
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Aula` (
  `aula` VARCHAR(20) NOT NULL,
  `codEdificioFF` INT NOT NULL,
  PRIMARY KEY (`aula`, `codEdificioFF`),
  CONSTRAINT `FK__Aula__codEdifici__2E1BDC42`
    FOREIGN KEY (`codEdificioFF`)
    REFERENCES `Registro`.`Edificio` (`codEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CorreoEstudiante
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CorreoEstudiante` (
  `codUsuario` VARCHAR(15) NOT NULL,
  `correo` VARCHAR(70) NOT NULL,
  `tipo` VARCHAR(15) NULL,
  PRIMARY KEY (`codUsuario`, `correo`),
  CONSTRAINT `FK__CorreoEst__codUs__2EDAF651`
    FOREIGN KEY (`codUsuario`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Empleado
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Empleado` (
  `codEmpleado` VARCHAR(7) NOT NULL,
  `identidad` VARCHAR(15) NOT NULL,
  `primerNombre` VARCHAR(20) NOT NULL,
  `segundoNombre` VARCHAR(20) NULL,
  `apellidoMaterno` VARCHAR(20) NOT NULL,
  `apellidoPaterno` VARCHAR(20) NULL,
  `gradoAcademico` VARCHAR(50) NULL,
  `fechaNacimiento` DATE NULL,
  `municipioNac` INT NOT NULL,
  PRIMARY KEY (`codEmpleado`),
  INDEX `IDX_NOMBREEMPLEADO` (`primerNombre` ASC, `apellidoPaterno` ASC) VISIBLE,
  INDEX `IDX_IDENTIDAD` (`identidad` ASC) VISIBLE,
  CONSTRAINT `FK__Empleado__munici__30F848ED`
    FOREIGN KEY (`municipioNac`)
    REFERENCES `Registro`.`Municipio` (`codMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.TelefonoEmpleado
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`TelefonoEmpleado` (
  `codUsuario` VARCHAR(7) NOT NULL,
  `telefono` INT NOT NULL,
  PRIMARY KEY (`codUsuario`, `telefono`),
  CONSTRAINT `FK__TelefonoE__codUs__31B762FC`
    FOREIGN KEY (`codUsuario`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CoordinadorFacultad
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CoordinadorFacultad` (
  `codCoordinador` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `fechaInicioC` DATE NOT NULL,
  `fechaTerminoC` DATE NULL,
  PRIMARY KEY (`codCoordinador`, `fechaInicioC`),
  CONSTRAINT `FK__Coordinad__codEm__33D4B598`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.TelefonoEstudiante
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`TelefonoEstudiante` (
  `codUsuario` VARCHAR(15) NOT NULL,
  `telefono` INT NOT NULL,
  PRIMARY KEY (`codUsuario`, `telefono`),
  CONSTRAINT `FK__TelefonoE__codUs__3493CFA7`
    FOREIGN KEY (`codUsuario`)
    REFERENCES `Registro`.`Estudiante` (`numCuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Facultad
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Facultad` (
  `codFacultad` INT NOT NULL,
  `nombreFacultad` VARCHAR(50) NULL,
  `codCoordinadorFF` VARCHAR(15) NULL,
  `codEdificioFF` INT NULL,
  PRIMARY KEY (`codFacultad`),
  CONSTRAINT `FK__Facultad__codEdi__36B12243`
    FOREIGN KEY (`codEdificioFF`)
    REFERENCES `Registro`.`Edificio` (`codEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CordinaFacultad
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CordinaFacultad` (
  `codCoordinadorFF` VARCHAR(15) NOT NULL,
  `fechaInicioCoordinador` DATE NOT NULL,
  `codFacultadFF` INT NOT NULL,
  PRIMARY KEY (`codCoordinadorFF`, `fechaInicioCoordinador`),
  UNIQUE INDEX `UQ__CordinaF__90F04BD3157A0CBD` (`codFacultadFF` ASC) VISIBLE,
  CONSTRAINT `FK__CordinaFacultad__3A81B327`
    FOREIGN KEY (`codCoordinadorFF` , `fechaInicioCoordinador`)
    REFERENCES `Registro`.`CoordinadorFacultad` (`codCoordinador` , `fechaInicioC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__CordinaFa__codFa__3B75D760`
    FOREIGN KEY (`codFacultadFF`)
    REFERENCES `Registro`.`Facultad` (`codFacultad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.JefeDepartamento
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`JefeDepartamento` (
  `codJefeDepartamento` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `fechaInicioCargo` DATE NOT NULL,
  `fechaFinalCargo` DATE NULL,
  PRIMARY KEY (`codJefeDepartamento`, `fechaInicioCargo`),
  CONSTRAINT `FK__JefeDepar__codEm__3E52440B`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.DepartamentosCarrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`DepartamentosCarrera` (
  `codDepartamento` VARCHAR(7) NOT NULL,
  `nombreDepartamento` VARCHAR(50) NULL,
  `codEdificioFF` INT NULL,
  PRIMARY KEY (`codDepartamento`),
  CONSTRAINT `FK__Departame__codEd__412EB0B6`
    FOREIGN KEY (`codEdificioFF`)
    REFERENCES `Registro`.`Edificio` (`codEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.DepartamentoJefe
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`DepartamentoJefe` (
  `codJefeDepartamentoFF` VARCHAR(15) NOT NULL,
  `fechaInicioCargoFF` DATE NOT NULL,
  `codDepartamentoFF` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codJefeDepartamentoFF`, `fechaInicioCargoFF`),
  UNIQUE INDEX `UQ__Departam__CB568C35650E4834` (`codDepartamentoFF` ASC) VISIBLE,
  CONSTRAINT `FK__DepartamentoJefe__44FF419A`
    FOREIGN KEY (`codJefeDepartamentoFF` , `fechaInicioCargoFF`)
    REFERENCES `Registro`.`JefeDepartamento` (`codJefeDepartamento` , `fechaInicioCargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Departame__codDe__45F365D3`
    FOREIGN KEY (`codDepartamentoFF`)
    REFERENCES `Registro`.`DepartamentosCarrera` (`codDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Asignatura
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Asignatura` (
  `codAsignatura` VARCHAR(7) NOT NULL,
  `nombreAsignatura` VARCHAR(50) NOT NULL,
  `unidadesValorativas` INT NOT NULL,
  `observacion` VARCHAR(50) NULL,
  `unificada` TINYINT(1) NULL,
  `codDepartamentoFF` VARCHAR(7) NULL,
  PRIMARY KEY (`codAsignatura`),
  INDEX `IDX_NOMBREASIGNATURA` (`nombreAsignatura` ASC) VISIBLE,
  CONSTRAINT `FK__Asignatur__codDe__48CFD27E`
    FOREIGN KEY (`codDepartamentoFF`)
    REFERENCES `Registro`.`DepartamentosCarrera` (`codDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Catedratico
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Catedratico` (
  `codCatedratico` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `cantidadClases` INT NULL,
  `activo` TINYINT(1) NULL,
  PRIMARY KEY (`codCatedratico`),
  CONSTRAINT `FK__Catedrati__codEm__4BAC3F29`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CoordinadorAsignatura
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CoordinadorAsignatura` (
  `codCatedraticoFF` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `fechaInicioCargoFF` DATE NOT NULL,
  `fechaFinalCargoFF` DATE NULL,
  `codasignaturaFF` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codCatedraticoFF`, `fechaInicioCargoFF`),
  UNIQUE INDEX `UQ__Coordina__62F65DD7D877D06D` (`codasignaturaFF` ASC) VISIBLE,
  CONSTRAINT `FK__Coordinad__codCa__4F7CD00D`
    FOREIGN KEY (`codCatedraticoFF`)
    REFERENCES `Registro`.`Catedratico` (`codCatedratico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Coordinad__codas__5070F446`
    FOREIGN KEY (`codasignaturaFF`)
    REFERENCES `Registro`.`Asignatura` (`codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Coordinad__codEm__5165187F`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Laboratorio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Laboratorio` (
  `codLaboratorio` VARCHAR(7) NOT NULL,
  `codAsignatura` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codLaboratorio`, `codAsignatura`),
  UNIQUE INDEX `UQ__Laborato__5BD4F696107DDBC6` (`codAsignatura` ASC) VISIBLE,
  CONSTRAINT `FK__Laborator__codAs__5535A963`
    FOREIGN KEY (`codAsignatura`)
    REFERENCES `Registro`.`Asignatura` (`codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Instructor
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Instructor` (
  `codInstructor` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `cantLaboratorios` INT NULL,
  PRIMARY KEY (`codInstructor`),
  CONSTRAINT `FK__Instructo__codEm__5812160E`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.SeccionLab
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`SeccionLab` (
  `codSeccion` INT NOT NULL,
  `codLab` VARCHAR(7) NOT NULL,
  `codAsignatura` VARCHAR(7) NULL,
  `horaInicial` TIME(6) NULL,
  `horaFinal` TIME(6) NULL,
  `cupos` INT NULL,
  `diaImparte` VARCHAR(10) NOT NULL,
  `codEdificioFF` INT NULL,
  `codAula` VARCHAR(20) NULL,
  `codInstructor` VARCHAR(15) NULL,
  PRIMARY KEY (`codSeccion`, `codLab`),
  CONSTRAINT `FK__SeccionLab__5AEE82B9`
    FOREIGN KEY (`codLab` , `codAsignatura`)
    REFERENCES `Registro`.`Laboratorio` (`codLaboratorio` , `codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__SeccionLab__5BE2A6F2`
    FOREIGN KEY (`codAula` , `codEdificioFF`)
    REFERENCES `Registro`.`Aula` (`aula` , `codEdificioFF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__SeccionLa__codIn__5CD6CB2B`
    FOREIGN KEY (`codInstructor`)
    REFERENCES `Registro`.`Instructor` (`codInstructor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Seccion
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Seccion` (
  `codSeccion` INT NOT NULL,
  `codAsignatura` VARCHAR(7) NOT NULL,
  `horaInicial` TIME(6) NULL,
  `horaFinal` TIME(6) NULL,
  `cupos` INT NULL,
  `codEdificioFF` INT NULL,
  `aula` VARCHAR(20) NULL,
  `diaPresenciales` VARCHAR(10) NOT NULL,
  `codCatedratico` VARCHAR(15) NULL,
  PRIMARY KEY (`codSeccion`, `codAsignatura`),
  CONSTRAINT `FK__Seccion__codAsig__5FB337D6`
    FOREIGN KEY (`codAsignatura`)
    REFERENCES `Registro`.`Asignatura` (`codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Seccion__60A75C0F`
    FOREIGN KEY (`aula` , `codEdificioFF`)
    REFERENCES `Registro`.`Aula` (`aula` , `codEdificioFF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Seccion__codCate__619B8048`
    FOREIGN KEY (`codCatedratico`)
    REFERENCES `Registro`.`Catedratico` (`codCatedratico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.RequisitoExtraRequerido
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`RequisitoExtraRequerido` (
  `codRequisito` INT NOT NULL,
  `nombre` VARCHAR(10) NULL,
  PRIMARY KEY (`codRequisito`));

-- ----------------------------------------------------------------------------
-- Table Registro.Carrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Carrera` (
  `codCarrera` VARCHAR(7) NOT NULL,
  `nombreCarrera` VARCHAR(50) NOT NULL,
  `duracion` INT NOT NULL,
  `indiceRequerido` INT NULL,
  `codRequisitoExtraRequerido` INT NULL,
  `indiceExtraRequerido` INT NULL,
  `disponible` TINYINT(1) NOT NULL,
  `titulo` VARCHAR(30) NULL,
  `codFacultadFF` INT NULL,
  `cuposDisponibles` INT NULL,
  PRIMARY KEY (`codCarrera`),
  CONSTRAINT `FK__Carrera__codFacu__66603565`
    FOREIGN KEY (`codFacultadFF`)
    REFERENCES `Registro`.`Facultad` (`codFacultad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Carrera__codRequ__6754599E`
    FOREIGN KEY (`codRequisitoExtraRequerido`)
    REFERENCES `Registro`.`RequisitoExtraRequerido` (`codRequisito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CarreraDepartamento
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CarreraDepartamento` (
  `codCarreraFF` VARCHAR(7) NOT NULL,
  `codDepartamentoFF` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codCarreraFF`, `codDepartamentoFF`),
  CONSTRAINT `FK__CarreraDe__codCa__6A30C649`
    FOREIGN KEY (`codCarreraFF`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__CarreraDe__codDe__6B24EA82`
    FOREIGN KEY (`codDepartamentoFF`)
    REFERENCES `Registro`.`DepartamentosCarrera` (`codDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CoordinadorCarrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CoordinadorCarrera` (
  `codCoordinador` VARCHAR(15) NOT NULL,
  `codEmpleado` VARCHAR(7) NULL,
  `fechaInicioC` DATE NOT NULL,
  `fechaFinalC` DATE NULL,
  PRIMARY KEY (`codCoordinador`, `fechaInicioC`),
  CONSTRAINT `FK__Coordinad__codEm__6E01572D`
    FOREIGN KEY (`codEmpleado`)
    REFERENCES `Registro`.`Empleado` (`codEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.CordinaCarrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`CordinaCarrera` (
  `codCoordinadorFF` VARCHAR(15) NOT NULL,
  `fechaInicioCoordinador` DATE NOT NULL,
  `codCarreradFF` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codCoordinadorFF`, `fechaInicioCoordinador`),
  UNIQUE INDEX `UQ__CordinaC__44F857573897A35C` (`codCarreradFF` ASC) VISIBLE,
  CONSTRAINT `FK__CordinaCarrera__71D1E811`
    FOREIGN KEY (`codCoordinadorFF` , `fechaInicioCoordinador`)
    REFERENCES `Registro`.`CoordinadorCarrera` (`codCoordinador` , `fechaInicioC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__CordinaCa__codCa__72C60C4A`
    FOREIGN KEY (`codCarreradFF`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.PlanEstudio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`PlanEstudio` (
  `codCarreraFF` VARCHAR(7) NOT NULL,
  `codAsignaturaFF` VARCHAR(7) NOT NULL,
  `optativa` TINYINT(1) NULL,
  PRIMARY KEY (`codCarreraFF`, `codAsignaturaFF`),
  CONSTRAINT `FK__PlanEstud__codCa__75A278F5`
    FOREIGN KEY (`codCarreraFF`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Requisitos
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Requisitos` (
  `codCarreraFFR` VARCHAR(7) NOT NULL,
  `codAsignaturaFFR` VARCHAR(7) NOT NULL,
  `codAsignarutaRequisitos` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`codCarreraFFR`, `codAsignaturaFFR`, `codAsignarutaRequisitos`),
  CONSTRAINT `FK__Requisitos__787EE5A0`
    FOREIGN KEY (`codCarreraFFR` , `codAsignaturaFFR`)
    REFERENCES `Registro`.`PlanEstudio` (`codCarreraFF` , `codAsignaturaFF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Requisito__codAs__797309D9`
    FOREIGN KEY (`codAsignarutaRequisitos`)
    REFERENCES `Registro`.`Asignatura` (`codAsignatura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table Registro.Modalidad
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`Modalidad` (
  `codModalidad` INT NOT NULL,
  `nombre` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`codModalidad`));

-- ----------------------------------------------------------------------------
-- Table Registro.ModalidadCarrera
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Registro`.`ModalidadCarrera` (
  `codCarreraFF` VARCHAR(7) NOT NULL,
  `codModalidadFF` INT NOT NULL,
  PRIMARY KEY (`codCarreraFF`, `codModalidadFF`),
  CONSTRAINT `FK__Modalidad__codCa__7E37BEF6`
    FOREIGN KEY (`codCarreraFF`)
    REFERENCES `Registro`.`Carrera` (`codCarrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK__Modalidad__codMo__7F2BE32F`
    FOREIGN KEY (`codModalidadFF`)
    REFERENCES `Registro`.`Modalidad` (`codModalidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Trigger Registro.trFinalizePeriod
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- USE `Registro`$$
-- -- =============================================
-- -- Author:		Jorge Marin
-- -- Create date: 22/04/2020
-- -- Description: Cuando se terminen el periodo academico
-- -- se debe eliminar los registros de la tabla matricula 
-- -- y mudar los a la tabla historial academico
-- -- =============================================
-- CREATE TRIGGER [smregistro].[trFinalizePeriod]
--    ON  [smregistro].[MatriculaClase]
--    AFTER DELETE
-- AS 
-- BEGIN
-- 	DECLARE @currentDate DATE;
-- 	SET @currentDate = (SELECT GETDATE());
-- 
-- 	SET NOCOUNT ON;
-- 	
-- 	IF(CAST(@currentDate AS VARCHAR(12)) = '2020-04-22')
-- 		BEGIN
-- 			INSERT INTO Registro.smregistro.HistorialAcademico(
-- 																codCarrera,
-- 																cuentaEstudiante,
-- 																codAsignatura, 
-- 																seccion, 
-- 																codPeriodo,
-- 																fechaInicioPeriodo,
-- 																calificacion, 
-- 																observacion)
-- 																SELECT De.codCarrera, 
-- 																	   De.cuentaEstudiante,
-- 																	   De.codAsignatura,
-- 																	   codSeccionClase, 
-- 																	   codperiodo,
-- 																	   fechaPeriodo,
-- 																	   calificacion,
-- 																	   observaciones
-- 																	FROM deleted As De
-- 		END
-- END
-- ;

-- ----------------------------------------------------------------------------
-- Trigger Registro.trMatriculaAsignatura
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- USE `Registro`$$
-- -- =============================================
-- -- Author:		Jorge Marin 20171003167
-- -- Create date: 07/04/2020
-- -- Description:	Matricula Asignatura
-- -- =============================================
-- CREATE TRIGGER  [smregistro].[trMatriculaAsignatura]
--    ON  [smregistro].[MatriculaClase]
--    AFTER INSERT
-- AS 
-- BEGIN
-- 
-- 	SET NOCOUNT ON;
-- 	
-- 	DECLARE @codAsigMatriculada AS VARCHAR(7);
-- 	DECLARE @cuentaEstudiante AS VARCHAR(15);
-- 	DECLARE @codigoCarrera AS VARCHAR(7);
-- 	DECLARE @codSeccion AS INT;
-- 	DECLARE @fechaPeriodo AS DATE;
-- 	DECLARE @codPeriodo AS INT;
-- 
-- 	SELECT @codAsigMatriculada = codAsignatura,
-- 		   @cuentaEstudiante = cuentaEstudiante,
-- 		   @codigoCarrera = codCarrera,
-- 		   @codSeccion = codSeccionClase,
-- 		   @fechaPeriodo = fechaPeriodo,
-- 		   @codPeriodo = codperiodo  FROM inserted;
-- 
-- 	/*Comienzo de la Transaccion*/
-- 			BEGIN TRANSACTION
-- 				BEGIN TRY
-- 					
-- 
-- 					/*Extrae las unidades valorativas de la asignatura que desea matricular*/
-- 					DECLARE @uvAsignatura INT;
-- 					SET @uvAsignatura = (SELECT Ag.unidadesValorativas FROM Registro.smregistro.Asignatura 
-- 											AS Ag WHERE codAsignatura = @codAsigMatriculada);
-- 
-- 					/*Extrae las unidades disponibles de un estudiante.*/
-- 					DECLARE @uvDisponible INT;
-- 					SET @uvDisponible = (SELECT unidadesValorativas FROM Registro.smregistro.Estudiante 
-- 														WHERE numCuenta = @cuentaEstudiante)
-- 
-- 					/*Verifica si ya aprobo la asignatura,
-- 					por si acaso*/
-- 					DECLARE @aprobada INT;
-- 					SET @aprobada = (SELECT COUNT(DISTINCT(codAsignatura)) FROM Registro.smregistro.HistorialAcademico
-- 												WHERE codCarrera = @codigoCarrera
-- 													AND cuentaEstudiante = @cuentaEstudiante
-- 													AND codAsignatura = @codAsigMatriculada
-- 													AND calificacion >= 65);
-- 													
-- 					
-- 					/*Crea una tabla temporal de los requisitos que aun le falta a la clase 
-- 					matriculada*/
-- 					IF OBJECT_ID('tempdb.dbo.#RequisitosFaltantes', 'U') IS NOT NULL
-- 								DROP TABLE #RequisitosFaltantes; 
-- 							CREATE TABLE #RequisitosFaltantes (codAsignatura VARCHAR(7));
-- 							INSERT INTO #RequisitosFaltantes EXEC [smregistro].[spRequisitosClase] @cuentaEstudiante, @codigoCarrera, @codAsigMatriculada;
-- 							DECLARE @requisitos INT;
-- 							SET @requisitos = (SELECT COUNT(DISTINCT(codAsignatura)) FROM #RequisitosFaltantes);
-- 							
-- 
-- 					/*Extrae los cupos de la seccion a matricular, se controla 
-- 					que la seccion exista, si no existe retornara 404 y no la matriculara*/
-- 					DECLARE @cuposSeccion INT;
-- 					SET @cuposSeccion = ISNULL((SELECT Se.cupos FROM Registro.smregistro.Seccion Se 
-- 												WHERE codAsignatura = @codAsigMatriculada 
-- 												AND codSeccion = @codSeccion), 404)
-- 
-- 
-- 					/*Verifica que: 
-- 							1. El estudiante tenga unidades Valorativas Disponibles para matricular
-- 								la asignatura
-- 							2. Verifica que este matriculad@ en la carrera
-- 							3. Y que no este matriculando una asignatura que ya aprobo
-- 							4. Que exista la seccion que desea matricular*/
-- 					IF((@uvDisponible-@uvAsignatura)>=0 AND @uvDisponible IS NOT NULL AND @aprobada = 0 AND @cuposSeccion!= 404)
-- 						BEGIN
-- 							
-- 							/*Comprueba que el estudiante cumpla con los requisitos para la clase*/
-- 							IF(@requisitos=0)
-- 								BEGIN
-- 												
-- 									/*Verifica que en la seccion existan cupos, si no hay cupos disponibles 
-- 										la clase se matriculara en espera*/
-- 									
-- 									IF(@cuposSeccion>0)
-- 										BEGIN 
-- 											UPDATE Registro.smregistro.Estudiante SET unidadesValorativas = (unidadesValorativas - @uvAsignatura)
-- 												WHERE numCuenta = @cuentaEstudiante;
-- 
-- 											UPDATE Registro.smregistro.Seccion SET cupos = (cupos-1)	
-- 												WHERE codAsignatura = @codAsigMatriculada 
-- 												AND codSeccion = @codSeccion;
-- 											
-- 											/*Se ingresan los datos faltantes de la tabla matriculaclase 
-- 												para una mejor UX desde este punto*/
-- 											
-- 											UPDATE Registro.smregistro.MatriculaClase 
-- 												SET espera = 0,
-- 												fechaMat = GETDATE(),
-- 												calificacion = 0,
-- 												observaciones = 'N/D'
-- 													WHERE codCarrera = @codigoCarrera 
-- 													AND cuentaEstudiante = @cuentaEstudiante
-- 													AND codAsignatura = @codAsigMatriculada
-- 													AND codperiodo = @codPeriodo
-- 													AND fechaPeriodo = @fechaPeriodo;
-- 
-- 
-- 											PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada');
-- 										END
-- 									ELSE 
-- 										BEGIN
-- 											/*Se ingresan los datos faltantes de la tabla matriculaclase 
-- 												para una mejor UX desde este punto*/
-- 											UPDATE Registro.smregistro.MatriculaClase 
-- 											SET espera = 1,
-- 											fechaMat = GETDATE(),
-- 											calificacion = 0,
-- 											observaciones = 'N/D'
-- 												WHERE codCarrera = @codigoCarrera 
-- 												AND cuentaEstudiante = @cuentaEstudiante
-- 												AND codAsignatura = @codAsigMatriculada
-- 												AND codperiodo = @codPeriodo
-- 												AND fechaPeriodo = @fechaPeriodo;
-- 
-- 											PRINT CONCAT('La clase con Codigo', @codAsigMatriculada,' Ha sido Matriculada En Espera');
-- 										END
-- 
-- 									DECLARE @laboratorioClase INT;
-- 									SET @laboratorioClase = (SELECT COUNT(DISTINCT(codLaboratorio)) FROM Registro.smregistro.Laboratorio WHERE 
-- 									codAsignatura = @codAsigMatriculada);
-- 
-- 									/*Verifica si la clase tiene laboratorio para imprimir un mensaje que 
-- 										informe sobre la existencia del laboratorio*/
-- 									IF(@laboratorioClase=1)
-- 										BEGIN 
-- 											PRINT CONCAT('La clase ', @codAsigMatriculada,' Posee Laboratorio, Revise las Secciones Disponibles en Secciones Laboratorio')
-- 										END
-- 									ELSE 
-- 										BEGIN 
-- 											PRINT CONCAT('La clase ', @codAsigMatriculada,' No Posee Laboratorio')
-- 										END
-- 
-- 
-- 										/*Todo bien en la transaccion*/
-- 									COMMIT TRANSACTION
-- 								END    
-- 							ELSE 
-- 								BEGIN
-- 
-- 									/*
-- 										Si faltan requisitos ademas imprimira una tabla con los requisitos faltantes
-- 									*/
-- 									PRINT 'Faltan Requisitos para matricular esta asignatura';
-- 									SELECT * FROM #RequisitosFaltantes;
-- 									
-- 									ROLLBACK TRANSACTION
-- 								END	
-- 						END	
-- 					ELSE 
-- 						BEGIN
-- 							/*
-- 							Notifica algunos errores
-- 							*/
-- 							IF ((@uvDisponible-@uvAsignatura)<0)
-- 								BEGIN
-- 									PRINT 'No dispone de Unidades Valorativas para Matricular Esta Asignatura';
-- 								END
-- 
-- 							
-- 							IF (@cuposSeccion = 404)
-- 								BEGIN
-- 									PRINT CONCAT('La Seccion ', @codSeccion,' para la Asignatura ', @codAsigMatriculada, ' No Existe');
-- 								END
-- 
-- 							IF (@aprobada != 0)
-- 								BEGIN
-- 									PRINT 'Esta Asignatura ya Fue Aprobada';
-- 								END
-- 
-- 							ROLLBACK TRANSACTION
-- 					END
-- 				END TRY 
-- 
-- 				BEGIN CATCH
-- 
-- 					/*Algo malo paso, regresa todos los registros a la normalidad*/
-- 					PRINT 'Ha Ocurrido Un Error, Intente lo nuevamente';
-- 					ROLLBACK TRANSACTION 
-- 				END CATCH
-- 
-- END
-- ;
SET FOREIGN_KEY_CHECKS = 1;
