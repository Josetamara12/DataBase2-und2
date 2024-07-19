CREATE DATABASE BD_Brigadas;
USE BD_Brigadas;

-- Se crean las tablas --

CREATE TABLE proyecto (
    cod_proy INT,
    nom_proy VARCHAR(50),
    ciudad VARCHAR(50),
    PRIMARY KEY(cod_proy)
	ALTER TABLE proyecto
ADD cantidad_brigadas INT DEFAULT 0;
);
select * from proyecto

CREATE TABLE brigada (
    cod_bri INT,
    nom_bri VARCHAR(50),
    cod_proy INT,
    PRIMARY KEY(cod_bri),
    FOREIGN KEY(cod_proy) REFERENCES proyecto(cod_proy)
);

CREATE TABLE medicamento (
    cod_med INT,
    nom_med VARCHAR(50),
    forma_uso VARCHAR(50),
    cantidad INT,
    valor INT,
    PRIMARY KEY(cod_med)
);

CREATE TABLE empleado (
    cedula INT,
    nom_emp VARCHAR(50),
    telefono VARCHAR(50),
    salario INT,
    bonificacion INT,
    PRIMARY KEY(cedula)
);

CREATE TABLE participa (
    cod_bri INT,
    cedula INT,
    fecha DATETIME,
    PRIMARY KEY(cod_bri, cedula),
    FOREIGN KEY(cod_bri) REFERENCES brigada(cod_bri),
    FOREIGN KEY(cedula) REFERENCES empleado(cedula)
);

CREATE TABLE bri_med (
    cod_bri INT,
    cod_med INT,
    canti_utilizada INT,
    PRIMARY KEY(cod_bri, cod_med),
    FOREIGN KEY(cod_bri) REFERENCES brigada(cod_bri),
    FOREIGN KEY(cod_med) REFERENCES medicamento(cod_med)
);

-- se insertan los datos en las tablas -- 

-- Inserciones para la tabla proyecto
INSERT INTO proyecto (cod_proy, nom_proy, ciudad) VALUES (200, 'Marina', 'Cartagena');
INSERT INTO proyecto (cod_proy, nom_proy, ciudad) VALUES (201, 'Aerea', 'Bogota');
INSERT INTO proyecto (cod_proy, nom_proy, ciudad) VALUES (202, 'Militar', 'Medellin');
-- Agrega más inserciones según sea necesario

-- Inserciones para la tabla brigada
INSERT INTO brigada (cod_bri, nom_bri, cod_proy) VALUES (301, 'osteoporosis', 200);
INSERT INTO brigada (cod_bri, nom_bri, cod_proy) VALUES (302, 'asma', 201);
INSERT INTO brigada (cod_bri, nom_bri, cod_proy) VALUES (303, 'neumonia', 200);
-- Agrega más inserciones según sea necesario


-- Inserciones para la tabla medicamento
INSERT INTO medicamento (cod_med, nom_med, forma_uso, cantidad, valor) VALUES (009, 'contac', 'jarabe', 6, 2000);
INSERT INTO medicamento (cod_med, nom_med, forma_uso, cantidad, valor) VALUES (001, 'salbumex', 'jarabe', 6, 2000);
INSERT INTO medicamento (cod_med, nom_med, forma_uso, cantidad, valor) VALUES (002, 'bifosfonato', 'pastilla', 9, 10000);
INSERT INTO medicamento (cod_med, nom_med, forma_uso, cantidad, valor) VALUES (003, 'omega3', 'pastilla', 7, 200020);
-- Agrega más inserciones según sea necesario

-- Inserciones para la tabla empleado
INSERT INTO empleado (cedula, nom_emp, telefono, salario, bonificacion) VALUES (100, 'Raul', '311', 2000000, 110000);
INSERT INTO empleado (cedula, nom_emp, telefono, salario, bonificacion) VALUES (101, 'Andres', '312', 3000000, 2100000);
INSERT INTO empleado (cedula, nom_emp, telefono, salario, bonificacion) VALUES (102, 'Luis', '313', 4000000, 101000);
-- Agrega más inserciones según sea necesario


