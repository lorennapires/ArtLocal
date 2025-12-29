package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.UsuarioDAO;
import dao.ObraDAO;
import dao.InteracaoDAO;
import dao.RegiaoDAO;
import model.UsuarioModel;
import model.ObraModel;
import model.RegiaoModel;

@WebServlet("/artista")
public class PerfilArtistaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("artistas");
            return;
        }
        
        int idArtista = Integer.parseInt(idParam);
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        ObraDAO obraDAO = new ObraDAO();
        InteracaoDAO interacaoDAO = new InteracaoDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        
        // Buscar artista
        UsuarioModel artista = usuarioDAO.buscarPorId(idArtista);
        
        if (artista == null || !"artista".equals(artista.getTipoUsuario())) {
            response.sendRedirect("artistas");
            return;
        }
        
        // Buscar obras do artista
        List<ObraModel> obras = obraDAO.listarPorUsuario(idArtista);
        
        // Buscar estatísticas
        int totalObras = obras.size();
        int totalSeguidores = interacaoDAO.contarSeguidores(idArtista);
        
        // Buscar região
        RegiaoModel regiao = null;
        if (artista.getIdRegiao() != null) {
            regiao = regiaoDAO.buscarPorId(artista.getIdRegiao());
        }
        
        // Enviar para JSP
        request.setAttribute("artista", artista);
        request.setAttribute("obras", obras);
        request.setAttribute("totalObras", totalObras);
        request.setAttribute("totalSeguidores", totalSeguidores);
        request.setAttribute("regiao", regiao);
        
        request.getRequestDispatcher("/pages/perfil-artista.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}