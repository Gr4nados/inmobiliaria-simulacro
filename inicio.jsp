<%--
 inicio.jsp - Panel principal segun el rol del usuario.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA", "CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Inicio";
    int totalPropiedades = 0;
    Connection con = null; Statement st = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery("SELECT COUNT(*) AS total FROM propiedad WHERE estado = 'DISPONIBLE'");
        if (rs.next()) totalPropiedades = rs.getInt("total");
    } catch (SQLException ex) {
        request.setAttribute("errorBD", ex.getMessage());
    } finally { cerrar(rs, st, con); }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-1">Hola, <%= esc(nombreSesion) %></h3>
<p class="text-muted">Panel de control del rol <%= rolSesion.toLowerCase() %>.</p>

<% if ("permiso".equals(request.getParameter("error"))) { %>
    <div class="alert alert-warning">
        <i class="bi bi-shield-lock"></i> No tiene permisos para entrar a esa seccion.</div>
<% } %>

<div class="row g-3 mb-4">
    <div class="col-6 col-lg-3">
        <div class="card border-0 shadow-sm text-center h-100">
            <div class="card-body">
                <i class="bi bi-houses fs-2 text-warning"></i>
                <h3 class="mt-2 mb-0"><%= totalPropiedades %></h3>
                <small class="text-muted">Propiedades disponibles</small>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
    <% if ("INMOBILIARIA".equals(rolSesion) || "ADMINISTRADOR".equals(rolSesion)) { %>
    <div class="col-md-4">
        <div class="card h-100 shadow-sm">
            <div class="card-body">
                <h5><i class="bi bi-houses text-warning"></i> Gestionar propiedades</h5>
                <p class="small text-muted">Publicar, editar y dar de baja propiedades.</p>
                <a href="<%= ctx %>/propiedad/listar.jsp" class="btn btn-warning btn-sm">Entrar</a>
            </div>
        </div>
    </div>
    <% } %>
    <% if ("CLIENTE".equals(rolSesion)) { %>
    <div class="col-md-4">
        <div class="card h-100 shadow-sm">
            <div class="card-body">
                <h5><i class="bi bi-search text-primary"></i> Buscar propiedades</h5>
                <p class="small text-muted">Explora el catalogo disponible.</p>
                <a href="<%= ctx %>/propiedad/listar.jsp" class="btn btn-primary btn-sm">Entrar</a>
            </div>
        </div>
    </div>
    <% } %>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>