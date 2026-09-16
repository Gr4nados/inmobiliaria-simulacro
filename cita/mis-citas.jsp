<%--
 cita/mis-citas.jsp - Lista las citas del cliente que inicio sesion.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Mis citas";
    String msg = request.getParameter("msg");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-calendar-check"></i> Mis citas</h3>
<% if (msg != null) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
<% } %>

<div class="card shadow-sm">
<div class="table-responsive">
<table class="table table-hover align-middle mb-0">
<thead class="table-dark"><tr><th>Propiedad</th><th>Fecha y hora</th><th>Estado</th><th></th></tr></thead>
<tbody>
<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT c.id_cita, c.fecha_hora, c.estado, p.titulo "
          + "FROM cita c JOIN propiedad p ON p.id_propiedad = c.id_propiedad "
          + "WHERE c.id_cliente = ? ORDER BY c.fecha_hora DESC");
        ps.setInt(1, idUsuarioSesion);
        rs = ps.executeQuery();
        while (rs.next()) {
            filas++;
            String estado = rs.getString("estado");
%>
<tr>
    <td><%= esc(rs.getString("titulo")) %></td>
    <td><%= rs.getTimestamp("fecha_hora") %></td>
    <td><span class="badge text-bg-<%= colorEstado(estado) %>"><%= estado %></span></td>
    <td>
        <% if ("PENDIENTE".equals(estado) || "CONFIRMADA".equals(estado)) { %>
        <form method="post" action="<%= ctx %>/cita/acciones.jsp" onsubmit="return confirm('Cancelar esta cita?')">
            <input type="hidden" name="accion" value="cancelar">
            <input type="hidden" name="id_cita" value="<%= rs.getInt("id_cita") %>">
            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-x-circle"></i></button>
        </form>
        <% } %>
    </td>
</tr>
<%      }
    } catch (SQLException ex) {
%>
<tr><td colspan="4" class="text-danger">Error: <%= esc(ex.getMessage()) %></td></tr>
<%
    } finally { cerrar(rs, ps, con); }
    if (filas == 0) {
%>
<tr><td colspan="4" class="text-center text-muted py-4">Aun no tienes citas agendadas.</td></tr>
<% } %>
</tbody>
</table>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>