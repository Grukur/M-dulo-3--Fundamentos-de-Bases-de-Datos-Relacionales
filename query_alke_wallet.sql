-- Creación de la tabla `Usuario`
CREATE TABLE `Usuario` (
  `user_id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `contraseña` VARCHAR(45) NOT NULL,
  `saldo` INT NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE = InnoDB;

-- Creación de la tabla `Moneda`
CREATE TABLE `Moneda` (
  `currency_id` INT NOT NULL,
  `currency_name` VARCHAR(45) NOT NULL,
  `currency_symbol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`currency_id`)
) ENGINE = InnoDB;

-- Creación de la tabla `Transaction`
CREATE TABLE `Transaction` (
  `transaction_id` INT NOT NULL,
  `importe` INT NOT NULL,
  `transaction_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `sender_user_id` INT NOT NULL,
  `receiver_user_id` INT NOT NULL,
  `moneda_id` INT NOT NULL,
  PRIMARY KEY (`transaction_id`),
  INDEX `fk_Transaction_Usuario_idx` (`sender_user_id`, `receiver_user_id`) VISIBLE,
  CONSTRAINT `fk_Transaction_Usuario`
    FOREIGN KEY (`sender_user_id`)
    REFERENCES `Usuario` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaction_Usuario2`
    FOREIGN KEY (`receiver_user_id`)
    REFERENCES `Usuario` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaction_Moneda`
    FOREIGN KEY (`moneda_id`)
    REFERENCES `Moneda` (`currency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Ingresando datos para el desarrollo del caso
INSERT INTO `Usuario` (`user_id`, `nombre`, `email`, `contraseña`, `saldo`)
VALUES (1, 'Usuario1', 'usuario1@example.com', 'contraseña1', 100),
       (2, 'Usuario2', 'usuario2@example.com', 'contraseña2', 200);

INSERT INTO `Moneda` (`currency_id`, `currency_name`, `currency_symbol`)
VALUES (1, 'Dólar', 'USD'),
       (2, 'Euro', 'EUR');
       
INSERT INTO `Transaction` (`transaction_id`, `importe`, `sender_user_id`, `receiver_user_id`, `moneda_id`)
VALUES (1, 50, 1, 2, 1),
       (2, 100, 2, 1, 2),
       (3, 150, 1, 2, 2);
       
-- Consulta para obtener el nombre de la moneda elegida por un usuario específico:
SELECT u.nombre AS usuario, m.currency_name AS moneda
FROM `Usuario` u
JOIN `Transaction` t ON u.user_id = t.sender_user_id
JOIN `Moneda` m ON t.moneda_id = m.currency_id
WHERE u.user_id = 1;

-- Consulta para obtener todas las transacciones registradas:
SELECT t.transaction_id, m.currency_name AS moneda, t.importe, t.transaction_date, u1.nombre AS sender, u2.nombre AS receiver
FROM `Transaction` t
JOIN `Usuario` u1 ON t.sender_user_id = u1.user_id
JOIN `Usuario` u2 ON t.receiver_user_id = u2.user_id
JOIN `Moneda` m ON t.moneda_id = m.currency_id;

-- Consulta para obtener todas las transacciones realizadas por un usuario específico:
SELECT t.transaction_id, t.importe, t.transaction_date, u1.nombre AS sender, u2.nombre AS receiver
FROM `Transaction` t
JOIN `Usuario` u1 ON t.sender_user_id = u1.user_id
JOIN `Usuario` u2 ON t.receiver_user_id = u2.user_id
WHERE u1.user_id = 1;

-- Sentencia DML para modificar el campo correo electrónico de un usuario específico:
UPDATE `Usuario`
SET email = 'nuevo_correo@example.com'
WHERE user_id = 1;

SELECT * FROM `Usuario`;

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa):
DELETE FROM `Transaction`
WHERE transaction_id = 1;

SELECT * FROM `Transaction`;

-- limpieza de tablas:
DELETE FROM `transaction`;
DELETE FROM `usuario`;
DELETE FROM `moneda`;

