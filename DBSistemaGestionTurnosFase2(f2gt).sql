--Creacion Base de Datos
CREATE DATABASE DBSistemaGestionTurnos2;
--Usar Base de Datos
USE DBSistemaGestionTurnos2
--CREACION DE TABLAS

-- Crear tabla Estudiantes
--Esta tabla almacenará la información de los estudiantes que utilizan la sala de computadoras. 
CREATE TABLE Estudiantes (
Id_Estudiante INT PRIMARY KEY NOT NULL,
Nombre_Estudiante VARCHAR(30)NOT NULL,
Apellidos_Estudiante VARCHAR(30)NOT NULL,
Correo_Estudiante VARCHAR(100)NOT NULL,
FechaNacimiento_Estudiante DATE NOT NULL,
Telefono_Estudiante INT NOT NULL,
);

-- Crear tabla Computadoras
--Aquí se almacenará la información de las computadoras disponibles en la sala. 
CREATE TABLE Computadoras (
Id_Computadora VARCHAR(20) PRIMARY KEY NOT NULL,
Serie_Computadora VARCHAR(50) NOT NULL,
Estado_Computadora VARCHAR(20) NOT NULL--(disponible, ocupado, en mantenimiento)
); 

-- Crear tabla Turnos
--Esta tabla registrará los turnos asignados a cada estudiante para usar las computadoras.

CREATE TABLE Turnos (
Id_Turno VARCHAR(20) PRIMARY KEY NOT NULL,
Id_Estudiante INT NOT NULL,
Id_Computadora VARCHAR(20) NOT NULL,
FechayHoraInicio_Turno DATETIME NOT NULL,
FechayHoraFin_Turno DATETIME NOT NULL,
Estado_Turno VARCHAR(30) NOT NULL, --(activo, completado, cancelado)
FOREIGN KEY (Id_Estudiante) REFERENCES Estudiantes(Id_Estudiante),
FOREIGN KEY (Id_Computadora) REFERENCES Computadoras(Id_Computadora)
);


-- Crear tabla Ocupaciones
--Esta tabla registrará el historial de ocupación de las computadoras en la sala.
CREATE TABLE Ocupaciones (
Id_Ocupacion VARCHAR(20) PRIMARY KEY NOT NULL, 
Id_Estudiante INT NOT NULL,--(si está ocupada por un estudiante)
Id_Computadora VARCHAR(20) NOT NULL,
Id_Turno VARCHAR(20)NOT NULL,
FechayHoraInicio_Ocupacion DATETIME NOT NULL,
FechayHoraFin_Ocupacion DATETIME,
Duracion_Ocupacion TIME,
FOREIGN KEY (Id_Estudiante) REFERENCES Estudiantes(Id_Estudiante),
FOREIGN KEY (Id_Computadora) REFERENCES Computadoras(Id_Computadora),
FOREIGN KEY (Id_Turno) REFERENCES Turnos(Id_Turno)
);


-- Crear tabla SolicitudesSoporteTecnico
--Esta tabla registrará si se necesita solicitar soporte técnico para problemas con las computadoras.
CREATE TABLE SolicitudesSoporteTecnico (
Id_Solicitud  VARCHAR(20) PRIMARY KEY NOT NULL, 
Id_Computadora VARCHAR(20) NOT NULL,
Fecha_Solicitud DATE NOT NULL,
Descripción_Solicitud VARCHAR(50)NOT NULL,
Prioridad_Solicitud VARCHAR(50),
FOREIGN KEY (Id_Computadora) REFERENCES Computadoras(Id_Computadora)
);

-- Crear tabla Mantenimientos
--Esta tabla registrará los mantenimientos que se hacen a las computadoras de la sala
CREATE TABLE Mantenimientos (
Id_Mantenimiento  VARCHAR(20) PRIMARY KEY NOT NULL, 
Id_Computadora VARCHAR(20) NOT NULL,
Id_Solicitud  VARCHAR(20) NOT NULL,
Fecha_Mantenimiento DATE NOT NULL,
Tipo_Mantenimiento VARCHAR(50)NOT NULL,--(preventivo, correctivo, actualización de software)
Descripción_Mantenimiento VARCHAR(50)NOT NULL,
Costo_Mantenimiento INT NOT NULL,
FOREIGN KEY (Id_Computadora) REFERENCES Computadoras(Id_Computadora ),
FOREIGN KEY (Id_Solicitud) REFERENCES SolicitudesSoporteTecnico(Id_Solicitud )
);

