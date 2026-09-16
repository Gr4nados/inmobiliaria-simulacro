<%--
 solicitud/nueva.jsp - Formulario para radicar una solicitud de compra/arriendo
 con sus documentos, sobre una propiedad.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Nueva solicitud";
    int idPropiedad = aEntero(request.getParameter("id"), 0);
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

<h3 class="mb-3"><i class="bi bi-file-earmark-text"></i> Solicitar propiedad</h3>
<p class="text-muted">Propiedad: <b><%= esc(titulo) %></b></p>

<div class="card shadow-sm">
<div class="card-body">
    <form method="post" action="<%= ctx %>/solicitud/acciones.jsp">
        <input type="hidden" name="accion" value="crear">
        <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
        <div class="mb-3">
            <label class="form-label">Tipo de solicitud</label>
            <select class="form-select" name="tipo" required>
                <option value="COMPRA">Compra</option>
                <option value="ARRIENDO">Arriendo</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Observaciones (opcional)</label>
            <textarea class="form-control" name="observaciones" rows="2" maxlength="255"></textarea>
        </div>
        <hr>
        <label class="form-label fw-bold">Documentos a radicar</label>
        <p class="small text-muted">Escribe el nombre de cada documento (ej: cedula.pdf).</p>
        <div class="row g-2 mb-2">
            <div class="col-md-8">
                <input type="text" class="form-control" name="nombreDoc" placeholder="cedula.pdf">
            </div>
            <div class="col-md-4">
                <select class="form-select" name="tipoDoc">
                    <option value="CEDULA">Cédula</option>
                    <option value="CERTIFICADO_LABORAL">Certificado laboral</option>
                    <option value="EXTRACTO_BANCARIO">Extracto bancario</option>
                </select>
            </div>
        </div>
        <div class="row g-2 mb-3">
            <div class="col-md-8">
                <input type="text" class="form-control" name="nombreDoc" placeholder="certificado_laboral.pdf (opcional)">
            </div>
            <div class="col-md-4">
                <select class="form-select" name="tipoDoc">
                    <option value="CERTIFICADO_LABORAL">Certificado laboral</option>
                    <option value="CEDULA">Cédula</option>
                    <option value="EXTRACTO_BANCARIO">Extracto bancario</option>
                </select>
            </div>
        </div>
        <button type="submit" class="btn btn-success fw-bold"><i class="bi bi-check2"></i> Radicar solicitud</button>
        <a href="<%= ctx %>/propiedad/detalle.jsp?id=<%= idPropiedad %>" class="btn btn-link">Cancelar</a>
    </form>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>