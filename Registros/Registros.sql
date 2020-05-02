
--Insertar datos a las tablas
--1. DepartamentoH
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Atlántida')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Choluteca')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Colón')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Comayagua')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Copán')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Cortes')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('El Paraíso, ')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Francisco Morazán')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Gracias a Dios')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Intibucá')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Islas de la Bahía')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('La Paz')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Lempira')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Ocotepeque')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Olancho')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Santa Bárbara')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Valle')
INSERT INTO Registro.smregistro.Departamento (nombreDepartamento) 
												VALUES('Yoro')

SELECT * FROM Registro.smregistro.Departamento


--2. Municipio
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('La Ceiba',
											1)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Tela',
											1)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Jutiapa',
											1)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Apacilagua',
											2)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Concepción de María',
											2)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Duyure',
											2)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Trujillo',
											3)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Balfate',
											3)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Iriona',
											3)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Ajuterique',
											4)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Esquías',
											4)
INSERT INTO Registro.smregistro.Municipio (nombreMunicipio,
											codDeptartamentoFF) 
											VALUES('Humuya',
											4)

SELECT * FROM Registro.smregistro.Municipio

--3. Periodo
INSERT INTO Registro.smregistro.Periodo(periodo,
										observaciones,fechaInicio,
										fechaFinal,InicioAdiciones, 
										FinalizaAdiciones,
										inicioPrematricula, 
										finalPrematricula, 
										inicioMatricula, 
										finalMatricula, 
										activo) 
										VALUES ('Periodo I',
										'Periodo Corto',
										'01-20-2020',
										'03-22-2020',
										'01-30-2020', 
										'02-10-2020',
										'01-07-2020',
										'01-12-2020',
										'01-14-2020',
										'01-19-2020',
										0)

INSERT INTO Registro.smregistro.Periodo(periodo,
										observaciones,
										fechaInicio,
										fechaFinal,
										InicioAdiciones, 
										FinalizaAdiciones,
										inicioPrematricula, 
										finalPrematricula, 
										inicioMatricula, 
										finalMatricula, 
										activo) 
										VALUES ('Periodo II',
										'',
										'04-05-2020',
										'08-18-2020',
										'05-10-2020', 
										'05-18-2020',
										'03-20-2020',
										'03-25-2020',
										'03-28-2020',
										'01-02-2020',
										0)

INSERT INTO Registro.smregistro.Periodo(periodo,
										observaciones,
										fechaInicio,
										fechaFinal,
										InicioAdiciones, 
										FinalizaAdiciones,
										inicioPrematricula, 
										finalPrematricula, 
										inicioMatricula, 
										finalMatricula, 
										activo) 
										VALUES ('Periodo II',
										'',
										'05-05-2020',
										'08-18-2020',
										'05-07-2020', 
										'05-12-2020',
										'04-14-2020',
										'04-19-2020',
										'04-24-2020',
										'04-29-2020',
										1)

SELECT * FROM Registro.smregistro.Periodo

