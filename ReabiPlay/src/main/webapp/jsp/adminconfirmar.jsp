<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Confirmar Profissionais - ReabiPlay</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/jsp/css/adminconfirmar.css">
</head>
<body>

<div class="sidebar">
  <div class="logo">ReabiPlay</div>
  <a href="adminprincipal.jsp">Página Principal</a>
  <a href="adminconfirmar.jsp">Confirmar Profissionais</a>
  <a href="adminperfil.jsp">Perfil</a>
  <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main-content">
  <h2>Confirmar Profissionais de Saúde</h2>
  <p><em>Aqui encontra a lista de profissionais que aguardam confirmação.</em></p>

  <div class="confirmation-list">

    <%
      // Parâmetros de conexão
      String jdbcURL = "jdbc:mysql://localhost:3306/ReabiPlay";
      String dbUser = "root";
      String dbPassword = "Supermercado00"; 

      Connection conn = null;
      PreparedStatement stmt = null;
      ResultSet rs = null;

      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

          // Buscar profissionais com tipo = 'Profissional'
          String sql = "SELECT u.id, u.nome, u.email FROM Utilizadores u WHERE u.tipo = 'Profissional' AND u.ativo = 0";
          stmt = conn.prepareStatement(sql);
          rs = stmt.executeQuery();

          while (rs.next()) {
              int id = rs.getInt("id");
              String nome = rs.getString("nome");
              String email = rs.getString("email");
    %>
        <div class="professional-card">
          <p><strong>Nome:</strong> <%= nome %></p>
          <p><strong>Email:</strong> <%= email %></p>
          <form method="post" action="confirmarProfissional.jsp" style="display:inline;">
            <input type="hidden" name="id" value="<%= id %>">
            <button type="submit" name="action" value="confirmar" class="confirm-button">Confirmar</button>
          </form>
          <form method="post" action="confirmarProfissional.jsp" style="display:inline;">
            <input type="hidden" name="id" value="<%= id %>">
            <button type="submit" name="action" value="rejeitar" class="reject-button">Rejeitar</button>
          </form>
        </div>
    <%
          }
      } catch (Exception e) {
          out.println("<p>Erro ao carregar profissionais: " + e.getMessage() + "</p>");
      } finally {
          try { if (rs != null) rs.close(); } catch (Exception e) {}
          try { if (stmt != null) stmt.close(); } catch (Exception e) {}
          try { if (conn != null) conn.close(); } catch (Exception e) {}
      }
    %>

  </div>
</div>

</body>
</html>
