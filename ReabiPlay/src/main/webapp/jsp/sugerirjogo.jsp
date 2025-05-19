<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    int idPaciente = Integer.parseInt(request.getParameter("id_paciente"));
    int idJogo = Integer.parseInt(request.getParameter("id_jogo"));
    String mensagem = request.getParameter("mensagem");
    Integer idProfissional = (Integer) session.getAttribute("userId");

    if (idProfissional != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

            String sql = "INSERT INTO Sugeridos (id_paciente, id_profissional, id_jogo, mensagem) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfissional);
            stmt.setInt(3, idJogo);
            stmt.setString(4, mensagem);
            stmt.executeUpdate();

            response.sendRedirect("profissionalpacientes.jsp");
        } catch (Exception e) {
            out.println("Erro ao sugerir jogo: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        out.println("Sessão expirada. Faça login novamente.");
    }
%>
