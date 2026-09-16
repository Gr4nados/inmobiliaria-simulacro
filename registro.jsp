<%--
 registro.jsp - Formulario publico de registro. Rol por defecto: CLIENTE.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = request.getParameter("err");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Crear cuenta | Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-dark d-flex align-items-center" style="min-height:100vh">
<div class="container" style="max-width:500px">
    <div class="card shadow-lg border-0">
        <div class="card-body p-4">
            <div class="text-center mb-3">
                <i class="bi bi-person-plus display-4 text-warning"></i>
                <h4 class="mt-2 mb-0 fw-bold">Crear cuenta</h4>
                <small class="text-muted">Regístrate para agendar citas y guardar favoritos</small>
            </div>
            <% if (error != null) { %>
                <div class="alert alert-danger py-2"><i class="bi bi-exclamation-triangle"></i> <%= error %></div>
            <% } %>
            <form method="post" action="<%= ctx %>/registrar.jsp">
                <div class="row g-2">
                    <div class="col-md-6">
                        <label class="form-label">Nombres</label>
                        <input type="text" class="form-control" name="nombres" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Apellidos</label>
                        <input type="text" class="form-control" name="apellidos" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Documento</label>
                        <input type="text" class="form-control" name="documento" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Teléfono</label>
                        <input type="text" class="form-control" name="telefono">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Dirección</label>
                        <input type="text" class="form-control" name="direccion">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Usuario</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Correo</label>
                        <input type="email" class="form-control" name="correo" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Contraseña</label>
                        <input type="password" class="form-control" name="clave" required minlength="4">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Confirmar</label>
                        <input type="password" class="form-control" name="clave2" required minlength="4">
                    </div>
                </div>
                <button type="submit" class="btn btn-warning w-100 fw-bold mt-3">
                    <i class="bi bi-check2"></i> Crear cuenta</button>
            </form>
            <p class="text-center small text-muted mt-3 mb-0">
                ¿Ya tienes cuenta? <a href="<%= ctx %>/login.jsp">Inicia sesión</a></p>
        </div>
    </div>
</div>
</body>
</html>