--INSERTAR DATOS EN LAS TABLAS

/*Insertar 10 registros en la tabla Estudiantes*/
INSERT INTO Estudiantes (
Id_Estudiante, 
Nombre_Estudiante, 
Apellidos_Estudiante, 
Correo_Estudiante, 
FechaNacimiento_Estudiante, 
Telefono_Estudiante)
VALUES
(10001,'Carlos','García','carlos@gmail.com','1990-05-15',12345),
(10002,'Ana','Rodríguez','ana@gmail.com','1992-08-20',98765),
(10003,'Martin','López','martin@gmail.com','1995-03-10',55512),
(10004,'Luisa','Martínez','luisa@gmail.com','1988-11-25',11122),
(10005,'Juan','Hernández','juan@gmail.com','1997-07-01',44455),
(10006,'Laura','Sánchez','laura@gmail.com','1993-12-18',77788),
(10007,'Pedro','Gómez','pedro@gmail.com','1994-09-05',99988),
(10008,'María','Torres','maria@gmail.com','2001-06-30',12398),
(10009,'Sofía','Ramírez','sofia@gmail.com','2002-11-16',65432),
(10010,'Javier','Jiménez','javier@gmail.com','2000-02-22',33322
);
SELECT*FROM Estudiantes

/*Insertar 10 registros en la tabla Computadoras*/
INSERT INTO Computadoras (
Id_Computadora,
Serie_Computadora,
Estado_Computadora)
VALUES
('C1','AA01','Disponible'),
('C2','AA02','Disponible'),
('C3','AA03','Disponible'),
('C4','AA04','Disponible'),
('C5','AA05','Disponible'),
('C6','AA06','Mantenimiento'),
('C7','AA07','Mantenimiento'),
('C8','AA08','Disponible'),
('C9','AA09','Mantenimiento'),
('C10','AA10','Disponible'
);
SELECT*FROM Computadoras

--PARA LLENAR LAS TABLAS DE TURNOS Y OPERACIONES NECESITAMOS LOS SIGUIENTES COMANDOS:

/*Consultar qué computadoras están disponibles al momento de insertar un nuevo 
turno en la base de datos*/

SELECT c.Id_computadora, c.Estado_Computadora
FROM Computadoras c
WHERE c.Estado_Computadora = 'Disponible'
AND NOT EXISTS (
    SELECT 1
    FROM Turnos t
    WHERE t.Id_Computadora = c.Id_Computadora
    AND ((t.FechayHoraInicio_Turno < CAST('2024-03-01 10:59:00' AS DATETIME) 
	AND t.FechayHoraFin_Turno > CAST('2024-03-01 09:00:00' AS DATETIME)))
)

/*Insertar 10 registros en la tabla Turnos*/
INSERT INTO Turnos VALUES
('TUR1',10001,'C1','2024-03-01 09:00:00','2024-03-01 10:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR2',10002,'C2','2024-03-01 10:00:00','2024-03-01 11:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR3',10003,'C10','2024-03-01 09:00:00','2024-03-01 10:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR4',10004,'C5','2024-03-01 10:00:00','2024-03-01 11:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR5',10005,'C1','2024-03-01 11:00:00','2024-03-01 12:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR6',10006,'C2','2024-03-01 08:00:00','2024-03-01 09:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR7',10007,'C2','2024-03-01 12:00:00','2024-03-01 13:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR8',10008,'C1','2024-03-01 06:00:00','2024-03-01 07:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR9',10009,'C2','2024-03-01 14:00:00','2024-03-01 16:59:00','Activo')
INSERT INTO Turnos VALUES
('TUR10',10010,'C8','2024-03-01 09:00:00','2024-03-01 10:59:00','Activo')
SELECT*FROM Turnos


/*Consultar si un estudiante tiene un turno activo en la base de datos*/

SELECT * FROM Turnos
WHERE Id_Estudiante = 10010
AND Estado_Turno = 'activo';

/*Insertar 10 registros en la tabla Ocupaciones*/
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP1',10001,'C1','TUR1','2024-03-01 09:20:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP2',10002,'C2','TUR2','2024-03-01 10:05:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP3',10003,'C10','TUR3','2024-03-01 09:00:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP4',10004,'C5','TUR4','2024-03-01 10:32:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP5',10005,'C1','TUR5','2024-03-01 11:17:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP6',10006,'C2','TUR6','2024-03-01 08:05:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP7',10007,'C2','TUR7','2024-03-01 12:28:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP8',10008,'C1','TUR8','2024-03-01 06:30:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP9',10009,'C2','TUR9','2024-03-01 15:10:00')
INSERT INTO Ocupaciones (
Id_Ocupacion,Id_Estudiante,Id_Computadora,Id_Turno,FechayHoraInicio_Ocupacion)VALUES
('OCUP10',10010,'C8','TUR10','2024-03-01 09:03:00')
SELECT*FROM Ocupaciones

