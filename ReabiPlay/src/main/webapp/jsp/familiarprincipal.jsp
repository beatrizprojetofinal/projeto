<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Verificar se o utilizador está logado e é um Familiar
    Integer userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");

    if (userId == null || !"Familiar".equals(userType)) {
        response.sendRedirect("html/login.html");
        return;
    }

    // Dados do paciente associado
    String nomePaciente = "";
    String numeroUtente = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        // Obter o ID do paciente associado a este familiar
        String sql = "SELECT u.nome, p.numero_utente FROM Familiares f " +
                     "JOIN Pacientes p ON f.id_paciente = p.id " +
                     "JOIN Utilizadores u ON p.id = u.id " +
                     "WHERE f.id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            nomePaciente = rs.getString("nome");
            numeroUtente = rs.getString("numero_utente");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReabiPlay - Página Principal do Familiar</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/familiarprincipal.css">
</head>
<body>
    <div class="sidebar">
        <div class="logo">ReabiPlay</div>
        <a href="familiarprincipal.jsp">Página Principal</a>
        <a href="familiarjogos.jsp">Jogos</a>
        <a href="familiarperfil.jsp">Perfil</a>
        <a href="paginainicial.jsp">Sair</a>
    </div>

    <div class="main-content">
        <h2>Página Principal</h2>
        <p><em>Acompanhe o progresso do seu familiar e interaja com a plataforma.</em></p>

        <div class="info-box">
            <h3>Informações do Paciente Associado</h3>
            <% if (!nomePaciente.isEmpty()) { %>
                <p><strong>Nome:</strong> <%= nomePaciente %></p>
                <p><strong>Número de Utente:</strong> <%= numeroUtente %></p>
            <% } else { %>
                <p style="color: red;">Não foi possível carregar as informações do paciente.</p>
            <% } %>
        </div>

        <button class="exit-button" onclick="paginainicial.jsp'">Sair</button>
    </div>
</body>
</html>
