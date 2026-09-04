<%--
 acceso.jsp - Valida las credenciales contra la tabla usuario.
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    String usuario = request.getParameter("usuario");
    String clave = request.getParameter("clave");

    if (usuario == null || clave == null
            || usuario.trim().isEmpty() || clave.trim().isEmpty()) {
        response.sendRedirect(ctx + "/login.jsp?error=vacio");
        return;
    }
    usuario = usuario.trim();

    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        String sql = "SELECT u.id_usuario, u.password_hash, u.activo, "
                   + "       p.nombres, p.apellidos, r.nombre AS rol "
                   + "FROM usuario u "
                   + "  JOIN rol r ON r.id_rol = u.id_rol "
                   + "  LEFT JOIN perfil p ON p.id_usuario = u.id_usuario "
                   + "WHERE u.username = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, usuario);
        rs = ps.executeQuery();

        if (rs.next()) {
            String hashGuardado = rs.getString("password_hash");
            boolean activo = rs.getBoolean("activo");
            if (!activo) {
                response.sendRedirect(ctx + "/login.jsp?error=inactivo");
                return;
            }
            if (hashGuardado.equals(claveCifrada(usuario, clave))) {
                session.setAttribute("idUsuario", rs.getInt("id_usuario"));
                session.setAttribute("nombre",
                    rs.getString("nombres") + " " + rs.getString("apellidos"));
                session.setAttribute("rol", rs.getString("rol"));
                session.setAttribute("username", usuario);
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(ctx + "/inicio.jsp");
                return;
            }
        }
        response.sendRedirect(ctx + "/login.jsp?error=clave");
    } catch (SQLException ex) {
        out.println("<div style='font-family:sans-serif;padding:20px'>"
            + "<h3>Error de conexion con la base de datos</h3><pre>"
            + ex.getMessage() + "</pre></div>");
    } finally {
        cerrar(rs, ps, con);
    }
%>