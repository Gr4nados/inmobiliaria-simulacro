<%--
 propiedad/detalle.jsp - Ficha de detalle con galeria, caracteristicas,
 y accesos a favoritos/citas/solicitud. Publica (visitante puede verla).
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%@ include file="/WEB-INF/jspf/sesionOpcional.jspf" %>
<%
    String tituloPagina = "Detalle de propiedad";
    int idPropiedad = aEntero(request.getParameter("id"), 0);
    String msg = request.getParameter("msg");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<% if (msg != null) { %>
    <div class="alert alert-success"><i class="bi bi-check-circle"></i> <%= esc(msg) %></div>
<% } %>

<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    boolean existe = false;
    String titulo = "", descripcion = "", ciudad = "", tipo = "", estado = "", matricula = "";
    double precio = 0;
    int idAgente = 0;
        boolean esFavorito = false;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT pr.titulo, pr.descripcion, pr.precio, pr.estado, pr.matricula_inmobiliaria, "
          + "       c.nombre AS ciudad, t.nombre AS tipo, pr.id_usuario "
          + "FROM propiedad pr "
          + "  JOIN ciudad c ON c.id_ciudad = pr.id_ciudad "
          + "  JOIN tipo_propiedad t ON t.id_tipo_propiedad = pr.id_tipo_propiedad "
          + "WHERE pr.id_propiedad = ?");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        if (rs.next()) {
            existe = true;
            titulo = rs.getString("titulo");
            descripcion = rs.getString("descripcion");
            precio = rs.getDouble("precio");
            estado = rs.getString("estado");
            matricula = rs.getString("matricula_inmobiliaria");
            ciudad = rs.getString("ciudad");
            tipo = rs.getString("tipo");
            idAgente = rs.getInt("id_usuario");
        }
            if (existe && idUsuarioSesion != null) {
        ps = con.prepareStatement(
            "SELECT id_favorito FROM favorito WHERE id_usuario = ? AND id_propiedad = ?");
        ps.setInt(1, idUsuarioSesion);
        ps.setInt(2, idPropiedad);
        rs = ps.executeQuery();
        esFavorito = rs.next();
        cerrar(rs, ps);
    }
        cerrar(rs, ps);
    } catch (SQLException ex) {
        request.setAttribute("errorBD", ex.getMessage());
    }
%>

<% if (!existe) { %>
    <div class="alert alert-danger">La propiedad solicitada no existe.</div>
<% } else { %>

<div class="row g-4">
    <div class="col-lg-7">
        <!-- ================= Galeria ================= -->
        <div id="galeria" class="carousel slide shadow-sm rounded" data-bs-ride="carousel">
            <div class="carousel-inner rounded">
<%
    try {
        ps = con.prepareStatement(
            "SELECT url_imagen FROM imagen_propiedad WHERE id_propiedad = ? ORDER BY orden");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        int i = 0;
        boolean alguna = false;
        while (rs.next()) {
            alguna = true;
%>
                <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                    <img src="<%= rs.getString("url_imagen") %>" class="d-block w-100" style="height:380px;object-fit:cover" alt="">
                </div>
<%
            i++;
        }
        if (!alguna) {
%>
                <div class="carousel-item active">
                    <img src="https://picsum.photos/seed/default/800/600" class="d-block w-100" style="height:380px;object-fit:cover" alt="">
                </div>
<%
        }
        cerrar(rs, ps);
    } catch (SQLException ex) { }
%>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#galeria" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span></button>
            <button class="carousel-control-next" type="button" data-bs-target="#galeria" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span></button>
        </div>

        <h3 class="mt-3"><%= esc(titulo) %></h3>
        <p class="text-muted"><i class="bi bi-geo-alt"></i> <%= esc(ciudad) %> &middot; <%= esc(tipo) %>
            &middot; <code><%= esc(matricula) %></code>
            &middot; <span class="badge text-bg-<%= colorEstado(estado) %>"><%= estado %></span></p>
        <p><%= esc(descripcion) %></p>

        <h6>Caracteristicas</h6>
        <div class="mb-3">
<%
    try {
        ps = con.prepareStatement(
            "SELECT c.nombre FROM propiedad_caracteristica pc "
          + "JOIN caracteristica c ON c.id_caracteristica = pc.id_caracteristica "
          + "WHERE pc.id_propiedad = ?");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        while (rs.next()) {
%>
            <span class="badge text-bg-light border me-1"><%= esc(rs.getString("nombre")) %></span>
<%
        }
        cerrar(rs, ps);
    } catch (SQLException ex) { }
%>
        </div>
    </div>

    <!-- ================= Panel de acciones ================= -->
    <div class="col-lg-5">
        <div class="card shadow-sm">
            <div class="card-body">
                <h3 class="text-warning fw-bold"><%= pesos(precio) %></h3>

                <% if ("ADMINISTRADOR".equals(rolSesion) || (idUsuarioSesion != null && idUsuarioSesion == idAgente)) { %>
                    <a href="<%= ctx %>/propiedad/editar.jsp?id=<%= idPropiedad %>" class="btn btn-outline-dark w-100 mb-2">
                        <i class="bi bi-pencil"></i> Editar propiedad</a>
                <% } %>

                <% if ("CLIENTE".equals(rolSesion)) { %>
                    <form method="post" action="<%= ctx %>/propiedad/acciones.jsp" class="d-grid mb-2">
    <input type="hidden" name="accion" value="favorito">
    <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
    <button class="btn <%= esFavorito ? "btn-danger" : "btn-outline-danger" %>">
        <i class="bi bi-heart<%= esFavorito ? "-fill" : "" %>"></i>
        <%= esFavorito ? "Marcada como favorita" : "Marcar como favorita" %>
    </button>
</form>
<a href="<%= ctx %>/propiedad/favoritos.jsp" class="btn btn-link btn-sm w-100">Ver mis favoritos</a>
                    <a href="<%= ctx %>/cita/nueva.jsp?id=<%= idPropiedad %>" class="btn btn-primary w-100 mb-2">
                        <i class="bi bi-calendar-plus"></i> Agendar cita</a>
                    <a href="<%= ctx %>/solicitud/nueva.jsp?id=<%= idPropiedad %>" class="btn btn-success w-100">
                        <i class="bi bi-file-earmark-text"></i> Solicitar compra/arriendo</a>
                <% } else if (idUsuarioSesion == null) { %>
                    <div class="alert alert-warning small">
                        <a href="<%= ctx %>/login.jsp">Inicia sesión</a> o
                        <a href="<%= ctx %>/registro.jsp">regístrate</a> para agendar una cita o hacer una solicitud.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<% } %>
<%@ include file="/WEB-INF/jspf/pie.jspf" %>