/*Insertar 10 registros en la tabla SolicitudesSoporteTecnico*/
INSERT INTO SolicitudesSoporteTecnico (Id_Solicitud, Id_Computadora, Fecha_Solicitud, Descripción_Solicitud, Prioridad_Solicitud)
VALUES
('SOL1', 'C9', '2024-02-28', 'La computadora no enciende', 'Alta'),
('SOL2', 'C9', '2024-02-28', 'La computadora está lenta', 'Media'),
('SOL3', 'C9', '2024-02-28', 'El monitor no muestra imagen', 'Alta'),
('SOL4', 'C9', '2024-02-28', 'Problemas de conectividad a Internet', 'Baja'),
('SOL5', 'C4', '2024-03-05', 'El teclado no funciona correctamente', 'Alta'),
('SOL6', 'C6', '2024-03-06', 'El equipo emite ruidos extraños', 'Media'),
('SOL7', 'C7', '2024-03-07', 'La impresora no imprime correctamente', 'Alta'),
('SOL8', 'C4', '2024-03-08', 'Se necesita instalar nuevo software', 'Media'),
('SOL9', 'C4', '2024-03-09', 'El sistema operativo no responde', 'Alta'),
('SOL10', 'C4', '2024-03-10', 'El equipo muestra errores al arrancar', 'Alta');
SELECT*FROM SolicitudesSoporteTecnico


/*Insertar 10 registros en la tabla Mantenimientos*/
INSERT INTO  Mantenimientos (Id_Mantenimiento, Id_Computadora,Id_Solicitud, Fecha_Mantenimiento, Tipo_Mantenimiento, Descripción_Mantenimiento, Costo_Mantenimiento)
VALUES
('MAN1', 'C9','SOL1', '2024-03-01', 'Correctivo', 'Reemplazo de disco duro', 150000),
('MAN2', 'C9','SOL2', '2024-03-02', 'Preventivo', 'Limpieza interna y mantenimiento preventivo', 80000),
('MAN3', 'C9','SOL3', '2024-03-03', 'Correctivo', 'Reparación de la tarjeta gráfica', 200000),
('MAN4', 'C9','SOL4', '2024-03-04', 'Actualización de software', 'Actualización del sistema operativo', 100000),
('MAN5', 'C4','SOL5', '2024-03-05', 'Correctivo', 'Reemplazo de teclado defectuoso', 50000),
('MAN6', 'C6','SOL6', '2024-03-06', 'Preventivo', 'Revisión y lubricación de ventiladores', 70000),
('MAN7', 'C7','SOL7', '2024-03-07', 'Correctivo', 'Reparación del alimentador de papel impresora', 120000),
('MAN8', 'C4','SOL8', '2024-03-08', 'Actualización de software', 'Instalación de nuevas aplicaciones', 90000),
('MAN9', 'C4','SOL9', '2024-03-09', 'Correctivo', 'Reemplazo de la fuente de alimentación', 80000),
('MAN10', 'C4','SOL10', '2024-03-10', 'Preventivo', 'Revisión y limpieza general del equipo', 100000);
SELECT*FROM Mantenimientos


---------------------------------------------------------------------
----------- MANIPULACIÓN DE LA BASE DE DATOS:------------
----------- FASE 2:------------
---------------------------------------------------------------------

---- trigger 1 --- 
-------------------------

-- Trigger para actualizar automáticamente el estado de la computadora después de un mantenimiento:
CREATE TRIGGER UpdateComputerStateAfterMaintenance
ON Mantenimientos
AFTER INSERT
AS
BEGIN
    UPDATE Computadoras
    SET Estado_Computadora = 'Disponible'
    FROM Computadoras c
    INNER JOIN inserted i ON c.Id_Computadora = i.Id_Computadora;
END;

-- insert para mantenimientos
INSERT INTO Mantenimientos (Id_Mantenimiento, Id_Computadora, Id_Solicitud, Fecha_Mantenimiento, Tipo_Mantenimiento, Descripción_Mantenimiento, Costo_Mantenimiento)
VALUES ('MAN2', 'C6', 'SOL16', '2024-04-09', 'Correctivo', 'Reparación de hardware', 250000);

