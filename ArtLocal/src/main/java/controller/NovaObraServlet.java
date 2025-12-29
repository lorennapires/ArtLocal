package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.ObraDAO;
import dao.CategoriaDAO;
import model.UsuarioModel;
import model.ObraModel;
import model.CategoriaModel;
import java.math.BigDecimal;


@WebServlet("/nova-obra")
public class NovaObraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar se está logado e é artista
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }
        
        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        
        if (!"artista".equals(usuario.getTipoUsuario())) {
            response.sendRedirect("perfil");
            return;
        }
        
        // Buscar categorias para o dropdown
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/nova-obra.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Verificar se está logado e é artista
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }
        
        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        
        if (!"artista".equals(usuario.getTipoUsuario())) {
            response.sendRedirect("perfil");
            return;
        }
        
        // Receber dados do formulário
        String nomeObra = request.getParameter("nomeObra");
        String descricao = request.getParameter("descricao");
        String idCategoriaStr = request.getParameter("idCategoria");
        String linkExterno = request.getParameter("linkExterno");
        String precoStr = request.getParameter("preco");
        
        // Validações
        if (nomeObra == null || nomeObra.trim().isEmpty() ||
            descricao == null || descricao.trim().isEmpty() ||
            idCategoriaStr == null || idCategoriaStr.isEmpty()) {
            request.setAttribute("erro", "Nome, descrição e categoria são obrigatórios");
            doGet(request, response);
            return;
        }
        
        // Criar obra
        ObraModel obra = new ObraModel();
        obra.setIdUsuario(usuario.getIdUsuario());
        obra.setNomeObra(nomeObra);
        obra.setDescricao(descricao);
        obra.setIdCategoria(Integer.parseInt(idCategoriaStr));
        obra.setLinkExterno(linkExterno);
        
        if (precoStr != null && !precoStr.trim().isEmpty()) {
            obra.setPreco(new BigDecimal(precoStr));
        }
        
        // Inserir no banco
        ObraDAO obraDAO = new ObraDAO();
        boolean sucesso = obraDAO.inserir(obra);
        
        if (sucesso) {
            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao publicar obra");
            doGet(request, response);
        }
    }
}
