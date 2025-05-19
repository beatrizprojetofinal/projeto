<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, util.DBConnection" %>
<%@ page session="true" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Verifica se o utilizador está autenticado
    Integer idPaciente = (Integer) session.getAttribute("userId");
    if (idPaciente == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        out.print("{\"erro\": \"Utilizador não autenticado\"}");
        return;
    }

    // Validação dos parâmetros
    String pontuacaoParam = request.getParameter("pontuacao");
    String tempoParam = request.getParameter("tempo");
    
    if (pontuacaoParam == null || tempoParam == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"erro\": \"Parâmetros ausentes\"}");
        return;
    }

    int pontuacao = 0;
    int tempo = 0;

    try {
        pontuacao = Integer.parseInt(pontuacaoParam);
        tempo = Integer.parseInt(tempoParam);
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"erro\": \"Parâmetros inválidos\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // Verifica se o jogo já existe
        int idJogo = -1;
        ps = conn.prepareStatement("SELECT id FROM Jogos WHERE nome = ?");
        ps.setString(1, "Jogo da Memória - 4 Pares");
        rs = ps.executeQuery();
        if (rs.next()) {
            idJogo = rs.getInt("id");
        }
        rs.close();
        ps.close();

        // Regista a pontuação na tabela Estatisticas
        ps = conn.prepareStatement(
            "INSERT INTO Estatisticas (id_paciente, id_jogo, pontuacao, tempo_execucao) VALUES (?, ?, ?, ?)"
        );
        ps.setInt(1, idPaciente);
        ps.setInt(2, idJogo);
        ps.setInt(3, pontuacao);
        ps.setInt(4, tempo);
        ps.executeUpdate();

        out.print("{\"sucesso\": true}");
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"erro\": \"" + e.getMessage().replace("\"", "'") + "\"}");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