-- insert para solicitudes de soporte --
INSERT INTO SolicitudesSoporteTecnico (Id_Solicitud, Id_Computadora, Fecha_Solicitud, Descripción_Solicitud, Prioridad_Solicitud)
VALUES ('SOL16', 'C6', '2024-04-09', 'Reparación de hardware', 'Alta');


select * from dbo.Mantenimientos
select * from Computadoras
select * from SolicitudesSoporteTecnico

---- trigger 2 --- Dani
--------------------------

-- Trigger para verificar la disponibilidad de la computadora antes de asignar un turno:
CREATE TRIGGER CheckComputadoraDisponibleAntesAsignarTurno
ON Turnos
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Computadoras c ON i.Id_Computadora = c.Id_Computadora
        WHERE c.Estado_Computadora != 'Disponible'
    )
    BEGIN
        RAISERROR ('La computadora seleccionada no está disponible en este momento.', 16, 1)
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Turnos
        SELECT * FROM inserted;
    END
END;

-- Intento de insertar un nuevo turno para una computadora disponible
INSERT INTO Turnos (Id_Turno, Id_Estudiante, Id_Computadora, FechayHoraInicio_Turno, FechayHoraFin_Turno, Estado_Turno)
VALUES ('TUR11', 10009, 'C5', '2024-04-10 10:00:00', '2024-04-10 12:00:00', 'Activo');

-- Intento de insertar un nuevo turno para una computadora no disponible
INSERT INTO Turnos (Id_Turno, Id_Estudiante, Id_Computadora, FechayHoraInicio_Turno, FechayHoraFin_Turno, Estado_Turno)
VALUES ('TUR12', 10008, 'C9', '2024-04-10 10:00:00', '2024-04-10 12:00:00', 'Activo');

select * from Turnos
select * from Computadoras

-- vista 1 -- 
-------------------------

-- Vista de Turnos Activos por Estudiante:
select * from Turnos

CREATE VIEW VistaTurnosActivos AS
SELECT 
    T.Id_Turno,
    E.Id_Estudiante,
    E.Nombre_Estudiante,
    E.Apellidos_Estudiante,
    C.Id_Computadora,
    C.Serie_Computadora,
    T.FechayHoraInicio_Turno,
    T.FechayHoraFin_Turno
FROM 
    Turnos T
INNER JOIN 
    Estudiantes E ON T.Id_Estudiante = E.Id_Estudiante
INNER JOIN 
    Computadoras C ON T.Id_Computadora = C.Id_Computadora
WHERE 
    T.Estado_Turno = 'Activo';
-- Prueba vista 1-- 
select * from VistaTurnosActivos


-- vista 2 -- Dani
-------------------------

-- Filtrar las ocupaciones que ya han comenzado
CREATE VIEW VistaOcupacionesActuales AS
SELECT *
FROM Ocupaciones
WHERE FechayHoraInicio_Ocupacion <= GETDATE();

-- prueba de vista 2 -- 
SELECT * FROM VistaOcupacionesActuales;


--Procedimiento almacenado 1 
-------------------------

-- para insertar un nuevo estudiante en la tabla Estudiantes:
CREATE PROCEDURE InsertarEstudiante
@Id_Estudiante INT,
@Nombre_Estudiante VARCHAR(30),
@Apellidos_Estudiante VARCHAR(30),
@Correo_Estudiante VARCHAR(100),
@FechaNacimiento_Estudiante DATE,
@Telefono_Estudiante INT
AS
BEGIN
INSERT INTO Estudiantes (Id_Estudiante, Nombre_Estudiante, Apellidos_Estudiante, Correo_Estudiante, FechaNacimiento_Estudiante, Telefono_Estudiante)
VALUES (@Id_Estudiante, @Nombre_Estudiante, @Apellidos_Estudiante, @Correo_Estudiante, @FechaNacimiento_Estudiante, @Telefono_Estudiante);
END;

select * from Estudiantes

-- prueba para procedimiento almacenado que ingresa un usuario. 
EXEC InsertarEstudiante 10011, 'Daniela', 'Estrada', 'Daniela@gmail.com', '1998-04-20', 566165;


--Procedimiento almacenado 2 Dani
-------------------------

