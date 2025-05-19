<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("paginainicial.jsp");
        return;
    }
    
    Integer pacienteId = userId;

    String titulo = request.getParameter("titulo");
    String conteudo = request.getParameter("conteudo");

    if (titulo == null || titulo.trim().isEmpty() || conteudo == null || conteudo.trim().isEmpty()) {
        response.sendRedirect("pacienteforum.jsp");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

        String sql = "INSERT INTO Forum (id_utilizador, titulo, conteudo) VALUES (?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, pacienteId);
        ps.setString(2, titulo);
        ps.setString(3, conteudo);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("pacienteforum.jsp");
        return;

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Erro ao criar tópico.");
    }
%>
