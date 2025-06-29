drop table if EXISTS usuario;
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('ADMIN', 'VENDEDOR', 'SUPERVISOR') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion date DEFAULT CURRENT_DATE
);