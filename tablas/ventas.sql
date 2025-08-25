DROP TABLE IF EXISTS `Ventas`;

CREATE TABLE `Ventas` (
  `id_venta` varchar(50) NOT NULL,
  `id_cliente` varchar(50) NOT NULL,
  `fecha_venta` date NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `notas` text DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `fk_ventas_cliente` (`id_cliente`),
  CONSTRAINT `fk_ventas_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`)
)
