# Sprint 3 — Operación y cierre
**Duración:** 10/09/2026 – 20/09/2026
**Roles Scrum:** Product Owner: Docente Julian Barney Jaimes Rincon · Scrum Master / Development Team: Jhon Granados y [Nombre del compañero]

## Sprint Planning

**Objetivo del sprint:** completar citas, solicitudes y documentos, reportes con consultas de agregación, pruebas unitarias, y cerrar la documentación completa del proyecto.

**Historias seleccionadas del backlog:**

| Historia | Estimación (h) | Responsable |
|---|---|---|
| #9 Cliente solicita una cita | 3 | Equipo |
| #10 Cliente radica documentos y consulta el estado de su solicitud | 4 | Equipo |
| #11 Agente aprueba o rechaza solicitudes | 3 | Equipo |
| #12 Reporte de propiedades por ciudad/estado (agregación) | 3 | Equipo |
| Consultas obligatorias restantes (2do INNER JOIN, LEFT JOIN, N:M) | 2 | Equipo |
| Pruebas unitarias básicas | 2 | Equipo |
| Documentación final del proyecto | 3 | Equipo |

**Definition of Done del sprint:** módulos de citas y solicitudes en operación con sus respectivas restricciones UNIQUE; las 5 consultas obligatorias completas y documentadas; pruebas unitarias ejecutadas; documentación completa (MER, diccionario de datos, informe) lista para la sustentación.

## Sprint Review

**Demostración funcional:**
- Agendamiento de citas respetando la restricción UNIQUE (`id_propiedad`, `fecha_hora`), con mensaje claro si se intenta agendar dos visitas al mismo horario en la misma propiedad.
- Radicación de solicitudes de compra/arriendo por parte del cliente, con consulta del estado.
- Aprobación/rechazo de solicitudes por parte del agente, reflejado de inmediato para el cliente.
- Reporte de propiedades por ciudad y estado usando `GROUP BY`/`HAVING`.
- Las 5 consultas obligatorias completas: 2 `INNER JOIN` de 3+ tablas, 1 consulta que resuelve la relación N:M, 1 `LEFT JOIN`, y 1 de agregación con `GROUP BY`/`HAVING`.
- Pruebas unitarias básicas sobre la lógica de cifrado de contraseñas y las validaciones de formulario.

**Historias completadas:** #9, #10, #11, #12.
**Historia no implementada:** #13 (auditoría), decisión de alcance documentada desde la Retrospectiva del Sprint 2.

## Sprint Retrospective

**Qué funcionó bien:**
- Priorizar en cada sprint las historias que alimentan directamente los tres criterios de la rúbrica de evaluación (aplicación funcional, metodología Scrum, modelo de datos) permitió llegar al cierre del proyecto con el 100% de lo evaluable cubierto, a pesar de un cronograma real más apretado de lo planeado inicialmente.
- Reutilizar una tercera vez el mismo patrón de controlador por entidad (ya usado en propiedades y en el Sprint 1) hizo que citas y solicitudes se construyeran más rápido que los módulos anteriores.

**Qué se puede mejorar:**
- Documentar el backlog y los sprints de forma incremental, sprint a sprint, en vez de dejar la documentación Scrum completa para el cierre del proyecto — aunque el contenido documentado es fiel a lo realmente construido, hacerlo en tiempo real habría reducido la carga de trabajo en la última semana.
- Iniciar la consulta de requisitos ambiguos con el docente (como el caso del Filter de servlet) desde la primera semana del proyecto, no solo cuando se vuelven bloqueantes.

**Decisión de alcance documentada:** no se implementó la historia #13 (auditoría de accesos y cambios), de prioridad Baja y marcada como valor agregado opcional en el enunciado, para dedicar el tiempo disponible del Sprint 3 a las historias de mayor peso en la evaluación.
