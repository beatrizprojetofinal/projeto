<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Verifica se o paciente está autenticado
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String descricaoPlano = "";
    String dataInicio = "";
    String dataFim = "";
    String mensagemSolicitacao = "";
    boolean temLigacao = false;
    boolean ligacaoAceite = false;
    String nomeProfissional = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        // Verifica se existe ligação pendente ou aceite
        String sql = "SELECT L.estado, U.nome FROM Ligacoes L " +
                     "JOIN Profissionais P ON L.id_profissional = P.id " +
                     "JOIN Utilizadores U ON P.id = U.id " +
                     "WHERE L.id_paciente = ? AND L.estado IN ('Pendente', 'Aceite') LIMIT 1";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            temLigacao = true;
            String estado = rs.getString("estado");
            nomeProfissional = rs.getString("nome");
            if ("Aceite".equals(estado)) {
                ligacaoAceite = true;
            }
        }
        rs.close();
        stmt.close();

        // Consultar plano de reabilitação
        sql = "SELECT descricao, data_inicio, data_fim FROM PlanosReabilitacao WHERE id_paciente = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            descricaoPlano = rs.getString("descricao");
            dataInicio = rs.getString("data_inicio");
            dataFim = rs.getString("data_fim");
        } else {
            descricaoPlano = "Ainda não existe um profissional atribuído.";
        }
        rs.close();
        stmt.close();

        // Processar solicitação de ligação
        String emailProfissional = request.getParameter("emailProfissional");
        if (!temLigacao && emailProfissional != null && !emailProfissional.trim().isEmpty()) {
            // Verifica se o profissional existe
            sql = "SELECT id FROM Utilizadores WHERE email = ? AND tipo = 'Profissional'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, emailProfissional);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int profissionalId = rs.getInt("id");
                stmt.close();
                rs.close();

                // Envia mensagem
                String mensagemTexto = "O paciente deseja conectar-se consigo.";
                sql = "INSERT INTO Mensagens (remetente_id, destinatario_id, mensagem) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setInt(2, profissionalId);
                stmt.setString(3, mensagemTexto);
                stmt.executeUpdate();
                stmt.close();

                // Cria ligação pendente
                sql = "INSERT INTO Ligacoes (id_paciente, id_profissional, estado) VALUES (?, ?, 'Pendente')";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setInt(2, profissionalId);
                stmt.executeUpdate();
                stmt.close();

                mensagemSolicitacao = "Solicitação enviada com sucesso!";
                temLigacao = true;
            } else {
                mensagemSolicitacao = "Profissional não encontrado com esse email.";
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        mensagemSolicitacao = "Erro ao processar a solicitação.";
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ReabiPlay - Plano de Reabilitação</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/pacienteplanoreabilitacao.css"> 
</head>
<body>

  <div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="pacienteprincipal.jsp">Página Principal</a>
    <a href="pacienteplanoreabilitacao.jsp">Plano de Reabilitação</a>
    <a href="pacientejogos.jsp">Jogos</a>
    <a href="pacienteestatisticas.jsp">Estatísticas</a>
    <a href="pacientemensagens.jsp">Mensagens</a>
    <a href="pacienteforum.jsp">Fórum</a>
    <a href="pacienteperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
  </div>

  <div class="main-content">
    <h2>Plano de Reabilitação</h2>
    <p><em>O seu Profissional de Saúde deixou o seguinte plano de reabilitação disponível:</em></p>

    <div class="plan-box">
      <strong>Plano de Reabilitação</strong><br><br>
      <% if (!dataInicio.isEmpty()) { %>
        <strong>Início:</strong> <%= dataInicio %><br>
        <strong>Fim:</strong> <%= dataFim %><br><br>
      <% } %>
      <%= descricaoPlano.replaceAll("\n", "<br>") %>
    </div>

    <% if (temLigacao) { %>
      <div class="connect-box">
        <% if (ligacaoAceite) { %>
          <p class="mensagem-sucesso">Ligado com o profissional: <strong><%= nomeProfissional %></strong></p>
        <% } else { %>
          <p class="mensagem-sucesso">Solicitação de ligação pendente com: <strong><%= nomeProfissional %></strong></p>
        <% } %>
      </div>
    <% } else { %>
      <div class="connect-box">
        <h3>Conectar-se a um Profissional de Saúde</h3>
        <p>Introduza o email do profissional de saúde que deseja associar ao seu plano.</p>

        <form method="post" action="pacienteplanoreabilitacao.jsp" class="connect-form">
          <input type="email" name="emailProfissional" placeholder="Email do profissional" required />
          <button type="submit">Enviar Solicitação</button>
        </form>

        <% if (!mensagemSolicitacao.isEmpty()) { %>
          <p class="mensagem-sucesso"><%= mensagemSolicitacao %></p>
        <% } %>
      </div>
    <% } %>

    <button class="exit-button" onclick="window.location.href='paginainicial.jsp'">Sair</button>
  </div>

</body>
</html>
