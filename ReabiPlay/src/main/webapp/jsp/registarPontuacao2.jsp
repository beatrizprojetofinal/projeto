<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*" %>
<%@ page session="true" contentType="text/plain; charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");

    if (userId == null || !"Paciente".equals(userType)) {
        out.print("Acesso não autorizado. Por favor, inicie sessão.");
        return;
    }

    try {
        int pontuacao = Integer.parseInt(request.getParameter("pontuacao"));
        int tempo = Integer.parseInt(request.getParameter("tempo"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

            int idJogo = 2; // ID do jogo da memória - 8 pares

            String sql = "INSERT INTO Estatisticas (id_paciente, id_jogo, pontuacao, tempo_execucao) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, idJogo);
            ps.setInt(3, pontuacao);
            ps.setInt(4, tempo);

            int linhasAfetadas = ps.executeUpdate();
            if (linhasAfetadas > 0) {
                out.print("Pontuação registada com sucesso!");
            } else {
                out.print("Erro ao registar a pontuação.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Erro na base de dados: " + e.getMessage());
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    } catch (NumberFormatException e) {
        out.print("Parâmetros inválidos.");
    } catch (Exception e) {
        out.print("Erro inesperado: " + e.getMessage());
    }
%>
