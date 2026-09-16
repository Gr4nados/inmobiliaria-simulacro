<%--
 propiedad/listar.jsp - Catalogo publico de propiedades, con filtros.
 Visible para VISITANTE, CLIENTE, INMOBILIARIA y ADMINISTRADOR.
 Solo INMOBILIARIA/ADMINISTRADOR ven los botones de gestion.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%@ include file="/WEB-INF/jspf/sesionOpcional.jspf" %>
<%
    String tituloPagina = "Propiedades";
    String msg = request.getParameter("msg");
    String err = request.getParameter("err");
    String q = request.getParameter("q");
    String ciudadParam = request.getParameter("ciudad");
    String tipoParam = request.getParameter("tipo");
    String precioMin = request.getParameter("precioMin");
    String precioMax = request.getParameter("precioMax");
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

<!-- ================= Filtros ================= -->
<div class="card shadow-sm mb-3">
<div class="card-body">
    <form method="get" action="<%= ctx %>/propiedad/listar.jsp" class="row g-2">
        <div class="col-md-3">
            <input type="text" class="form-control" name="q" placeholder="Buscar por titulo"
                   value="<%= q == null ? "" : esc(q) %>">
        </div>
        <div class="col-md-2">
            <select class="form-select" name="ciudad">
                <option value="">Ciudad</option>
<%
    Connection con = null; Statement st = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        while (rs.next()) {
            String sel = String.valueOf(rs.getInt("id_ciudad")).equals(ciudadParam) ? "selected" : "";
%>
                <option value="<%= rs.getInt("id_ciudad") %>" <%= sel %>><%= esc(rs.getString("nombre")) %></option>
<%      }
        cerrar(rs, st);
    } catch (SQLException ex) { }
%>
            </select>
        </div>
        <div class="col-md-2">
            <select class="form-select" name="tipo">
                <option value="">Tipo</option>
<%
    try {
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_tipo_propiedad, nombre FROM tipo_propiedad ORDER BY nombre");
        while (rs.next()) {
            String sel = String.valueOf(rs.getInt("id_tipo_propiedad")).equals(tipoParam) ? "selected" : "";
%>
                <option value="<%= rs.getInt("id_tipo_propiedad") %>" <%= sel %>><%= esc(rs.getString("nombre")) %></option>
<%      }
    } catch (SQLException ex) { }
    finally { cerrar(rs, st, con); }
%>
            </select>
        </div>
        <div class="col-md-2">
            <input type="number" class="form-control" name="precioMin" placeholder="Precio min"
                   value="<%= precioMin == null ? "" : esc(precioMin) %>">
        </div>
        <div class="col-md-2">
            <input type="number" class="form-control" name="precioMax" placeholder="Precio max"
                   value="<%= precioMax == null ? "" : esc(precioMax) %>">
        </div>
        <div class="col-md-1 d-grid">
            <button class="btn btn-dark"><i class="bi bi-funnel"></i></button>
        </div>
    </form>
</div>
</div>

<div class="row g-3">
<%
    con = null; PreparedStatement ps = null; rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        StringBuilder sql = new StringBuilder(
            "SELECT pr.id_propiedad, pr.matricula_inmobiliaria, pr.titulo, pr.precio, pr.estado, "
          + "       c.nombre AS ciudad, t.nombre AS tipo, u.username AS agente, "
          + "       (SELECT url_imagen FROM imagen_propiedad ip WHERE ip.id_propiedad = pr.id_propiedad ORDER BY orden LIMIT 1) AS imagen "
          + "FROM propiedad pr "
          + "  JOIN ciudad c ON c.id_ciudad = pr.id_ciudad "
          + "  JOIN tipo_propiedad t ON t.id_tipo_propiedad = pr.id_tipo_propiedad "
          + "  JOIN usuario u ON u.id_usuario = pr.id_usuario "
          + "WHERE pr.estado <> 'INACTIVA' ");
        if (q != null && !q.trim().isEmpty()) sql.append(" AND pr.titulo LIKE ? ");
        if (ciudadParam != null && !ciudadParam.trim().isEmpty()) sql.append(" AND pr.id_ciudad = ? ");
        if (tipoParam != null && !tipoParam.trim().isEmpty()) sql.append(" AND pr.id_tipo_propiedad = ? ");
        if (precioMin != null && !precioMin.trim().isEmpty()) sql.append(" AND pr.precio >= ? ");
        if (precioMax != null && !precioMax.trim().isEmpty()) sql.append(" AND pr.precio <= ? ");
        sql.append(" ORDER BY pr.fecha_publicacion DESC");

        ps = con.prepareStatement(sql.toString());
        int i = 1;
        if (q != null && !q.trim().isEmpty()) ps.setString(i++, "%" + q.trim() + "%");
        if (ciudadParam != null && !ciudadParam.trim().isEmpty()) ps.setInt(i++, aEntero(ciudadParam, 0));
        if (tipoParam != null && !tipoParam.trim().isEmpty()) ps.setInt(i++, aEntero(tipoParam, 0));
        if (precioMin != null && !precioMin.trim().isEmpty()) ps.setDouble(i++, aDoble(precioMin, 0));
        if (precioMax != null && !precioMax.trim().isEmpty()) ps.setDouble(i++, aDoble(precioMax, 0));

        rs = ps.executeQuery();
        while (rs.next()) {
            filas++;
            int idPropiedad = rs.getInt("id_propiedad");
            String img = rs.getString("imagen");
            if (img == null) img = "https://picsum.photos/seed/default/800/600";
%>
    <div class="col-md-4">
        <div class="card h-100 shadow-sm">
            <img src="<%= img %>" class="card-img-top" style="height:170px;object-fit:cover" alt="">
            <div class="card-body">
                <h6><%= esc(rs.getString("titulo")) %></h6>
                <p class="small text-muted mb-1">
                    <i class="bi bi-geo-alt"></i> <%= esc(rs.getString("ciudad")) %> &middot; <%= esc(rs.getString("tipo")) %></p>
                <p class="fw-bold text-warning mb-1"><%= pesos(rs.getDouble("precio")) %></p>
                <span class="badge text-bg-<%= colorEstado(rs.getString("estado")) %> mb-2"><%= rs.getString("estado") %></span>
                               <div class="d-flex gap-1">
                    <a href="<%= ctx %>/propiedad/detalle.jsp?id=<%= idPropiedad %>" class="btn btn-sm btn-dark">
                        <i class="bi bi-eye"></i> Ver</a>
                    <% if ("INMOBILIARIA".equals(rolSesion) || "ADMINISTRADOR".equals(rolSesion)) { %>
                        <form method="post" action="<%= ctx %>/propiedad/acciones.jsp"
                              onsubmit="return confirm('Dar de baja esta propiedad?')">
                            <input type="hidden" name="accion" value="baja">
                            <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
<%
        }
    } catch (SQLException ex) {
%>
    <div class="col-12"><div class="alert alert-danger">Error: <%= esc(ex.getMessage()) %></div></div>
<%
    } finally { cerrar(rs, ps, con); }
    if (filas == 0) {
%>
    <div class="col-12"><div class="alert alert-secondary text-center py-4">No se encontraron propiedades con esos filtros.</div></div>
<% } %>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>