-- para eliminar un estudiante en la tabla Estudiantes:
CREATE PROCEDURE EliminarEstudiante
@Id_Estudiante INT
AS
BEGIN
BEGIN TRANSACTION;
DELETE FROM Ocupaciones WHERE Id_Estudiante = @Id_Estudiante;
DELETE FROM Turnos WHERE Id_Estudiante = @Id_Estudiante;
DELETE FROM Estudiantes WHERE Id_Estudiante = @Id_Estudiante;
COMMIT TRANSACTION;
END;

-- Prueba del procedimiento para eliminar un estudiante:
EXEC EliminarEstudiante 10009;

select * from Estudiantes
select * from Turnos


-- funciones lineales 1
-------------------------
CREATE FUNCTION dbo.CalcularPromedioEdadEstudiantes()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @promedio DECIMAL(10, 2);
    
    SELECT @promedio = AVG(DATEDIFF(YEAR, FechaNacimiento_Estudiante, GETDATE()))
    FROM Estudiantes;
    
    RETURN @promedio;
END;
GO

SELECT dbo.CalcularPromedioEdadEstudiantes() AS PromedioEdadEstudiantes;
select * from Estudiantes


-- Funciónes lineales 2 Dani
-------------------------
CREATE FUNCTION ObtenerTotalEstudiantes()
RETURNS INT
AS
BEGIN
    DECLARE @total_estudiantes INT;
    SELECT @total_estudiantes = COUNT(*) FROM Estudiantes;
    RETURN @total_estudiantes;
END;
GO

SELECT dbo.ObtenerTotalEstudiantes() AS TotalEstudiantes;
select * from Estudiantes



-- Funcion escalar

CREATE FUNCTION dbo.ObtenerEdadEstudiante(@Id_Estudiante INT)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;

    SELECT @edad = DATEDIFF(YEAR, FechaNacimiento_Estudiante, GETDATE())
    FROM Estudiantes
    WHERE Id_Estudiante = @id_estudiante;

    RETURN @edad;
END;
GO

SELECT dbo.ObtenerEdadEstudiante(10011) AS EdadEstudiante;
select * from Estudiantes


-- Crear un usuario para la base de datos donde solo pueda consultar las tablas
-------------------------

-- Crear el usuario:
CREATE LOGIN Carmen WITH PASSWORD = 'Carmen123';

USE DBSistemaGestionTurnos2;

-- Asignar al usuario a la base de datos:
CREATE USER Carmen FOR LOGIN Carmen;

-- Conceder permisos de solo lectura:
GRANT SELECT TO Carmen;

drop table Computadoras
drop table Estudiantes












-----------



-- TIA: Administraci n de bases de datos  Biblioteca  -- 

-- 1. Crear un trigger que cambie el estado del ejemplar cuando se inserta un prestamo --
create trigger trg_CambiarEstadoEjemplar
on tblPrestamo
after insert
as
begin
 -- Actualizar estado de ejemplar a "Prestado" para registros prestados
    UPDATE tblEjemplar
    SET estadoEjemplar = 'Prestado'
    FROM tblEjemplar
    INNER JOIN inserted ON tblEjemplar.Cod_Material = inserted.Cod_Material
    AND tblEjemplar.Num_Ejemplar = inserted.Num_Ejemplar;
END;

-- pruebas -- 
-- Insertar un nuevo registro en TablaPrestamo
--#1
INSERT INTO tblPrestamo(Cod_Material, Num_Ejemplar, Fecha_Entrega, Fecha_Devolucion, Cedula_Usuario)
VALUES (9, 10, '2023-11-14', '2023-11-21', 1000);

--#2 para el video
INSERT INTO tblPrestamo (Cod_Material, Num_Ejemplar, Fecha_Entrega, Fecha_Devolucion, Cedula_Usuario)
VALUES (10, 11, '2024-04-11', '2024-04-18', 1001);
/*consultas */
select * from tblPrestamo
select * from tblEjemplar
select * from tblMaterial

/* Comprobar el estado del ejemplar en TablaEjemplar */
SELECT estadoEjemplar
FROM tblEjemplar
WHERE Cod_Material = 10
AND Num_Ejemplar = 11;
-- El resultado deber a ser "Prestado"


/*2. Crear un trigger que cambie del ejemplar cuando se borra un pr stamo.*/ 
CREATE TRIGGER TR_CambiarEstadoEjemplarDevolucion
ON tblPrestamo
AFTER DELETE
AS
BEGIN
  -- Actualizar el estado del ejemplar a "Disponible" para el registro eliminado
  UPDATE tblEjemplar
  SET estadoEjemplar = 'Disponible'
  FROM tblEjemplar
  INNER JOIN deleted ON tblEjemplar.Cod_Material = deleted.Cod_Material
            AND tblEjemplar.Num_Ejemplar = deleted.Num_Ejemplar;
