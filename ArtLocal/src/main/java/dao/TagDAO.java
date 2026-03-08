package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.TagModel;
import util.Conexao;

public class TagDAO {

    public boolean inserir(TagModel tag) {
        String sql = "INSERT INTO tag (nome_tag, id_categoria) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tag.getNomeTag());
            stmt.setInt(2, tag.getIdCategoria());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao inserir tag: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

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

            if (rs.next()) return extrairTag(rs);

        } catch (SQLException e) {
            System.err.println("Erro ao buscar tag: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }

        return null;
    }

    public List<TagModel> listarTodas() {
        String sql = "SELECT * FROM tag ORDER BY id_categoria, nome_tag";
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
            } catch (SQLException e) { e.printStackTrace(); }
        }

        return tags;
    }

    public List<TagModel> listarPorCategoria(int idCategoria) {
        String sql = "SELECT * FROM tag WHERE id_categoria = ? ORDER BY nome_tag";
        List<TagModel> tags = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idCategoria);
            rs = stmt.executeQuery();

            while (rs.next()) {
                tags.add(extrairTag(rs));
            }

        } catch (SQLException e) {
            System.err.println("Erro ao listar tags por categoria: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }

        return tags;
    }

    public boolean atualizar(TagModel tag) {
        String sql = "UPDATE tag SET nome_tag = ?, id_categoria = ? WHERE id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tag.getNomeTag());
            stmt.setInt(2, tag.getIdCategoria());
            stmt.setInt(3, tag.getIdTag());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar tag: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM tag WHERE id_tag = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao deletar tag: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

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

            if (rs.next()) return extrairTag(rs);

        } catch (SQLException e) {
            System.err.println("Erro ao buscar tag por nome: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }

        return null;
    }

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
            } catch (SQLException e) { e.printStackTrace(); }
        }

        return tags;
    }

    private TagModel extrairTag(ResultSet rs) throws SQLException {
        TagModel tag = new TagModel();
        tag.setIdTag(rs.getInt("id_tag"));
        tag.setNomeTag(rs.getString("nome_tag"));
        tag.setIdCategoria(rs.getInt("id_categoria"));
        return tag;
    }
}