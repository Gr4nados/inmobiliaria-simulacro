<%--
 propiedad/listar.jsp - Lista las propiedades disponibles.
 Visible para los 3 roles; solo INMOBILIARIA/ADMINISTRADOR ven los botones de gestion.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA", "CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Propiedades";
    String msg = request.getParameter("msg");
    String err = request.getParameter("err");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="mb-0"><i class="bi bi-houses"></i> Propiedades</h3>
    <% if ("INMOBILIARIA".equals(rolSesion) || "ADMINISTRADOR".equals(rolSesion)) { %>
        <a href="<%= ctx %>/propiedad/nueva.jsp" class="btn btn-warning">
            <i class="bi bi-plus-circle"></i> Nueva propiedad</a>
    <% } %>
</div>

<% if (msg != null) { %>
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> <%= esc(msg) %>
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>
<% if (err != null) { %>
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle"></i> <%= esc(err) %>
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

<div class="card shadow-sm">
<div class="table-responsive">
    <table class="table table-hover align-middle mb-0">
        <thead class="table-dark">
            <tr>
                <th>Matricula</th><th>Titulo</th><th>Ciudad</th><th>Tipo</th>
                <th class="text-end">Precio</th><th>Estado</th><th>Agente</th><th></th>
            </tr>
        </thead>
        <tbody>
<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        // INNER JOIN de 3 tablas: propiedad + ciudad + tipo_propiedad (+ usuario)
        String sql =
            "SELECT pr.id_propiedad, pr.matricula_inmobiliaria, pr.titulo, pr.precio, pr.estado, "
          + "       c.nombre AS ciudad, t.nombre AS tipo, u.username AS agente "
          + "FROM propiedad pr "
          + "  JOIN ciudad c ON c.id_ciudad = pr.id_ciudad "
          + "  JOIN tipo_propiedad t ON t.id_tipo_propiedad = pr.id_tipo_propiedad "
          + "  JOIN usuario u ON u.id_usuario = pr.id_usuario "
          + "WHERE pr.estado <> 'INACTIVA' "
          + "ORDER BY pr.fecha_publicacion DESC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            filas++;
            int idPropiedad = rs.getInt("id_propiedad");
%>
            <tr>
                <td><code><%= esc(rs.getString("matricula_inmobiliaria")) %></code></td>
                <td><%= esc(rs.getString("titulo")) %></td>
                <td><%= esc(rs.getString("ciudad")) %></td>
                <td><%= esc(rs.getString("tipo")) %></td>
                <td class="text-end"><%= pesos(rs.getDouble("precio")) %></td>
                <td><span class="badge text-bg-<%= colorEstado(rs.getString("estado")) %>">
                    <%= rs.getString("estado") %></span></td>
                <td class="small text-muted"><%= esc(rs.getString("agente")) %></td>
                <td class="text-end">
                    <% if ("INMOBILIARIA".equals(rolSesion) || "ADMINISTRADOR".equals(rolSesion)) { %>
                        <form method="post" action="<%= ctx %>/propiedad/acciones.jsp"
                              class="d-inline"
                              onsubmit="return confirm('Dar de baja esta propiedad?')">
                            <input type="hidden" name="accion" value="baja">
                            <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
                            <button class="btn btn-sm btn-outline-danger">
                                <i class="bi bi-trash"></i></button>
                        </form>
                    <% } %>
                </td>
            </tr>
<%
        }
    } catch (SQLException ex) {
%>
        <tr><td colspan="8" class="text-danger">Error: <%= esc(ex.getMessage()) %></td></tr>
<%
    } finally { cerrar(rs, ps, con); }
    if (filas == 0) {
%>
        <tr><td colspan="8" class="text-center text-muted py-4">
            No hay propiedades registradas.</td></tr>
<% } %>
        </tbody>
    </table>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>