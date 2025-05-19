package dao;

import modelo.Mensagem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MensagemDAO {

    private Connection conn;

    public MensagemDAO(Connection conn) {
        this.conn = conn;
    }

    public void enviarMensagem(Mensagem msg) throws SQLException {
        String sql = "INSERT INTO Mensagens (remetente_id, destinatario_id, mensagem) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, msg.getRemetenteId());
            stmt.setInt(2, msg.getDestinatarioId());
            stmt.setString(3, msg.getMensagem());
            stmt.executeUpdate();
        }
    }

    public List<Mensagem> listarMensagensRecebidas(int utilizadorId) throws SQLException {
        List<Mensagem> mensagens = new ArrayList<>();
        String sql = "SELECT * FROM Mensagens WHERE destinatario_id = ? ORDER BY data_envio DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, utilizadorId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Mensagem msg = new Mensagem();
                msg.setId(rs.getInt("id"));
                msg.setRemetenteId(rs.getInt("remetente_id"));
                msg.setDestinatarioId(rs.getInt("destinatario_id"));
                msg.setMensagem(rs.getString("mensagem"));
                msg.setDataEnvio(rs.getTimestamp("data_envio"));
                mensagens.add(msg);
            }
        }
        return mensagens;
    }
}
