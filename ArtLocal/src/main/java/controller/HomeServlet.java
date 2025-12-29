package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ObraDAO;
import dao.UsuarioDAO;
import dao.CategoriaDAO;
import model.ObraModel;
import model.UsuarioModel;
import model.CategoriaModel;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ObraDAO obraDAO = new ObraDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        // Buscar obras em destaque (12 mais recentes)
        List<ObraModel> obrasDestaque = obraDAO.listarTodas();
        if (obrasDestaque.size() > 12) {
            obrasDestaque = obrasDestaque.subList(0, 12);
        }
        
        // Buscar artistas em destaque (8 mais recentes)
        List<UsuarioModel> artistasDestaque = usuarioDAO.listarArtistas();
        if (artistasDestaque.size() > 8) {
            artistasDestaque = artistasDestaque.subList(0, 8);
        }
        
        // Buscar todas as categorias
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        // Enviar para JSP
        request.setAttribute("obrasDestaque", obrasDestaque);
        request.setAttribute("artistasDestaque", artistasDestaque);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/home.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}