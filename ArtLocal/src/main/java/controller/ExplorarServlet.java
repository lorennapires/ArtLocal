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
import dao.ObraDAO;
import dao.CategoriaDAO;
import dao.RegiaoDAO;
import dao.TagDAO;
import model.ObraModel;
import model.CategoriaModel;
import model.RegiaoModel;
import model.TagModel;

@WebServlet("/explorar")
public class ExplorarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ObraDAO obraDAO = new ObraDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        TagDAO tagDAO = new TagDAO();

        String categoriaParam = request.getParameter("categoria");
        String regiaoParam    = request.getParameter("regiao");
        String ordenacao      = request.getParameter("ordem");

        List<ObraModel> obras;
        if (categoriaParam != null && !categoriaParam.isEmpty()) {
            obras = obraDAO.listarPorCategoria(Integer.parseInt(categoriaParam));
        } else if (regiaoParam != null && !regiaoParam.isEmpty()) {
            obras = obraDAO.listarPorRegiao(Integer.parseInt(regiaoParam));
        } else {
            obras = obraDAO.listarTodas();
        }

        if ("menor-preco".equals(ordenacao)) {
            obras.sort((o1, o2) -> {
                if (o1.getPreco() == null) return 1;
                if (o2.getPreco() == null) return -1;
                return o1.getPreco().compareTo(o2.getPreco());
            });
        } else if ("maior-preco".equals(ordenacao)) {
            obras.sort((o1, o2) -> {
                if (o1.getPreco() == null) return 1;
                if (o2.getPreco() == null) return -1;
                return o2.getPreco().compareTo(o1.getPreco());
            });
        }

        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();

        Map<Integer, String> nomesCategorias = new HashMap<>();
        for (CategoriaModel cat : categorias) {
            nomesCategorias.put(cat.getIdCategoria(), cat.getNomeCategoria());
        }

        // tags por obra: mapa idObra -> lista de tags
        Map<Integer, List<TagModel>> tagsPorObra = new HashMap<>();
        for (ObraModel obra : obras) {
            List<TagModel> tagsObra = tagDAO.listarPorObra(obra.getIdObra());
            tagsPorObra.put(obra.getIdObra(), tagsObra);
        }

        request.setAttribute("obras", obras);
        request.setAttribute("categorias", categorias);
        request.setAttribute("regioes", regioes);
        request.setAttribute("nomesCategorias", nomesCategorias);
        request.setAttribute("tagsPorObra", tagsPorObra);
        request.setAttribute("categoriaParam", categoriaParam);
        request.setAttribute("regiaoParam", regiaoParam);
        request.setAttribute("ordem", ordenacao);

        request.getRequestDispatcher("/pages/explorar.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}