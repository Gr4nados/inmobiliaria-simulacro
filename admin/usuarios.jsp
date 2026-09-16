<%--
 admin/usuarios.jsp - El administrador asigna/revoca roles y activa/inactiva cuentas.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Gestión de usuarios";
    String msg = request.getParameter("msg");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-people"></i> Gestión de usuarios y roles</h3>
<% if (msg != null) { %><div class="alert alert-success"><%= esc(msg) %></div><% } %>

<div class="card shadow-sm">
<div class="table-responsive">
<table class="table table-hover align-middle mb-0">
<thead class="table-dark"><tr><th>Usuario</th><th>Correo</th><th>Rol actual</th><th>Estado</th><th></th></tr></thead>
<tbody>
<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    Statement st = null; ResultSet rsRol = null;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT u.id_usuario, u.username, u.correo, u.activo, r.nombre AS rol, u.id_rol "
          + "FROM usuario u JOIN rol r ON r.id_rol = u.id_rol ORDER BY u.username");
        rs = ps.executeQuery();
        while (rs.next()) {
            int idUsuario = rs.getInt("id_usuario");
%>
<tr>
    <td><%= esc(rs.getString("username")) %></td>
    <td class="small text-muted"><%= esc(rs.getString("correo")) %></td>
    <td>
        <form method="post" action="<%= ctx %>/admin/acciones.jsp" class="d-flex gap-1">
            <input type="hidden" name="accion" value="cambiarRol">
            <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
            <select class="form-select form-select-sm" name="id_rol" style="width:auto"
                    <%= idUsuario == idUsuarioSesion ? "disabled" : "" %>>
<%
        st = con.createStatement();
        rsRol = st.executeQuery("SELECT id_rol, nombre FROM rol ORDER BY id_rol");
        while (rsRol.next()) {
            String sel = rsRol.getInt("id_rol") == rs.getInt("id_rol") ? "selected" : "";
%>
                <option value="<%= rsRol.getInt("id_rol") %>" <%= sel %>><%= esc(rsRol.getString("nombre")) %></option>
<%      }
        cerrar(rsRol, st);
%>
            </select>
            <% if (idUsuario != idUsuarioSesion) { %>
            <button class="btn btn-sm btn-outline-dark"><i class="bi bi-check2"></i></button>
            <% } %>
        </form>
    </td>
    <td><span class="badge text-bg-<%= rs.getBoolean("activo") ? "success" : "secondary" %>">
        <%= rs.getBoolean("activo") ? "ACTIVO" : "INACTIVO" %></span></td>
    <td>
        <% if (idUsuario != idUsuarioSesion) { %>
        <form method="post" action="<%= ctx %>/admin/acciones.jsp">
            <input type="hidden" name="accion" value="toggleActivo">
            <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
            <input type="hidden" name="valor" value="<%= rs.getBoolean("activo") ? 0 : 1 %>">
            <button class="btn btn-sm btn-<%= rs.getBoolean("activo") ? "outline-danger" : "outline-success" %>">
                <%= rs.getBoolean("activo") ? "Inactivar" : "Activar" %></button>
        </form>
        <% } else { %>
            <span class="small text-muted">(tú)</span>
        <% } %>
    </td>
</tr>
<%      }
        cerrar(rs, ps, con);
    } catch (SQLException ex) {
%>
<tr><td colspan="5" class="text-danger">Error: <%= esc(ex.getMessage()) %></td></tr>
<% } %>
</tbody>
</table>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>