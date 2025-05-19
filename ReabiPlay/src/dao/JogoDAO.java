package dao;

import java.sql.*;
import modelo.Jogo;
import util.DBConnection;
import java.util.ArrayList;
import java.util.List;


public class JogoDAO {

    // Retorna um jogo pelo ID
    public Jogo obterJogoPorId(int jogoId) throws SQLException {
        String query = "SELECT id, nome, descricao FROM Jogos WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, jogoId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Jogo jogo = new Jogo();
                jogo.setId(rs.getInt("id"));
                jogo.setNome(rs.getString("nome"));
                jogo.setDescricao(rs.getString("descricao"));
                return jogo;
            }
        }
        return null;
    }

    public void sugerirJogoParaPaciente(int idPaciente, int idJogo, String mensagem, int idProfissional) throws SQLException {
        String query = "INSERT INTO Sugeridos (id_paciente, id_profissional, id_jogo, mensagem, data_sugestao) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, idPaciente);
            stmt.setInt(2, idProfissional); 
            stmt.setInt(3, idJogo);
            stmt.setString(4, mensagem);
            stmt.executeUpdate();
        }
    }


    // Retorna a sugestão mais recente feita ao paciente
    public Jogo obterSugestaoMaisRecente(int idPaciente) throws SQLException {
        String query = "SELECT j.id, j.nome, j.descricao " +
                       "FROM Sugeridos s " +
                       "JOIN Jogos j ON s.id_jogo = j.id " +
                       "WHERE s.id_paciente = ? " +
                       "ORDER BY s.data_sugestao DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Jogo jogo = new Jogo();
                jogo.setId(rs.getInt("id"));
                jogo.setNome(rs.getString("nome"));
                jogo.setDescricao(rs.getString("descricao"));
                return jogo;
            }
        }
        return null;
    }
    
    public List<Jogo> listarJogos() throws SQLException {
        List<Jogo> jogos = new ArrayList<>();
        String query = "SELECT id, nome, descricao FROM Jogos";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Jogo jogo = new Jogo();
                jogo.setId(rs.getInt("id"));
                jogo.setNome(rs.getString("nome"));
                jogo.setDescricao(rs.getString("descricao"));
                jogos.add(jogo);
            }
        }

        return jogos;
    }

}
