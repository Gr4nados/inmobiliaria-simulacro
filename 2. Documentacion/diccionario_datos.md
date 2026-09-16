# Diccionario de Datos — Sistema de Gestión de Propiedades (Inmobiliaria)

Base de datos: `inmobiliaria_simulacro` · Motor: MySQL 8 · 13 tablas

---

## rol
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_rol | INT | PK, AUTO_INCREMENT | Identificador del rol |
| nombre | VARCHAR(30) | NOT NULL, UNIQUE | Nombre del rol (ADMINISTRADOR, INMOBILIARIA, CLIENTE) |
| descripcion | VARCHAR(150) | — | Descripción del rol |

## usuario
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_usuario | INT | PK, AUTO_INCREMENT | Identificador del usuario |
| documento | VARCHAR(20) | NOT NULL, UNIQUE | Número de documento |
| username | VARCHAR(40) | NOT NULL, UNIQUE | Usuario para iniciar sesión |
| correo | VARCHAR(120) | NOT NULL, UNIQUE | Correo electrónico (credencial de recuperación) |
| password_hash | CHAR(64) | NOT NULL | Hash SHA-256 de `username:clave` |
| id_rol | INT | FK → rol | Rol asignado |
| activo | TINYINT(1) | NOT NULL, DEFAULT 1 | Estado de la cuenta |
| fecha_registro | DATETIME | NOT NULL, DEFAULT NOW | Fecha de creación de la cuenta |

## perfil
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_perfil | INT | PK, AUTO_INCREMENT | Identificador del perfil |
| id_usuario | INT | FK → usuario, UNIQUE | Garantiza la relación 1:1 con usuario |
| nombres | VARCHAR(60) | NOT NULL | Nombres del usuario |
| apellidos | VARCHAR(60) | NOT NULL | Apellidos del usuario |
| telefono | VARCHAR(20) | — | Teléfono de contacto |
| direccion | VARCHAR(150) | — | Dirección de residencia |

## ciudad
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_ciudad | INT | PK, AUTO_INCREMENT | Identificador de la ciudad |
| nombre | VARCHAR(60) | NOT NULL, UNIQUE | Nombre de la ciudad |

## tipo_propiedad
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_tipo_propiedad | INT | PK, AUTO_INCREMENT | Identificador del tipo |
| nombre | VARCHAR(40) | NOT NULL, UNIQUE | Casa, Apartamento, Local, Oficina, Terreno |

## propiedad
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_propiedad | INT | PK, AUTO_INCREMENT | Identificador de la propiedad |
| matricula_inmobiliaria | VARCHAR(30) | NOT NULL, UNIQUE | Identifica de forma irrepetible el inmueble |
| titulo | VARCHAR(120) | NOT NULL | Título de la publicación |
| descripcion | VARCHAR(500) | — | Descripción del inmueble |
| precio | DECIMAL(14,2) | NOT NULL | Precio de venta o arriendo |
| id_ciudad | INT | FK → ciudad | Ciudad donde se ubica |
| id_tipo_propiedad | INT | FK → tipo_propiedad | Tipo de inmueble |
| id_usuario | INT | FK → usuario | Agente/inmobiliaria que la publicó |
| estado | VARCHAR(20) | NOT NULL, DEFAULT 'DISPONIBLE' | DISPONIBLE / INACTIVA (baja lógica) |
| fecha_publicacion | DATETIME | NOT NULL, DEFAULT NOW | Fecha de publicación |

## imagen_propiedad
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_imagen | INT | PK, AUTO_INCREMENT | Identificador de la imagen |
| id_propiedad | INT | FK → propiedad | Propiedad a la que pertenece (relación 1:N) |
| url_imagen | VARCHAR(255) | NOT NULL | Ruta o URL de la imagen |
| orden | INT | NOT NULL, DEFAULT 1 | Orden de aparición en la galería |
| fecha_carga | DATETIME | NOT NULL, DEFAULT NOW | Fecha de carga |

## caracteristica
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_caracteristica | INT | PK, AUTO_INCREMENT | Identificador de la característica |
| nombre | VARCHAR(40) | NOT NULL, UNIQUE | Piscina, Parqueadero, Ascensor, Gimnasio, Terraza, Balcón |

## propiedad_caracteristica (tabla intermedia N:M)
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_propiedad | INT | PK compuesta, FK → propiedad | Propiedad |
| id_caracteristica | INT | PK compuesta, FK → caracteristica | Característica asociada |

## cita
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_cita | INT | PK, AUTO_INCREMENT | Identificador de la cita |
| id_propiedad | INT | FK → propiedad | Propiedad a visitar |
| id_cliente | INT | FK → usuario | Cliente que agenda |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora de la visita |
| estado | VARCHAR(20) | NOT NULL, DEFAULT 'PENDIENTE' | PENDIENTE / CONFIRMADA / CANCELADA / REALIZADA |
| observaciones | VARCHAR(255) | — | Notas adicionales |
| fecha_creacion | DATETIME | NOT NULL, DEFAULT NOW | Fecha en que se agendó |
| **UNIQUE** | (id_propiedad, fecha_hora) | — | Impide dos citas en la misma propiedad al mismo horario |

## solicitud
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_solicitud | INT | PK, AUTO_INCREMENT | Identificador de la solicitud |
| id_propiedad | INT | FK → propiedad | Propiedad solicitada |
| id_cliente | INT | FK → usuario | Cliente que radica |
| tipo | VARCHAR(20) | NOT NULL | COMPRA / ARRIENDO |
| estado | VARCHAR(20) | NOT NULL, DEFAULT 'PENDIENTE' | PENDIENTE / APROBADA / RECHAZADA |
| observaciones | VARCHAR(255) | — | Notas del agente al aprobar/rechazar |
| fecha_solicitud | DATETIME | NOT NULL, DEFAULT NOW | Fecha de radicación |

## documento_solicitud
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_documento | INT | PK, AUTO_INCREMENT | Identificador del documento |
| id_solicitud | INT | FK → solicitud | Solicitud a la que pertenece (relación 1:N) |
| nombre_archivo | VARCHAR(150) | NOT NULL | Nombre del archivo radicado |
| tipo_documento | VARCHAR(50) | NOT NULL | CEDULA / CERTIFICADO_LABORAL / EXTRACTO_BANCARIO |
| fecha_carga | DATETIME | NOT NULL, DEFAULT NOW | Fecha de carga del documento |

## favorito (relación N:M usuario–propiedad)
| Campo | Tipo | Restricción | Descripción |
|---|---|---|---|
| id_favorito | INT | PK, AUTO_INCREMENT | Identificador del registro |
| id_usuario | INT | FK → usuario | Cliente que marca la propiedad |
| id_propiedad | INT | FK → propiedad | Propiedad marcada |
| fecha_marcado | DATETIME | NOT NULL, DEFAULT NOW | Fecha en que se marcó como favorita |
| **UNIQUE** | (id_usuario, id_propiedad) | — | Evita marcar la misma propiedad dos veces |

---

## Resumen de relaciones

| Tipo | Relación |
|---|---|
| 1:1 | usuario ↔ perfil |
| 1:N | rol → usuario |
| 1:N | usuario → propiedad, ciudad → propiedad, tipo_propiedad → propiedad |
| 1:N | propiedad → imagen_propiedad |
| 1:N | propiedad → cita, usuario → cita |
| 1:N | propiedad → solicitud, usuario → solicitud |
| 1:N | solicitud → documento_solicitud |
| N:M | propiedad ↔ caracteristica (vía propiedad_caracteristica) |
| N:M | usuario ↔ propiedad (vía favorito, con restricción UNIQUE) |
