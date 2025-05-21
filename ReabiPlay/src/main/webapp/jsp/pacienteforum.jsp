<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Define explicitamente o encoding da resposta
    response.setContentType("text/html;charset=UTF-8");
    response.setCharacterEncoding("UTF-8");

    // Pega o userId da sessão
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("paginainicial.jsp");
        return;
    }

    List<Map<String, Object>> posts = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ReabiPlay?useUnicode=true&characterEncoding=UTF-8", 
            "root", "Supermercado00");

        // Busca tópicos de usuários do tipo 'Paciente'
        String sql = "SELECT f.id, f.titulo, f.conteudo, f.data_publicacao, u.nome, " +
                     "(SELECT COUNT(*) FROM ForumRespostas fr WHERE fr.id_forum = f.id) AS respostasCount " +
                     "FROM Forum f " +
                     "JOIN Utilizadores u ON f.id_utilizador = u.id " +
                     "WHERE u.tipo = 'Paciente' " +
                     "ORDER BY f.data_publicacao DESC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> post = new HashMap<>();
            post.put("id", rs.getInt("id"));
            post.put("titulo", rs.getString("titulo"));
            post.put("conteudo", rs.getString("conteudo"));
            post.put("data_publicacao", rs.getTimestamp("data_publicacao"));
            post.put("nome", rs.getString("nome"));
            post.put("respostasCount", rs.getInt("respostasCount"));
            posts.add(post);
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <title>ReabiPlay - Fórum</title>
  <link rel="stylesheet" href="css/pacienteforum.css?<%= System.currentTimeMillis() %>" />
</head>
<body>
  <div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="pacienteprincipal.jsp">Página Principal</a>
    <a href="pacienteplanoreabilitacao.jsp">Plano de Reabilitação</a>
    <a href="pacientejogos.jsp">Jogos</a>
    <a href="pacientemensagens.jsp">Mensagens</a>
    <a href="pacienteforum.jsp" class="active">Fórum</a>
    <a href="pacienteperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
  </div>

  <div class="main-content">
    <h2>Fórum</h2>

    <hr style="margin-top: 10px;"/>

    <div class="novo-topico-wrapper">
      <h3>Criar Novo Tópico</h3>

      <form action="pacienteforum_criar.jsp" method="post" class="novo-topico-form">
        <label for="titulo">Título:</label><br />
        <input type="text" id="titulo" name="titulo" maxlength="255" required class="input-field" /><br /><br />

        <label for="conteudo">Conteúdo:</label><br />
        <textarea id="conteudo" name="conteudo" rows="6" required class="input-field"></textarea><br /><br />

        <button type="submit" class="button">Publicar</button>
      </form>
    </div>

    <hr style="margin-top: 40px;"/>

    <div class="forum-container">
      <% if (posts.isEmpty()) { %>
        <p>Nenhum tópico criado ainda. Seja o primeiro a criar um!</p>
      <% } else {
          for (Map<String,Object> post : posts) {
      %>
        <div class="forum-box">
          <div class="forum-header">
            <h3><%= post.get("titulo") %></h3>
            <span class="forum-meta">Por <strong><%= post.get("nome") %></strong> em <%= ((Timestamp)post.get("data_publicacao")).toLocalDateTime().toLocalDate() %></span>
            <span class="forum-meta">Respostas: <%= post.get("respostasCount") %></span>
          </div>
          <div class="forum-body">
            <p>
              <%= ((String)post.get("conteudo")).length() > 250 ? ((String)post.get("conteudo")).substring(0,250) + "..." : post.get("conteudo") %>
            </p>
          </div>
          <div class="forum-footer">
            <form action="pacienteforumrespostas.jsp" method="get">
              <input type="hidden" name="forumId" value="<%= post.get("id") %>" />
              <button class="button" type="submit">Ver Respostas</button>
            </form>
          </div>
        </div>
      <% }
      } %>
    </div>
  </div>
</body>
</html>
