<%--
 cita/agenda.jsp - Agenda de citas para el agente (solo sus propiedades) o el administrador (todas).
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"INMOBILIARIA", "ADMINISTRADOR"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Agenda de citas";
    String msg = request.getParameter("msg");
    boolean esAdmin = "ADMINISTRADOR".equals(rolSesion);
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-calendar-week"></i> Agenda de citas</h3>
<% if (msg != null) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
<% } %>

<div class="card shadow-sm">
<div class="table-responsive">
<table class="table table-hover align-middle mb-0">
<thead class="table-dark"><tr><th>Propiedad</th><th>Cliente</th><th>Fecha y hora</th><th>Estado</th><th></th></tr></thead>
<tbody>
<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        String sql =
            "SELECT c.id_cita, c.fecha_hora, c.estado, p.titulo, u.username AS cliente "
          + "FROM cita c "
          + "  JOIN propiedad p ON p.id_propiedad = c.id_propiedad "
          + "  JOIN usuario u ON u.id_usuario = c.id_cliente "
          + (esAdmin ? "" : "WHERE p.id_usuario = ? ")
          + "ORDER BY c.fecha_hora DESC";
        ps = con.prepareStatement(sql);
        if (!esAdmin) ps.setInt(1, idUsuarioSesion);
        rs = ps.executeQuery();
        while (rs.next()) {
            filas++;
            String estado = rs.getString("estado");
            int idCita = rs.getInt("id_cita");
%>
<tr>
    <td><%= esc(rs.getString("titulo")) %></td>
    <td><%= esc(rs.getString("cliente")) %></td>
    <td><%= rs.getTimestamp("fecha_hora") %></td>
    <td><span class="badge text-bg-<%= colorEstado(estado) %>"><%= estado %></span></td>
    <td class="d-flex gap-1">
        <% if ("PENDIENTE".equals(estado)) { %>
        <form method="post" action="<%= ctx %>/cita/acciones.jsp">
            <input type="hidden" name="accion" value="confirmar">
            <input type="hidden" name="id_cita" value="<%= idCita %>">
            <button class="btn btn-sm btn-success"><i class="bi bi-check2"></i></button>
        </form>
        <% } %>
        <% if ("CONFIRMADA".equals(estado)) { %>
        <form method="post" action="<%= ctx %>/cita/acciones.jsp">
            <input type="hidden" name="accion" value="realizada">
            <input type="hidden" name="id_cita" value="<%= idCita %>">
            <button class="btn btn-sm btn-primary"><i class="bi bi-flag"></i></button>
        </form>
        <% } %>
        <% if (!"CANCELADA".equals(estado) && !"REALIZADA".equals(estado)) { %>
        <form method="post" action="<%= ctx %>/cita/acciones.jsp" onsubmit="return confirm('Cancelar esta cita?')">
            <input type="hidden" name="accion" value="cancelar">
            <input type="hidden" name="id_cita" value="<%= idCita %>">
            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-x-circle"></i></button>
        </form>
        <% } %>
    </td>
</tr>
<%      }
    } catch (SQLException ex) {
%>
<tr><td colspan="5" class="text-danger">Error: <%= esc(ex.getMessage()) %></td></tr>
<%
    } finally { cerrar(rs, ps, con); }
    if (filas == 0) {
%>
<tr><td colspan="5" class="text-center text-muted py-4">No hay citas registradas.</td></tr>
<% } %>
</tbody>
</table>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>