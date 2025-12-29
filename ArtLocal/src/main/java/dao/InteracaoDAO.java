package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.InteracaoModel;
import util.Conexao;

public class InteracaoDAO {

    // Inserir nova interação
    public boolean inserir(InteracaoModel interacao) {
        String sql = "INSERT INTO interacao (id_usuario, id_obra, id_usuario_seguido, tipo, data_interacao) " +
                     "VALUES (?, ?, ?, ?, NOW())";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, interacao.getIdUsuario());
            
            if (interacao.getIdObra() != null) {
                stmt.setInt(2, interacao.getIdObra());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            
            if (interacao.getIdUsuarioSeguido() != null) {
                stmt.setInt(3, interacao.getIdUsuarioSeguido());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            
            stmt.setString(4, interacao.getTipo());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir interação: " + e.getMessage());
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

    // Buscar interação por ID
    public InteracaoModel buscarPorId(int id) {
        String sql = "SELECT * FROM interacao WHERE id_interacao = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairInteracao(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar interação: " + e.getMessage());
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

    // Listar todas as interações
    public List<InteracaoModel> listarTodas() {
        String sql = "SELECT * FROM interacao ORDER BY data_interacao DESC";
        List<InteracaoModel> interacoes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                interacoes.add(extrairInteracao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar interações: " + e.getMessage());
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
        
        return interacoes;
    }

    // Listar interações de um usuário
    public List<InteracaoModel> listarPorUsuario(int idUsuario) {
        String sql = "SELECT * FROM interacao WHERE id_usuario = ? ORDER BY data_interacao DESC";
        List<InteracaoModel> interacoes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                interacoes.add(extrairInteracao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar interações do usuário: " + e.getMessage());
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
        
        return interacoes;
    }

    // Listar favoritos de um usuário (obras favoritadas)
    public List<InteracaoModel> listarFavoritos(int idUsuario) {
        String sql = "SELECT * FROM interacao WHERE id_usuario = ? AND tipo = 'favorito' " +
                     "ORDER BY data_interacao DESC";
        List<InteracaoModel> favoritos = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                favoritos.add(extrairInteracao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar favoritos: " + e.getMessage());
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
        
        return favoritos;
    }

    // Listar curtidas de uma obra
    public List<InteracaoModel> listarCurtidasObra(int idObra) {
        String sql = "SELECT * FROM interacao WHERE id_obra = ? AND tipo = 'curtir' " +
                     "ORDER BY data_interacao DESC";
        List<InteracaoModel> curtidas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                curtidas.add(extrairInteracao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar curtidas da obra: " + e.getMessage());
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
        
        return curtidas;
    }

    // Listar seguidores de um artista
    public List<InteracaoModel> listarSeguidores(int idArtista) {
        String sql = "SELECT * FROM interacao WHERE id_usuario_seguido = ? AND tipo = 'seguir' " +
                     "ORDER BY data_interacao DESC";
        List<InteracaoModel> seguidores = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idArtista);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                seguidores.add(extrairInteracao(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar seguidores: " + e.getMessage());
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
        
        return seguidores;
    }

    // Verificar se usuário já curtiu/favoritou/segue
    public boolean verificarInteracao(int idUsuario, String tipo, Integer idObra, Integer idUsuarioSeguido) {
        String sql = "SELECT COUNT(*) as total FROM interacao WHERE id_usuario = ? AND tipo = ?";
        
        if (idObra != null) {
            sql += " AND id_obra = ?";
        }
        if (idUsuarioSeguido != null) {
            sql += " AND id_usuario_seguido = ?";
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            stmt.setString(2, tipo);
            
            int paramIndex = 3;
            if (idObra != null) {
                stmt.setInt(paramIndex++, idObra);
            }
            if (idUsuarioSeguido != null) {
                stmt.setInt(paramIndex, idUsuarioSeguido);
            }
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao verificar interação: " + e.getMessage());
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

    // Deletar interação específica
    public boolean deletar(int idUsuario, String tipo, Integer idObra, Integer idUsuarioSeguido) {
        String sql = "DELETE FROM interacao WHERE id_usuario = ? AND tipo = ?";
        
        if (idObra != null) {
            sql += " AND id_obra = ?";
        }
        if (idUsuarioSeguido != null) {
            sql += " AND id_usuario_seguido = ?";
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            stmt.setString(2, tipo);
            
            int paramIndex = 3;
            if (idObra != null) {
                stmt.setInt(paramIndex++, idObra);
            }
            if (idUsuarioSeguido != null) {
                stmt.setInt(paramIndex, idUsuarioSeguido);
            }
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar interação: " + e.getMessage());
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

    // Contar curtidas de uma obra
    public int contarCurtidas(int idObra) {
        String sql = "SELECT COUNT(*) as total FROM interacao WHERE id_obra = ? AND tipo = 'curtir'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idObra);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao contar curtidas: " + e.getMessage());
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
        
        return 0;
    }

    // Contar seguidores de um artista
    public int contarSeguidores(int idArtista) {
        String sql = "SELECT COUNT(*) as total FROM interacao WHERE id_usuario_seguido = ? AND tipo = 'seguir'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idArtista);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao contar seguidores: " + e.getMessage());
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
        
        return 0;
    }

    // Método auxiliar para extrair interação do ResultSet
    private InteracaoModel extrairInteracao(ResultSet rs) throws SQLException {
        InteracaoModel interacao = new InteracaoModel();
        interacao.setIdInteracao(rs.getInt("id_interacao"));
        interacao.setIdUsuario(rs.getInt("id_usuario"));
        
        Integer idObra = rs.getInt("id_obra");
        if (!rs.wasNull()) {
            interacao.setIdObra(idObra);
        }
        
        Integer idUsuarioSeguido = rs.getInt("id_usuario_seguido");
        if (!rs.wasNull()) {
            interacao.setIdUsuarioSeguido(idUsuarioSeguido);
        }
        
        interacao.setTipo(rs.getString("tipo"));
        
        Timestamp timestamp = rs.getTimestamp("data_interacao");
        if (timestamp != null) {
            interacao.setDataInteracao(timestamp.toLocalDateTime());
        }
        
        return interacao;
    }
}