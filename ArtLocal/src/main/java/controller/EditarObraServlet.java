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

@WebServlet("/editar-obra")
public class EditarObraServlet extends HttpServlet {
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
        
        String idObraStr = request.getParameter("id");
        
        if (idObraStr == null || idObraStr.isEmpty()) {
            response.sendRedirect("perfil");
            return;
        }
        
        int idObra = Integer.parseInt(idObraStr);
        
        ObraDAO obraDAO = new ObraDAO();
        ObraModel obra = obraDAO.buscarPorId(idObra);
        
        // Verificar se a obra pertence ao usuário logado
        if (obra == null || obra.getIdUsuario() != usuario.getIdUsuario()) {
            response.sendRedirect("perfil");
            return;
        }
        
        // Buscar categorias para o dropdown
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("obra", obra);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/editar-obra.jsp").forward(request, response);
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
        
        String acao = request.getParameter("acao");
        String idObraStr = request.getParameter("idObra");
        
        if (idObraStr == null || idObraStr.isEmpty()) {
            response.sendRedirect("perfil");
            return;
        }
        
        int idObra = Integer.parseInt(idObraStr);
        ObraDAO obraDAO = new ObraDAO();
        
        // Verificar se a obra pertence ao usuário
        ObraModel obraExistente = obraDAO.buscarPorId(idObra);
        if (obraExistente == null || obraExistente.getIdUsuario() != usuario.getIdUsuario()) {
            response.sendRedirect("perfil");
            return;
        }
        
        // Ação de excluir
        if ("excluir".equals(acao)) {
            obraDAO.deletar(idObra);
            response.sendRedirect("perfil");
            return;
        }
        
        // Ação de atualizar
        String nomeObra = request.getParameter("nomeObra");
        String descricao = request.getParameter("descricao");
        String idCategoriaStr = request.getParameter("idCategoria");
        String linkExterno = request.getParameter("linkExterno");
        String precoStr = request.getParameter("preco");
        
        // Atualizar obra
        obraExistente.setNomeObra(nomeObra);
        obraExistente.setDescricao(descricao);
        obraExistente.setIdCategoria(Integer.parseInt(idCategoriaStr));
        obraExistente.setLinkExterno(linkExterno);
        
        if (precoStr != null && !precoStr.trim().isEmpty()) {
            obraExistente.setPreco(new BigDecimal(precoStr));
        } else {
            obraExistente.setPreco(null);
        }
        
        boolean sucesso = obraDAO.atualizar(obraExistente);
        
        if (sucesso) {
            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao atualizar obra");
            doGet(request, response);
        }
    }
}