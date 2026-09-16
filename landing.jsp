<%--
 landing.jsp - Pagina publica. Buscador rapido y propiedades destacadas.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%@ include file="/WEB-INF/jspf/sesionOpcional.jspf" %>
<% String tituloPagina = "Inicio"; %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="p-5 mb-4 bg-dark rounded-3 text-white">
    <h1 class="fw-bold"><i class="bi bi-building"></i> Encuentra tu próximo hogar</h1>
    <p class="col-md-8 fs-5">Casas, apartamentos, locales y oficinas en Bucaramanga y su área metropolitana.</p>
    <form method="get" action="<%= ctx %>/propiedad/listar.jsp" class="row g-2 mt-3">
        <div class="col-md-5">
            <input type="text" class="form-control" name="q" placeholder="Buscar por título (ej: apartamento, casa...)">
        </div>
        <div class="col-md-4">
            <select class="form-select" name="ciudad">
                <option value="">Todas las ciudades</option>
<%
    Connection con = null; Statement st = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        while (rs.next()) {
%>
                <option value="<%= rs.getInt("id_ciudad") %>"><%= esc(rs.getString("nombre")) %></option>
<%      }
    } catch (SQLException ex) { }
%>
            </select>
        </div>
        <div class="col-md-3 d-grid">
            <button class="btn btn-warning fw-bold"><i class="bi bi-search"></i> Buscar</button>
        </div>
    </form>
</div>

<h4 class="mb-3">Propiedades destacadas</h4>
<div class="row g-3">
<%
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "SELECT p.id_propiedad, p.titulo, p.precio, c.nombre AS ciudad, "
          + "  (SELECT url_imagen FROM imagen_propiedad ip WHERE ip.id_propiedad = p.id_propiedad ORDER BY orden LIMIT 1) AS imagen "
          + "FROM propiedad p JOIN ciudad c ON c.id_ciudad = p.id_ciudad "
          + "WHERE p.estado = 'DISPONIBLE' ORDER BY p.fecha_publicacion DESC LIMIT 3");
        while (rs.next()) {
            String img = rs.getString("imagen");
            if (img == null) img = "https://picsum.photos/seed/default/800/600";
%>
    <div class="col-md-4">
        <div class="card h-100 shadow-sm">
            <img src="<%= img %>" class="card-img-top" style="height:180px;object-fit:cover" alt="">
            <div class="card-body">
                <h6><%= esc(rs.getString("titulo")) %></h6>
                <p class="small text-muted mb-1"><i class="bi bi-geo-alt"></i> <%= esc(rs.getString("ciudad")) %></p>
                <p class="fw-bold text-warning"><%= pesos(rs.getDouble("precio")) %></p>
                <a href="<%= ctx %>/propiedad/listar.jsp" class="btn btn-sm btn-outline-dark">Ver más</a>
            </div>
        </div>
    </div>
<%      }
    } catch (SQLException ex) {
        out.println("<div class='alert alert-danger'>" + esc(ex.getMessage()) + "</div>");
    } finally { cerrar(rs, st, con); }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>