<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReabiPlay - Página Principal do Administrador</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/jsp/css/adminprincipal.css"> 
</head>
<body>
    <div class="sidebar">
        <div class="logo">ReabiPlay</div>
        <a href="adminprincipal.jsp">Página Principal</a>
        <a href="adminconfirmar.jsp">Confirmar Profissionais</a>
        <a href="adminperfil.jsp">Perfil</a>
        <a href="paginainicial.jsp">Sair</a>
    </div>

    <div class="main-content">
        <h2>Página Principal</h2>
        <p><em>Bem-vindo à área de administração da plataforma ReabiPlay.</em></p>

        <div class="info-box">Aqui poderá confirmar profissionais e configurar o sistema.</div>

        <button class="exit-button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
    </div>

    <% 
        String userType = (String) session.getAttribute("userType");
        if (userType != null && userType.equals("admin")) {
    %>
        <div class="admin-actions">
            <p><strong>Ações do Administrador:</strong></p>
            <ul>
                <li><a href="adminprofissionais.jsp">Confirmar Profissionais</a></li>
                <li><a href="adminperfil.jsp">Editar Perfil</a></li>
            </ul>
        </div>

<% 
    } 
%>

</body>
</html>
