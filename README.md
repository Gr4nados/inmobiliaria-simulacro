# Inmobiliaria Web

Sistema web de gestión de propiedades para una inmobiliaria ficticia, desarrollado como
parcial de la asignatura **Programación Java** — Tecnología en Desarrollo de Sistemas
Informáticos, Unidades Tecnológicas de Santander.

**Docente:** Julian Barney Jaimes Rincon
**Integrantes:** Jhon Granados · Lewing Santiago Mendez Trillos

## Qué es esto

Una aplicación JSP + JSPF + JDBC + MySQL 8 + Bootstrap 5 (sin Servlets ni DAO, arquitectura
Modelo 1) que permite a una inmobiliaria publicar propiedades, y a los clientes buscarlas,
marcarlas como favoritas, agendar citas y radicar solicitudes de compra/arriendo.

📄 **[Ver el documento final completo](<4.%20Documento%20Final/Documento%20final.pdf>)** —
arquitectura, modelo de datos, cada módulo explicado con su código, las 5 consultas
obligatorias, metodología Scrum, pruebas unitarias y evidencia de funcionamiento.

## Roles del sistema

| Rol | Qué puede hacer |
|---|---|
| Visitante | Ver la landing, buscar y ver el detalle de propiedades. |
| Cliente | Registrarse, buscar/filtrar, marcar favoritos, agendar citas, radicar solicitudes. |
| Inmobiliaria (agente) | Publicar/editar/dar de baja sus propiedades, gestionar sus citas y solicitudes. |
| Administrador | Gestión de usuarios y roles, reportes. |

**Usuarios de prueba** (clave `1234` para todos): `admin`, `agente1`–`agente4`, `cliente1`–`cliente5`.

## Cómo levantarlo localmente

1. Ejecuta `2. Documentacion/01_base_datos_inmobiliaria_completo.sql` en tu MySQL 8 —
   crea el esquema `inmobiliaria_simulacro` con las 13 tablas y los datos de prueba.
2. Copia esta carpeta del proyecto a tu `webapps` de Apache Tomcat.
3. Ajusta usuario/clave de MySQL en `WEB-INF/jspf/conexion.jspf` si son distintos a los tuyos.
4. Entra a `http://localhost:8080/InmobiliariaWeb/`.

## Estructura del repositorio

```
1. Capturas/          Evidencia de funcionamiento (todas las pruebas realizadas)
2. Documentacion/      Script SQL, MER, diccionario de datos, casos de uso
3. Pruebas/            Pruebas unitarias (Java plano, no se despliega en Tomcat)
4. Documento Final/    Documento completo del proyecto
5. Scrum/              Product backlog y los 3 sprints (Planning/Review/Retrospective)
WEB-INF/               Configuración, fragmentos .jspf y driver JDBC
admin/ cita/ solicitud/ propiedad/   Módulos de la aplicación
*.jsp (raíz)           Autenticación, registro, landing e inicio
```

## Tecnologías

Java EE (JSP) · JDBC · MySQL 8 · Apache Tomcat · Bootstrap 5.3 · Git/GitHub
