<%--
 admin/acciones.jsp - Controlador de gestion de usuarios.
 Acciones: cambiarRol | toggleActivo
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"ADMINISTRADOR"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    int idUsuario = aEntero(request.getParameter("id_usuario"), 0);
    String destino = ctx + "/admin/usuarios.jsp";
    Connection con = null; PreparedStatement ps = null;

    // Un administrador no puede modificarse a si mismo (evita que se quede sin acceso).
    if (idUsuario == idUsuarioSesion) {
        response.sendRedirect(destino);
        return;
    }

    try {
        con = abrirConexion();
        if ("cambiarRol".equals(accion)) {
            int idRol = aEntero(request.getParameter("id_rol"), 0);
            ps = con.prepareStatement("UPDATE usuario SET id_rol = ? WHERE id_usuario = ?");
            ps.setInt(1, idRol);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
            destino += "?msg=" + java.net.URLEncoder.encode("Rol actualizado.", "UTF-8");
        } else if ("toggleActivo".equals(accion)) {
            int valor = aEntero(request.getParameter("valor"), 1);
            ps = con.prepareStatement("UPDATE usuario SET activo = ? WHERE id_usuario = ?");
            ps.setInt(1, valor);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
            destino += "?msg=" + java.net.URLEncoder.encode("Estado de la cuenta actualizado.", "UTF-8");
        }
        cerrar(ps, con);
    } catch (SQLException ex) {
        destino += "?err=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8");
    }
    response.sendRedirect(destino);
%>