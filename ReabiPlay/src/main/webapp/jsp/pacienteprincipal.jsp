<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JogoDAO, modelo.Jogo" %>
<%@ page import="java.sql.SQLException" %>
<%
	Integer idPaciente = (Integer) session.getAttribute("userId");
	if (idPaciente == null) {
	    response.sendRedirect("html/login.html");
	    return;
	}

    JogoDAO jogoDAO = new JogoDAO();
    Jogo jogoSugerido = null;

    try {
        jogoSugerido = jogoDAO.obterSugestaoMaisRecente(idPaciente);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ReabiPlay - Página Principal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/pacienteprincipal.css"> 
</head>
<body>

  <div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="pacienteprincipal.jsp?id=<%=idPaciente%>">Página Principal</a>
    <a href="pacienteplanoreabilitacao.jsp?id=<%=idPaciente%>">Plano de Reabilitação</a>
    <a href="pacientejogos.jsp?id=<%=idPaciente%>">Jogos</a>
    <a href="pacientemensagens.jsp?id=<%=idPaciente%>">Mensagens</a>
    <a href="pacienteforum.jsp?id=<%=idPaciente%>">Fórum</a>
    <a href="pacienteperfil.jsp?id=<%=idPaciente%>">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
  </div>

  <div class="main-content">
    <h2>Bem-vindo à sua área pessoal</h2>
    <% if (jogoSugerido != null) { %>
      <p><em>O seu Profissional de Saúde deixou o seguinte jogo disponível:</em></p>
      <div class="game-box">
        <strong><%= jogoSugerido.getNome() %></strong><br>
        <%= jogoSugerido.getDescricao() %><br><br>
        <%-- <a href="jogo<%= jogoSugerido.getNome().toLowerCase().replaceAll(" ", "") %>.jsp"> --%>
        <a href="pacientejogos.jsp">
          <button class="exit-button">Jogar</button>
        </a>
      </div>
    <% } else { %>
      <p><em>Nenhuma sugestão de jogo disponível no momento.</em></p>
    <% } %>

    <button class="exit-button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
  </div>

</body>
</html>
