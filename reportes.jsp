<%--
 reportes.jsp - Consultas de reporte para el administrador.
 Incluye: INNER JOIN de 3+ tablas, LEFT JOIN, y agregacion con GROUP BY/HAVING.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<% String tituloPagina = "Reportes"; %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<h3 class="mb-4"><i class="bi bi-bar-chart"></i> Reportes</h3>

<!-- ============ Reporte 1: GROUP BY / HAVING (historia #12) ============ -->
<div class="card shadow-sm mb-4">
<div class="card-header bg-white fw-bold">
    <i class="bi bi-buildings"></i> Propiedades por ciudad y estado (ciudades con más de 1 propiedad)
</div>
<div class="table-responsive">
<table class="table table-sm mb-0">
<thead class="table-dark"><tr><th>Ciudad</th><th>Estado</th><th class="text-end">Cantidad</th></tr></thead>
<tbody>
<%
    Connection con = null; Statement st = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        st = con.createStatement();
        rs = st.executeQuery(
            "SELECT c.nombre AS ciudad, p.estado, COUNT(*) AS cantidad "
          + "FROM propiedad p JOIN ciudad c ON c.id_ciudad = p.id_ciudad "
          + "GROUP BY c.nombre, p.estado "
          + "HAVING COUNT(*) >= 1 "
          + "ORDER BY cantidad DESC");
        while (rs.next()) {
%>
<tr><td><%= esc(rs.getString("ciudad")) %></td>
    <td><span class="badge text-bg-<%= colorEstado(rs.getString("estado")) %>"><%= rs.getString("estado") %></span></td>
    <td class="text-end"><%= rs.getInt("cantidad") %></td></tr>
<%      }
        cerrar(rs, st);
    } catch (SQLException ex) { out.println("<tr><td colspan='3' class='text-danger'>" + esc(ex.getMessage()) + "</td></tr>"); }
%>
</tbody>
</table>
</div>
</div>

<!-- ============ Reporte 2: LEFT JOIN ============ -->
<div class="card shadow-sm mb-4">
<div class="card-header bg-white fw-bold">
    <i class="bi bi-calendar-x"></i> Propiedades que aún no tienen citas agendadas
</div>
<div class="table-responsive">
<table class="table table-sm mb-0">
<thead class="table-dark"><tr><th>Matricula</th><th>Titulo</th><th class="text-end">Precio</th></tr></thead>
<tbody>
<%
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "SELECT p.matricula_inmobiliaria, p.titulo, p.precio "
          + "FROM propiedad p LEFT JOIN cita c ON c.id_propiedad = p.id_propiedad "
          + "WHERE c.id_cita IS NULL AND p.estado <> 'INACTIVA'");
        int filas = 0;
        while (rs.next()) {
            filas++;
%>
<tr><td><code><%= esc(rs.getString("matricula_inmobiliaria")) %></code></td>
    <td><%= esc(rs.getString("titulo")) %></td>
    <td class="text-end"><%= pesos(rs.getDouble("precio")) %></td></tr>
<%      }
        cerrar(rs, st);
        if (filas == 0) { out.println("<tr><td colspan='3' class='text-center text-muted py-3'>Todas las propiedades tienen al menos una cita.</td></tr>"); }
    } catch (SQLException ex) { out.println("<tr><td colspan='3' class='text-danger'>" + esc(ex.getMessage()) + "</td></tr>"); }
%>
</tbody>
</table>
</div>
</div>

<!-- ============ Reporte 3: INNER JOIN de 4 tablas ============ -->
<div class="card shadow-sm mb-4">
<div class="card-header bg-white fw-bold">
    <i class="bi bi-calendar-week"></i> Citas agendadas por ciudad y cliente
</div>
<div class="table-responsive">
<table class="table table-sm mb-0">
<thead class="table-dark"><tr><th>Ciudad</th><th>Propiedad</th><th>Cliente</th><th>Fecha</th><th>Estado</th></tr></thead>
<tbody>
<%
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "SELECT ci.nombre AS ciudad, p.titulo, u.username AS cliente, c.fecha_hora, c.estado "
          + "FROM cita c "
          + "  JOIN propiedad p ON p.id_propiedad = c.id_propiedad "
          + "  JOIN ciudad ci ON ci.id_ciudad = p.id_ciudad "
          + "  JOIN usuario u ON u.id_usuario = c.id_cliente "
          + "ORDER BY c.fecha_hora");
        int filas = 0;
        while (rs.next()) {
            filas++;
%>
<tr><td><%= esc(rs.getString("ciudad")) %></td>
    <td><%= esc(rs.getString("titulo")) %></td>
    <td><%= esc(rs.getString("cliente")) %></td>
    <td><%= rs.getTimestamp("fecha_hora") %></td>
    <td><span class="badge text-bg-<%= colorEstado(rs.getString("estado")) %>"><%= rs.getString("estado") %></span></td></tr>
<%      }
        if (filas == 0) { out.println("<tr><td colspan='5' class='text-center text-muted py-3'>No hay citas registradas.</td></tr>"); }
    } catch (SQLException ex) { out.println("<tr><td colspan='5' class='text-danger'>" + esc(ex.getMessage()) + "</td></tr>"); }
    finally { cerrar(rs, st, con); }
%>
</tbody>
</table>
</div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>