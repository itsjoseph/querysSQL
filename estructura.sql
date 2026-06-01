/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `Adeudos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Adeudos` (
  `id_adeudo` varchar(50) NOT NULL,
  `id_venta_origen` varchar(50) DEFAULT NULL,
  `tipo_origen` varchar(20) NOT NULL DEFAULT 'VENTA',
  `id_cliente` varchar(50) NOT NULL,
  `monto_inicial` decimal(10,2) NOT NULL,
  `saldo_pendiente` decimal(10,2) NOT NULL,
  `fecha_origen` datetime DEFAULT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `estado_adeudo` varchar(20) NOT NULL DEFAULT 'ABIERTO',
  `notas` text DEFAULT NULL,
  PRIMARY KEY (`id_adeudo`),
  KEY `fk_adeudo_venta` (`id_venta_origen`),
  KEY `fk_adeudo_cliente` (`id_cliente`),
  KEY `idx_adeudos_cliente_fifo` (`id_cliente`,`fecha_origen`),
  KEY `fk_adeudo_estado` (`estado_adeudo`),
  KEY `fk_adeudo_tipo_origen` (`tipo_origen`),
  CONSTRAINT `fk_adeudo_estado` FOREIGN KEY (`estado_adeudo`) REFERENCES `EstadoAdeudo` (`codigo`),
  CONSTRAINT `fk_adeudo_tipo_origen` FOREIGN KEY (`tipo_origen`) REFERENCES `TipoOrigenAdeudo` (`codigo`),
  CONSTRAINT `fk_adeudos_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_adeudos_venta` FOREIGN KEY (`id_venta_origen`) REFERENCES `Ventas` (`id_venta`),
  CONSTRAINT `chk_adeudo_venta_required` CHECK (`tipo_origen` = 'VENTA' and `id_venta_origen` is not null or `tipo_origen` <> 'VENTA')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`conor`@`localhost`*/ /*!50003 TRIGGER tr_acumular_deuda
AFTER INSERT ON Adeudos
FOR EACH ROW
BEGIN
  UPDATE Clientes
  SET saldo_pendiente_total = saldo_pendiente_total + NEW.monto_inicial
  WHERE id_cliente = NEW.id_cliente;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP TABLE IF EXISTS `Auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auditoria` (
  `id_auditoria` bigint(20) NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario` varchar(50) DEFAULT NULL,
  `accion` varchar(50) NOT NULL,
  `entidad` varchar(50) DEFAULT NULL,
  `entidad_id` varchar(64) DEFAULT NULL,
  `detalles` varchar(1000) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_fecha` (`fecha`),
  KEY `idx_auditoria_usuario_fecha` (`usuario`,`fecha`),
  KEY `idx_auditoria_accion` (`accion`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `id_cliente` varchar(50) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido_paterno` varchar(50) DEFAULT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `telefono_principal` varchar(20) NOT NULL,
  `correo_electronico` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `estatus` varchar(20) DEFAULT 'ACTIVO',
  `saldo_pendiente_total` decimal(10,2) DEFAULT 0.00,
  `fecha_alta` datetime DEFAULT NULL,
  `usuario_asignado` varchar(255) NOT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_clientes_usuario_asignado` (`usuario_asignado`),
  KEY `fk_cliente_estatus` (`estatus`),
  CONSTRAINT `fk_cliente_estatus` FOREIGN KEY (`estatus`) REFERENCES `EstadoCliente` (`codigo`),
  CONSTRAINT `fk_clientes_usuario_asignado` FOREIGN KEY (`usuario_asignado`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `EstadoAdeudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EstadoAdeudo` (
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `es_terminal` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `EstadoCliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EstadoCliente` (
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `severidad` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `MetodoPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MetodoPago` (
  `id_metodo_pago` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_metodo_pago`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pagos` (
  `id_pago` varchar(50) NOT NULL,
  `fecha_pago` datetime DEFAULT NULL,
  `monto_pagado` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `notas` text DEFAULT NULL,
  `id_cliente` varchar(50) NOT NULL,
  `usuario_cobrador` varchar(255) NOT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `fk_pagos_cliente` (`id_cliente`),
  KEY `fk_pagos_metodo_pago` (`metodo_pago`),
  KEY `fk_pagos_usuario_cobrador` (`usuario_cobrador`),
  CONSTRAINT `fk_pagos_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_pagos_metodo_pago` FOREIGN KEY (`metodo_pago`) REFERENCES `MetodoPago` (`codigo`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pagos_usuario_cobrador` FOREIGN KEY (`usuario_cobrador`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`conor`@`localhost`*/ /*!50003 TRIGGER actualizarSaldoDespuesPago
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
  DECLARE saldo_actual DECIMAL(10,2);

  -- Obtener el saldo pendiente actual del cliente
  SELECT saldo_pendiente_total INTO saldo_actual
  FROM Clientes
  WHERE id_cliente = NEW.id_cliente;

  -- Solo actualizar si el saldo es mayor que 0
  IF saldo_actual > 0 AND NEW.monto_pagado <= saldo_actual THEN
    UPDATE Clientes
    SET saldo_pendiente_total = saldo_pendiente_total - NEW.monto_pagado
    WHERE id_cliente = NEW.id_cliente;
  END IF;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP TABLE IF EXISTS `PagosAplicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PagosAplicaciones` (
  `id_aplicacion` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pago` varchar(50) NOT NULL,
  `id_adeudo` varchar(50) NOT NULL,
  `monto_aplicado` decimal(10,2) NOT NULL,
  `fecha_aplicacion` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_aplicacion`),
  KEY `idx_pa_pago` (`id_pago`),
  KEY `idx_pa_adeudo` (`id_adeudo`),
  CONSTRAINT `fk_pa_adeudo` FOREIGN KEY (`id_adeudo`) REFERENCES `Adeudos` (`id_adeudo`),
  CONSTRAINT `fk_pa_pago` FOREIGN KEY (`id_pago`) REFERENCES `Pagos` (`id_pago`),
  CONSTRAINT `chk_pa_monto` CHECK (`monto_aplicado` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `PasswordResetToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PasswordResetToken` (
  `token` varchar(64) NOT NULL,
  `username` varchar(50) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`token`),
  KEY `idx_prt_username_expires` (`username`,`expires_at`),
  CONSTRAINT `fk_prt_username` FOREIGN KEY (`username`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `TipoOrigenAdeudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoOrigenAdeudo` (
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `id_usuario` varchar(50) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `apellido_paterno` varchar(255) DEFAULT NULL,
  `apellido_materno` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `fecha_creacion` datetime(6) DEFAULT NULL,
  `fecha_actualizacion` datetime(6) DEFAULT NULL,
  `fecha_vencimiento` datetime(6) DEFAULT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'ADMIN',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_por` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ventas` (
  `id_venta` varchar(50) NOT NULL,
  `id_cliente` varchar(50) NOT NULL,
  `fecha_venta` datetime DEFAULT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `notas` text DEFAULT NULL,
  `usuario_registra` varchar(255) NOT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `fk_ventas_cliente` (`id_cliente`),
  KEY `fk_ventas_usuario_registra` (`usuario_registra`),
  CONSTRAINT `fk_ventas_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_ventas_usuario_registra` FOREIGN KEY (`usuario_registra`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`conor`@`localhost`*/ /*!50003 TRIGGER after_insert_venta_crea_adeudo
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    DECLARE nuevo_id_adeudo VARCHAR(50);
    DECLARE fecha_venc DATE;
    SET nuevo_id_adeudo = CONCAT('LCDEU-', UUID());
    SET fecha_venc = DATE_ADD(NEW.fecha_venta, INTERVAL 30 DAY);

    INSERT INTO Adeudos (
        id_adeudo,
        id_venta_origen,
        tipo_origen,
        id_cliente,
        monto_inicial,
        saldo_pendiente,
        fecha_origen,
        fecha_vencimiento,
        estado_adeudo,
        notas
    ) VALUES (
        nuevo_id_adeudo,
        NEW.id_venta,
        'VENTA',           -- explícito; el DEFAULT existe pero no nos apoyamos en él
        NEW.id_cliente,
        NEW.monto_total,
        NEW.monto_total,
        NEW.fecha_venta,
        fecha_venc,
        'ABIERTO',
        NEW.notas
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

