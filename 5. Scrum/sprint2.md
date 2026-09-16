# Sprint 2 — Núcleo del negocio
**Duración:** 03/09/2026 – 09/09/2026 (7 días)
**Roles Scrum:** Product Owner: Docente Julian Barney Jaimes Rincon · Scrum Master / Development Team: Jhon Granados y [Nombre del compañero]

## Sprint Planning

**Objetivo del sprint:** completar el módulo de propiedades con imágenes (1:N), características (N:M), búsqueda con filtros, perfil del usuario (1:1) y favoritos, con paneles diferenciados por rol.

**Historias seleccionadas del backlog:**

| Historia | Estimación (h) | Responsable |
|---|---|---|
| #5 Cliente completa su perfil | 2 | Equipo |
| #6 Agente registra y edita propiedades con fotos y características | 6 | Equipo |
| #7 Cliente busca y filtra propiedades | 3 | Equipo |
| #8 Cliente marca propiedades como favoritas | 2 | Equipo |
| Ficha de detalle de propiedad con galería de imágenes | 3 | Equipo |

**Definition of Done del sprint:** CRUD completo de propiedades (crear, editar, listar con filtros, baja lógica) con galería de imágenes y características asociadas; perfil de usuario editable; favoritos funcionando; todo validado en el servidor con transacciones donde aplique.

## Sprint Review

**Demostración funcional:**
- Listado de propiedades con filtros combinables por ciudad, tipo y rango de precio.
- Ficha de detalle de cada propiedad con su galería de imágenes (relación 1:N `propiedad`→`imagen_propiedad`).
- Formulario de creación y edición de propiedades, con selección de características (relación N:M vía `propiedad_caracteristica`), ejecutado dentro de una transacción (`setAutoCommit(false)` / `commit()` / `rollback()`).
- Restricción UNIQUE de `matricula_inmobiliaria` capturada con `SQLIntegrityConstraintViolationException` y traducida a un mensaje claro para el usuario.
- Baja lógica de propiedades (cambia `estado` a `INACTIVA` en vez de borrar la fila).
- Perfil de usuario (tabla `perfil`, relación 1:1) editable desde el panel del cliente.
- Favoritos: el cliente puede marcar y desmarcar propiedades sin duplicados (restricción UNIQUE en la tabla `favorito`).

**Historias completadas:** #5, #6, #7, #8.
**Historias pendientes:** ninguna del sprint.

## Sprint Retrospective

**Qué funcionó bien:**
- Reutilizar el mismo patrón de controlador (`acciones.jsp` por entidad, con el parámetro `accion` distinguiendo la operación) usado en el Sprint 1 aceleró la construcción del CRUD de propiedades: no hubo que diseñar una arquitectura nueva, solo aplicar la ya probada.
- Probar cada UNIQUE con un caso de duplicado real (por ejemplo, repetir una matrícula inmobiliaria) apenas se terminaba el formulario, en vez de dejarlo para el final, permitió detectar a tiempo que faltaba mostrar el mensaje de error en la vista.

**Qué se puede mejorar:**
- Definir desde el Sprint Planning en qué pantalla exacta se muestra cada mensaje de error de vuelta al usuario (parámro `err` en la URL), ya que en el Sprint 1 se detectó tarde que un formulario no estaba leyendo ese parámetro.

**Decisiones para el siguiente sprint:**
- Dejar para el Sprint 3 los módulos de citas y solicitudes, que son los últimos que faltan para completar el criterio de "Aplicación web funcional" de la rúbrica de evaluación.
- Documentar como decisión de alcance que el historial de auditoría (historia #13, prioridad Baja) no se implementará, dado el tiempo disponible para el Sprint 3.
