<%--
 cita/acciones.jsp - Controlador de citas.
 Acciones: crear (cliente) | cancelar (cliente o gestor) | confirmar (gestor) | realizada (gestor)
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<% String[] rolesPermitidos = {"CLIENTE", "INMOBILIARIA", "ADMINISTRADOR"}; %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    boolean esGestor = "ADMINISTRADOR".equals(rolSesion) || "INMOBILIARIA".equals(rolSesion);
    String destino = esGestor ? ctx + "/cita/agenda.jsp" : ctx + "/cita/mis-citas.jsp";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;

    try {
        con = abrirConexion();
        con.setAutoCommit(false);

        if ("crear".equals(accion)) {
            if (!"CLIENTE".equals(rolSesion)) { deshacer(con); response.sendRedirect(ctx + "/inicio.jsp?error=permiso"); return; }
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            String fechaHora = request.getParameter("fecha_hora").replace("T", " ") + ":00";
            String obs = request.getParameter("observaciones");

            ps = con.prepareStatement(
                "INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, observaciones) VALUES (?, ?, ?, ?)");
            ps.setInt(1, idPropiedad);
            ps.setInt(2, idUsuarioSesion);
            ps.setString(3, fechaHora);
            ps.setString(4, obs);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino = ctx + "/cita/mis-citas.jsp?msg=" + java.net.URLEncoder.encode("Cita agendada correctamente.", "UTF-8");

        } else if ("cancelar".equals(accion)) {
            int idCita = aEntero(request.getParameter("id_cita"), 0);
            if ("CLIENTE".equals(rolSesion)) {
                ps = con.prepareStatement(
                    "UPDATE cita SET estado='CANCELADA' WHERE id_cita=? AND id_cliente=?");
                ps.setInt(1, idCita);
                ps.setInt(2, idUsuarioSesion);
            } else {
                ps = con.prepareStatement("UPDATE cita SET estado='CANCELADA' WHERE id_cita=?");
                ps.setInt(1, idCita);
            }
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Cita cancelada.", "UTF-8");

        } else if ("confirmar".equals(accion) && esGestor) {
            int idCita = aEntero(request.getParameter("id_cita"), 0);
            ps = con.prepareStatement("UPDATE cita SET estado='CONFIRMADA' WHERE id_cita=?");
            ps.setInt(1, idCita);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Cita confirmada.", "UTF-8");

        } else if ("realizada".equals(accion) && esGestor) {
            int idCita = aEntero(request.getParameter("id_cita"), 0);
            ps = con.prepareStatement("UPDATE cita SET estado='REALIZADA' WHERE id_cita=?");
            ps.setInt(1, idCita);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Cita marcada como realizada.", "UTF-8");
        }

    } catch (SQLIntegrityConstraintViolationException ex) {
        deshacer(con);
        String amigable = ex.getMessage().contains("uq_cita_propiedad_fecha")
            ? "Esa propiedad ya tiene una cita agendada en ese horario. Elige otra fecha/hora."
            : "Datos duplicados.";
        destino = ctx + "/cita/nueva.jsp?id=" + request.getParameter("id_propiedad")
            + "&err=" + java.net.URLEncoder.encode(amigable, "UTF-8");
    } catch (SQLException ex) {
        deshacer(con);
        destino += "?err=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8");
    } finally {
        cerrar(rs, ps, con);
    }
    response.sendRedirect(destino);
%>