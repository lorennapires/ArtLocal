package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.UsuarioModel;
import util.Conexao;

public class UsuarioDAO {

    // Inserir novo usuário
    public boolean inserir(UsuarioModel usuario) {
        String sql = "INSERT INTO usuario (nome_completo, nome_artistico, id_icone, biografia, " +
                     "email, senha, tipo_usuario, portfolio, categoria_principal, tags_principais, " +
                     "id_regiao, data_criacao) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, usuario.getNomeCompleto());
            stmt.setString(2, usuario.getNomeArtistico());
            stmt.setString(3, usuario.getIdIcone());
            stmt.setString(4, usuario.getBiografia());
            stmt.setString(5, usuario.getEmail());
            stmt.setString(6, usuario.getSenha());
            stmt.setString(7, usuario.getTipoUsuario());
            stmt.setString(8, usuario.getPortfolio());
            
            if (usuario.getCategoriaPrincipal() != null) {
                stmt.setInt(9, usuario.getCategoriaPrincipal());
            } else {
                stmt.setNull(9, Types.INTEGER);
            }
            
            stmt.setString(10, usuario.getTagsPrincipais());
            
            if (usuario.getIdRegiao() != null) {
                stmt.setInt(11, usuario.getIdRegiao());
            } else {
                stmt.setNull(11, Types.INTEGER);
            }
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao inserir usuário: " + e.getMessage());
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

    // Buscar usuário por ID
    public UsuarioModel buscarPorId(int id) {
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairUsuario(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar usuário: " + e.getMessage());
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

    // Buscar usuário por email
    public UsuarioModel buscarPorEmail(String email) {
        String sql = "SELECT * FROM usuario WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairUsuario(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao buscar usuário por email: " + e.getMessage());
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

    // Listar todos os usuários
    public List<UsuarioModel> listarTodos() {
        String sql = "SELECT * FROM usuario ORDER BY data_criacao DESC";
        List<UsuarioModel> usuarios = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                usuarios.add(extrairUsuario(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar usuários: " + e.getMessage());
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
        
        return usuarios;
    }

    // Listar apenas artistas
    public List<UsuarioModel> listarArtistas() {
        String sql = "SELECT * FROM usuario WHERE tipo_usuario = 'artista' ORDER BY data_criacao DESC";
        List<UsuarioModel> artistas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                artistas.add(extrairUsuario(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar artistas: " + e.getMessage());
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
        
        return artistas;
    }

    // Listar artistas por região - NOVO!
    public List<UsuarioModel> listarArtistasPorRegiao(int idRegiao) {
        String sql = "SELECT * FROM usuario WHERE tipo_usuario = 'artista' AND id_regiao = ? " +
                     "ORDER BY data_criacao DESC";
        List<UsuarioModel> artistas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idRegiao);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                artistas.add(extrairUsuario(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao listar artistas por região: " + e.getMessage());
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
        
        return artistas;
    }

    // Atualizar usuário
    public boolean atualizar(UsuarioModel usuario) {
        String sql = "UPDATE usuario SET nome_completo = ?, nome_artistico = ?, id_icone = ?, " +
                     "biografia = ?, email = ?, senha = ?, tipo_usuario = ?, portfolio = ?, " +
                     "categoria_principal = ?, tags_principais = ?, id_regiao = ? WHERE id_usuario = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, usuario.getNomeCompleto());
            stmt.setString(2, usuario.getNomeArtistico());
            stmt.setString(3, usuario.getIdIcone());
            stmt.setString(4, usuario.getBiografia());
            stmt.setString(5, usuario.getEmail());
            stmt.setString(6, usuario.getSenha());
            stmt.setString(7, usuario.getTipoUsuario());
            stmt.setString(8, usuario.getPortfolio());
            
            if (usuario.getCategoriaPrincipal() != null) {
                stmt.setInt(9, usuario.getCategoriaPrincipal());
            } else {
                stmt.setNull(9, Types.INTEGER);
            }
            
            stmt.setString(10, usuario.getTagsPrincipais());
            
            if (usuario.getIdRegiao() != null) {
                stmt.setInt(11, usuario.getIdRegiao());
            } else {
                stmt.setNull(11, Types.INTEGER);
            }
            
            stmt.setInt(12, usuario.getIdUsuario());
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar usuário: " + e.getMessage());
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

    // Deletar usuário
    public boolean deletar(int id) {
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Erro ao deletar usuário: " + e.getMessage());
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

    // Método auxiliar para extrair usuário do ResultSet
    private UsuarioModel extrairUsuario(ResultSet rs) throws SQLException {
        UsuarioModel usuario = new UsuarioModel();
        usuario.setIdUsuario(rs.getInt("id_usuario"));
        usuario.setNomeCompleto(rs.getString("nome_completo"));
        usuario.setNomeArtistico(rs.getString("nome_artistico"));
        usuario.setIdIcone(rs.getString("id_icone"));
        usuario.setBiografia(rs.getString("biografia"));
        usuario.setEmail(rs.getString("email"));
        usuario.setSenha(rs.getString("senha"));
        usuario.setTipoUsuario(rs.getString("tipo_usuario"));
        usuario.setPortfolio(rs.getString("portfolio"));
        
        Integer categoriaPrincipal = rs.getInt("categoria_principal");
        if (!rs.wasNull()) {
            usuario.setCategoriaPrincipal(categoriaPrincipal);
        }
        
        usuario.setTagsPrincipais(rs.getString("tags_principais"));
        
        Integer idRegiao = rs.getInt("id_regiao");  // NOVO!
        if (!rs.wasNull()) {
            usuario.setIdRegiao(idRegiao);
        }
        
        Timestamp timestamp = rs.getTimestamp("data_criacao");
        if (timestamp != null) {
            usuario.setDataCriacao(timestamp.toLocalDateTime());
        }
        
        return usuario;
    }

    // Validar login
    public UsuarioModel validarLogin(String email, String senha) {
        String sql = "SELECT * FROM usuario WHERE email = ? AND senha = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = Conexao.getConexao();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, senha);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extrairUsuario(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Erro ao validar login: " + e.getMessage());
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