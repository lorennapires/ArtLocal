package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.UsuarioDAO;
import dao.RegiaoDAO;
import dao.CategoriaDAO;
import model.UsuarioModel;
import model.RegiaoModel;
import model.CategoriaModel;

@WebServlet("/artistas")
public class ArtistasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        // Pegar parâmetros de filtro
        String regiaoParam = request.getParameter("regiao");
        
        List<UsuarioModel> artistas;
        
        // Aplicar filtros
        if (regiaoParam != null && !regiaoParam.isEmpty()) {
            artistas = usuarioDAO.listarArtistasPorRegiao(Integer.parseInt(regiaoParam));
        } else {
            artistas = usuarioDAO.listarArtistas();
        }
        
        // Buscar dados para os filtros
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        // Enviar para JSP
        request.setAttribute("artistas", artistas);
        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/artistas.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}