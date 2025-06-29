CREATE TABLE `Adeudos` (
  `id_adeudo` varchar(50) NOT NULL,
  `id_venta_origen` varchar(50) NOT NULL,
  `id_cliente` varchar(50) NOT NULL,
  `monto_inicial` decimal(10,2) NOT NULL,
  `saldo_pendiente` decimal(10,2) NOT NULL,
  `fecha_origen` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `estado_adeudo` varchar(50) DEFAULT 'Pendiente',
  `notas` text DEFAULT NULL,
  PRIMARY KEY (`id_adeudo`),
  KEY `fk_adeudo_venta` (`id_venta_origen`),
  KEY `fk_adeudo_cliente` (`id_cliente`),
  CONSTRAINT `fk_adeudo_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_adeudo_venta` FOREIGN KEY (`id_venta_origen`) REFERENCES `Ventas` (`id_venta`),
  CONSTRAINT `fk_adeudos_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`),
  CONSTRAINT `fk_adeudos_venta` FOREIGN KEY (`id_venta_origen`) REFERENCES `Ventas` (`id_venta`)
) 

drop table if EXISTS Adeudos;