<<%-- index.jsp - Redirige al panel si hay sesion, o a la landing si no. --%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("idUsuario") != null) {
        response.sendRedirect("inicio.jsp");
    } else {
        response.sendRedirect("landing.jsp");
    }
%>