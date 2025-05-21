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
    <style>
        /* Apenas estilos específicos locais */
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
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #ccc;
            max-width: 600px;
        }
        .form-wrapper {
            margin-top: 20px;
            margin-bottom: 40px;
        }
        .center-form {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }
        .center-form select,
        .center-form textarea {
            width: 100%;
            max-width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 16px;
        }
        
        button.button {
		    background-color: #A0522D !important;
		    color: white !important;
		    padding: 12px 28px;
		    border: none;
		    border-radius: 30px;
		    font-size: 16px;
		    cursor: pointer;
		    margin-top: 40px;
		    transition: background-color 0.3s ease;
		    display: inline-flex;
		    align-items: center;
		    justify-content: center;
		}
		
		button.button:hover {
		    background-color: #B5651D !important;
		}
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="profissionalprincipal.jsp">Página Principal</a>
    <a href="profissionalpacientes.jsp">Pacientes</a>
    <a href="profissionalmensagens.jsp">Mensagens</a>
    <a href="profissionalperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main-content">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        // Buscar pacientes ligados ao profissional
        String sqlPacientes = "SELECT u.id, u.nome FROM Ligacoes l JOIN Utilizadores u ON l.id_paciente = u.id WHERE l.id_profissional = ? AND l.estado = 'Aceite'";
        ps = conn.prepareStatement(sqlPacientes);
        ps.setInt(1, profissionalId);
        rs = ps.executeQuery();
%>

    <h2>Enviar Nova Mensagem</h2>
    <p><em>Envie uma mensagem a um dos seus pacientes.</em></p>
    
    <div class="form-wrapper">
        <form method="post" action="<%= request.getContextPath() %>/EnviarMensagemServlet" class="center-form">
            <select name="destinatarioId" required>
                <option value="">Selecione o paciente</option>
<%
    while (rs.next()) {
%>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("nome") %></option>
<%
    }
    rs.close();
    ps.close();
%>
            </select><br>
            <textarea name="mensagem" rows="4" cols="50" required></textarea><br>
            <button class="button" type="submit">Enviar Mensagem</button>
        </form>
        
        <%
		    String msg = request.getParameter("msg");
		    if ("sucesso".equals(msg)) {
		%>
		    <div class="alert success">
		        Mensagem enviada com sucesso!
		    </div>
		<%
		    }
		%>
    </div>

    <h2>Mensagens Recebidas</h2>
    <p><em>Veja as mensagens dos seus pacientes.</em></p>

<%
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
%>

    <button class="button" onclick="window.location.href='paginainicial.jsp'">Sair</button>

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
