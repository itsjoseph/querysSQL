CREATE TABLE `Clientes` (
  `id_cliente` varchar(50) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido_paterno` varchar(50) DEFAULT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `telefono_principal` varchar(20) NOT NULL,
  `correo_electronico` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `estatus` varchar(50) DEFAULT 'Activo',
  `fecha_alta` DATE NULL,
  `saldo_pendiente_total` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id_cliente`)
)
