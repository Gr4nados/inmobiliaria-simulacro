<%--
 registrar.jsp - Inserta usuario + perfil en una transaccion. Rol CLIENTE (id 3).
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    String nombres = request.getParameter("nombres");
    String apellidos = request.getParameter("apellidos");
    String documento = request.getParameter("documento");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    String username = request.getParameter("username");
    String correo = request.getParameter("correo");
    String clave = request.getParameter("clave");
    String clave2 = request.getParameter("clave2");

    if (!clave.equals(clave2)) {
        response.sendRedirect(ctx + "/registro.jsp?err=" + java.net.URLEncoder.encode("Las contraseñas no coinciden.", "UTF-8"));
        return;
    }

    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
        con = abrirConexion();
        con.setAutoCommit(false);

        ps = con.prepareStatement(
            "INSERT INTO usuario (documento, username, correo, password_hash, id_rol, activo) "
          + "VALUES (?, ?, ?, ?, 3, 1)", Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, documento.trim());
        ps.setString(2, username.trim());
        ps.setString(3, correo.trim());
        ps.setString(4, claveCifrada(username.trim(), clave));
        ps.executeUpdate();
        rs = ps.getGeneratedKeys();
        rs.next();
        int idUsuario = rs.getInt(1);
        cerrar(rs, ps);

        ps = con.prepareStatement(
            "INSERT INTO perfil (id_usuario, nombres, apellidos, telefono, direccion) VALUES (?, ?, ?, ?, ?)");
        ps.setInt(1, idUsuario);
        ps.setString(2, nombres.trim());
        ps.setString(3, apellidos.trim());
        ps.setString(4, telefono);
        ps.setString(5, direccion);
        ps.executeUpdate();
        cerrar(ps);

        con.commit();
        response.sendRedirect(ctx + "/login.jsp?msg=cuenta_creada");

    } catch (SQLIntegrityConstraintViolationException ex) {
        deshacer(con);
        String m = ex.getMessage();
        String amigable = m.contains("uq_usuario_correo") ? "Ese correo ya está registrado."
            : m.contains("uq_usuario_username") ? "Ese nombre de usuario ya existe."
            : m.contains("uq_usuario_documento") ? "Ese documento ya está registrado."
            : "Datos duplicados.";
        response.sendRedirect(ctx + "/registro.jsp?err=" + java.net.URLEncoder.encode(amigable, "UTF-8"));
    } catch (SQLException ex) {
        deshacer(con);
        response.sendRedirect(ctx + "/registro.jsp?err=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
    } finally {
        cerrar(rs, ps, con);
    }
%>