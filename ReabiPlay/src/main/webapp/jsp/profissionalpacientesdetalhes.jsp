<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.PacienteDAO, dao.JogoDAO, modelo.Paciente, modelo.Jogo" %>
<%@ page import="java.util.List" %>
<%
	int pacienteId = Integer.parseInt(request.getParameter("id"));
	Integer idProfissional = (Integer) session.getAttribute("userId");
	PacienteDAO pacienteDAO = new PacienteDAO();
	Paciente paciente = pacienteDAO.getPacientePorId(pacienteId);
	
	JogoDAO jogoDAO = new JogoDAO();
	List<Jogo> jogos = jogoDAO.listarJogos();
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Paciente</title>
    <link rel="stylesheet" href="css/profissionalpacientesdetalhes.css">
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
    <h2>Detalhes do Paciente</h2>
    <p><strong>Nome:</strong> <%= paciente.getNome() %></p>

    <h3>Atribuir Jogo e Sugestão</h3>
	<form action="sugerirjogo.jsp" method="post">
	    <input type="hidden" name="id_paciente" value="<%= pacienteId %>">
            <label for="jogo">Selecione um jogo:</label>
        <select name="id_jogo" id="jogo" required>
            <% for (Jogo jogo : jogos) { %>
                <option value="<%= jogo.getId() %>"><%= jogo.getNome() %></option>
            <% } %>
        </select><br><br>

        <label for="mensagem">Mensagem/Sugestão:</label><br>
        <textarea name="mensagem" id="mensagem" rows="4" cols="50" placeholder="Ex: Jogue este jogo 3 vezes por semana."></textarea><br><br>
		
		<div class="button-container">
		    <button type="submit" class="sugerir-button">Sugerir Jogo</button>
		</div>

    </form>
</div>

</body>
</html>