--4. edificio
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('A1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('A2')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('B1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('B2')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('C1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('C2')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('C3')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('D1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('F1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('E1')
INSERT INTO Registro.smregistro.Edificio(nombreEdificio) 
											VALUES ('Polideportivo')

SELECT * FROM Registro.smregistro.Edificio


--5. Aula
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('101',
									1)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('102',
									1)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('103',
									1)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('101',
									2)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('102',
									2)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('103',
									2)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('203',
									10)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('105',
									10)
INSERT INTO Registro.smregistro.Aula (aula
									,codEdificioFF) 
									VALUES ('305',
									9)


/*Para testeo de El Procedimiento de Espacios Disponibles*/
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('101',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('102',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('103',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('105',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('203',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('Laboratorio 2 (IS)',
										4)
INSERT INTO Registro.smregistro.Aula (aula,
										codEdificioFF) 
										VALUES ('Laboratorio 1 (IS)',
										4)
SELECT * FROM Registro.smregistro.Aula

--6.Empleados
INSERT INTO Registro.smregistro.Empleado VALUES('010',
												'0801197300675',
												'Juan',
												'Mario',
												'López',
												'Pérez',
												'Ing Sistemas',
												'01-02-1974',
												1)
INSERT INTO Registro.smregistro.Empleado VALUES('020',
												'0811197300675',
												'Jorge',
												'Arturo',
												'Marin',
												'',
												'Lic. Matemática'
												,'01-12-1984',
												2)
INSERT INTO Registro.smregistro.Empleado VALUES('030',
												'0812197300675',
												'Isaac',
												'Fernando',
												'Zavala',
												'',
												'Lic. Sociología',
												'06-02-1994',
												3)
INSERT INTO Registro.smregistro.Empleado VALUES('040',
												'0412197300675',
												'Bessy',
												'Daniela',
												'Zavala',
												'Licona',
												'Lic. Fisica',
												'02-02-1994',
												4)
INSERT INTO Registro.smregistro.Empleado VALUES('050',
												'0112197300675',
												'Marcos',
												'',
												'López',
												'',
												'Lic. Derecho',
												'04-02-1994',
												6)

SELECT * FROM Registro.smregistro.Empleado;

--7. coordFacultad
INSERT INTO Registro.smregistro.CoordinadorFacultad VALUES('001',
															'010',
															'01-02-2000',
															'')

SELECT * FROM Registro.smregistro.CoordinadorFacultad


--8. Facultad
INSERT INTO Registro.smregistro.Facultad VALUES (100,'
												Ingeniería',
												1,
												4)
INSERT INTO Registro.smregistro.Facultad VALUES (101,'
												Arquitectura',
												2,
												4)
INSERT INTO Registro.smregistro.Facultad VALUES (102,'
												Sociología',
												3,
												1)
INSERT INTO Registro.smregistro.Facultad VALUES (103,'
												Ciencias Jurídicas',4,
												2)
INSERT INTO Registro.smregistro.Facultad VALUES (104,'
												Matemática',
												5,
												9)

SELECT * FROM Registro.smregistro.Facultad


--9. CordinaFacultad Relacion 1:1
INSERT INTO Registro.smregistro.CordinaFacultad VALUES('001',
														'01-02-2000',
														100)

SELECT * FROM Registro.smregistro.CordinaFacultad


--10. JefeDepto
INSERT INTO Registro.smregistro.JefeDepartamento VALUES('100',
														'020',
														'02-03-2001',
														'')
SELECT * FROM Registro.smregistro.JefeDepartamento


--11. deptoCarrera
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('01M',
															'Matematica',
															9)
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('02IS',
															'Ingeniería en Sistemas',
															4)
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('03S',
															'Sociología',
															1)
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('01CE',
															'Ciencias Económicas',
															5)
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('01LE',
															'Lenguas Extranjeras',
															8)
INSERT INTO Registro.smregistro.DepartamentosCarrera VALUES('01FS',
															'Fisica',
															11)


SELECT * FROM Registro.smregistro.DepartamentosCarrera

--12. DeptoJefe 1:1
INSERT INTO Registro.smregistro.DepartamentoJefe VALUES('100',
														'2001-02-03',
														'01CE')

SELECT * FROM Registro.smregistro.DepartamentoJefe

--13. Asignatura 
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-110',
												  'Matematica I',
													5,
													'',
													1,
													'01M')
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-111',
												  'Geometría y Trigonometría',
												  5,
												  '',
												  1,
												  '01M')
INSERT INTO Registro.smregistro.Asignatura VALUES('SC-101',
												  'Sociologia',
												  4,
												  '',
												  0,
												  '03S')
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-201',
												  'Calculo I',
												  5,
												  '',
												  1,
												  '01M')
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-211',
												  'Vectores y Matrices',
												  3,
												  '',
												  0,
												  '01M')
INSERT INTO Registro.smregistro.Asignatura VALUES('IN-101',
												  'Inglés I',
												  4,
												  '',
												  0,
												  '01LE')
INSERT INTO Registro.smregistro.Asignatura VALUES('IS-210',
												  'Programación II',
												  5,
												  '',
												  0,
												  '02IS')
INSERT INTO Registro.smregistro.Asignatura VALUES('FS-100',
												  'Física General I',
												  5,
												  '',
												  0,
												  '01FS')
INSERT INTO Registro.smregistro.Asignatura VALUES('IS-110',
												  'Introduccion a la Ingenieria en Sistemas',
												  3,''
												  ,0
												  ,'02IS');
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-314',
												  'Programación I',
												  3,
												  '',
												  1,
												  '01M');
INSERT INTO Registro.smregistro.Asignatura VALUES('MM-202',
												  'Calculo II',
												  5,''
												  ,1,
												  '01M');
INSERT INTO Registro.smregistro.Asignatura VALUES('IN-102',
												  'Ingles II',
												  4,
												  '',
												  0,
												  '01LE');


SELECT * FROM Registro.smregistro.Asignatura


--14. Catedratico
INSERT INTO Registro.smregistro.Catedratico VALUES('102',
													'030',
													3,
													1)

SELECT * FROM Registro.smregistro.Catedratico

--15. coodinadorAsignatura 
INSERT INTO Registro.smregistro.CoordinadorAsignatura VALUES('102',
															 '040',
															 '02-03-2001',
															 '',
															 'MM-110')

SELECT * FROM Registro.smregistro.CoordinadorAsignatura


--16. Laboratorio
INSERT INTO Registro.smregistro.Laboratorio VALUES('FS1LAB',
													'FS-100')

SELECT * FROM Registro.smregistro.Laboratorio 

--17. Instructor
INSERT INTO Registro.smregistro.Instructor VALUES('300',
												  '050',
												  2)

SELECT * FROM Registro.smregistro.Instructor

--18. Seccion Clase
INSERT INTO Registro.smregistro.Seccion VALUES (0700,'SC-101','07:00:00','08:00:00',50,10,'105','LuMaMiJu','102')
INSERT INTO Registro.smregistro.Seccion VALUES (0800,'MM-110','08:00:00','09:00:00',35,10,'203','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (0900,'MM-111','09:00:00','10:00:00',35,4,'203','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (1000,'IS-110','10:00:00','11:00:00',25,4,'Laboratorio 2 (IS)','LuMaMi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (1100,'FS-100','11:00:00','12:00:00',25,10,'203','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (1200,'MM-201','12:00:00','13:00:00',25,10,'105','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (1000, 'MM-110','10:00:00','11:00:00',25,9,'305','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (1000, 'MM-110','10:00:00','11:00:00',25,9,'305','LuMaMiJuVi','102')
INSERT INTO Registro.smregistro.Seccion VALUES (0900, 'IN-102','09:00:00','13:00:00',25,1,'101','Mi','102')

SELECT * FROM Registro.smregistro.Edificio
SELECT * FROM Registro.smregistro.Aula
--19. SeccionLab
INSERT INTO Registro.smregistro.SeccionLab VALUES(1100,
												  'FS1LAB',
												  'FS-100',
												  '10:00:00',
												  '11:00:00',
												  15,
												  'Lu',
												  10,
												  '203',
												  '300')

SELECT * FROM Registro.smregistro.SeccionLab







--20. Requsitos extraRequerido para cada carrera
INSERT INTO Registro.smregistro.RequisitoExtraRequerido(nombre) 
														VALUES('PAM')
INSERT INTO Registro.smregistro.RequisitoExtraRequerido(nombre) 
														VALUES('PCCNS')



--21. Carrera
INSERT INTO Registro.smregistro.Carrera VALUES ('IS01',
												'Ingeniería en sistemas',
												5,
												1000,
												1,
												750,
												1,
												'Lic. en Sistemas',
												100,
												1000)

INSERT INTO Registro.smregistro.Carrera(codCarrera,
										nombreCarrera,
										duracion,
										indiceRequerido,
										disponible,
										titulo,
										codFacultadFF, 
										cuposDisponibles) 
										VALUES ('SC01',
										'Sociología',
										4,
										700,
										1,
										'Lic. en Sociología',
										102,
										1200)

INSERT INTO Registro.smregistro.Carrera(codCarrera,
										nombreCarrera,
										duracion,
										indiceRequerido,
										disponible,
										titulo,
										codFacultadFF, 
										cuposDisponibles) 
										VALUES ('CJ01',
										'Derecho',
										5,
										900,
										1,
										'Lic. en Derecho',
										103,
										1500)

INSERT INTO Registro.smregistro.Carrera(codCarrera,
										nombreCarrera,
										duracion,
										indiceRequerido,
										disponible,
										titulo,
										codFacultadFF, 
										cuposDisponibles) 
										VALUES ('MM01',
										'Matemática',
										4,
										800,
										1,
										'Lic. en Matemática',
										104, 
										800)

INSERT INTO Registro.smregistro.Carrera(codCarrera,
										nombreCarrera,
										duracion,
										indiceRequerido,
										disponible,
										titulo,
										codFacultadFF, 
										cuposDisponibles) 
										VALUES ('AQ01',
										'Arquitectura',
										6,
										1000,
										1,
										'Lic en Arquitectura',
										101, 
										800)

SELECT * FROM Registro.smregistro.Carrera


--22. carreradepto M:N
INSERT INTO Registro.smregistro.CarreraDepartamento VALUES ('IS01',
															'02IS')
INSERT INTO Registro.smregistro.CarreraDepartamento VALUES ('SC01',
															'03S')
INSERT INTO Registro.smregistro.CarreraDepartamento VALUES ('MM01',
															'01M')
INSERT INTO Registro.smregistro.CarreraDepartamento VALUES ('IS01',
															'01M')

SELECT * FROM Registro.smregistro.CarreraDepartamento

--23. coordinadorCarrera
INSERT INTO Registro.smregistro.CoordinadorCarrera VALUES ('001',
															'010',
															'03-02-2020',
															'')

SELECT * FROM Registro.smregistro.CoordinadorCarrera


--24. cordinaCarrera
INSERT INTO Registro.smregistro.CordinaCarrera VALUES('001',
													  '03-02-2020',
													  'AQ01')

SELECT * FROM Registro.smregistro.CordinaCarrera

--25. Plan de estudio
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'FS-100',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-110',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-201',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-211',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('CJ01',
													'IN-101',
													1)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-111',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'IN-102',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-202',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'MM-314',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'IS-110',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'IS-210',
													0)
INSERT INTO Registro.smregistro.PlanEstudio VALUES ('IS01',
													'SC-101',
													0)

SELECT * FROM Registro.smregistro.PlanEstudio

--26. Requisito
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'FS-100',
												   'MM-201')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'FS-100',
												   'MM-211')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-201',
												   'MM-110')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-201',
												   'MM-111')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-211',
												   'MM-110')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-314',
												   'MM-110')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-314',
												   'IS-110')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'MM-202',
												   'MM-201')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'IN-102',
												   'IN-101')
