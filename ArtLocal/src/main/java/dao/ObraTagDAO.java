package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ObraTagModel;
import util.Conexao;

public class ObraTagDAO {

    // Associar tag a uma obra
    public boolean inserir(ObraTagModel obraTag) {
        String sql = "INSERT INTO obra_tag (id_obra, id_tag) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, obraTag.getIdObra());
            stmt.setInt(2, obraTag.getIdTag());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao associar tag à obra: " + e.getMessage());
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

    // Associar múltiplas tags a uma obra
    public boolean inserirMultiplas(int idObra, List<Integer> idsTags) {
        String sql = "INSERT INTO obra_tag (id_obra, id_tag) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            conn.setAutoCommit(false); // Inicia transação
            stmt = conn.prepareStatement(sql);
            
            for (Integer idTag : idsTags) {
                stmt.setInt(1, idObra);
                stmt.setInt(2, idTag);
                stmt.addBatch();
            }
            
            stmt.executeBatch();
            conn.commit(); // Confirma transação
            return true;
            
        } catch (SQLException e) {
            System.err.println("Erro ao associar múltiplas tags: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Desfaz se der erro
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Listar todas as associações
    public List<ObraTagModel> listarTodas() {
        String sql = "SELECT * FROM obra_tag";
        List<ObraTagModel> associacoes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                associacoes.add(extrairObraTag(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar associações: " + e.getMessage());
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
        
        return associacoes;
    }

    // Listar tags de uma obra específica (retorna IDs das tags)
    public List<Integer> listarTagsPorObra(int idObra) {
        String sql = "SELECT id_tag FROM obra_tag WHERE id_obra = ?";
        List<Integer> idsTags = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                idsTags.add(rs.getInt("id_tag"));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar tags da obra: " + e.getMessage());
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
        
        return idsTags;
    }

    // Listar obras com uma tag específica (retorna IDs das obras)
    public List<Integer> listarObrasPorTag(int idTag) {
        String sql = "SELECT id_obra FROM obra_tag WHERE id_tag = ?";
        List<Integer> idsObras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTag);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                idsObras.add(rs.getInt("id_obra"));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar obras por tag: " + e.getMessage());
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
        
        return idsObras;
    }

    // Remover associação específica
    public boolean deletar(int idObra, int idTag) {
        String sql = "DELETE FROM obra_tag WHERE id_obra = ? AND id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            stmt.setInt(2, idTag);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar associação: " + e.getMessage());
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

    // Remover todas as tags de uma obra
    public boolean deletarTodasDaObra(int idObra) {
        String sql = "DELETE FROM obra_tag WHERE id_obra = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar tags da obra: " + e.getMessage());
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

    // Verificar se uma associação já existe
    public boolean existe(int idObra, int idTag) {
        String sql = "SELECT COUNT(*) as total FROM obra_tag WHERE id_obra = ? AND id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            stmt.setInt(2, idTag);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao verificar associação: " + e.getMessage());
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
        
        return false;
    }

    // Método auxiliar para extrair ObraTag do ResultSet
    private ObraTagModel extrairObraTag(ResultSet rs) throws SQLException {
        ObraTagModel obraTag = new ObraTagModel();
        obraTag.setIdObra(rs.getInt("id_obra"));
        obraTag.setIdTag(rs.getInt("id_tag"));
        return obraTag;
    }
}