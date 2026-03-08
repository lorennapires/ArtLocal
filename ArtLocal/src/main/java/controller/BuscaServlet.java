package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ObraDAO;
import dao.UsuarioDAO;
import dao.CategoriaDAO;
import dao.TagDAO;
import model.ObraModel;
import model.UsuarioModel;
import model.CategoriaModel;
import model.TagModel;

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
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        TagDAO tagDAO = new TagDAO();

        List<ObraModel> obras = obraDAO.buscarPorNome(termoBusca);

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

        Map<Integer,String> nomesCategorias = new HashMap<>();
        for (CategoriaModel cat : categoriaDAO.listarTodas()) {
            nomesCategorias.put(cat.getIdCategoria(), cat.getNomeCategoria());
        }

        Map<Integer,String> nomesTags = new HashMap<>();
        for (TagModel tag : tagDAO.listarTodas()) {
            nomesTags.put(tag.getIdTag(), tag.getNomeTag());
        }

        request.setAttribute("termoBusca", termoBusca);
        request.setAttribute("obras", obras);
        request.setAttribute("artistas", artistas);
        request.setAttribute("nomesCategorias", nomesCategorias);
        request.setAttribute("nomesTags", nomesTags);

        request.getRequestDispatcher("/pages/busca.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}