END;

/*prueba #2 
  Insertar un nuevo registro en TablaPrestamo*/
INSERT INTO tblPrestamo (Cod_Material, Num_Ejemplar, Fecha_Entrega, Fecha_Devolucion, Cedula_Usuario)
VALUES (9, 10, '2023-11-14', '2023-11-21', 1001);

-- Eliminar el registro
DELETE FROM tblPrestamo
WHERE Cod_Material = 9
AND Num_Ejemplar = 10 and Cedula_Usuario = 1001;

select * from tblEjemplar
select * from tblPrestamo

-- Comprobar el estado del ejemplar
SELECT estadoEjemplar
FROM tblEjemplar
WHERE Cod_Material = 9
AND Num_Ejemplar = 10;

-- 3. Crear un trigger que cambie la cantidad del material cuando se inserta un pr stamo -- 
CREATE TRIGGER tr_actualizar_cantidad_material
ON tblPrestamo
AFTER INSERT
AS
BEGIN
    DECLARE @Cod_Material INT
    DECLARE @Num_Ejemplar INT

    SELECT @Cod_Material = Cod_Material, @Num_Ejemplar = Num_Ejemplar
    FROM inserted

    UPDATE tblMaterial
    SET CantidadMaterial = CantidadMaterial - 1
    WHERE Cod_material = @Cod_Material AND Cod_material = @Cod_Material
END

-- prueba 3 -- 
-- Insertar un nuevo pr stamo
INSERT INTO tblPrestamo (Fecha_Entrega, Fecha_Devolucion, Cod_Material, Num_Ejemplar, Cedula_Usuario)
VALUES (GETDATE(), '2024-05-01', 10, 11, 1001)

-- Verificar la cantidad de material antes y despu s del pr stamo
SELECT * FROM tblMaterial WHERE Cod_material = 10

-- Deber as ver que la cantidad de material se ha reducido en 1
select * from tblEjemplar
select * from tblMaterial
select * from tblPrestamo

-- 4. Crear un trigger que cambie la cantidad del material cuando se borra un pr stamo. -- 
CREATE TRIGGER tr_BorrarPrestamo
ON tblPrestamo
AFTER DELETE
AS
BEGIN
    DECLARE @Cod_Material int
    DECLARE @Num_Ejemplar int

    SELECT @Cod_Material = Cod_Material, @Num_Ejemplar = Num_Ejemplar
    FROM deleted

    UPDATE tblMaterial
    SET CantidadMaterial = CantidadMaterial + 1
    WHERE Cod_material = @Cod_Material
END
-- prueba 4 --
DELETE FROM tblPrestamo WHERE Cod_Prestamo = 8;
select * from tblPrestamo
select * from tblEjemplar
select * from tblMaterial
select * from tblDevolucion

SELECT Cod_material, Nombre_material, CantidadMaterial FROM tblMaterial WHERE Cod_material = 16;

-- 5. Crear un trigger que cambie el estado del ejemplar a disponible cuando se realice una devoluci n -- 


