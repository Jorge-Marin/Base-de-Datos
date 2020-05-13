USE [Registro]
GO
--Jorge, deberiamos poner como UNIQUE este campo
CREATE INDEX idx_iden ON smregistro.Estudiante(identidad)

CREATE INDEX idx_iden ON smregistro.Empleado(identidad)