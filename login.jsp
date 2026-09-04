<%--
 login.jsp - Formulario de inicio de sesion. Es la unica pagina publica.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = request.getParameter("error");
    String mensaje = null;
    if ("clave".equals(error))    mensaje = "Usuario o clave incorrectos.";
    if ("sesion".equals(error))   mensaje = "Debe iniciar sesion para continuar.";
    if ("vacio".equals(error))    mensaje = "Escriba el usuario y la clave.";
    if ("inactivo".equals(error)) mensaje = "El usuario esta inhabilitado.";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar sesion | Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-dark d-flex align-items-center" style="min-height:100vh">
<div class="container" style="max-width:420px">
    <div class="card shadow-lg border-0">
        <div class="card-body p-4">
            <div class="text-center mb-4">
                <i class="bi bi-building display-4 text-warning"></i>
                <h4 class="mt-2 mb-0 fw-bold">Inmobiliaria</h4>
                <small class="text-muted">Sistema de gestion de propiedades</small>
            </div>
            <% if (mensaje != null) { %>
                <div class="alert alert-danger py-2">
                    <i class="bi bi-exclamation-triangle"></i> <%= mensaje %>
                </div>
            <% } %>
            <form method="post" action="<%= ctx %>/acceso.jsp">
                <div class="mb-3">
                    <label class="form-label" for="usuario">Usuario</label>
                    <input type="text" class="form-control" id="usuario" name="usuario"
                           required autofocus placeholder="admin">
                </div>
                <div class="mb-4">
                    <label class="form-label" for="clave">Clave</label>
                    <input type="password" class="form-control" id="clave" name="clave"
                           required placeholder="********">
                </div>
                <button type="submit" class="btn btn-warning w-100 fw-bold">
                    <i class="bi bi-box-arrow-in-right"></i> Ingresar
                </button>
            </form>
            <hr class="my-4">
            <p class="small text-muted mb-1"><b>Usuarios de prueba</b> (clave: 1234)</p>
            <ul class="small text-muted mb-0">
                <li>admin &middot; agente1 &middot; cliente1</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>