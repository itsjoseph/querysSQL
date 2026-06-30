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
  `eliminado_en` datetime DEFAULT NULL,
  `eliminado_por` varchar(50) DEFAULT NULL,
  `motivo_eliminacion` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_adeudo`),
  KEY `fk_adeudo_venta` (`id_venta_origen`),
  KEY `fk_adeudo_cliente` (`id_cliente`),
  KEY `idx_adeudos_cliente_fifo` (`id_cliente`,`fecha_origen`),
  KEY `fk_adeudo_estado` (`estado_adeudo`),
  KEY `fk_adeudo_tipo_origen` (`tipo_origen`),
  KEY `idx_adeudos_no_eliminados` (`eliminado_en`),
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
DROP TABLE IF EXISTS `Administradores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Administradores` (
  `id_admin` varchar(50) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `fecha_actualizacion` datetime(6) DEFAULT NULL,
  `fecha_creacion` datetime(6) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
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
) ENGINE=InnoDB AUTO_INCREMENT=1005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `CajaSesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CajaSesion` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `terminal` varchar(40) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `abierta_en` datetime NOT NULL DEFAULT current_timestamp(),
  `cerrada_en` datetime DEFAULT NULL,
  `fondo_inicial` decimal(12,2) NOT NULL DEFAULT 0.00,
  `efectivo_esperado` decimal(12,2) DEFAULT NULL,
  `efectivo_contado` decimal(12,2) DEFAULT NULL,
  `diferencia` decimal(12,2) DEFAULT NULL,
  `estado` varchar(12) NOT NULL DEFAULT 'ABIERTA',
  PRIMARY KEY (`id`),
  KEY `idx_caja_equipo_estado` (`equipo`,`estado`),
  CONSTRAINT `chk_caja_estado` CHECK (`estado` in ('ABIERTA','CERRADA'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `tint_bg` varchar(9) DEFAULT NULL,
  `tint_fg` varchar(9) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `eliminado_en` datetime DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_categoria_equipo` (`equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `saldo_pendiente_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fecha_alta` datetime DEFAULT NULL,
  `usuario_asignado` varchar(255) NOT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `eliminado_en` datetime DEFAULT NULL,
  `eliminado_por` varchar(50) DEFAULT NULL,
  `motivo_eliminacion` varchar(500) DEFAULT NULL,
  `es_publico_general` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_clientes_usuario_asignado` (`usuario_asignado`),
  KEY `fk_cliente_estatus` (`estatus`),
  KEY `idx_clientes_no_eliminados` (`eliminado_en`),
  CONSTRAINT `fk_cliente_estatus` FOREIGN KEY (`estatus`) REFERENCES `EstadoCliente` (`codigo`),
  CONSTRAINT `fk_clientes_usuario_asignado` FOREIGN KEY (`usuario_asignado`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `EmailsPendientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EmailsPendientes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(40) NOT NULL,
  `destinatario` varchar(150) NOT NULL,
  `asunto` varchar(255) NOT NULL,
  `cuerpo` text NOT NULL,
  `adjunto` longblob DEFAULT NULL,
  `adjunto_nombre` varchar(255) DEFAULT NULL,
  `adjunto_mime` varchar(100) DEFAULT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'PENDIENTE',
  `intentos` int(11) NOT NULL DEFAULT 0,
  `proximo_intento_en` datetime NOT NULL DEFAULT current_timestamp(),
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  `enviado_en` datetime DEFAULT NULL,
  `error_ultimo` varchar(500) DEFAULT NULL,
  `referencia_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_outbox_picker` (`estado`,`proximo_intento_en`),
  KEY `idx_outbox_referencia` (`referencia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
DROP TABLE IF EXISTS `FolioSecuencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `FolioSecuencia` (
  `serie` varchar(40) NOT NULL,
  `ultimo_folio` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`serie`)
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
DROP TABLE IF EXISTS `MovimientoCaja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MovimientoCaja` (
  `id` varchar(50) NOT NULL,
  `caja_sesion_id` varchar(50) NOT NULL,
  `tipo` varchar(12) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(20) DEFAULT NULL,
  `referencia` varchar(64) DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_movcaja_sesion` (`caja_sesion_id`),
  CONSTRAINT `fk_movcaja_sesion` FOREIGN KEY (`caja_sesion_id`) REFERENCES `CajaSesion` (`id`),
  CONSTRAINT `chk_movcaja_tipo` CHECK (`tipo` in ('VENTA','RETIRO','INGRESO','AJUSTE','ABONO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `MovimientoInventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MovimientoInventario` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `producto_id` varchar(50) NOT NULL,
  `tipo` varchar(12) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `costo_unitario` decimal(12,2) DEFAULT NULL,
  `existencia_resultante` int(11) NOT NULL,
  `referencia` varchar(60) DEFAULT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_movinv_producto` (`producto_id`,`creado_en`),
  KEY `idx_movinv_equipo` (`equipo`),
  CONSTRAINT `fk_movinv_producto` FOREIGN KEY (`producto_id`) REFERENCES `Producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `eliminado_en` datetime DEFAULT NULL,
  `eliminado_por` varchar(50) DEFAULT NULL,
  `motivo_eliminacion` varchar(500) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_pago`),
  KEY `fk_pagos_cliente` (`id_cliente`),
  KEY `fk_pagos_metodo_pago` (`metodo_pago`),
  KEY `fk_pagos_usuario_cobrador` (`usuario_cobrador`),
  KEY `idx_pagos_no_eliminados` (`eliminado_en`),
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Pagos_Suscripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pagos_Suscripcion` (
  `id_pago_susc` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `moneda` char(3) NOT NULL DEFAULT 'MXN',
  `proveedor` varchar(20) NOT NULL,
  `proveedor_order_id` varchar(100) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'CREADA',
  `dias_otorgados` int(11) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `confirmado_en` timestamp NULL DEFAULT NULL,
  `raw_payload` text DEFAULT NULL,
  PRIMARY KEY (`id_pago_susc`),
  UNIQUE KEY `uq_pagos_susc_order` (`proveedor`,`proveedor_order_id`),
  KEY `idx_pagos_susc_user_fecha` (`username`,`creado_en` DESC),
  KEY `idx_pagos_susc_estado` (`estado`),
  CONSTRAINT `fk_pagos_susc_user` FOREIGN KEY (`username`) REFERENCES `Usuarios` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `categoria_id` varchar(50) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `sku` varchar(60) DEFAULT NULL,
  `codigo_barras` varchar(60) DEFAULT NULL,
  `precio` decimal(12,2) NOT NULL DEFAULT 0.00,
  `existencia` int(11) NOT NULL DEFAULT 0,
  `impuesto_tasa` decimal(5,4) NOT NULL DEFAULT 0.1600,
  `clave_prod_sat` varchar(20) DEFAULT NULL,
  `unidad_sat` varchar(20) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `eliminado_en` datetime DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  `costo_promedio` decimal(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `idx_producto_equipo` (`equipo`),
  KEY `idx_producto_categoria` (`categoria_id`),
  CONSTRAINT `fk_producto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `Categoria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ProductoCodigoUnidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductoCodigoUnidad` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `producto_id` varchar(50) NOT NULL,
  `codigo_barras` varchar(60) NOT NULL,
  `vendido` tinyint(1) NOT NULL DEFAULT 0,
  `venta_id` varchar(50) DEFAULT NULL,
  `vendido_en` datetime DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_codunidad_equipo_codigo` (`equipo`,`codigo_barras`),
  KEY `idx_codunidad_producto` (`producto_id`),
  KEY `idx_codunidad_equipo` (`equipo`),
  CONSTRAINT `fk_codunidad_producto` FOREIGN KEY (`producto_id`) REFERENCES `Producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Promocion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Promocion` (
  `id` varchar(50) NOT NULL,
  `equipo` varchar(50) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `tipo` varchar(10) NOT NULL,
  `valor` decimal(12,2) NOT NULL DEFAULT 0.00,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `eliminado_en` datetime DEFAULT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_promocion_equipo` (`equipo`,`eliminado_en`),
  CONSTRAINT `chk_promocion_tipo` CHECK (`tipo` in ('PCT','FIJO')),
  CONSTRAINT `chk_promocion_valor` CHECK (`valor` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `RecordatoriosVencidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RecordatoriosVencidos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_cliente` varchar(64) NOT NULL,
  `fecha_target` date NOT NULL,
  `enviado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_recordatorio_vencido` (`id_cliente`,`fecha_target`),
  KEY `idx_recordatorio_vencido_cliente` (`id_cliente`,`fecha_target`),
  CONSTRAINT `fk_recordatorio_vencido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `RecordatoriosVencimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RecordatoriosVencimiento` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_cliente` varchar(64) NOT NULL,
  `dias_antes` int(11) NOT NULL,
  `fecha_target` date NOT NULL,
  `enviado_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_recordatorio` (`id_cliente`,`dias_antes`,`fecha_target`),
  CONSTRAINT `fk_recordatorio_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `totp_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `totp_secret` varchar(255) DEFAULT NULL,
  `estado_cuenta` varchar(255) DEFAULT NULL,
  `fecha_inicio_prueba` date DEFAULT NULL,
  `aviso_12d_enviado_en` datetime DEFAULT NULL,
  `recordatorio_5d_enviado_en` datetime DEFAULT NULL,
  `recordatorio_2d_enviado_en` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `uk_usuarios_email` (`email`),
  KEY `idx_usuarios_totp_enabled` (`totp_enabled`),
  KEY `idx_usuarios_estado_cuenta` (`estado_cuenta`),
  KEY `idx_usuarios_inicio_prueba` (`fecha_inicio_prueba`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `VentaDetalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `VentaDetalle` (
  `id` varchar(50) NOT NULL,
  `id_venta` varchar(64) NOT NULL,
  `producto_id` varchar(50) NOT NULL,
  `nombre_snapshot` varchar(150) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_linea` decimal(12,2) NOT NULL DEFAULT 0.00,
  `impuesto_tasa` decimal(5,4) NOT NULL DEFAULT 0.0000,
  `importe` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ventadetalle_producto` (`producto_id`),
  KEY `idx_ventadetalle_venta` (`id_venta`),
  CONSTRAINT `fk_ventadetalle_producto` FOREIGN KEY (`producto_id`) REFERENCES `Producto` (`id`),
  CONSTRAINT `fk_ventadetalle_venta` FOREIGN KEY (`id_venta`) REFERENCES `Ventas` (`id_venta`)
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
  `tipo_venta` varchar(20) NOT NULL DEFAULT 'CREDITO',
  `metodo_pago` varchar(20) DEFAULT NULL,
  `comprador_nombre` varchar(150) DEFAULT NULL,
  `serie` varchar(40) DEFAULT NULL,
  `folio` bigint(20) DEFAULT NULL,
  `subtotal` decimal(12,2) DEFAULT NULL,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `impuesto_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `caja_sesion_id` varchar(50) DEFAULT NULL,
  `descripcion` varchar(500) NOT NULL,
  `notas` text DEFAULT NULL,
  `usuario_registra` varchar(255) NOT NULL,
  `eliminado_en` datetime DEFAULT NULL,
  `eliminado_por` varchar(50) DEFAULT NULL,
  `motivo_eliminacion` varchar(500) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_venta`),
  KEY `fk_ventas_cliente` (`id_cliente`),
  KEY `fk_ventas_usuario_registra` (`usuario_registra`),
  KEY `idx_ventas_no_eliminados` (`eliminado_en`),
  KEY `fk_venta_metodo_pago` (`metodo_pago`),
  KEY `fk_venta_caja_sesion` (`caja_sesion_id`),
  CONSTRAINT `fk_venta_caja_sesion` FOREIGN KEY (`caja_sesion_id`) REFERENCES `CajaSesion` (`id`),
  CONSTRAINT `fk_venta_metodo_pago` FOREIGN KEY (`metodo_pago`) REFERENCES `MetodoPago` (`codigo`),
  CONSTRAINT `fk_ventas_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_ventas_usuario_registra` FOREIGN KEY (`usuario_registra`) REFERENCES `Usuarios` (`username`),
  CONSTRAINT `chk_venta_contado_metodo` CHECK (`tipo_venta` = 'CONTADO' and `metodo_pago` is not null or `tipo_venta` <> 'CONTADO')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`conor`@`localhost`*/ /*!50003 TRIGGER after_insert_venta_crea_adeudo
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    DECLARE nuevo_id_adeudo VARCHAR(50);
    DECLARE fecha_venc DATE;

    IF NEW.tipo_venta = 'CREDITO' THEN
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
            'VENTA',
            NEW.id_cliente,
            NEW.monto_total,
            NEW.monto_total,
            NEW.fecha_venta,
            fecha_venc,
            'ABIERTO',
            NEW.notas
        );
    END IF;
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

