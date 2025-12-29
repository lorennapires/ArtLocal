package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.ObraDAO;
import dao.InteracaoDAO;
import dao.RegiaoDAO;
import model.UsuarioModel;
import model.ObraModel;
import model.RegiaoModel;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar se está logado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }
        
        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        ObraDAO obraDAO = new ObraDAO();
        InteracaoDAO interacaoDAO = new InteracaoDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        
        // Buscar obras do usuário (se for artista)
        List<ObraModel> minhasObras = null;
        int totalObras = 0;
        int totalSeguidores = 0;
        
        if ("artista".equals(usuario.getTipoUsuario())) {
            minhasObras = obraDAO.listarPorUsuario(usuario.getIdUsuario());
            totalObras = minhasObras.size();
            totalSeguidores = interacaoDAO.contarSeguidores(usuario.getIdUsuario());
        }
        
        // Buscar favoritos
        List<Integer> idsFavoritos = interacaoDAO.listarFavoritos(usuario.getIdUsuario())
                                                  .stream()
                                                  .map(i -> i.getIdObra())
                                                  .collect(java.util.stream.Collectors.toList());
        
        // Buscar região
        RegiaoModel regiao = null;
        if (usuario.getIdRegiao() != null) {
            regiao = regiaoDAO.buscarPorId(usuario.getIdRegiao());
        }
        
        // Enviar para JSP
        request.setAttribute("usuario", usuario);
        request.setAttribute("minhasObras", minhasObras);
        request.setAttribute("totalObras", totalObras);
        request.setAttribute("totalSeguidores", totalSeguidores);
        request.setAttribute("regiao", regiao);
        
        request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}