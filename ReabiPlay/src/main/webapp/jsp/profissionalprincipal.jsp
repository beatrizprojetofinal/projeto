<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>ReabiPlay - Página Principal do Profissional</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/profissionalprincipal.css">
</head>
<body>

<div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="profissionalprincipal.jsp" class="active">Página Principal</a>
    <a href="profissionalpacientes.jsp">Pacientes</a>
    <a href="profissionalmensagens.jsp">Mensagens</a>
    <a href="profissionalperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main-content">
    <h2>Bem-vindo à sua área profissional</h2>
    <p><em>Veja abaixo os pedidos de conexão dos pacientes.</em></p>

    <h3>Pedidos de Conexão Pendentes</h3>
    <table border="1">
        <thead>
            <tr>
                <th>Nome do Paciente</th>
                <th>Email</th>
                <th>Data do Pedido</th>
                <th>Ação</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

                String sql = "SELECT l.id AS id_pedido, u.nome, u.email, l.data_solicitacao " +
                             "FROM Ligacoes l " +
                             "JOIN Utilizadores u ON l.id_paciente = u.id " +
                             "WHERE l.id_profissional = ? AND l.estado = 'Pendente'";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();

                boolean temPedidos = false;
                while (rs.next()) {
                    temPedidos = true;
        %>
            <tr>
                <td><%= rs.getString("nome") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getTimestamp("data_solicitacao") %></td>
                <td>
                    <form action="aceitarPedido.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="idPedido" value="<%= rs.getInt("id_pedido") %>">
                        <button type="submit">Aceitar</button>
                    </form>
                    <form action="recusarPedido.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="idPedido" value="<%= rs.getInt("id_pedido") %>">
                        <button type="submit">Recusar</button>
                    </form>
                </td>
            </tr>
        <%
                }
                if (!temPedidos) {
        %>
            <tr>
                <td colspan="4">Nenhum pedido pendente encontrado.</td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Erro ao carregar pedidos: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
