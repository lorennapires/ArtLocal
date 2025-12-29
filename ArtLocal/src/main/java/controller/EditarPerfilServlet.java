package controller;

import java.io.IOException;
import java.util.List;
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
import model.RegiaoModel;
import model.CategoriaModel;

@WebServlet("/editar-perfil")
public class EditarPerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar se está logado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }
        
        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        
        // Buscar dados para os dropdowns
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("usuario", usuario);
        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/editar-perfil.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Verificar se está logado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
        response.sendRedirect("login");
        return;
        }
            UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
            
            // Receber dados do formulário
            String nomeCompleto = request.getParameter("nomeCompleto");
            String email = request.getParameter("email");
            String idIcone = request.getParameter("idIcone");
            String idRegiaoStr = request.getParameter("idRegiao");
            
            usuario.setNomeCompleto(nomeCompleto);
            usuario.setEmail(email);
            usuario.setIdIcone(idIcone);
            
            if (idRegiaoStr != null && !idRegiaoStr.isEmpty()) {
                usuario.setIdRegiao(Integer.parseInt(idRegiaoStr));
            }
            
            // Dados específicos de artista
            if ("artista".equals(usuario.getTipoUsuario())) {
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
            
            // Atualizar no banco
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            boolean sucesso = usuarioDAO.atualizar(usuario);
            
            if (sucesso) {
                // Atualizar sessão
                session.setAttribute("usuarioLogado", usuario);
                response.sendRedirect("perfil");
            } else {
                request.setAttribute("erro", "Erro ao atualizar perfil");
                doGet(request, response);
            }
        }
        }