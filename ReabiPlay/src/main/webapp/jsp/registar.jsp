<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String errorMessage = "";
    boolean foiSubmetido = request.getMethod().equalsIgnoreCase("POST");

    if (foiSubmetido) {
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("palavra_passe");
        String tipo = request.getParameter("tipo");
        String numeroUtente = request.getParameter("utente");
        String especialidade = request.getParameter("especialidade");

        if (nome == null || nome.isEmpty() || email == null || email.isEmpty() ||
            senha == null || senha.isEmpty() || tipo == null || tipo.isEmpty()) {
            errorMessage = "Dados incompletos.";
        } else {
            Connection conn = null;
            PreparedStatement psUser = null;
            PreparedStatement psRole = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

                String sqlUser = "INSERT INTO Utilizadores (nome, email, palavra_passe, tipo) VALUES (?, ?, ?, ?)";
                psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
                psUser.setString(1, nome);
                psUser.setString(2, email);
                psUser.setString(3, senha);
                psUser.setString(4, tipo);
                psUser.executeUpdate();

                rs = psUser.getGeneratedKeys();
                int userId = 0;
                if (rs.next()) {
                    userId = rs.getInt(1);
                }

                if ("Paciente".equals(tipo)) {
                    String sqlPaciente = "INSERT INTO Pacientes (id, numero_utente) VALUES (?, ?)";
                    psRole = conn.prepareStatement(sqlPaciente);
                    psRole.setInt(1, userId);
                    psRole.setString(2, numeroUtente);
                } else if ("Profissional".equals(tipo)) {
                    String sqlProf = "INSERT INTO Profissionais (id, especialidade) VALUES (?, ?)";
                    psRole = conn.prepareStatement(sqlProf);
                    psRole.setInt(1, userId);
                    psRole.setString(2, especialidade);
                } else if ("Familiar".equals(tipo)) {
                    String sqlFam = "INSERT INTO Familiares (id, id_paciente) VALUES (?, ?)";
                    psRole = conn.prepareStatement(sqlFam);
                    psRole.setInt(1, userId);
                    psRole.setInt(2, 1); // <- Aqui seria melhor selecionar um paciente dinamicamente
                }

                if (psRole != null) psRole.executeUpdate();

                // Redirecionar após registo
                if ("Paciente".equals(tipo)) {
                    response.sendRedirect("pacienteprincipal.jsp");
                } else if ("Profissional".equals(tipo)) {
                    response.sendRedirect("profissionalprincipal.jsp");
                } else if ("Familiar".equals(tipo)) {
                    response.sendRedirect("familiarprincipal.jsp");
                }
                return;

            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Erro ao processar os dados: " + e.getMessage();
            } finally {
                if (rs != null) rs.close();
                if (psUser != null) psUser.close();
                if (psRole != null) psRole.close();
                if (conn != null) conn.close();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>ReabiPlay - Registar</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/registar.css">
</head>
<body>
    <div class="header">
        <h1>ReabiPlay</h1>
        <div class="sub-header">Plataforma de Exercícios e Jogos Sérios Aplicados à Reabilitação de Idosos</div>
    </div>

    <div class="form-wrapper">
        <div class="form-container">
            <h2>Registo de Utilizador</h2>

            <% if (!errorMessage.isEmpty()) { %>
                <p style="color:red;"><%= errorMessage %></p>
            <% } %>

            <form method="post" action="registar.jsp">
                <label for="nome">Nome Completo:</label>
                <input type="text" id="nome" name="nome" required>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>

                <label for="senha">Palavra Passe:</label>
                <input type="password" id="senha" name="palavra_passe" required>

                <label for="tipo">Tipo de Utilizador:</label>
                <select id="tipo" name="tipo" onchange="toggleFields()" required>
                    <option value="" disabled selected>Selecione</option>
                    <option value="Paciente">Paciente</option>
                    <option value="Profissional">Profissional de Saúde</option>
                    <option value="Familiar">Familiar</option>
                </select>

                <div id="utenteField" style="display: none;">
                    <label for="utente">Número de Utente:</label>
                    <input type="number" id="utente" name="utente" min="0">
                </div>

                <div id="especialidadeField" style="display: none;">
                    <label for="especialidade">Especialidade:</label>
                    <input type="text" id="especialidade" name="especialidade" />
                </div>

                <button type="submit">Registar</button>
            </form>
        </div>
    </div>

    <script>
        function toggleFields() {
            const tipo = document.getElementById("tipo").value;
            const utenteField = document.getElementById("utenteField");
            const especialidadeField = document.getElementById("especialidadeField");

            utenteField.style.display = tipo === "Paciente" ? "block" : "none";
            especialidadeField.style.display = tipo === "Profissional" ? "block" : "none";
        }

        toggleFields(); // Executar no carregamento
    </script>
</body>
</html>
