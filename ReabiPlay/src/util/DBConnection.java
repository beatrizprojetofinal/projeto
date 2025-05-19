package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/ReabiPlay?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // substitui pelo teu utilizador
    private static final String PASSWORD = "Supermercado00";  // substitui pela tua senha

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Erro na ligação à base de dados: " + e.getMessage());
            throw e;
        }
    }
}
