<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nome = "";
    String numeroUtente = "";
    int idade = 0;
    String profissao = "";
    String objetivo = "";
    String planoAtual = "";

    boolean saved = false;
    String msg = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            nome = request.getParameter("name");
            String ageStr = request.getParameter("age");
            idade = (ageStr != null && !ageStr.isEmpty()) ? Integer.parseInt(ageStr) : 0;
            profissao = request.getParameter("profession");
            objetivo = request.getParameter("goal");
            planoAtual = request.getParameter("rehabPlan");

            // Atualizar nome em Utilizadores
            ps = conn.prepareStatement("UPDATE Utilizadores SET nome = ? WHERE id = ?");
            ps.setString(1, nome);
            ps.setInt(2, userId);
            ps.executeUpdate();
            ps.close();

            // Inserir ou atualizar detalhes na PacienteDetalhes
            String sqlUpsert = "INSERT INTO PacienteDetalhes (id_paciente, idade, profissao, objetivo, plano) " +
                               "VALUES (?, ?, ?, ?, ?) " +
                               "ON DUPLICATE KEY UPDATE idade=?, profissao=?, objetivo=?, plano=?";
            ps = conn.prepareStatement(sqlUpsert);
            ps.setInt(1, userId);
            ps.setInt(2, idade);
            ps.setString(3, profissao);
            ps.setString(4, objetivo);
            ps.setString(5, planoAtual);
            ps.setInt(6, idade);
            ps.setString(7, profissao);
            ps.setString(8, objetivo);
            ps.setString(9, planoAtual);
            ps.executeUpdate();
            ps.close();

            saved = true;
            msg = "Perfil atualizado com sucesso!";
        }

        // Obter nome do utilizador
        ps = conn.prepareStatement("SELECT nome FROM Utilizadores WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            nome = rs.getString("nome");
        }
        rs.close();
        ps.close();

        // Obter número de utente
        ps = conn.prepareStatement("SELECT numero_utente FROM Pacientes WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            numeroUtente = rs.getString("numero_utente");
        }
        rs.close();
        ps.close();

        // Obter detalhes adicionais
        ps = conn.prepareStatement("SELECT idade, profissao, objetivo, plano FROM PacienteDetalhes WHERE id_paciente = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            idade = rs.getInt("idade");
            profissao = rs.getString("profissao");
            objetivo = rs.getString("objetivo");
            planoAtual = rs.getString("plano");
        }
        rs.close();
        ps.close();

    } catch (Exception e) {
        e.printStackTrace();
        msg = "Erro: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <title>ReabiPlay - Perfil</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/pacienteperfil.css" />
    <style>
        .hidden {
            display: none;
        }
    </style>
    <script>
        function toggleEdit() {
            document.getElementById('profile-info').classList.toggle('hidden');
            document.getElementById('edit-form').classList.toggle('hidden');
        }
    </script>
</head>
<body>
    <div class="sidebar">
        <div class="logo">ReabiPlay</div>
        <a href="pacienteprincipal.jsp">Página Principal</a>
        <a href="pacienteplanoreabilitacao.jsp">Plano de Reabilitação</a>
        <a href="pacientejogos.jsp">Jogos</a>
        <a href="pacientemensagens.jsp">Mensagens</a>
        <a href="pacienteforum.jsp">Fórum</a>
        <a href="pacienteperfil.jsp">Perfil</a>
        <a href="paginainicial.jsp">Sair</a>
    </div>

    <div class="main-content">
        <h2>Perfil</h2>

        <% if (!msg.isEmpty()) { %>
            <p style="color: <%= saved ? "green" : "red" %>;"><%= msg %></p>
        <% } %>

        <div class="profile-box" id="profile-info">
            <p><strong>Nome:</strong> <%= nome %></p>
            <p><strong>Número de Utente:</strong> <%= numeroUtente %></p>
            <p><strong>Idade:</strong> <%= idade %></p>
            <p><strong>Profissão:</strong> <%= profissao %></p>
            <p><strong>Objetivo de Reabilitação:</strong> <%= objetivo %></p>
            <div class="button-container">
                <button class="button" onclick="toggleEdit()">Editar Perfil</button>
            </div>
        </div>

        <form method="post" class="profile-box hidden" id="edit-form">
            <label for="name">Nome:</label>
            <input type="text" id="name" name="name" value="<%= nome %>" required />

            <label for="age">Idade:</label>
            <input type="number" id="age" name="age" value="<%= idade %>" min="0" required />

            <label for="profession">Profissão:</label>
            <input type="text" id="profession" name="profession" value="<%= profissao %>" required />

            <label for="goal">Objetivo de Reabilitação:</label>
            <input type="text" id="goal" name="goal" value="<%= objetivo %>" required />

            <div class="button-container">
                <button type="submit" class="button">Guardar Alterações</button>
                <button type="button" class="button" onclick="toggleEdit()">Cancelar</button>
            </div>
        </form>
    </div>

    <% if (saved) { %>
        <script>
            document.getElementById('edit-form').classList.add('hidden');
            document.getElementById('profile-info').classList.remove('hidden');
        </script>
    <% } %>
</body>
</html>
