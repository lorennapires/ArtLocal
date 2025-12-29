package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.TagModel;
import util.Conexao;

public class TagDAO {

    // Inserir nova tag
    public boolean inserir(TagModel tag) {
        String sql = "INSERT INTO tag (nome_tag) VALUES (?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tag.getNomeTag());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir tag: " + e.getMessage());
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

    // Buscar tag por ID
    public TagModel buscarPorId(int id) {
        String sql = "SELECT * FROM tag WHERE id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairTag(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar tag: " + e.getMessage());
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

    // Listar todas as tags
    public List<TagModel> listarTodas() {
        String sql = "SELECT * FROM tag ORDER BY nome_tag";
        List<TagModel> tags = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                tags.add(extrairTag(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar tags: " + e.getMessage());
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
        
        return tags;
    }

    // Atualizar tag
    public boolean atualizar(TagModel tag) {
        String sql = "UPDATE tag SET nome_tag = ? WHERE id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tag.getNomeTag());
            stmt.setInt(2, tag.getIdTag());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar tag: " + e.getMessage());
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

    // Deletar tag
    public boolean deletar(int id) {
        String sql = "DELETE FROM tag WHERE id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar tag: " + e.getMessage());
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

    // Método auxiliar para extrair tag do ResultSet
    private TagModel extrairTag(ResultSet rs) throws SQLException {
        TagModel tag = new TagModel();
        tag.setIdTag(rs.getInt("id_tag"));
        tag.setNomeTag(rs.getString("nome_tag"));
        return tag;
    }

    // Buscar tag por nome
    public TagModel buscarPorNome(String nome) {
        String sql = "SELECT * FROM tag WHERE nome_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nome);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairTag(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar tag por nome: " + e.getMessage());
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

    // Listar tags de uma obra específica
    public List<TagModel> listarPorObra(int idObra) {
        String sql = "SELECT t.* FROM tag t " +
                     "INNER JOIN obra_tag ot ON t.id_tag = ot.id_tag " +
                     "WHERE ot.id_obra = ? ORDER BY t.nome_tag";
        List<TagModel> tags = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                tags.add(extrairTag(rs));
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
        
        return tags;
    }
}