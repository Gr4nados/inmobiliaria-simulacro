<%--
 propiedad/acciones.jsp - Controlador del modulo de propiedades.
 Acciones: crear | editar | baja | favorito
 crear/editar/baja: solo INMOBILIARIA/ADMINISTRADOR (doble candado: pagina + codigo).
 favorito: cualquier usuario logueado (CLIENTE en la practica).
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR", "INMOBILIARIA", "CLIENTE"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    String destino = ctx + "/propiedad/listar.jsp";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;

    boolean esGestor = "ADMINISTRADOR".equals(rolSesion) || "INMOBILIARIA".equals(rolSesion);

    try {
        con = abrirConexion();
        con.setAutoCommit(false);

        if (("crear".equals(accion) || "editar".equals(accion) || "baja".equals(accion)) && !esGestor) {
            // Segunda validacion en el propio codigo, ademas de la pagina que llama.
            deshacer(con);
            response.sendRedirect(ctx + "/inicio.jsp?error=permiso");
            return;
        }

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
              + "  precio, id_ciudad, id_tipo_propiedad, id_usuario) VALUES (?, ?, ?, ?, ?, ?, ?)",
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

        } else if ("editar".equals(accion)) {
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            double precio = aDoble(request.getParameter("precio"), 0);
            int idCiudad = aEntero(request.getParameter("id_ciudad"), 0);
            int idTipo = aEntero(request.getParameter("id_tipo_propiedad"), 0);
            String[] caracteristicas = request.getParameterValues("caracteristicas");

            ps = con.prepareStatement(
                "UPDATE propiedad SET titulo=?, descripcion=?, precio=?, id_ciudad=?, id_tipo_propiedad=? "
              + "WHERE id_propiedad=?");
            ps.setString(1, titulo.trim());
            ps.setString(2, descripcion);
            ps.setDouble(3, precio);
            ps.setInt(4, idCiudad);
            ps.setInt(5, idTipo);
            ps.setInt(6, idPropiedad);
            ps.executeUpdate();
            cerrar(ps);

            ps = con.prepareStatement("DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?");
            ps.setInt(1, idPropiedad);
            ps.executeUpdate();
            cerrar(ps);

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
            destino = ctx + "/propiedad/detalle.jsp?id=" + idPropiedad
                + "&msg=" + java.net.URLEncoder.encode("Propiedad actualizada.", "UTF-8");

        } else if ("baja".equals(accion)) {
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            ps = con.prepareStatement("UPDATE propiedad SET estado = 'INACTIVA' WHERE id_propiedad = ?");
            ps.setInt(1, idPropiedad);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Propiedad dada de baja.", "UTF-8");

        } else if ("favorito".equals(accion)) {
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            ps = con.prepareStatement(
                "SELECT id_favorito FROM favorito WHERE id_usuario = ? AND id_propiedad = ?");
            ps.setInt(1, idUsuarioSesion);
            ps.setInt(2, idPropiedad);
            rs = ps.executeQuery();
            boolean existeFav = rs.next();
            cerrar(rs, ps);

            if (existeFav) {
                ps = con.prepareStatement("DELETE FROM favorito WHERE id_usuario = ? AND id_propiedad = ?");
                ps.setInt(1, idUsuarioSesion);
                ps.setInt(2, idPropiedad);
                ps.executeUpdate();
                cerrar(ps);
                destino = ctx + "/propiedad/detalle.jsp?id=" + idPropiedad
                    + "&msg=" + java.net.URLEncoder.encode("Quitado de favoritos.", "UTF-8");
            } else {
                ps = con.prepareStatement("INSERT INTO favorito (id_usuario, id_propiedad) VALUES (?, ?)");
                ps.setInt(1, idUsuarioSesion);
                ps.setInt(2, idPropiedad);
                ps.executeUpdate();
                cerrar(ps);
                destino = ctx + "/propiedad/detalle.jsp?id=" + idPropiedad
                    + "&msg=" + java.net.URLEncoder.encode("Agregado a favoritos.", "UTF-8");
            }
            con.commit();
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