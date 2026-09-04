<%--
 propiedad/acciones.jsp - Controlador del modulo de propiedades.
 Acciones: crear | baja
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    String destino = ctx + "/propiedad/listar.jsp";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;

    try {
        con = abrirConexion();
        con.setAutoCommit(false);

        if ("crear".equals(accion)) {
            String matricula = request.getParameter("matricula");
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            double precio = aDoble(request.getParameter("precio"), 0);
            int idCiudad = aEntero(request.getParameter("id_ciudad"), 0);
            int idTipo = aEntero(request.getParameter("id_tipo_propiedad"), 0);
            String[] caracteristicas = request.getParameterValues("caracteristicas");

            ps = con.prepareStatement(
                "INSERT INTO propiedad (matricula_inmobiliaria, titulo, descripcion, "
              + "  precio, id_ciudad, id_tipo_propiedad, id_usuario) "
              + "VALUES (?, ?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, matricula.trim());
            ps.setString(2, titulo.trim());
            ps.setString(3, descripcion);
            ps.setDouble(4, precio);
            ps.setInt(5, idCiudad);
            ps.setInt(6, idTipo);
            ps.setInt(7, idUsuarioSesion);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            rs.next();
            int idPropiedad = rs.getInt(1);
            cerrar(rs, ps);

            if (caracteristicas != null) {
                ps = con.prepareStatement(
                    "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)");
                for (String idCar : caracteristicas) {
                    ps.setInt(1, idPropiedad);
                    ps.setInt(2, aEntero(idCar, 0));
                    ps.addBatch();
                }
                ps.executeBatch();
                cerrar(ps);
            }

            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Propiedad publicada correctamente.", "UTF-8");

        } else if ("baja".equals(accion)) {
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            ps = con.prepareStatement(
                "UPDATE propiedad SET estado = 'INACTIVA' WHERE id_propiedad = ?");
            ps.setInt(1, idPropiedad);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Propiedad dada de baja.", "UTF-8");
        }

    } catch (SQLIntegrityConstraintViolationException ex) {
        deshacer(con);
        String m = ex.getMessage();
        String amigable = m.contains("uq_propiedad_matricula")
            ? "Ya existe una propiedad con esa matricula inmobiliaria."
            : "Datos duplicados: " + m;
        destino = ctx + "/propiedad/nueva.jsp?err=" + java.net.URLEncoder.encode(amigable, "UTF-8");
    } catch (SQLException ex) {
        deshacer(con);
        destino += "?err=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8");
    } finally {
        cerrar(rs, ps, con);
    }
    response.sendRedirect(destino);
%>