-- 6. Crear un trigger que evite que se actualice el campo "valor" de la tabla "material  -- 
CREATE TRIGGER tr_EvitarActualizarValor
ON tblMaterial
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- Detectar si el campo 'Valor_Material' ha sido actualizado.
    IF (SELECT COUNT(*) 
        FROM inserted i
        JOIN deleted d ON i.Cod_Material = d.Cod_Material
        WHERE i.ValorMaterial <> d.ValorMaterial) > 0
    BEGIN
        -- Revertir la transacci n para cancelar la actualizaci n
        --PRINT ('No se permite actualizar el campo Valor_Material en TablaMaterial.');
		RAISERROR ('No se permite actualizar el campo ValorMaterial en tblMaterial.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

SELECT * FROM tblMaterial

UPDATE tblMaterial
SET ValorMaterial = 90000
WHERE Nombre_material = 'Fundamentos de bases de datos';

-- 7. Crear un trigger que muestra el valor anterior y nuevo valor de los registros actualizados.
CREATE TRIGGER TR_MostrarCambiosEstadoEjemplar
ON tblEjemplar
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Old_Estado_Ejemplar NVARCHAR(30);
    DECLARE @New_Estado_Ejemplar NVARCHAR(30);

    -- Obtener el Estado_Ejemplar anterior y el nuevo Estado_Ejemplar
    SELECT @Old_Estado_Ejemplar = d.estadoEjemplar, @New_Estado_Ejemplar = i.estadoEjemplar
    FROM inserted i
    JOIN deleted d ON i.Num_Ejemplar = d.Num_Ejemplar;

    -- Mostrar los valores en la consola del servidor
    PRINT 'Estado_Ejemplar anterior: ' + @Old_Estado_Ejemplar;
    PRINT 'Nuevo Estado_Ejemplar: ' + @New_Estado_Ejemplar;
END
-- prueba 7 --
INSERT INTO tblDevolucion VALUES(GETDATE(),3)

select * from tblDevolucion

-- 8. Crear un trigger que No permita actualizar el valor del material que tenga estado prestado.
CREATE TRIGGER NoActualizarValorMaterialPrestado
ON tblMaterial
FOR UPDATE
AS
BEGIN
    -- Verificar si hay intento de actualizar el campo Valor_Material
    IF UPDATE(ValorMaterial)
    BEGIN
        -- Verificar si hay ejemplares prestados relacionados con el material
        IF EXISTS (
            SELECT 1
            FROM tblEjemplar E
            INNER JOIN inserted I ON E.Cod_Material = I.Cod_Material
            WHERE E.estadoEjemplar = 'Prestado'
        )
        BEGIN
            -- Si hay ejemplares prestados, revertir la actualizaci n del campo Valor_Material
            RAISERROR('No se puede actualizar el campo Valor_Material porque existen ejemplares prestados relacionados con este material.', 16, 1)
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    END;
END;

-- prueba 8 -- 
UPDATE tblMaterial
SET ValorMaterial = 20000
WHERE Nombre_Material = 'Fundamentos de bases de datos';

SELECT * FROM tblMaterial
SELECT * FROM tblEjemplar

-- 9. Crear un trigger que cambie el estado del usuario cuando se inserta un pr stamo.
CREATE TRIGGER tr_CambiarEstadoUsuario
ON tblPrestamo
AFTER INSERT
AS
BEGIN
    DECLARE @Cedula_Usuario int;

    SELECT @Cedula_Usuario = Cedula_Usuario
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM tblPrestamo
        WHERE Cedula_Usuario = @Cedula_Usuario
          AND Fecha_Devolucion IS NULL
    )
    BEGIN
        UPDATE tblusuario
        SET Estado_Usuario = 'Con pr stamo'
        WHERE Cedula_Usuario = @Cedula_Usuario;
    END
END;
-- prueba 9 -- 
INSERT INTO tblPrestamo (Fecha_Entrega, Fecha_Devolucion, Cod_Material, Num_Ejemplar, Cedula_Usuario)
VALUES ('2024-04-08', '2024-04-30', 11, 12, 1002);

select * from tblPrestamo

-- 10. Crear una vista que muestre los datos de los materiales con un valor mayor a 500.000
CREATE VIEW vw_MaterialesValorAlto AS
SELECT *
FROM tblMaterial
WHERE ValorMaterial >= 50000;


drop view vw_MaterialesValorAlto
-- prueba 10 -- 
SELECT *
FROM vw_MaterialesValorAlto;

-- 11. Crear una vista que muestre los datos de los materiales que tienen un precio mayor que los materiales tipo audiovisual o revista
CREATE VIEW vw_MaterialesPrecioAlto AS
SELECT *
FROM tblMaterial
WHERE ValorMaterial > (
    SELECT MAX(ValorMaterial)
    FROM tblMaterial
    WHERE CodTipo_Material IN (
        SELECT CodTipo_Material
        FROM tblTipo_Material
        WHERE NombreTipo_Material IN ('Audiovisual', 'Revistas')
    )
);

-- prueba 11 -- 
SELECT *
FROM vw_MaterialesPrecioAlto;

-- 12. Crear un procedimiento que muestre los datos de los materiales con un valor mayor que un valor dado por el usuario.
CREATE PROCEDURE sp_MaterialesPorValor
    @ValorMinimo INT
AS
BEGIN
    SELECT *
    FROM tblMaterial
    WHERE ValorMaterial > @ValorMinimo;
END;

-- prueba 12 -- 
EXEC sp_MaterialesPorValor @ValorMinimo = 50000;

