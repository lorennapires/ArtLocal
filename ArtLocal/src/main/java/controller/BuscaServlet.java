package controller;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ObraDAO;
import dao.UsuarioDAO;
import model.ObraModel;
import model.UsuarioModel;

@WebServlet("/busca")
public class BuscaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String termoBusca = request.getParameter("q");
        
        if (termoBusca == null || termoBusca.trim().isEmpty()) {
            response.sendRedirect("explorar");
            return;
        }
        
        ObraDAO obraDAO = new ObraDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        // Buscar obras por nome
        List<ObraModel> obras = obraDAO.buscarPorNome(termoBusca);
        
        // Buscar artistas por nome (filtrar da lista completa)
        List<UsuarioModel> todosArtistas = usuarioDAO.listarArtistas();
        List<UsuarioModel> artistas = new ArrayList<>();
        
        for (UsuarioModel artista : todosArtistas) {
            if (artista.getNomeArtistico() != null && 
                artista.getNomeArtistico().toLowerCase().contains(termoBusca.toLowerCase())) {
                artistas.add(artista);
            } else if (artista.getNomeCompleto().toLowerCase().contains(termoBusca.toLowerCase())) {
                artistas.add(artista);
            }
        }
        
        // Enviar para JSP
        request.setAttribute("termoBusca", termoBusca);
        request.setAttribute("obras", obras);
        request.setAttribute("artistas", artistas);
        
        request.getRequestDispatcher("/pages/busca.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
