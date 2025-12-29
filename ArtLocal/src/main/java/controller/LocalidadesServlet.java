package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.RegiaoDAO;
import dao.UsuarioDAO;
import dao.ObraDAO;
import model.RegiaoModel;

@WebServlet("/localidades")
public class LocalidadesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        ObraDAO obraDAO = new ObraDAO();
        
        // Buscar todas as regiões
        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        
        // Para cada região, contar artistas e obras
        for (RegiaoModel regiao : regioes) {
            int totalArtistas = usuarioDAO.listarArtistasPorRegiao(regiao.getIdRegiao()).size();
            int totalObras = obraDAO.listarPorRegiao(regiao.getIdRegiao()).size();
            
            // Adicionar informações como atributos (criar getters/setters extras se necessário)
            // Ou usar Map para passar essas informações
        }
        
        // Enviar para JSP
        request.setAttribute("regioes", regioes);
        
        request.getRequestDispatcher("/pages/localidades.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}