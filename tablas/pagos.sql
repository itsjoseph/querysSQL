CREATE TABLE `Pagos` (
  `id_pago` varchar(50) NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto_pagado` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(100) NOT NULL,
  `notas` text DEFAULT NULL,
  `id_cliente` varchar(50) NOT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `fk_pagos_cliente` (`id_cliente`),
  CONSTRAINT `fk_pagos_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`)
) 

drop table if EXISTS Pagos;