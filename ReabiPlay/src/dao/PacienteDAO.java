package dao;

import modelo.Paciente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection; // Classe de conexão ao banco

public class PacienteDAO {

    // Método original - lista todos os pacientes
    public List<Paciente> listarPacientes() throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String query = "SELECT u.id, u.nome, u.email, p.numero_utente " +
                       "FROM Utilizadores u " +
                       "JOIN Pacientes p ON u.id = p.id " +
                       "WHERE u.tipo = 'Paciente'"; 
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setId(rs.getInt("id"));
                paciente.setNome(rs.getString("nome"));
                paciente.setEmail(rs.getString("email"));
                paciente.setNumeroUtente(rs.getString("numero_utente"));
                pacientes.add(paciente);
            }
        }
        return pacientes;
    }

    // Novo método - lista pacientes conectados ao profissional com estado 'Aceite'
    public List<Paciente> listarPacientesPorProfissional(int profissionalId) throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String query = "SELECT u.id, u.nome, u.email, p.numero_utente " +
                       "FROM Ligacoes l " +
                       "JOIN Pacientes p ON l.id_paciente = p.id " +
                       "JOIN Utilizadores u ON p.id = u.id " +
                       "WHERE l.id_profissional = ? AND l.estado = 'Aceite'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, profissionalId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setId(rs.getInt("id"));
                paciente.setNome(rs.getString("nome"));
                paciente.setEmail(rs.getString("email"));
                paciente.setNumeroUtente(rs.getString("numero_utente"));
                pacientes.add(paciente);
            }
        }
        return pacientes;
    }
    
    public Paciente getPacientePorId(int id) throws SQLException {
        String query = "SELECT u.id, u.nome, u.email, p.numero_utente " +
                       "FROM Utilizadores u " +
                       "JOIN Pacientes p ON u.id = p.id " +
                       "WHERE u.id = ? AND u.tipo = 'Paciente'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    paciente.setNome(rs.getString("nome"));
                    paciente.setEmail(rs.getString("email"));
                    paciente.setNumeroUtente(rs.getString("numero_utente"));
                    return paciente;
                }
            }
        }

        return null; // ou lança uma exceção se preferires
    }

}
