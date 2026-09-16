<%--
 solicitud/acciones.jsp - Controlador de solicitudes.
 crear (cliente, con documentos) | aprobar/rechazar (gestor)
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
    String destino = esGestor ? ctx + "/solicitud/gestion.jsp" : ctx + "/solicitud/mis-solicitudes.jsp";
    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;

    try {
        con = abrirConexion();
        con.setAutoCommit(false);

        if ("crear".equals(accion)) {
            if (!"CLIENTE".equals(rolSesion)) { deshacer(con); response.sendRedirect(ctx + "/inicio.jsp?error=permiso"); return; }
            int idPropiedad = aEntero(request.getParameter("id_propiedad"), 0);
            String tipo = request.getParameter("tipo");
            String obs = request.getParameter("observaciones");
            String[] nombresDoc = request.getParameterValues("nombreDoc");
            String[] tiposDoc = request.getParameterValues("tipoDoc");

            ps = con.prepareStatement(
                "INSERT INTO solicitud (id_propiedad, id_cliente, tipo, observaciones) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, idPropiedad);
            ps.setInt(2, idUsuarioSesion);
            ps.setString(3, tipo);
            ps.setString(4, obs);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            rs.next();
            int idSolicitud = rs.getInt(1);
            cerrar(rs, ps);

            if (nombresDoc != null) {
                ps = con.prepareStatement(
                    "INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, tipo_documento) VALUES (?, ?, ?)");
                for (int i = 0; i < nombresDoc.length; i++) {
                    if (nombresDoc[i] == null || nombresDoc[i].trim().isEmpty()) continue;
                    ps.setInt(1, idSolicitud);
                    ps.setString(2, nombresDoc[i].trim());
                    ps.setString(3, tiposDoc[i]);
                    ps.addBatch();
                }
                ps.executeBatch();
                cerrar(ps);
            }
            con.commit();
            destino = ctx + "/solicitud/mis-solicitudes.jsp?msg="
                + java.net.URLEncoder.encode("Solicitud radicada correctamente.", "UTF-8");

        } else if (("aprobar".equals(accion) || "rechazar".equals(accion)) && esGestor) {
            int idSolicitud = aEntero(request.getParameter("id_solicitud"), 0);
            String nuevoEstado = "aprobar".equals(accion) ? "APROBADA" : "RECHAZADA";
            ps = con.prepareStatement("UPDATE solicitud SET estado = ? WHERE id_solicitud = ?");
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSolicitud);
            ps.executeUpdate();
            cerrar(ps);
            con.commit();
            destino += "?msg=" + java.net.URLEncoder.encode("Solicitud " + nuevoEstado.toLowerCase() + ".", "UTF-8");
        }

    } catch (SQLException ex) {
        deshacer(con);
        destino += "?err=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8");
    } finally {
        cerrar(rs, ps, con);
    }
    response.sendRedirect(destino);
%>