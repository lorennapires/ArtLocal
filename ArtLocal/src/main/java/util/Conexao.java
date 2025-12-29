package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    private static final String URL = "jdbc:mysql://localhost:3306/artlocal2345?useTimezone=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    public static Connection getConexao() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.err.println("Driver JDBC do MySQL não encontrado!");
            e.printStackTrace();
            return null;

        } catch (SQLException e) {
            System.err.println("Erro ao conectar com o banco de dados!");
            e.printStackTrace();
            return null;
        }
    }

    public static void fecharConexao(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar conexão!");
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        Connection conn = getConexao();

        if (conn != null) {
            System.out.println("Conexão realizada com sucesso!");
            fecharConexao(conn);
        } else {
            System.out.println("Falha na conexão!");
        }
    }
}