USE Registro;
GO

-- =============================================
-- Author: Jorge Arturo Reyes Marin
-- Create date: 25/5/2020
-- Description:	Muestra a los estudiantes que poseen discapacidades fisicas
-- =============================================

CREATE VIEW smregistro.mostrarPROSENE AS 
    SELECT CONCAT(Es.numCuenta, ' ', Es.primerNombre, ' ',
                  Es.segundoNombre,' ', Es.primerApellido, ' ',
                  Es.segundoApellido) 'Estudiante',
                  Dis.nombreDiscapacidad  
     FROM Registro.smregistro.Estudiante Es
             INNER JOIN Registro.smregistro.PROSENE Po
             ON Es.numCuenta = Po.numeroCuentaFF
             INNER JOIN Registro.smregistro.Discapacidad Dis
             ON Po.codDiscapacidadFF = Dis.codDiscapacidad

/*
    USE Registro;
    GO
    
    SELECT * FROM smregistro.mostrarPROSENE
*/