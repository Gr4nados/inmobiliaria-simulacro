
<%--
 propiedad/editar.jsp - Formulario de edicion de una propiedad existente.
 No modifica las imagenes (se mantienen las ya cargadas), solo datos y caracteristicas.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Editar propiedad";
    int idPropiedad = aEntero(request.getParameter("id"), 0);
    String matricula = "", titulo = "", descripcion = "";
    double precio = 0;
    int idCiudadActual = 0, idTipoActual = 0;
    java.util.Set<Integer> caracSeleccionadas = new java.util.HashSet<>();

    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT matricula_inmobiliaria, titulo, descripcion, precio, id_ciudad, id_tipo_propiedad "
          + "FROM propiedad WHERE id_propiedad = ?");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        if (rs.next()) {
            matricula = rs.getString("matricula_inmobiliaria");
            titulo = rs.getString("titulo");
            descripcion = rs.getString("descripcion");
            precio = rs.getDouble("precio");
            idCiudadActual = rs.getInt("id_ciudad");
            idTipoActual = rs.getInt("id_tipo_propiedad");
        }
        cerrar(rs, ps);

        ps = con.prepareStatement("SELECT id_caracteristica FROM propiedad_caracteristica WHERE id_propiedad = ?");
        ps.setInt(1, idPropiedad);
        rs = ps.executeQuery();
        while (rs.next()) caracSeleccionadas.add(rs.getInt("id_caracteristica"));
        cerrar(rs, ps);
    } catch (SQLException ex) {
        request.setAttribute("errorBD", ex.getMessage());
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-pencil"></i> Editar propiedad <code><%= esc(matricula) %></code></h3>

<div class="card shadow-sm">
<div class="card-body">
    <form method="post" action="<%= ctx %>/propiedad/acciones.jsp">
        <input type="hidden" name="accion" value="editar">
        <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
        <div class="row g-3">
            <div class="col-md-12">
                <label class="form-label">Titulo</label>
                <input type="text" class="form-control" name="titulo" required maxlength="120" value="<%= esc(titulo) %>">
            </div>
            <div class="col-12">
                <label class="form-label">Descripcion</label>
                <textarea class="form-control" name="descripcion" rows="2" maxlength="500"><%= esc(descripcion) %></textarea>
            </div>
            <div class="col-md-4">
                <label class="form-label">Precio</label>
                <input type="number" class="form-control" name="precio" required min="0" step="1000" value="<%= (long) precio %>">
            </div>
            <div class="col-md-4">
                <label class="form-label">Ciudad</label>
                <select class="form-select" name="id_ciudad" required>
<%
    try {
        Statement st = con.createStatement();
        rs = st.executeQuery("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        while (rs.next()) {
            String sel = rs.getInt("id_ciudad") == idCiudadActual ? "selected" : "";
%>
                    <option value="<%= rs.getInt("id_ciudad") %>" <%= sel %>><%= esc(rs.getString("nombre")) %></option>
<%      }
        cerrar(rs, st);
    } catch (SQLException ex) { }
%>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Tipo de propiedad</label>
                <select class="form-select" name="id_tipo_propiedad" required>
<%
    try {
        Statement st = con.createStatement();
        rs = st.executeQuery("SELECT id_tipo_propiedad, nombre FROM tipo_propiedad ORDER BY nombre");
        while (rs.next()) {
            String sel = rs.getInt("id_tipo_propiedad") == idTipoActual ? "selected" : "";
%>
                    <option value="<%= rs.getInt("id_tipo_propiedad") %>" <%= sel %>><%= esc(rs.getString("nombre")) %></option>
<%      }
        cerrar(rs, st);
    } catch (SQLException ex) { }
    finally { cerrar(con); }
%>
                </select>
            </div>
            <div class="col-12">
                <label class="form-label">Caracteristicas</label>
                <div class="d-flex flex-wrap gap-3">
<%
    Connection con2 = null; Statement st2 = null; ResultSet rs2 = null;
    try {
        con2 = abrirConexion();
        st2 = con2.createStatement();
        rs2 = st2.executeQuery("SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre");
        while (rs2.next()) {
            int idc = rs2.getInt("id_caracteristica");
            String checked = caracSeleccionadas.contains(idc) ? "checked" : "";
%>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="caracteristicas"
                               value="<%= idc %>" id="car<%= idc %>" <%= checked %>>
                        <label class="form-check-label" for="car<%= idc %>"><%= esc(rs2.getString("nombre")) %></label>
                    </div>
<%      }
    } catch (SQLException ex) { out.println(esc(ex.getMessage())); }
    finally { cerrar(rs2, st2, con2); }
%>
                </div>
            </div>
        </div>
        <div class="mt-4">
            <button type="submit" class="btn btn-warning fw-bold"><i class="bi bi-check2"></i> Guardar cambios</button>
            <a href="<%= ctx %>/propiedad/detalle.jsp?id=<%= idPropiedad %>" class="btn btn-link">Cancelar</a>
        </div>
    </form>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>