<%--
 solicitud/mis-solicitudes.jsp - Lista las solicitudes del cliente con sus documentos.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Mis solicitudes";
    String msg = request.getParameter("msg");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-file-earmark-text"></i> Mis solicitudes</h3>
<% if (msg != null) { %><div class="alert alert-success"><%= esc(msg) %></div><% } %>

<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT s.id_solicitud, s.tipo, s.estado, s.fecha_solicitud, p.titulo "
          + "FROM solicitud s JOIN propiedad p ON p.id_propiedad = s.id_propiedad "
          + "WHERE s.id_cliente = ? ORDER BY s.fecha_solicitud DESC");
        ps.setInt(1, idUsuarioSesion);
        rs = ps.executeQuery();
        while (rs.next()) {
            filas++;
            int idSolicitud = rs.getInt("id_solicitud");
            String estado = rs.getString("estado");
%>
<div class="card shadow-sm mb-2">
    <div class="card-body">
        <div class="d-flex justify-content-between">
            <div>
                <h6 class="mb-1"><%= esc(rs.getString("titulo")) %>
                    <span class="badge text-bg-light border"><%= rs.getString("tipo") %></span></h6>
                <small class="text-muted">Radicada: <%= rs.getTimestamp("fecha_solicitud") %></small>
            </div>
            <span class="badge text-bg-<%= colorEstado(estado) %> align-self-start"><%= estado %></span>
        </div>
        <hr class="my-2">
        <small class="text-muted">Documentos:</small>
        <ul class="small mb-0">
<%
    PreparedStatement psDoc = con.prepareStatement(
        "SELECT nombre_archivo, tipo_documento FROM documento_solicitud WHERE id_solicitud = ?");
    psDoc.setInt(1, idSolicitud);
    ResultSet rsDoc = psDoc.executeQuery();
    boolean algunDoc = false;
    while (rsDoc.next()) {
        algunDoc = true;
%>
            <li><%= esc(rsDoc.getString("nombre_archivo")) %> (<%= rsDoc.getString("tipo_documento") %>)</li>
<%  }
    if (!algunDoc) { %><li class="text-muted">Sin documentos</li><% }
    cerrar(rsDoc, psDoc);
%>
        </ul>
    </div>
</div>
<%      }
    } catch (SQLException ex) {
%>
<div class="alert alert-danger">Error: <%= esc(ex.getMessage()) %></div>
<%
    } finally { cerrar(rs, ps, con); }
    if (filas == 0) {
%>
<div class="alert alert-secondary text-center py-4">Aun no has radicado solicitudes.</div>
<% } %>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>