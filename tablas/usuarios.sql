drop table if EXISTS usuario;
CREATE TABLE `Usuarios` (
  `id_usuario` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido_paterno` varchar(50) DEFAULT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('ADMIN','VENDEDOR','SUPERVISOR') NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` date DEFAULT curdate(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `username` (`username`)
) 