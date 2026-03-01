package controller;

import java.io.IOException;
import java.util.List;
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
        
        // Pegar parâmetros de filtro
        String categoriaParam = request.getParameter("categoria");
        String regiaoParam = request.getParameter("regiao");
        String ordenacao = request.getParameter("ordem");
        
        List<ObraModel> obras;
        
        // Aplicar filtros
        if (categoriaParam != null && !categoriaParam.isEmpty()) {
            obras = obraDAO.listarPorCategoria(Integer.parseInt(categoriaParam));
        } else if (regiaoParam != null && !regiaoParam.isEmpty()) {
            obras = obraDAO.listarPorRegiao(Integer.parseInt(regiaoParam));
        } else {
            obras = obraDAO.listarTodas();
        }
        
        // Aplicar ordenação
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
        } else if ("relevantes".equals(ordenacao)) {
            // TODO: Implementar ordenação por curtidas
            // Por enquanto, manter ordem padrão
        }
        // Se "recentes" ou null, manter ordem padrão (já vem do banco por data_criacao DESC)
        
        // Buscar dados para os filtros
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<TagModel> tags = tagDAO.listarTodas();
        
        // Enviar para JSP
        request.setAttribute("obras", obras);
        request.setAttribute("categorias", categorias);
        request.setAttribute("regioes", regioes);
        request.setAttribute("tags", tags);
        
        request.getRequestDispatcher("/pages/explorar.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}