<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String email = request.getParameter("email");
    String senha = request.getParameter("senha");

    // Verifica se os dados foram enviados (via POST)
    if (email != null && senha != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

            String sql = "SELECT id, tipo, palavra_passe FROM Utilizadores WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String senhaBD = rs.getString("palavra_passe");
                String tipo = rs.getString("tipo");
                int id = rs.getInt("id");

                if (senhaBD.equals(senha)) {
                    // Login bem-sucedido
                    session.setAttribute("userId", id);
                    session.setAttribute("userType", tipo);

                    if ("Paciente".equals(tipo)) {
                        response.sendRedirect("pacienteprincipal.jsp");
                    } else if ("Profissional".equals(tipo)) {
                        response.sendRedirect("profissionalprincipal.jsp");
                    } else if ("Familiar".equals(tipo)) {
                        response.sendRedirect("familiarprincipal.jsp");
                    } else if ("Administrador".equals(tipo)) {
                        response.sendRedirect("adminprincipal.jsp");
                    }
                    return; // Para garantir que não executa mais nada
                } else {
                    response.sendRedirect("html/login.html?error=Senha incorreta.");
                }
            } else {
                response.sendRedirect("html/login.html?error=Email não encontrado.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Erro de conexão: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        // Caso chegue aqui sem dados POST (acesso direto)
        response.sendRedirect("html/login.html");
    }
%>
