<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("paginainicial.jsp");
        return;
    }
    Integer pacienteId = userId;

    String metodo = request.getMethod();

    String forumIdStr = request.getParameter("forumId");
    if (forumIdStr == null || forumIdStr.trim().isEmpty()) {
        response.sendRedirect("pacienteforum.jsp");
        return;
    }
    int forumId = Integer.parseInt(forumIdStr);

    if ("POST".equalsIgnoreCase(metodo)) {
        String resposta = request.getParameter("resposta");
        if (resposta != null && !resposta.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

                String sqlInsert = "INSERT INTO ForumRespostas (id_forum, id_utilizador, resposta) VALUES (?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, forumId);
                psInsert.setInt(2, pacienteId);
                psInsert.setString(3, resposta);
                psInsert.executeUpdate();

                psInsert.close();
                conn.close();

                response.sendRedirect("pacienteforumrespostas.jsp?forumId=" + forumId);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                out.println("Erro ao salvar resposta.");
            }
        } else {
            response.sendRedirect("pacienteforumrespostas.jsp?forumId=" + forumId);
            return;
        }
    }

    String titulo = "";
    String conteudo = "";
    String autorNome = "";
    Timestamp dataPublicacao = null;
    List<Map<String,Object>> respostas = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        String sqlTopico = "SELECT f.titulo, f.conteudo, f.data_publicacao, u.nome " +
                          "FROM Forum f JOIN Utilizadores u ON f.id_utilizador = u.id WHERE f.id = ?";
        PreparedStatement psTopico = conn.prepareStatement(sqlTopico);
        psTopico.setInt(1, forumId);
        ResultSet rsTopico = psTopico.executeQuery();

        if (rsTopico.next()) {
            titulo = rsTopico.getString("titulo");
            conteudo = rsTopico.getString("conteudo");
            dataPublicacao = rsTopico.getTimestamp("data_publicacao");
            autorNome = rsTopico.getString("nome");
        } else {
            response.sendRedirect("pacienteforum.jsp");
            return;
        }
        rsTopico.close();
        psTopico.close();

        String sqlRespostas = "SELECT r.resposta, r.data_resposta, u.nome " +
                              "FROM ForumRespostas r JOIN Utilizadores u ON r.id_utilizador = u.id " +
                              "WHERE r.id_forum = ? ORDER BY r.data_resposta ASC";
        PreparedStatement psRespostas = conn.prepareStatement(sqlRespostas);
        psRespostas.setInt(1, forumId);
        ResultSet rsRespostas = psRespostas.executeQuery();

        while (rsRespostas.next()) {
            Map<String,Object> resp = new HashMap<>();
            resp.put("resposta", rsRespostas.getString("resposta"));
            resp.put("data_resposta", rsRespostas.getTimestamp("data_resposta"));
            resp.put("nome", rsRespostas.getString("nome"));
            respostas.add(resp);
        }

        rsRespostas.close();
        psRespostas.close();

        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <title>ReabiPlay - Respostas do Fórum</title>
  <link rel="stylesheet" href="css/pacienteforumrespostas.css" />
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
    <h2><%= titulo %></h2>
    <p><em>Por: <%= autorNome %> | Criado em: <%= dataPublicacao.toLocalDateTime().toLocalDate() %></em></p>
    <p><%= conteudo %></p>

    <hr />

    <h3>Respostas (<%= respostas.size() %>)</h3>
    <% if (respostas.isEmpty()) { %>
      <p>Não há respostas ainda. Seja o primeiro a responder!</p>
    <% } else {
        for (Map<String,Object> r : respostas) {
    %>
      <div class="resposta-box">
        <p><strong><%= r.get("nome") %></strong> respondeu em <%= ((Timestamp)r.get("data_resposta")).toLocalDateTime().toLocalDate() %>:</p>
        <p><%= r.get("resposta") %></p>
      </div>
    <% }
    } %>

    <hr />

    <h3>Adicionar Resposta</h3>
    
    <form action="pacienteforumrespostas.jsp" method="post" class="resposta-form">
	  <input type="hidden" name="forumId" value="<%= forumId %>" />
	  <textarea name="resposta" rows="4" required class="input-field"></textarea><br />
	  <button type="submit" class="button center-button">Enviar Resposta</button>
	</form>
	
	<button class="button center-button" onclick="window.location.href='pacienteforum.jsp'">Voltar ao Fórum</button>
	    
  </div>
</body>
</html>
