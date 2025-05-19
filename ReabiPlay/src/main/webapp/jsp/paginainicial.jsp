<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReabiPlay</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='css/paginainicial.css' />">
</head>
<body>

    <div class="header">
        <h1>ReabiPlay</h1>
        <div class="sub-header">Plataforma de Exercícios e Jogos Sérios Aplicados à Reabilitação de Idosos</div>
        <button class="login-button" onclick="window.location.href='login.jsp'">Entrar</button>
    </div>

    <div class="container">
        <div class="box">
            <h3>Paciente</h3>
            <p>Acesso a exercícios personalizados focados em suas necessidades de reabilitação.</p>
            <button class="button" onclick="window.location.href='registar.jsp'">Registar</button>
        </div>
        <div class="box">
            <h3>Profissional de Saúde</h3>
            <p>Ferramentas para monitorar progresso, prescrever atividades e acompanhar os pacientes.</p>
            <button class="button" onclick="window.location.href='registar.jsp'">Registar</button>
        </div>
        <div class="box">
            <h3>Familiar</h3>
            <p>Possibilidade de acompanhar o desenvolvimento e auxiliar no engajamento do paciente.</p>
            <button class="button" onclick="window.location.href='registar.jsp'">Registar</button>
        </div>
    </div>

    <div class="footer-button">
        <button class="button" onclick="window.location.href='html/paginadejogos.html'">Jogar</button>
    </div>

</body>
</html>
