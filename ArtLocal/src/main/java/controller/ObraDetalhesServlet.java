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
import dao.UsuarioDAO;
import dao.TagDAO;
import dao.InteracaoDAO;
import dao.CategoriaDAO;
import dao.RegiaoDAO;
import model.ObraModel;
import model.UsuarioModel;
import model.TagModel;
import model.CategoriaModel;
import model.RegiaoModel;

@WebServlet("/obra")
public class ObraDetalhesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("explorar");
            return;
        }

        int idObra = Integer.parseInt(idParam);
        ObraDAO obraDAO = new ObraDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        TagDAO tagDAO = new TagDAO();
        InteracaoDAO interacaoDAO = new InteracaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();

        ObraModel obra = obraDAO.buscarPorId(idObra);
        if (obra == null) {
            response.sendRedirect("explorar");
            return;
        }

        UsuarioModel artista = usuarioDAO.buscarPorId(obra.getIdUsuario());
        List<TagModel> tags = tagDAO.listarPorObra(idObra);
        int totalCurtidas = interacaoDAO.contarCurtidas(idObra);

        List<ObraModel> obrasRelacionadas = obraDAO.listarPorCategoria(obra.getIdCategoria());
        obrasRelacionadas.remove(obra);
        if (obrasRelacionadas.size() > 6) obrasRelacionadas = obrasRelacionadas.subList(0, 6);

        String nomeCategoria = null;
        if (obra.getIdCategoria() != null) {
            CategoriaModel cat = categoriaDAO.buscarPorId(obra.getIdCategoria());
            if (cat != null) nomeCategoria = cat.getNomeCategoria();
        }

        String nomeRegiao = null;
        if (artista != null && artista.getIdRegiao() != null) {
            RegiaoModel regiao = regiaoDAO.buscarPorId(artista.getIdRegiao());
            if (regiao != null) nomeRegiao = regiao.getNomeRegiao();
        }

        // mapa de nomes de tags para exibir as tags do artista
        Map<Integer,String> nomesTags = new HashMap<>();
        for (TagModel tag : tagDAO.listarTodas()) {
            nomesTags.put(tag.getIdTag(), tag.getNomeTag());
        }

        request.setAttribute("obra", obra);
        request.setAttribute("artista", artista);
        request.setAttribute("tags", tags);
        request.setAttribute("totalCurtidas", totalCurtidas);
        request.setAttribute("obrasRelacionadas", obrasRelacionadas);
        request.setAttribute("nomeCategoria", nomeCategoria);
        request.setAttribute("nomeRegiao", nomeRegiao);
        request.setAttribute("nomesTags", nomesTags);

        request.getRequestDispatcher("/pages/obra-detalhes.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}