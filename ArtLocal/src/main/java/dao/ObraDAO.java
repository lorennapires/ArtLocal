package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ObraModel;
import util.Conexao;

public class ObraDAO {

    public boolean inserir(ObraModel obra) {
        String sql = "INSERT INTO obra (id_usuario, id_categoria, nome_obra, descricao, " +
                     "link_externo, preco, imagem_obra, data_criacao) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, obra.getIdUsuario());
            stmt.setInt(2, obra.getIdCategoria());
            stmt.setString(3, obra.getNomeObra());
            stmt.setString(4, obra.getDescricao());
            stmt.setString(5, obra.getLinkExterno());
            stmt.setBigDecimal(6, obra.getPreco());
            stmt.setString(7, obra.getImagemObra() != null ? obra.getImagemObra() : "placeholder.jpg");
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao inserir obra: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public ObraModel buscarPorId(int id) {
        String sql = "SELECT * FROM obra WHERE id_obra = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) return extrairObra(rs);
        } catch (SQLException e) {
            System.err.println("Erro ao buscar obra: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return null;
    }

    public List<ObraModel> listarTodas() {
        String sql = "SELECT * FROM obra ORDER BY data_criacao DESC";
        List<ObraModel> obras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) obras.add(extrairObra(rs));
        } catch (SQLException e) {
            System.err.println("Erro ao listar obras: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return obras;
    }

    public List<ObraModel> listarPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM obra WHERE id_usuario = ? ORDER BY data_criacao DESC";
        List<ObraModel> obras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            rs = stmt.executeQuery();
            while (rs.next()) obras.add(extrairObra(rs));
        } catch (SQLException e) {
            System.err.println("Erro ao listar obras do usuário: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return obras;
    }

    public List<ObraModel> listarPorCategoria(int idCategoria) {
        String sql = "SELECT * FROM obra WHERE id_categoria = ? ORDER BY data_criacao DESC";
        List<ObraModel> obras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idCategoria);
            rs = stmt.executeQuery();
            while (rs.next()) obras.add(extrairObra(rs));
        } catch (SQLException e) {
            System.err.println("Erro ao listar obras por categoria: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return obras;
    }

    public List<ObraModel> listarPorRegiao(int idRegiao) {
        String sql = "SELECT o.* FROM obra o " +
                     "INNER JOIN usuario u ON o.id_usuario = u.id_usuario " +
                     "WHERE u.id_regiao = ? ORDER BY o.data_criacao DESC";
        List<ObraModel> obras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idRegiao);
            rs = stmt.executeQuery();
            while (rs.next()) obras.add(extrairObra(rs));
        } catch (SQLException e) {
            System.err.println("Erro ao listar obras por região: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return obras;
    }

    public List<ObraModel> buscarPorNome(String termo) {
        String sql = "SELECT * FROM obra WHERE nome_obra LIKE ? ORDER BY data_criacao DESC";
        List<ObraModel> obras = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + termo + "%");
            rs = stmt.executeQuery();
            while (rs.next()) obras.add(extrairObra(rs));
        } catch (SQLException e) {
            System.err.println("Erro ao buscar obras por nome: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return obras;
    }

    public boolean atualizar(ObraModel obra) {
        String sql = "UPDATE obra SET id_usuario = ?, id_categoria = ?, nome_obra = ?, " +
                     "descricao = ?, link_externo = ?, preco = ?, imagem_obra = ? WHERE id_obra = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, obra.getIdUsuario());
            stmt.setInt(2, obra.getIdCategoria());
            stmt.setString(3, obra.getNomeObra());
            stmt.setString(4, obra.getDescricao());
            stmt.setString(5, obra.getLinkExterno());
            stmt.setBigDecimal(6, obra.getPreco());
            stmt.setString(7, obra.getImagemObra() != null ? obra.getImagemObra() : "placeholder.jpg");
            stmt.setInt(8, obra.getIdObra());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar obra: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM obra WHERE id_obra = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao deletar obra: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    private ObraModel extrairObra(ResultSet rs) throws SQLException {
        ObraModel obra = new ObraModel();
        obra.setIdObra(rs.getInt("id_obra"));
        obra.setIdUsuario(rs.getInt("id_usuario"));
        obra.setIdCategoria(rs.getInt("id_categoria"));
        obra.setNomeObra(rs.getString("nome_obra"));
        obra.setDescricao(rs.getString("descricao"));
        obra.setLinkExterno(rs.getString("link_externo"));
        obra.setPreco(rs.getBigDecimal("preco"));
        obra.setImagemObra(rs.getString("imagem_obra"));
        Timestamp timestamp = rs.getTimestamp("data_criacao");
        if (timestamp != null) obra.setDataCriacao(timestamp.toLocalDateTime());
        return obra;
    }

    public int contarObrasPorUsuario(int idUsuario) {
        String sql = "SELECT COUNT(*) as total FROM obra WHERE id_usuario = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.err.println("Erro ao contar obras: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return 0;
    }
}