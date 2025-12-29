package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CategoriaModel;
import util.Conexao;

public class CategoriaDAO {

    // Inserir nova categoria
    public boolean inserir(CategoriaModel categoria) {
        String sql = "INSERT INTO categoria (nome_categoria, descricao) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoria.getNomeCategoria());
            stmt.setString(2, categoria.getDescricao());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir categoria: " + e.getMessage());
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

    // Buscar categoria por ID
    public CategoriaModel buscarPorId(int id) {
        String sql = "SELECT * FROM categoria WHERE id_categoria = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairCategoria(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar categoria: " + e.getMessage());
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

    // Listar todas as categorias
    public List<CategoriaModel> listarTodas() {
        String sql = "SELECT * FROM categoria ORDER BY nome_categoria";
        List<CategoriaModel> categorias = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                categorias.add(extrairCategoria(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar categorias: " + e.getMessage());
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
        
        return categorias;
    }

    // Atualizar categoria
    public boolean atualizar(CategoriaModel categoria) {
        String sql = "UPDATE categoria SET nome_categoria = ?, descricao = ? WHERE id_categoria = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoria.getNomeCategoria());
            stmt.setString(2, categoria.getDescricao());
            stmt.setInt(3, categoria.getIdCategoria());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar categoria: " + e.getMessage());
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

    // Deletar categoria
    public boolean deletar(int id) {
        String sql = "DELETE FROM categoria WHERE id_categoria = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar categoria: " + e.getMessage());
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

    // Método auxiliar para extrair categoria do ResultSet
    private CategoriaModel extrairCategoria(ResultSet rs) throws SQLException {
        CategoriaModel categoria = new CategoriaModel();
        categoria.setIdCategoria(rs.getInt("id_categoria"));
        categoria.setNomeCategoria(rs.getString("nome_categoria"));
        categoria.setDescricao(rs.getString("descricao"));
        return categoria;
    }

    // Buscar categoria por nome
    public CategoriaModel buscarPorNome(String nome) {
        String sql = "SELECT * FROM categoria WHERE nome_categoria = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nome);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairCategoria(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar categoria por nome: " + e.getMessage());
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
}
