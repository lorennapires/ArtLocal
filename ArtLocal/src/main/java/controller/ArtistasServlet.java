package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.UsuarioDAO;
import dao.RegiaoDAO;
import dao.CategoriaDAO;
import dao.TagDAO;
import model.UsuarioModel;
import model.RegiaoModel;
import model.CategoriaModel;
import model.TagModel;

@WebServlet("/artistas")
public class ArtistasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        TagDAO tagDAO = new TagDAO();

        String regiaoParam = request.getParameter("regiao");

        List<UsuarioModel> artistas;
        if (regiaoParam != null && !regiaoParam.isEmpty()) {
            artistas = usuarioDAO.listarArtistasPorRegiao(Integer.parseInt(regiaoParam));
        } else {
            artistas = usuarioDAO.listarArtistas();
        }

        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<TagModel> tags = tagDAO.listarTodas();

        Map<Integer, String> nomesRegioes = new HashMap<>();
        for (RegiaoModel r : regioes) nomesRegioes.put(r.getIdRegiao(), r.getNomeRegiao());

        Map<Integer, String> nomesCategorias = new HashMap<>();
        for (CategoriaModel c : categorias) nomesCategorias.put(c.getIdCategoria(), c.getNomeCategoria());

        Map<Integer, String> nomesTags = new HashMap<>();
        for (TagModel t : tags) nomesTags.put(t.getIdTag(), t.getNomeTag());

        request.setAttribute("artistas", artistas);
        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        request.setAttribute("nomesRegioes", nomesRegioes);
        request.setAttribute("nomesCategorias", nomesCategorias);
        request.setAttribute("nomesTags", nomesTags);

        request.getRequestDispatcher("/pages/artistas.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}