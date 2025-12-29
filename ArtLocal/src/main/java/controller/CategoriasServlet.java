package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.CategoriaDAO;
import model.CategoriaModel;

@WebServlet("/categorias")
public class CategoriasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        // Buscar todas as categorias
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        
        // Enviar para JSP
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/pages/categorias.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}