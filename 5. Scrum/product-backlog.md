# Product Backlog — Sistema de Gestión de Propiedades (Inmobiliaria)

Historias entregadas por el Docente Product Owner, priorizadas y con criterios
de aceptación (Definition of Done) definidos por el equipo de desarrollo.

| # | Historia | Prioridad | Sprint |
|---|----------|-----------|--------|
| 1 | Landing page para visitantes | Alta | 1 |
| 2 | Registro con correo único | Alta | 1 |
| 3 | Inicio/cierre de sesión seguro por rol | Alta | 1 |
| 4 | Administrador asigna y revoca roles | Alta | 1 |
| 5 | Cliente completa su perfil | Media | 2 |
| 6 | Agente registra y edita propiedades con fotos y características | Alta | 2 |
| 7 | Cliente busca y filtra propiedades | Alta | 2 |
| 8 | Cliente marca propiedades como favoritas | Media | 2 |
| 9 | Cliente solicita una cita | Media | 3 |
| 10 | Cliente radica documentos y consulta el estado de su solicitud | Media | 3 |
| 11 | Agente aprueba o rechaza solicitudes | Media | 3 |
| 12 | Administrador consulta reporte de propiedades por ciudad/estado | Media | 3 |
| 13 | Administrador consulta la auditoría de accesos y cambios | Baja | No incluida |

---

### 1. Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente.
**Criterios de aceptación:**
- La landing carga sin necesidad de sesión iniciada.
- Muestra un buscador rápido y las propiedades destacadas.
- Incluye accesos visibles a registro e inicio de sesión.
- Se ve correctamente en escritorio, tablet y celular (Bootstrap).

### 2. Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema.
**Criterios de aceptación:**
- El formulario valida campos obligatorios y formato de correo.
- Si el correo o el username ya existen, se muestra un mensaje claro (no una excepción de Java), capturando `SQLIntegrityConstraintViolationException`.
- La contraseña se guarda cifrada (SHA-256 con salt), nunca en texto plano.
- Al registrarse exitosamente, el usuario queda con rol CLIENTE por defecto y puede iniciar sesión de inmediato.

### 3. Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol.
**Criterios de aceptación:**
- Las credenciales se validan contra la base de datos comparando hashes.
- La sesión (`HttpSession`) guarda el id de usuario y su rol.
- `seguridad.jspf` bloquea el acceso a rutas privadas si no hay sesión o el rol no está autorizado, incluso escribiendo la URL directamente.
- El cierre de sesión invalida completamente la sesión activa.

### 4. Como administrador, quiero asignar y revocar roles a los usuarios para controlar los permisos de la aplicación.
**Criterios de aceptación:**
- Solo el rol ADMINISTRADOR accede a este módulo.
- El cambio de rol se refleja de inmediato en el próximo inicio de sesión del usuario afectado.

### 5. Como cliente, quiero completar mi perfil con documento, teléfono y dirección asociados a mi cuenta para agilizar mis trámites.
**Criterios de aceptación:**
- El formulario actualiza la tabla `perfil` (relación 1:1 con `usuario`).
- Los campos obligatorios se validan antes de guardar.

### 6. Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio para mantener el catálogo actualizado.
**Criterios de aceptación:**
- Publicar una propiedad exige matrícula inmobiliaria única (mensaje claro si se repite).
- Se pueden asociar varias características por propiedad (relación N:M).
- Se pueden asociar varias imágenes por propiedad (relación 1:N).
- La edición modifica los datos existentes sin duplicar la fila.
- La operación de creación se ejecuta dentro de una transacción (propiedad + características).

### 7. Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características para encontrar las opciones que se ajusten a mis necesidades.
**Criterios de aceptación:**
- El listado permite filtrar por al menos ciudad, tipo y rango de precio.
- Los filtros se pueden combinar entre sí.

### 8. Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo.
**Criterios de aceptación:**
- Un clic agrega/quita la propiedad de la lista de favoritos del usuario.
- La restricción UNIQUE de la tabla `favorito` evita duplicados.

### 9. Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas.
**Criterios de aceptación:**
- No se pueden agendar dos citas para la misma propiedad en el mismo horario (UNIQUE `id_propiedad + fecha_hora`).
- El intento de duplicado muestra un mensaje claro, no una excepción de Java.

### 10. Como cliente, quiero radicar los documentos de compra o arriendo y consultar el estado de mi solicitud.
**Criterios de aceptación:**
- El cliente puede crear una solicitud asociada a una propiedad.
- El cliente puede ver el estado actual (pendiente/aprobada/rechazada) de sus solicitudes.

### 11. Como agente de la inmobiliaria, quiero aprobar o rechazar las solicitudes y sus documentos para dar trámite a la negociación.
**Criterios de aceptación:**
- Solo el agente dueño de la propiedad (o un administrador) puede cambiar el estado de la solicitud.
- El cambio de estado queda reflejado de inmediato para el cliente.

### 12. Como administrador, quiero un reporte de propiedades por ciudad y estado, generado con consultas de agregación, para tomar decisiones.
**Criterios de aceptación:**
- El reporte usa `GROUP BY`/`HAVING` sobre datos reales de la base.
- Se puede consultar desde el panel de administrador.

### 13. Como administrador, quiero consultar la auditoría de accesos y cambios para hacer seguimiento a la operación del sistema.
**Nota:** historia de prioridad Baja, marcada como valor agregado opcional en el enunciado del parcial. Dado el tiempo disponible para el entregable final, el equipo decidió **no implementarla** y documentar esta decisión en la Retrospectiva del Sprint 3, priorizando las historias de mayor peso en la evaluación.
