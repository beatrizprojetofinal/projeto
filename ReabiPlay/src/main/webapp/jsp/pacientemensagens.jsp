<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("userId") == null || !"Paciente".equals(sessao.getAttribute("userType"))) {
        response.sendRedirect("paginainicial.jsp");
        return;
    }

    int pacienteId = (Integer) sessao.getAttribute("userId");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String profissionalNome = null;
    int profissionalId = -1;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        // 1. Verificar profissional associado PRIMEIRO
        String sqlProf = "SELECT u.id, u.nome FROM Ligacoes l JOIN Utilizadores u ON l.id_profissional = u.id WHERE l.id_paciente = ? AND l.estado = 'Aceite' LIMIT 1";
        ps = conn.prepareStatement(sqlProf);
        ps.setInt(1, pacienteId);
        rs = ps.executeQuery();
        if (rs.next()) {
            profissionalId = rs.getInt("id");
            profissionalNome = rs.getString("nome");
        }
        rs.close();
        ps.close();

        // 2. Buscar mensagens recebidas
        String sqlMensagens = "SELECT u.nome, m.mensagem, m.data_envio FROM Mensagens m JOIN Utilizadores u ON m.remetente_id = u.id WHERE m.destinatario_id = ? ORDER BY m.data_envio DESC";
        ps = conn.prepareStatement(sqlMensagens);
        ps.setInt(1, pacienteId);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mensagens - Paciente</title>
    <link rel="stylesheet" href="css/pacientemensagens.css">
    <style>
        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .message-box {
            margin-bottom: 25px;
        }
        .form-wrapper {
            margin-top: 20px;
            margin-bottom: 40px;
        }
    </style>
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
    <h2>Enviar Nova Mensagem</h2>

    <div class="form-wrapper">
        <% if (profissionalId != -1) { %>
            <form method="post" action="<%= request.getContextPath() %>/EnviarMensagemServlet" class="center-form">
                <input type="hidden" name="destinatarioId" value="<%= profissionalId %>">
                <textarea name="mensagem" rows="4" cols="50" required></textarea><br>
                <button class="button" type="submit">Enviar para <%= profissionalNome %></button>
            </form>
            
        <% } else { %>
            <p>Não tem ligação aceite com nenhum profissional ainda.</p>
        <% } %>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("sucesso".equals(msg)) {
    %>
        <div class="alert success">Mensagem enviada com sucesso!</div>
    <%
        }
    %>

    <h2>Mensagens Recebidas</h2>
    <%
        while (rs.next()) {
    %>
    <div class="message-box">
        <strong><%= rs.getString("nome") %></strong><br>
        <span><em><%= rs.getTimestamp("data_envio") %></em></span><br><br>
        <p><%= rs.getString("mensagem") %></p>
    </div>
    <%
        }
        rs.close();
        ps.close();
    %>

    <br>
    <button class="button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
</div>

<script>
    setTimeout(() => {
        const alert = document.querySelector('.alert.success');
        if (alert) alert.style.display = 'none';
    }, 4000);
</script>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("Erro: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception ex) {}
    }
%>