INSERT INTO Registro.smregistro.Requisitos VALUES ('IS01',
												   'IS-210',
												   'MM-314')

SELECT * FROM Registro.smregistro.Requisitos

--27. Modalidad
INSERT INTO Registro.smregistro.Modalidad VALUES (1,
												'Presencial')
INSERT INTO Registro.smregistro.Modalidad VALUES (2,
												'Distancia')
INSERT INTO Registro.smregistro.Modalidad VALUES (3,
												'Virtual')

SELECT * FROM Registro.smregistro.Modalidad


--28. ModalidadCarrera
INSERT INTO smregistro.ModalidadCarrera VALUES ('IS01',1)
INSERT INTO smregistro.ModalidadCarrera VALUES ('AQ01',1)
INSERT INTO smregistro.ModalidadCarrera VALUES ('CJ01',1)
INSERT INTO smregistro.ModalidadCarrera VALUES ('CJ01',2)
INSERT INTO smregistro.ModalidadCarrera VALUES ('MM01',1)
INSERT INTO smregistro.ModalidadCarrera VALUES ('MM01',2)
INSERT INTO smregistro.ModalidadCarrera VALUES ('SC01',1)

SELECT * FROM smregistro.ModalidadCarrera


--29. Estudiante
INSERT INTO smregistro.Estudiante VALUES('20171004244','0813199800412','Bessy','Daniela','Zavala','Licona','Dan_2J2','05-19-1998',1200,750,0,25,1,11)
INSERT INTO smregistro.Estudiante VALUES('20161004244','0914199800412','Jorge','Arturo','Reyes','Marin','Jor_2J6','10-19-1998',1000,850,0,25,1,10)
INSERT INTO smregistro.Estudiante VALUES('20151004244','0801199300412','Daniela','','Payan','','Dan_2J2','11-19-1998',1100,950,0,25,1,9)
INSERT INTO smregistro.Estudiante VALUES('20171504244','0814199800512','Dulce','Esperanza','Licona','Elvir','Dul_2J2','02-19-1999',800,500,0,25,1,11)
INSERT INTO smregistro.Estudiante VALUES('20161003244','0816199800452','Isaac','Fernando','Zavala','','Isaac_2J2','05-19-1999',900,900,0,25,1,8)