--13. Crear un procedimiento que inserte un material. -- 
CREATE PROCEDURE sp_InsertarMaterial
    @NombreMaterial VARCHAR(30),
    @ValorMaterial INT,
    @A oMaterial INT,
    @CodTipoMaterial INT,
    @CantidadMaterial INT
AS
BEGIN
    INSERT INTO tblMaterial (Nombre_material, ValorMaterial, a oMaterial, CodTipo_Material, CantidadMaterial)
    VALUES (@NombreMaterial, @ValorMaterial, @A oMaterial, @CodTipoMaterial, @CantidadMaterial);
END;

-- prueba 13 -- 
EXEC sp_InsertarMaterial
    @NombreMaterial = 'NuevoMaterial',
    @ValorMaterial = 50000,
    @A oMaterial = 2012,
    @CodTipoMaterial = 1,
    @CantidadMaterial = 10; 

SELECT *
FROM tblMaterial
WHERE Nombre_material = 'NuevoMaterial';

-- 14. Crear un procedimiento que actualice los datos del material.
CREATE PROCEDURE sp_ActualizarMaterial
    @CodMaterial INT,
    @NombreMaterial VARCHAR(30),
    @ValorMaterial INT,
    @A oMaterial INT,
    @CodTipoMaterial INT,
    @CantidadMaterial INT
AS
BEGIN
    UPDATE tblMaterial
    SET Nombre_material = @NombreMaterial,
        ValorMaterial = @ValorMaterial,
        a oMaterial = @A oMaterial,
        CodTipo_Material = @CodTipoMaterial,
        CantidadMaterial = @CantidadMaterial
    WHERE Cod_material = @CodMaterial;
END;

-- prueba 14 -- 
EXEC sp_ActualizarMaterial
    @CodMaterial = 25,
    @NombreMaterial = 'ingles',
    @ValorMaterial = 50000,
    @A oMaterial = 2012,
    @CodTipoMaterial = 1,
    @CantidadMaterial = 20;

select * from tblMaterial

-- 15. Crear un procedimiento que borre un pr stamo. -- 
CREATE PROCEDURE sp_BorrarPrestamo
    @CodPrestamo INT
AS
BEGIN
    DELETE FROM tblPrestamo
    WHERE Cod_Prestamo = @CodPrestamo;
END;

-- prueba 15 -- 
EXEC sp_BorrarPrestamo @CodPrestamo = 3;
select * from tblPrestamo

-- 16. Crear una funci n que muestre los datos del material con un t tulo entrado por el usuario. -- 
CREATE FUNCTION fn_BuscarMaterialPorTitulo
(
    @TituloMaterial VARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM tblMaterial
    WHERE Nombre_material = @TituloMaterial
);

-- prueba 16 -- 
SELECT *
FROM dbo.fn_BuscarMaterialPorTitulo('ingles');

-- 17. Crear una funci n que muestre los d as de retraso despu s de la fecha de devoluci n. --
CREATE FUNCTION dbo.fn_DiasRetraso
(
    @FechaDevolucion DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @DiasRetraso INT;

    SET @DiasRetraso = DATEDIFF(DAY, @FechaDevolucion, GETDATE());

    RETURN CASE
        WHEN @DiasRetraso > 0 THEN @DiasRetraso
        ELSE 0
    END;
END; 

-- prueba 17 -- 
SELECT dbo.fn_DiasRetraso(Fecha_Devolucion) AS Dias_Retraso
FROM tblPrestamo;

-- 18. Crear una funci n escalar que muestre el m ximo valor de los materiales. -- 
CREATE FUNCTION dbo.fn_MaximoValorMaterial()
RETURNS INT
AS
BEGIN
    DECLARE @MaximoValor INT;

    SELECT @MaximoValor = MAX(ValorMaterial)
    FROM tblMaterial;

    RETURN @MaximoValor;
END;

-- prueba 18 -- 
SELECT dbo.fn_MaximoValorMaterial() AS Maximo_Valor;


-- 19. Crear un usuario para la base de datos donde solo pueda consultar las tablas. --
CREATE LOGIN Luis WITH PASSWORD = 'luis1208';
USE DBBiblioteca; -- usar la base de datos
CREATE USER Luis FOR LOGIN Luis;
GRANT SELECT ON SCHEMA::dbo TO Luis;

-- prueba 19 -- 
SELECT * FROM tblMaterial;

-- 20. Generar la documentaci n de la base de datos utilizando un programa compatible con el SQL server (DESC_DB)
--listo

select * from tblPrestamo





