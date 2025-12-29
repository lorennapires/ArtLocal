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
import dao.TagDAO;
import dao.InteracaoDAO;
import model.ObraModel;
import model.UsuarioModel;
import model.TagModel;

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
        
        // Buscar obra
        ObraModel obra = obraDAO.buscarPorId(idObra);
        
        if (obra == null) {
            response.sendRedirect("explorar");
            return;
        }
        
        // Buscar artista da obra
        UsuarioModel artista = usuarioDAO.buscarPorId(obra.getIdUsuario());
        
        // Buscar tags da obra
        List<TagModel> tags = tagDAO.listarPorObra(idObra);
        
        // Contar curtidas
        int totalCurtidas = interacaoDAO.contarCurtidas(idObra);
        
        // Buscar obras relacionadas (mesma categoria)
        List<ObraModel> obrasRelacionadas = obraDAO.listarPorCategoria(obra.getIdCategoria());
        obrasRelacionadas.remove(obra); // Remove a obra atual
        if (obrasRelacionadas.size() > 6) {
            obrasRelacionadas = obrasRelacionadas.subList(0, 6);
        }
        
        // Enviar para JSP
        request.setAttribute("obra", obra);
        request.setAttribute("artista", artista);
        request.setAttribute("tags", tags);
        request.setAttribute("totalCurtidas", totalCurtidas);
        request.setAttribute("obrasRelacionadas", obrasRelacionadas);
        
        request.getRequestDispatcher("/pages/obra-detalhes.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}