-- Inserciones para la tabla participa
INSERT INTO participa (cod_bri, cedula, fecha) VALUES (301, 100, '2024-04-01 08:00:00');
INSERT INTO participa (cod_bri, cedula, fecha) VALUES (302, 101, '2024-04-01 08:00:00');
INSERT INTO participa (cod_bri, cedula, fecha) VALUES (303, 102, '2024-04-02 08:00:00');
-- Agrega más inserciones según sea necesario

-- Inserciones para la tabla bri_med
INSERT INTO bri_med (cod_bri, cod_med, canti_utilizada) VALUES (301, 001, 204);
INSERT INTO bri_med (cod_bri, cod_med, canti_utilizada) VALUES (302, 003, 2);
INSERT INTO bri_med (cod_bri, cod_med, canti_utilizada) VALUES (303, 002, 205);
-- Agrega más inserciones según sea necesario


-- TRIGGER - ejercicio1 --
CREATE TRIGGER tr_actualiza_bonificacion
ON participa
FOR UPDATE
AS
BEGIN 

    DECLARE @cod_bri INT;
    DECLARE @cedula INT;
    DECLARE @canti_utilizada INT;
    DECLARE @valor_medicamento INT;
    DECLARE @bonificacion_empleado INT;
    DECLARE @nueva_bonificacion INT;
 
    SELECT @cod_bri = cod_bri, @cedula = cedula
    FROM inserted;

	SELECT @canti_utilizada = canti_utilizada
    FROM bri_med
    WHERE cod_bri = @cod_bri;

    SELECT @valor_medicamento = valor
    FROM medicamento
    WHERE cod_med IN (SELECT cod_med FROM bri_med WHERE cod_bri = @cod_bri);

    SELECT @bonificacion_empleado = bonificacion
    FROM empleado
    WHERE cedula = @cedula;

    SET @nueva_bonificacion = @bonificacion_empleado + (0.15 * @valor_medicamento * @canti_utilizada);

    UPDATE empleado
    SET bonificacion = @nueva_bonificacion
    WHERE cedula = @cedula;
END;

-- pruebas del trigger 1 --
SELECT * FROM empleado WHERE cedula = 100;
SELECT * FROM participa
UPDATE participa SET fecha = '2024-04-05 09:00:00' WHERE cod_bri = 303 AND cedula = 102;
SELECT bonificacion FROM empleado WHERE cedula = 100;

-- TRIGGER - ejercicio2 --
CREATE TRIGGER tr_actualiza_cantidad_brigadas
ON brigada
AFTER INSERT
AS
BEGIN
    DECLARE @cod_proy INT;

    -- Obtener el código del proyecto de la brigada insertada --
    SELECT @cod_proy = cod_proy
    FROM inserted;

    -- Actualizar la cantidad de brigadas en el proyecto --
    UPDATE proyecto
    SET cantidad_brigadas = cantidad_brigadas + 1
    WHERE cod_proy = @cod_proy;
END;
-- pruebas del trigger 2 --
SELECT * FROM proyecto;
select * from brigada
INSERT INTO brigada (cod_bri, nom_bri, cod_proy) VALUES (304, 'bronquitis', 200);



-- TRIGGER - ejercicio3 --
CREATE TRIGGER tr_control_cantidad_medicamento
ON bri_med
AFTER DELETE
AS
BEGIN
	DECLARE @cod_med INT;
	DECLARE @canti_utilizada INT;
    
	-- Obtener el código del medicamento y la cantidad utilizada que se está borrando --
	SELECT @cod_med = cod_med, @canti_utilizada = canti_utilizada
	FROM deleted;

	-- Actualizar la cantidad del medicamento en la tabla medicamento --
	UPDATE medicamento
	SET cantidad = cantidad + @canti_utilizada
	WHERE cod_med = @cod_med;
	END;

-- pruebas del trigger 3 --
-- Eliminar un registro de bri_med para activar el trigger
DELETE FROM bri_med WHERE cod_med = 003;
DELETE FROM bri_med WHERE cod_med = 002;

-- Verificar los resultados
SELECT * FROM medicamento;
select * from bri_med;

-- Vistas ejercicio 1 --
CREATE VIEW v_medicamento_actualizable
AS
SELECT medicamento.*
FROM medicamento
WHERE valor > 50000;

