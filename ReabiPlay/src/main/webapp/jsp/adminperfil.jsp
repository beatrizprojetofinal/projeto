<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");
    if (userId == null || userType == null || !userType.equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nome = "";
    String email = "";
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
            email = request.getParameter("email");

            // Atualizar nome e email em Utilizadores
            ps = conn.prepareStatement("UPDATE Utilizadores SET nome = ?, email = ? WHERE id = ?");
            ps.setString(1, nome);
            ps.setString(2, email);
            ps.setInt(3, userId);
            ps.executeUpdate();
            ps.close();

            saved = true;
            msg = "Perfil atualizado com sucesso!";
        }

        // Obter nome e email do utilizador
        ps = conn.prepareStatement("SELECT nome, email FROM Utilizadores WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            nome = rs.getString("nome");
            email = rs.getString("email");
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
    <title>ReabiPlay - Perfil do Administrador</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/jsp/css/adminperfil.css" />
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
        <a href="adminprincipal.jsp">Página Principal</a>
        <a href="adminconfirmar.jsp">Confirmar Profissionais</a>
        <a href="adminperfil.jsp">Perfil</a>
        <a href="paginainicial.jsp">Sair</a>
    </div>

    <div class="main-content">
        <h2>Perfil</h2>

        <% if (!msg.isEmpty()) { %>
            <p style="color: <%= saved ? "green" : "red" %>;"><%= msg %></p>
        <% } %>

        <div class="profile-box" id="profile-info">
            <p><strong>Nome:</strong> <%= nome %></p>
            <p><strong>Email:</strong> <%= email %></p>
            <div class="button-container">
                <button class="button" onclick="toggleEdit()">Editar Perfil</button>
            </div>
        </div>

        <form method="post" class="profile-box hidden" id="edit-form">
            <label for="name">Nome:</label>
            <input type="text" id="name" name="name" value="<%= nome %>" required />

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= email %>" required />

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
