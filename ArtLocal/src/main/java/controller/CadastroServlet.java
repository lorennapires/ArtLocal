package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.UsuarioDAO;
import dao.RegiaoDAO;
import dao.CategoriaDAO;
import model.UsuarioModel;
import java.util.List;
import model.RegiaoModel;
import model.CategoriaModel;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Buscar dados para os dropdowns
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Receber dados do formulário
        String tipoUsuario = request.getParameter("tipoUsuario");
        String nomeCompleto = request.getParameter("nomeCompleto");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String idIcone = request.getParameter("idIcone");
        String idRegiaoStr = request.getParameter("idRegiao");
        
        // Validações básicas
        if (tipoUsuario == null || nomeCompleto == null || email == null || 
            senha == null || confirmarSenha == null) {
            request.setAttribute("erro", "Todos os campos obrigatórios devem ser preenchidos");
            doGet(request, response);
            return;
        }
        
        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem");
            doGet(request, response);
            return;
        }
        
        // Verificar se email já existe
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        if (usuarioDAO.buscarPorEmail(email) != null) {
            request.setAttribute("erro", "Este email já está cadastrado");
            doGet(request, response);
            return;
        }
        
        // Criar usuário
        UsuarioModel usuario = new UsuarioModel();
        usuario.setNomeCompleto(nomeCompleto);
        usuario.setEmail(email);
        usuario.setSenha(senha); // Em produção, usar hash de senha!
        usuario.setTipoUsuario(tipoUsuario);
        usuario.setIdIcone(idIcone);
        
        if (idRegiaoStr != null && !idRegiaoStr.isEmpty()) {
            usuario.setIdRegiao(Integer.parseInt(idRegiaoStr));
        }
        
        // Dados específicos de artista
        if ("artista".equals(tipoUsuario)) {
            String nomeArtistico = request.getParameter("nomeArtistico");
            String biografia = request.getParameter("biografia");
            String categoriaPrincipalStr = request.getParameter("categoriaPrincipal");
            String tagsPrincipais = request.getParameter("tagsPrincipais");
            String portfolio = request.getParameter("portfolio");
            
            usuario.setNomeArtistico(nomeArtistico);
            usuario.setBiografia(biografia);
            usuario.setTagsPrincipais(tagsPrincipais);
            usuario.setPortfolio(portfolio);
            
            if (categoriaPrincipalStr != null && !categoriaPrincipalStr.isEmpty()) {
                usuario.setCategoriaPrincipal(Integer.parseInt(categoriaPrincipalStr));
            }
        }
        
        // Inserir no banco
        boolean sucesso = usuarioDAO.inserir(usuario);
        
        if (sucesso) {
            // Buscar usuário recém-criado para fazer login automático
            UsuarioModel usuarioCriado = usuarioDAO.buscarPorEmail(email);
            
            if (usuarioCriado != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuarioCriado);
                session.setAttribute("idUsuario", usuarioCriado.getIdUsuario());
                session.setAttribute("tipoUsuario", usuarioCriado.getTipoUsuario());
            }
            
            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao criar conta. Tente novamente.");
            doGet(request, response);
        }
    }
}