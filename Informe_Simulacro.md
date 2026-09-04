# Informe corto — Simulacro Inmobiliaria (JSP + JSPF + JDBC + MySQL)

## Que hace cada fragmento .jspf

**conexion.jspf**
Centraliza los datos de acceso a MySQL (driver, URL, usuario, clave) en un solo
lugar y expone tres metodos reutilizables: `abrirConexion()` (crea una conexion
nueva cargando el driver JDBC), `cerrar(...)` (cierra en orden inverso
cualquier combinacion de Connection/PreparedStatement/ResultSet sin obligar a
escribir un `finally` distinto en cada pagina), y `deshacer(con)` (ejecuta
`rollback()` de forma segura cuando una transaccion falla). Al estar dentro de
`/WEB-INF`, nadie puede acceder a este archivo escribiendo su URL en el
navegador, asi que la contrasena de la base de datos queda protegida.

**utilidades.jspf**
Reune funciones que se repetirian en todas las paginas: `sha256()` y
`claveCifrada()` cifran la contrasena del usuario combinandola con su nombre de
usuario antes de aplicar SHA-256 (asi dos usuarios con la misma clave nunca
tienen el mismo hash); `pesos()` formatea los precios en moneda colombiana;
`aEntero()`/`aDoble()` convierten parametros de formulario a numero sin que la
pagina se caiga si el dato viene vacio o alterado; `esc()` escapa caracteres
HTML para evitar ataques XSS al mostrar texto escrito por el usuario; y
`colorEstado()` devuelve el color de Bootstrap correspondiente al estado de
una propiedad.

**seguridad.jspf**
Controla el acceso por sesion y por rol. Cada pagina protegida declara, justo
antes de incluir este fragmento, el arreglo `rolesPermitidos` con los roles
autorizados a verla. El fragmento revisa si hay una sesion activa
(`session.getAttribute("idUsuario")`); si no la hay, redirige al login. Si hay
sesion pero el rol no esta en `rolesPermitidos`, redirige al panel de inicio
con un aviso de "sin permisos". Esto se ejecuta en el servidor en cada
peticion, por lo que ocultar un boton en el HTML no es control de acceso real:
aunque un usuario escriba la URL directamente, el fragmento lo bloquea.

**cabecera.jspf / pie.jspf**
Contienen el HTML repetido de todas las paginas (barra de navegacion con
Bootstrap 5, menu que cambia segun el rol de la sesion, y el cierre de la
pagina con el JavaScript de Bootstrap). Se separan en fragmentos para no
duplicar ese codigo en cada archivo .jsp.

## Por que se uso una transaccion al crear una propiedad

El controlador `propiedad/acciones.jsp` inserta una propiedad y,
opcionalmente, varias filas en la tabla intermedia
`propiedad_caracteristica` (una por cada caracteristica marcada en el
formulario). Estas son dos operaciones separadas contra la base de datos que
deben tener exito juntas o fallar juntas: si el `INSERT` de la propiedad
funciona pero uno de los `INSERT` de sus caracteristicas falla, quedaria una
propiedad "huerfana" sin sus caracteristicas completas, lo cual es un estado
inconsistente.

Por eso el controlador llama a `con.setAutoCommit(false)` antes de empezar,
ejecuta todas las operaciones, y solo si todas terminan sin error llama a
`con.commit()` para guardar los cambios de forma definitiva. Si en cualquier
punto ocurre una `SQLException` (por ejemplo, la matricula inmobiliaria
duplicada, que viola la restriccion `UNIQUE uq_propiedad_matricula`), el
bloque `catch` llama a `deshacer(con)` (que ejecuta `rollback()`), devolviendo
la base de datos exactamente al estado en que estaba antes del intento. Ademas,
la excepcion especifica `SQLIntegrityConstraintViolationException` se captura
aparte para traducir el mensaje tecnico del motor a uno que el usuario
entienda ("Ya existe una propiedad con esa matricula inmobiliaria") en vez de
mostrarle una excepcion cruda de Java.

## Control de acceso probado

Se verifico que un usuario con rol CLIENTE no puede acceder a
`propiedad/nueva.jsp` (reservada a INMOBILIARIA y ADMINISTRADOR) ni siquiera
escribiendo la URL directamente en el navegador: `seguridad.jspf` lo redirige
al panel de inicio con un aviso de permisos, confirmando que la validacion de
acceso ocurre en el servidor y no solo en la interfaz.
