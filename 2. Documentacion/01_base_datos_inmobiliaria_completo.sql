-- ============================================================
-- 01_base_datos_inmobiliaria_completo.sql
-- Base de datos COMPLETA del parcial de Programacion Java (inmobiliaria).
-- Motor: MySQL 8
-- 13 tablas. Relaciones:
--   1:1  usuario <-> perfil
--   1:N  rol->usuario, usuario->propiedad, ciudad->propiedad,
--        tipo_propiedad->propiedad, propiedad->imagen_propiedad,
--        propiedad->cita, usuario->cita, propiedad->solicitud,
--        usuario->solicitud, solicitud->documento_solicitud
--   N:M  propiedad<->caracteristica (propiedad_caracteristica)
--        usuario<->propiedad via favorito (con restriccion UNIQUE)
-- ============================================================

DROP DATABASE IF EXISTS inmobiliaria_simulacro;
CREATE DATABASE inmobiliaria_simulacro
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE inmobiliaria_simulacro;

-- ------------------------------------------------------------
CREATE TABLE rol (
    id_rol      INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(30) NOT NULL,
    descripcion VARCHAR(150),
    CONSTRAINT uq_rol_nombre UNIQUE (nombre)
);

-- ------------------------------------------------------------
CREATE TABLE usuario (
    id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
    documento      VARCHAR(20)  NOT NULL,
    username       VARCHAR(40)  NOT NULL,
    correo         VARCHAR(120) NOT NULL,
    password_hash  CHAR(64)     NOT NULL,
    id_rol         INT          NOT NULL,
    activo         TINYINT(1)   NOT NULL DEFAULT 1,
    fecha_registro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_usuario_documento UNIQUE (documento),
    CONSTRAINT uq_usuario_username  UNIQUE (username),
    CONSTRAINT uq_usuario_correo    UNIQUE (correo),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol)
        REFERENCES rol (id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE perfil (
    id_perfil  INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombres    VARCHAR(60) NOT NULL,
    apellidos  VARCHAR(60) NOT NULL,
    telefono   VARCHAR(20),
    direccion  VARCHAR(150),
    CONSTRAINT uq_perfil_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(60) NOT NULL,
    CONSTRAINT uq_ciudad_nombre UNIQUE (nombre)
);

-- ------------------------------------------------------------
CREATE TABLE tipo_propiedad (
    id_tipo_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(40) NOT NULL,
    CONSTRAINT uq_tipo_propiedad_nombre UNIQUE (nombre)
);

-- ------------------------------------------------------------
CREATE TABLE propiedad (
    id_propiedad           INT AUTO_INCREMENT PRIMARY KEY,
    matricula_inmobiliaria VARCHAR(30)  NOT NULL,
    titulo                 VARCHAR(120) NOT NULL,
    descripcion            VARCHAR(500),
    precio                 DECIMAL(14,2) NOT NULL,
    id_ciudad              INT NOT NULL,
    id_tipo_propiedad      INT NOT NULL,
    id_usuario             INT NOT NULL,
    estado                 VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',
    fecha_publicacion      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_propiedad_matricula UNIQUE (matricula_inmobiliaria),
    CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad (id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo_propiedad)
        REFERENCES tipo_propiedad (id_tipo_propiedad) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE imagen_propiedad (
    id_imagen    INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen   VARCHAR(255) NOT NULL,
    orden        INT NOT NULL DEFAULT 1,
    fecha_carga  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad (id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(40) NOT NULL,
    CONSTRAINT uq_caracteristica_nombre UNIQUE (nombre)
);

-- ------------------------------------------------------------
CREATE TABLE propiedad_caracteristica (
    id_propiedad      INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    CONSTRAINT fk_propcar_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad (id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_propcar_caracteristica FOREIGN KEY (id_caracteristica)
        REFERENCES caracteristica (id_caracteristica) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE cita (
    id_cita        INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad   INT NOT NULL,
    id_cliente     INT NOT NULL,
    fecha_hora     DATETIME NOT NULL,
    estado         VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    observaciones  VARCHAR(255),
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_cita_propiedad_fecha UNIQUE (id_propiedad, fecha_hora),
    CONSTRAINT fk_cita_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad (id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE solicitud (
    id_solicitud     INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad     INT NOT NULL,
    id_cliente       INT NOT NULL,
    tipo             VARCHAR(20) NOT NULL,
    estado           VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    observaciones    VARCHAR(255),
    fecha_solicitud  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad (id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE documento_solicitud (
    id_documento    INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud    INT NOT NULL,
    nombre_archivo  VARCHAR(150) NOT NULL,
    tipo_documento  VARCHAR(50) NOT NULL,
    fecha_carga     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_documento_solicitud FOREIGN KEY (id_solicitud)
        REFERENCES solicitud (id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
CREATE TABLE favorito (
    id_favorito    INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT NOT NULL,
    id_propiedad   INT NOT NULL,
    fecha_marcado  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_favorito_usuario_propiedad UNIQUE (id_usuario, id_propiedad),
    CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad (id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO rol (nombre, descripcion) VALUES
    ('ADMINISTRADOR', 'Acceso total al sistema'),
    ('INMOBILIARIA',  'Publica y administra propiedades'),
    ('CLIENTE',       'Busca propiedades, agenda citas y radica solicitudes');

-- Password de todos los usuarios de prueba: 1234
INSERT INTO usuario (documento, username, correo, password_hash, id_rol, activo) VALUES
    ('1000000001', 'admin', 'admin@inmosim.com', 'f8e68e8d44bfb5314974a97f787d017ff6ac9d0046083f28665fcf96f0cef80c', 1, 1),
    ('1000000002', 'agente1', 'agente1@inmosim.com', '6f819d06ab2da586d80b35e08cbfd67c04211baba1af350d709a73e981f43d96', 2, 1),
    ('1000000010', 'agente2', 'agente2@inmosim.com', 'c447b68b22a25886333531060f58c14e1aab64c68b1fb29c583fda59559369d0', 2, 1),
    ('1000000011', 'agente3', 'agente3@inmosim.com', 'd0e94bff017ce1fc9ab8875ef3123ffe2d206c5576b824eaad8d73b130433103', 2, 1),
    ('1000000012', 'agente4', 'agente4@inmosim.com', '6245d8cef9a4fd73e69e0da520d65322bb906e012912c5f4049530a77355bda7', 2, 1),
    ('1000000003', 'cliente1', 'cliente1@inmosim.com', '8929c861a6048eb04b8e12fcc39669bb4aceac129ae2b521b40ec035ed00244b', 3, 1),
    ('1000000020', 'cliente2', 'cliente2@inmosim.com', 'fb3e975a138b56806a1fc691a2ba318de0a233f84df72fc9c85384efa1f4e8af', 3, 1),
    ('1000000021', 'cliente3', 'cliente3@inmosim.com', '6a93a1f7b327cda19f69a4a1d6c1e7c721e6ea8fae5fa493488b728b2cdbb2e7', 3, 1),
    ('1000000022', 'cliente4', 'cliente4@inmosim.com', '62538e91e6172c4958c116f8f809e95eefa08f2c7b833dc5296f93b8191318a6', 3, 1),
    ('1000000023', 'cliente5', 'cliente5@inmosim.com', '90e8f7707425ffe22fbcd21eb6abd8a6dcb306fefe196ea292b69502b0d5f4e2', 3, 1);

INSERT INTO perfil (id_usuario, nombres, apellidos, telefono, direccion) VALUES
    (1, 'Laura', 'Martinez', '3001234567', 'Cra 10 # 20-30, Bucaramanga'),
    (2, 'Carlos', 'Gomez', '3007654321', 'Calle 45 # 12-08, Bucaramanga'),
    (3, 'Diana', 'Rueda', '3011112222', 'Cra 27 # 34-10, Bucaramanga'),
    (4, 'Felipe', 'Cardenas', '3022223333', 'Calle 56 # 20-15, Floridablanca'),
    (5, 'Marcela', 'Ortiz', '3033334444', 'Cra 15 # 8-40, Piedecuesta'),
    (6, 'Andrea', 'Suarez', '3009876543', 'Av. Quebradaseca # 5-60, Bucaramanga'),
    (7, 'Julian', 'Pinzon', '3044445555', 'Calle 30 # 25-12, Bucaramanga'),
    (8, 'Camila', 'Rojas', '3055556666', 'Cra 33 # 45-20, Floridablanca'),
    (9, 'Santiago', 'Ardila', '3066667777', 'Calle 18 # 9-33, Piedecuesta'),
    (10, 'Valentina', 'Nino', '3077778888', 'Cra 20 # 15-05, Bucaramanga');

INSERT INTO ciudad (nombre) VALUES
    ('Bucaramanga'), ('Floridablanca'), ('Piedecuesta'), ('Bogota'), ('Medellin');

INSERT INTO tipo_propiedad (nombre) VALUES
    ('Casa'), ('Apartamento'), ('Local'), ('Oficina'), ('Terreno');

INSERT INTO caracteristica (nombre) VALUES
    ('Piscina'), ('Parqueadero'), ('Ascensor'), ('Gimnasio'), ('Terraza'), ('Balcon');

INSERT INTO propiedad (matricula_inmobiliaria, titulo, descripcion, precio, id_ciudad, id_tipo_propiedad, id_usuario) VALUES
    ('MI-0001', 'Apartamento moderno cerca al parque', 'Dos habitaciones, balcon amplio.', 320000000, 1, 2, 2),
    ('MI-0002', 'Casa campestre con jardin', 'Tres habitaciones, patio grande.', 480000000, 2, 1, 2),
    ('MI-0003', 'Local comercial en zona central', 'Ideal para negocio, buena afluencia.', 250000000, 1, 3, 2),
    ('MI-0004', 'Oficina ejecutiva en el centro', 'Amplia, con recepcion y dos salas.', 180000000, 1, 4, 3),
    ('MI-0005', 'Apartaestudio para estudiantes', 'Cerca a universidades, amoblado.', 150000000, 1, 2, 3),
    ('MI-0006', 'Casa de dos pisos con garaje', 'Cuatro habitaciones, garaje doble.', 390000000, 3, 1, 3),
    ('MI-0007', 'Lote urbanizable', 'Apto para proyecto residencial.', 95000000, 2, 5, 4),
    ('MI-0008', 'Penthouse con vista panoramica', 'Terraza privada, acabados de lujo.', 850000000, 4, 2, 4),
    ('MI-0009', 'Local esquinero en centro comercial', 'Alto trafico peatonal.', 310000000, 5, 3, 4),
    ('MI-0010', 'Casa campestre con piscina', 'Cinco habitaciones, zona social amplia.', 520000000, 3, 1, 5);

INSERT INTO imagen_propiedad (id_propiedad, url_imagen, orden) VALUES
    (1, 'https://picsum.photos/seed/propiedad1_1/800/600', 1),
    (2, 'https://picsum.photos/seed/propiedad2_1/800/600', 1),
    (2, 'https://picsum.photos/seed/propiedad2_2/800/600', 2),
    (3, 'https://picsum.photos/seed/propiedad3_1/800/600', 1),
    (4, 'https://picsum.photos/seed/propiedad4_1/800/600', 1),
    (4, 'https://picsum.photos/seed/propiedad4_2/800/600', 2),
    (5, 'https://picsum.photos/seed/propiedad5_1/800/600', 1),
    (6, 'https://picsum.photos/seed/propiedad6_1/800/600', 1),
    (6, 'https://picsum.photos/seed/propiedad6_2/800/600', 2),
    (7, 'https://picsum.photos/seed/propiedad7_1/800/600', 1),
    (8, 'https://picsum.photos/seed/propiedad8_1/800/600', 1),
    (8, 'https://picsum.photos/seed/propiedad8_2/800/600', 2),
    (9, 'https://picsum.photos/seed/propiedad9_1/800/600', 1),
    (10, 'https://picsum.photos/seed/propiedad10_1/800/600', 1),
    (10, 'https://picsum.photos/seed/propiedad10_2/800/600', 2);

INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
    (1, 2),
    (1, 3),
    (1, 6),
    (2, 1),
    (2, 2),
    (2, 5),
    (3, 2),
    (4, 2),
    (4, 3),
    (5, 2),
    (6, 2),
    (6, 5),
    (6, 1),
    (7, 2),
    (8, 1),
    (8, 3),
    (8, 5),
    (8, 4),
    (9, 2),
    (9, 3),
    (10, 1),
    (10, 2),
    (10, 5);

INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, estado) VALUES
    (1, 6, '2026-09-15 10:00:00', 'PENDIENTE'),
    (2, 7, '2026-09-15 11:00:00', 'CONFIRMADA'),
    (3, 8, '2026-09-16 09:00:00', 'PENDIENTE'),
    (4, 9, '2026-09-16 14:00:00', 'CANCELADA'),
    (5, 10, '2026-09-17 10:30:00', 'PENDIENTE'),
    (6, 6, '2026-09-17 15:00:00', 'CONFIRMADA'),
    (7, 7, '2026-09-18 09:30:00', 'PENDIENTE'),
    (8, 8, '2026-09-18 16:00:00', 'REALIZADA'),
    (9, 9, '2026-09-19 11:00:00', 'PENDIENTE'),
    (10, 10, '2026-09-19 17:00:00', 'PENDIENTE');

INSERT INTO solicitud (id_propiedad, id_cliente, tipo, estado) VALUES
    (1, 6, 'ARRIENDO', 'PENDIENTE'),
    (2, 7, 'COMPRA', 'APROBADA'),
    (3, 8, 'ARRIENDO', 'RECHAZADA'),
    (4, 9, 'ARRIENDO', 'PENDIENTE'),
    (5, 10, 'COMPRA', 'PENDIENTE'),
    (6, 6, 'COMPRA', 'APROBADA'),
    (7, 7, 'ARRIENDO', 'PENDIENTE'),
    (8, 8, 'COMPRA', 'PENDIENTE'),
    (9, 9, 'ARRIENDO', 'APROBADA'),
    (10, 10, 'COMPRA', 'PENDIENTE');

INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, tipo_documento) VALUES
    (1, 'documento_1_1.pdf', 'CEDULA'),
    (2, 'documento_2_1.pdf', 'CEDULA'),
    (2, 'documento_2_2.pdf', 'CERTIFICADO_LABORAL'),
    (3, 'documento_3_1.pdf', 'CEDULA'),
    (4, 'documento_4_1.pdf', 'CEDULA'),
    (4, 'documento_4_2.pdf', 'CERTIFICADO_LABORAL'),
    (5, 'documento_5_1.pdf', 'CEDULA'),
    (6, 'documento_6_1.pdf', 'CEDULA'),
    (6, 'documento_6_2.pdf', 'CERTIFICADO_LABORAL'),
    (7, 'documento_7_1.pdf', 'CEDULA'),
    (8, 'documento_8_1.pdf', 'CEDULA'),
    (8, 'documento_8_2.pdf', 'CERTIFICADO_LABORAL'),
    (9, 'documento_9_1.pdf', 'CEDULA'),
    (10, 'documento_10_1.pdf', 'CEDULA'),
    (10, 'documento_10_2.pdf', 'CERTIFICADO_LABORAL');

INSERT INTO favorito (id_usuario, id_propiedad) VALUES
    (6, 1),
    (6, 4),
    (7, 2),
    (7, 5),
    (8, 3),
    (8, 6),
    (9, 1),
    (9, 7),
    (10, 8),
    (10, 9);
