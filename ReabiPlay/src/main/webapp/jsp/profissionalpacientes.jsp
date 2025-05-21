<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.PacienteDAO" %>
<%@ page import="modelo.Paciente" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReabiPlay - Pacientes</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/profissionalpacientes.css">
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
        <h2>Pacientes Associados</h2>
        <p><em>Lista de pacientes atualmente associados à sua plataforma.</em></p>
        
        <div class="patients-list">
            <ul>
                <%
                    Integer profissionalId = (Integer) session.getAttribute("userId");
                    if (profissionalId != null) {
                        PacienteDAO pacienteDAO = new PacienteDAO();
                        List<Paciente> pacientes = pacienteDAO.listarPacientesPorProfissional(profissionalId);

                        for (Paciente paciente : pacientes) {
                %>
                <li>
                    <%= paciente.getNome() %> 
                    <button onclick="verDetalhes('<%= paciente.getId() %>')">Ver Detalhes</button>
                </li>
                <% 
                        }
                    } else {
                %>
                    <li>Erro: Sessão expirada. Faça login novamente.</li>
                <% } %>
            </ul>
        </div>

        <button class="exit-button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
    </div>

    <script>
        function verDetalhes(pacienteId) {
            // Redireciona para página de detalhes (pode ser ajustado)
            window.location.href = "profissionalpacientesdetalhes.jsp?id=" + pacienteId;
        }
    </script>

</body>
</html>
