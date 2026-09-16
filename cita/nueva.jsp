<%--
 cita/nueva.jsp - Formulario para agendar una cita sobre una propiedad.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Agendar cita";
    int idPropiedad = aEntero(request.getParameter("id"), 0);
    String err = request.getParameter("err");
    String titulo = "";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        ps = con.prepareStatement("SELECT titulo FROM propiedad WHERE id_propiedad = ?");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        if (rs.next()) titulo = rs.getString("titulo");
        cerrar(rs, ps, con);
    } catch (SQLException ex) { }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-calendar-plus"></i> Agendar cita</h3>
<p class="text-muted">Propiedad: <b><%= esc(titulo) %></b></p>

<% if (err != null) { %>
    <div class="alert alert-danger"><i class="bi bi-x-circle"></i> <%= esc(err) %></div>
<% } %>

<div class="card shadow-sm">
<div class="card-body">
    <form method="post" action="<%= ctx %>/cita/acciones.jsp">
        <input type="hidden" name="accion" value="crear">
        <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
        <div class="mb-3">
            <label class="form-label">Fecha y hora de la visita</label>
            <input type="datetime-local" class="form-control" name="fecha_hora" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Observaciones (opcional)</label>
            <textarea class="form-control" name="observaciones" rows="2" maxlength="255"></textarea>
        </div>
        <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-check2"></i> Agendar</button>
        <a href="<%= ctx %>/propiedad/detalle.jsp?id=<%= idPropiedad %>" class="btn btn-link">Cancelar</a>
    </form>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>