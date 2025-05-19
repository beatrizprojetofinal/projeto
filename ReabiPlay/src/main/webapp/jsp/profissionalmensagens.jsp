<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("userId") == null || !"Profissional".equals(sessao.getAttribute("userType"))) {
        response.sendRedirect("paginainicial.jsp");
        return;
    }

    int profissionalId = (Integer) sessao.getAttribute("userId");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mensagens - Profissional</title>
    <link rel="stylesheet" href="css/profissionalmensagens.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="profissionalprincipal.jsp">Página Principal</a>
    <a href="profissionalpacientes.jsp">Pacientes</a>
    <a href="profissionalestatisticas.jsp">Estatísticas</a>
    <a href="profissionalmensagens.jsp">Mensagens</a>
    <a href="profissionalperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main-content">
    <h2>Mensagens Recebidas</h2>
    <p><em>Veja as mensagens dos seus pacientes.</em></p>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        // Buscar mensagens recebidas
        String sqlMensagens = "SELECT u.nome, m.mensagem, m.data_envio FROM Mensagens m JOIN Utilizadores u ON m.remetente_id = u.id WHERE m.destinatario_id = ? ORDER BY m.data_envio DESC";
        ps = conn.prepareStatement(sqlMensagens);
        ps.setInt(1, profissionalId);
        rs = ps.executeQuery();

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

        // Buscar pacientes ligados ao profissional
        String sqlPacientes = "SELECT u.id, u.nome FROM Ligacoes l JOIN Utilizadores u ON l.id_paciente = u.id WHERE l.id_profissional = ? AND l.estado = 'Aceite'";
        ps = conn.prepareStatement(sqlPacientes);
        ps.setInt(1, profissionalId);
        rs = ps.executeQuery();
%>
	
	<h3>Enviar Nova Mensagem</h3>
	
    <form method="post" action="<%= request.getContextPath() %>/EnviarMensagemServlet">
        <select name="destinatarioId" required>
            <option value="">Selecione o paciente</option>
<%
        while (rs.next()) {
%>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("nome") %></option>
<%
        }
%>
        </select><br>
        <textarea name="mensagem" rows="4" cols="50" required></textarea><br>
        <button class="exit-button" type="submit">Enviar Mensagem</button>
    </form>

    <button class="exit-button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
</div>
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
        } catch (Exception ex) {
            out.println("Erro ao fechar recursos: " + ex.getMessage());
        }
    }
%>
