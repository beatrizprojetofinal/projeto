<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Verificar se o utilizador é Administrador (segurança)
    String tipoUtilizador = (String) session.getAttribute("userType");
    if (tipoUtilizador == null || !"Administrador".equals(tipoUtilizador)) {
        response.sendRedirect("html/login.html");
        return;
    }

    String idParam = request.getParameter("id");
    String action = request.getParameter("action");

    if (idParam == null || action == null) {
        response.sendRedirect("adminconfirmar.jsp?error=Parâmetros inválidos");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("adminconfirmar.jsp?error=ID inválido");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        if ("confirmar".equals(action)) {
            // Atualiza ativo para TRUE (1)
            String sql = "UPDATE Utilizadores SET ativo = 1 WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } else if ("rejeitar".equals(action)) {
            // Pode deletar ou apenas marcar como rejeitado. Vou deletar o profissional:
            String sqlDeleteProfissional = "DELETE FROM Profissionais WHERE id = ?";
            ps = conn.prepareStatement(sqlDeleteProfissional);
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close();

            String sqlDeleteUtilizador = "DELETE FROM Utilizadores WHERE id = ?";
            ps = conn.prepareStatement(sqlDeleteUtilizador);
            ps.setInt(1, id);
            ps.executeUpdate();
        } else {
            response.sendRedirect("adminconfirmar.jsp?error=Ação inválida");
            return;
        }

        // Após operação, redirecionar para página de confirmação
        response.sendRedirect("adminconfirmar.jsp?success=Operação realizada com sucesso");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Erro ao processar: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
