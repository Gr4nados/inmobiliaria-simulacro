<%--
 propiedad/favoritos.jsp - Lista las propiedades que el cliente marco como favoritas.
 Resuelve la historia #8: "...para consultarlas mas adelante sin tener que buscarlas de nuevo".
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    String tituloPagina = "Mis favoritos";
    String msg = request.getParameter("msg");
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-3"><i class="bi bi-heart-fill text-danger"></i> Mis propiedades favoritas</h3>
<% if (msg != null) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
<% } %>

<div class="row g-3">
<%
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    int filas = 0;
    try {
        con = abrirConexion();
        ps = con.prepareStatement(
            "SELECT pr.id_propiedad, pr.titulo, pr.precio, pr.estado, "
          + "       c.nombre AS ciudad, t.nombre AS tipo, "
          + "       (SELECT url_imagen FROM imagen_propiedad ip WHERE ip.id_propiedad = pr.id_propiedad "
          + "        ORDER BY orden LIMIT 1) AS imagen "
          + "FROM favorito f "
          + "  JOIN propiedad pr ON pr.id_propiedad = f.id_propiedad "
          + "  JOIN ciudad c ON c.id_ciudad = pr.id_ciudad "
          + "  JOIN tipo_propiedad t ON t.id_tipo_propiedad = pr.id_tipo_propiedad "
          + "WHERE f.id_usuario = ? "
          + "ORDER BY f.fecha_marcado DESC");
        ps.setInt(1, idUsuarioSesion);
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
                <p class="fw-bold text-warning mb-2"><%= pesos(rs.getDouble("precio")) %></p>
                <span class="badge text-bg-<%= colorEstado(rs.getString("estado")) %> mb-2"><%= rs.getString("estado") %></span>
                <div class="d-flex gap-1">
                    <a href="<%= ctx %>/propiedad/detalle.jsp?id=<%= idPropiedad %>" class="btn btn-sm btn-dark">
                        <i class="bi bi-eye"></i> Ver detalle</a>
                    <form method="post" action="<%= ctx %>/propiedad/acciones.jsp">
                        <input type="hidden" name="accion" value="favorito">
                        <input type="hidden" name="id_propiedad" value="<%= idPropiedad %>">
                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-heart-fill"></i></button>
                    </form>
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
    <div class="col-12"><div class="alert alert-secondary text-center py-4">
        Aún no has marcado ninguna propiedad como favorita.</div></div>
<% } %>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
