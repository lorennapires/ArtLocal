package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.RegiaoModel;
import util.Conexao;

public class RegiaoDAO {

    public boolean inserir(RegiaoModel regiao) {
        String sql = "INSERT INTO regiao (nome_regiao) VALUES (?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, regiao.getNomeRegiao());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir região: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public RegiaoModel buscarPorId(int id) {
        String sql = "SELECT * FROM regiao WHERE id_regiao = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairRegiao(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar região: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return null;
    }

    public List<RegiaoModel> listarTodas() {
        String sql = "SELECT * FROM regiao ORDER BY nome_regiao";
        List<RegiaoModel> regioes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                regioes.add(extrairRegiao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar regiões: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return regioes;
    }

    public boolean atualizar(RegiaoModel regiao) {
        String sql = "UPDATE regiao SET nome_regiao = ? WHERE id_regiao = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, regiao.getNomeRegiao());
            stmt.setInt(2, regiao.getIdRegiao());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar região: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM regiao WHERE id_regiao = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar região: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public RegiaoModel buscarPorNome(String nome) {
        String sql = "SELECT * FROM regiao WHERE nome_regiao = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nome);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairRegiao(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar região por nome: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return null;
    }

    private RegiaoModel extrairRegiao(ResultSet rs) throws SQLException {
        RegiaoModel regiao = new RegiaoModel();
        regiao.setIdRegiao(rs.getInt("id_regiao"));
        regiao.setNomeRegiao(rs.getString("nome_regiao"));
        return regiao;
    }
}