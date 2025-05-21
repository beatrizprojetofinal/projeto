<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nome = "";
    String especialidade = "";
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
            especialidade = request.getParameter("specialty");

            // Atualizar nome na tabela Utilizadores
            ps = conn.prepareStatement("UPDATE Utilizadores SET nome = ? WHERE id = ?");
            ps.setString(1, nome);
            ps.setInt(2, userId);
            ps.executeUpdate();
            ps.close();

            // Inserir ou atualizar especialidade
            String upsert = "INSERT INTO Profissionais (id, especialidade) VALUES (?, ?) " +
                            "ON DUPLICATE KEY UPDATE especialidade = ?";
            ps = conn.prepareStatement(upsert);
            ps.setInt(1, userId);
            ps.setString(2, especialidade);
            ps.setString(3, especialidade);
            ps.executeUpdate();
            ps.close();

            saved = true;
            msg = "Perfil atualizado com sucesso!";
        }

        // Obter nome
        ps = conn.prepareStatement("SELECT nome FROM Utilizadores WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            nome = rs.getString("nome");
        }
        rs.close();
        ps.close();

        // Obter especialidade
        ps = conn.prepareStatement("SELECT especialidade FROM Profissionais WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            especialidade = rs.getString("especialidade");
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
    <meta charset="UTF-8">
    <title>ReabiPlay - Perfil do Profissional</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/profissionalperfil.css" />
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
    <a href="profissionalprincipal.jsp">Página Principal</a>
    <a href="profissionalpacientes.jsp">Pacientes</a>
    <a href="profissionalmensagens.jsp">Mensagens</a>
    <a href="profissionalperfil.jsp" class="active">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main-content">
    <h2>Perfil</h2>

    <% if (!msg.isEmpty()) { %>
        <p style="color: <%= saved ? "green" : "red" %>;"><%= msg %></p>
    <% } %>

    <div class="profile-box" id="profile-info">
        <p><strong>Nome:</strong> <%= nome %></p>
        <p><strong>Especialidade:</strong> <%= especialidade %></p>
        <div class="button-container">
            <button class="button" onclick="toggleEdit()">Editar Perfil</button>
        </div>
    </div>

    <form method="post" class="profile-box hidden" id="edit-form">
        <label for="name">Nome:</label>
        <input type="text" id="name" name="name" value="<%= nome %>" required />

        <label for="specialty">Especialidade:</label>
        <input type="text" id="specialty" name="specialty" value="<%= especialidade %>" required />

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
