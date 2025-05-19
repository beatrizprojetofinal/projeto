<%@ page import="java.sql.*" %>
<%
    int idPedido = Integer.parseInt(request.getParameter("idPedido"));

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        String sql = "UPDATE Ligacoes SET estado = 'Recusado' WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idPedido);
        stmt.executeUpdate();

        response.sendRedirect("profissionalprincipal.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Erro ao recusar o pedido.");
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
