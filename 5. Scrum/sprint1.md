# Sprint 1 — Cimientos y acceso
**Duración:** 27/08/2026 – 02/09/2026 (7 días)
**Roles Scrum:** Product Owner: Docente Julian Barney Jaimes Rincon · Scrum Master / Development Team: Jhon Granados y [Nombre del compañero]

## Sprint Planning

**Objetivo del sprint:** dejar el modelo de datos diseñado y probado, la conexión JDBC centralizada, la landing page pública, y el módulo de autenticación con control de acceso por rol funcionando de punta a punta.

**Historias seleccionadas del backlog:**

| Historia | Estimación (h) | Responsable |
|---|---|---|
| #1 Landing page para visitantes | 4 | Equipo |
| #2 Registro con correo único | 3 | Equipo |
| #3 Inicio/cierre de sesión seguro por rol | 5 | Equipo |
| #4 Administrador asigna y revoca roles | 2 | Equipo |
| Diseño del modelo de datos (MER + relacional 3FN + DDL/DML) | 4 | Equipo |
| Conexión JDBC centralizada (`conexion.jspf`) | 1 | Equipo |

**Definition of Done del sprint:** modelo de datos documentado y cargado en MySQL con datos de prueba; conexión verificada desde la aplicación; landing pública responsiva; registro, login y logout funcionando; control de acceso por rol validado en el servidor (`seguridad.jspf`), no solo ocultando opciones en la vista.

## Sprint Review

**Demostración funcional:**
- Modelo de datos cargado en MySQL: 8+ tablas con relaciones 1:1 (`usuario`–`perfil`), 1:N (`rol`→`usuario`, `usuario`→`propiedad`, `ciudad`/`tipo_propiedad`→`propiedad`) y N:M (`propiedad`↔`caracteristica`), y restricciones UNIQUE (correo, username, matrícula inmobiliaria, entre otras).
- Conexión JDBC probada exitosamente desde `prueba_conexion.jsp`.
- Login funcionando con los tres roles del sistema (ADMINISTRADOR, INMOBILIARIA, CLIENTE), con contraseña cifrada (SHA-256 con salt) y sesión `HttpSession`.
- `seguridad.jspf` bloqueando correctamente el acceso a rutas privadas cuando un usuario no autenticado o sin el rol requerido intenta ingresar escribiendo la URL directamente.
- Landing page pública y responsiva con Bootstrap 5.

**Historias completadas:** #1, #2, #3, #4.
**Historias pendientes:** ninguna del sprint.

## Sprint Retrospective

**Qué funcionó bien:**
- Adoptar el patrón de arquitectura Modelo 1 (JSP + fragmentos `.jspf`) desde el inicio, siguiendo un ejemplo guiado entregado por el docente, permitió avanzar con una estructura clara desde el primer día.
- Centralizar la conexión JDBC y las utilidades comunes (`utilidades.jspf`) evitó duplicar código en cada página.
- Aislar el problema del login con páginas de diagnóstico temporales (comparando el hash calculado contra el guardado en la base de datos) permitió encontrar rápido un error de corrupción de caracteres al copiar y pegar código, en vez de perder tiempo revisando la lógica que sí estaba correcta.

**Qué se puede mejorar:**
- Verificar cada archivo copiado con una prueba inmediata, en vez de copiar varios archivos seguidos y probar hasta el final — esto habría evitado retrabajo al aislar en qué archivo específico estaba el problema de corrupción de caracteres.
- Confirmar con el docente por escrito, desde el día 1, los requisitos que generan ambigüedad respecto a lo visto en clase (en este caso, el uso de un `Filter` de servlet vs. control de acceso con JSPF), para no dejarlo para más adelante.

**Decisiones para el siguiente sprint:**
- Mantener el control de acceso con `seguridad.jspf` (confirmado con el docente: válido dado que el tema de Servlets aún no se ha explicado en clase).
- Priorizar en el Sprint 2 las historias que alimentan directamente el criterio de evaluación "Aplicación web funcional" antes que funcionalidades no evaluadas explícitamente en la rúbrica.
