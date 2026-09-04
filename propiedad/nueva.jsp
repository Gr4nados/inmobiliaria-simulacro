<%--
 propiedad/nueva.jsp - Formulario para publicar una propiedad nueva.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<% String tituloPagina = "Nueva propiedad"; %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>
<% if (request.getParameter("err") != null) { %>
    <div class="alert alert-danger">
        <i class="bi bi-x-circle"></i> <%= esc(request.getParameter("err")) %>
    </div>
<% } %>

<h3 class="mb-3"><i class="bi bi-plus-circle"></i> Publicar propiedad</h3>

<div class="card shadow-sm">
<div class="card-body">
    <form method="post" action="<%= ctx %>/propiedad/acciones.jsp">
        <input type="hidden" name="accion" value="crear">
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label" for="matricula">Matricula inmobiliaria</label>
                <input type="text" class="form-control" id="matricula" name="matricula"
                       required maxlength="30" placeholder="MI-0004">
            </div>
            <div class="col-md-8">
                <label class="form-label" for="titulo">Titulo</label>
                <input type="text" class="form-control" id="titulo" name="titulo"
                       required maxlength="120">
            </div>
            <div class="col-12">
                <label class="form-label" for="descripcion">Descripcion</label>
                <textarea class="form-control" id="descripcion" name="descripcion"
                          rows="2" maxlength="500"></textarea>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="precio">Precio</label>
                <input type="number" class="form-control" id="precio" name="precio"
                       required min="0" step="1000">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="ciudad">Ciudad</label>
                <select class="form-select" id="ciudad" name="id_ciudad" required>
<%
    Connection con = null; Statement st = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        while (rs.next()) {
%>
                    <option value="<%= rs.getInt("id_ciudad") %>"><%= esc(rs.getString("nombre")) %></option>
<%
        }
        cerrar(rs, st);
    } catch (SQLException ex) { out.println("<option>" + esc(ex.getMessage()) + "</option>"); }
%>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="tipo">Tipo de propiedad</label>
                <select class="form-select" id="tipo" name="id_tipo_propiedad" required>
<%
    try {
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_tipo_propiedad, nombre FROM tipo_propiedad ORDER BY nombre");
        while (rs.next()) {
%>
                    <option value="<%= rs.getInt("id_tipo_propiedad") %>"><%= esc(rs.getString("nombre")) %></option>
<%
        }
    } catch (SQLException ex) { out.println("<option>" + esc(ex.getMessage()) + "</option>"); }
    finally { cerrar(rs, st, con); }
%>
                </select>
            </div>
            <div class="col-12">
                <label class="form-label">Caracteristicas</label>
                <div class="d-flex flex-wrap gap-3">
<%
    con = null; st = null; rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre");
        while (rs.next()) {
%>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="caracteristicas"
                               value="<%= rs.getInt("id_caracteristica") %>"
                               id="car<%= rs.getInt("id_caracteristica") %>">
                        <label class="form-check-label" for="car<%= rs.getInt("id_caracteristica") %>">
                            <%= esc(rs.getString("nombre")) %></label>
                    </div>
<%
        }
    } catch (SQLException ex) { out.println(esc(ex.getMessage())); }
    finally { cerrar(rs, st, con); }
%>
                </div>
            </div>
        </div>
        <div class="mt-4">
            <button type="submit" class="btn btn-warning fw-bold">
                <i class="bi bi-check2"></i> Publicar</button>
            <a href="<%= ctx %>/propiedad/listar.jsp" class="btn btn-link">Cancelar</a>
        </div>
    </form>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>