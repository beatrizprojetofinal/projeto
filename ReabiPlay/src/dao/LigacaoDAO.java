package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LigacaoDAO {
    private Connection conn;

    public LigacaoDAO(Connection conn) {
        this.conn = conn;
    }

    // Para um paciente: obter o id do profissional com ligação aceite
    public Integer obterProfissionalLigado(int idPaciente) throws SQLException {
        String sql = "SELECT id_profissional FROM Ligacoes WHERE id_paciente = ? AND estado = 'Aceite'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPaciente);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id_profissional");
            }
        }
        return null;
    }

    // Para um profissional: listar ids de pacientes com ligação aceite
    public List<Integer> listarPacientesLigados(int idProfissional) throws SQLException {
        List<Integer> pacientes = new ArrayList<>();
        String sql = "SELECT id_paciente FROM Ligacoes WHERE id_profissional = ? AND estado = 'Aceite'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idProfissional);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                pacientes.add(rs.getInt("id_paciente"));
            }
        }
        return pacientes;
    }
}