SELECT * FROM Registro.smregistro.Estudiante

--30. MatriculaCarrera
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20171004244',
														'IS01')
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20161004244',
														'CJ01')
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20151004244',
														'IS01')
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20171004244',
														'AQ01')
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20171504244',
														'MM01')
INSERT INTO Registro.smregistro.MatriculaCarrera VALUES('20161003244',
														'SC01')

SELECT * FROM Registro.smregistro.MatriculaCarrera


--33. MatriculaLab
INSERT INTO Registro.smregistro.MatriculaLab VALUES('AQ01','20161003244','FS1LAB','FS-100','1100')
SELECT * FROM Registro.smregistro.MatriculaLab

--34. Cancelacion Clase
INSERT INTO Registro.smregistro.CancelacionClase VALUES('AQ01','20161003244','1100','FS-100','2020-04-05',2,'problemas economicos')

--35. Correo empleados
INSERT INTO Registro.smregistro.CorreoEmpleado VALUES('010','juan29z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEmpleado VALUES('010','BJuan29z@unah.hn','Instirucional')
INSERT INTO Registro.smregistro.CorreoEmpleado VALUES('020','jorge9z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEmpleado VALUES('030','isaac29z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEmpleado VALUES('040','bessy29z@gmail.com','Personal')


--36.Correo Estudiante
INSERT INTO Registro.smregistro.CorreoEstudiante VALUES('20151004244','daniela29z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEstudiante VALUES('20161003244','isaac29z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEstudiante VALUES('20171004244','daniela29z@gmail.com','Personal')
INSERT INTO Registro.smregistro.CorreoEstudiante VALUES('20171004244','daniela29z@outlook.com','Institucional')



--37.Telefono Empleados
INSERT INTO Registro.smregistro.TelefonoEmpleado VALUES('010','98765432')
INSERT INTO Registro.smregistro.TelefonoEmpleado VALUES('020','98643235')


--38.Telefono Estudiantes

INSERT INTO Registro.smregistro.TelefonoEstudiante VALUES('20151004244','98463756')
INSERT INTO Registro.smregistro.TelefonoEstudiante VALUES('20161003244','87654326')


--Insertando en la tabla Aspectos

INSERT INTO Registro.smregistro.AspectoRepresentativo VALUES('Artisticos','Se comprende a todas aquellas 
creaciones efectuadas por el ser humano que expresan una mirada sensible respecto del mundo');
INSERT INTO Registro.smregistro.AspectoRepresentativo VALUES('Culturales','Las costumbres, las prácticas, 
las maneras de ser, los rituales, los tipos de vestimenta y las normas de comportamiento son aspectos 
incluidos en la cultura');
INSERT INTO Registro.smregistro.AspectoRepresentativo VALUES('Deportivos','Es una actividad física reglamentada, 
normalmente de carácter competitivo, que en algunos casos, mejora la condición física y psíquica de quien lo practica.');


--Insertando en la Tabla Discapacidad.
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Física','Es todo aquel tipo de limitación generada 
por la presencia de una problemática vinculada a una disminución o eliminación de capacidades motoras o físicas')
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Sensorial','Hace referencia a la existencia de limitaciones 
derivadas de la existencia de deficiencias en alguno de los sentidos que nos permiten percibir el medio sea externo o interno.')
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Intelectual','Se define como toda aquella limitación del funcionamiento 
intelectual que dificulta la participación social o el desarrollo de la autonomía o de ámbitos como el académico o el laboral,')
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Psíquica','Hablamos de discapacidad psíquica cuando estamos ante una 
situación en que se presentan alteraciones de tipo conductual y del comportamiento adaptativo')
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Visceral','Aparece en aquellas personas que padecen algún tipo de 
deficiencia en alguno de sus órganos, la cual genera limitaciones en la vida y participación en comunidad del sujeto.')
INSERT INTO Registro.smregistro.Discapacidad VALUES ('Múltiple','Este tipo de discapacidad es la que se deriva de una 
combinación de limitaciones derivadas de algunas de las anteriores deficiencias. ')

/*
	--31. HistorialAcademico
INSERT INTO Registro.smregistro.HistorialAcademico 
	VALUES('IS01','20171004244','SC-101', 0700 ,3,'2020-05-05',90,'Aprobado')
INSERT INTO Registro.smregistro.HistorialAcademico 
	VALUES('IS01','20171004244','MM-110',0800,3,'2020-05-05',80,'Aprobado')
INSERT INTO Registro.smregistro.HistorialAcademico 
	VALUES('IS01','20171004244','MM-111',0900,3,'2020-05-05',90,'Aprobado')
INSERT INTO Registro.smregistro.HistorialAcademico 
	VALUES('IS01','20171004244','IS-110',1000,3,'2020-05-05',80,'Aprobado')

SELECT * FROM Registro.smregistro.HistorialAcademico
*/