-- pruebas vista 1 -- 
SELECT * FROM v_medicamento_actualizable;
INSERT INTO medicamento (cod_med, nom_med, forma_uso, cantidad, valor) VALUES (004, 'medicamento_costoso', 'pastilla', 10, 75000);

-- Vistas ejercicio 2 --
CREATE VIEW v_empleadoCondicion
AS
SELECT empleado.*, 
       salario+(salario*0.1) AS salarioAunmento, 
       bonificacion+(bonificacion*0.1) AS bonificacionAumento
FROM empleado 
INNER JOIN participa ON empleado.cedula = participa.cedula
WHERE salario BETWEEN 600000 AND 2000000
GROUP BY participa.cedula, empleado.cedula, empleado.bonificacion, empleado.nom_emp, empleado.salario, empleado.telefono
HAVING COUNT(*) > 2;

-- pruebas vista 2 -- 
SELECT * FROM empleado;
UPDATE participa SET fecha = '2024-04-01 08:00:00' WHERE cod_bri = 301 AND cedula = 100;
UPDATE participa SET fecha = '2024-04-01 08:00:00' WHERE cod_bri = 302 AND cedula = 100;
UPDATE participa SET fecha = '2024-04-02 08:00:00' WHERE cod_bri = 303 AND cedula = 100;

SELECT * FROM v_empleadoCondicion;
SELECT * FROM empleado WHERE salario BETWEEN 600000 AND 2000000;
select * from brigada
select * from participa

SELECT cedula, COUNT(*) AS cantidad_brigadas
FROM participa
GROUP BY cedula
HAVING COUNT(*) > 2;

-- Insertar 1 registros adicionales para el empleado con cédula 100
INSERT INTO participa (cod_bri, cedula, fecha) VALUES 
(304, 100, '2024-04-03 08:00:00')

-- Procedimientos almacenados  Ejercicio 1 -- 
CREATE PROCEDURE Pr_Promedio
    @val1 INT,
    @val2 INT,
    @total INT
AS
BEGIN
    SELECT medicamento.*
    FROM medicamento
    WHERE medicamento.cantidad BETWEEN @val1 AND @val2
    GROUP BY medicamento.cod_med, medicamento.nom_med, medicamento.forma_uso, medicamento.valor, medicamento.cantidad
    HAVING AVG(medicamento.valor) > @total;
END;

-- pruebas Procedimientos almacenados 1 -- 
EXEC Pr_Promedio 15, 21, 20000;
SELECT * FROM medicamento WHERE cantidad BETWEEN 15 AND 21;
SELECT AVG(valor) AS valor_promedio FROM medicamento WHERE cantidad BETWEEN 15 AND 21;

-- Procedimientos almacenados  Ejercicio 2 -- 
CREATE PROCEDURE Pr_Mostrar_Med
    @Valor INT,
    @Valorusu INT
AS
BEGIN
    SELECT medicamento.*, SUM(bri_med.canti_utilizada) AS total_utilizado
    FROM medicamento
    INNER JOIN bri_med ON medicamento.cod_med = bri_med.cod_med
    WHERE medicamento.cod_med = @Valorusu
    GROUP BY medicamento.cod_med, medicamento.nom_med, medicamento.forma_uso, medicamento.cantidad, medicamento.valor
    HAVING SUM(bri_med.canti_utilizada) > @Valor;
END;

-- pruebas Procedimientos almacenados 2 -- 
EXEC Pr_Mostrar_Med 001, 500;

-- Funciones Ejercicio -- 
CREATE FUNCTION F_Brigadas
(
    @Fechai DATETIME,
    @Fechaf DATETIME,
    @Valor INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT brigada.*
    FROM Participa
    INNER JOIN brigada ON participa.cod_bri = brigada.cod_bri
    INNER JOIN Bri_med ON brigada.cod_bri = Bri_med.cod_bri
    WHERE Participa.fecha BETWEEN @Fechai AND @Fechaf
    GROUP BY brigada.cod_bri, brigada.nom_bri, brigada.cod_proy
    HAVING SUM(Bri_med.canti_utilizada) > @Valor
);

-- pruebas Funciones -- 
SELECT * FROM F_Brigadas('2010-07-12', '2012-10-01', 501);


