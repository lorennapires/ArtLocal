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
import javax.servlet.http.HttpSession;
import dao.ObraDAO;
import dao.InteracaoDAO;
import dao.RegiaoDAO;
import dao.CategoriaDAO;
import model.UsuarioModel;
import model.ObraModel;
import model.RegiaoModel;
import model.CategoriaModel;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        ObraDAO obraDAO = new ObraDAO();
        InteracaoDAO interacaoDAO = new InteracaoDAO();
        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();

        List<ObraModel> obras = null;
        int totalObras = 0;
        int totalSeguidores = 0;

        if ("artista".equals(usuario.getTipoUsuario())) {
            obras = obraDAO.listarPorUsuario(usuario.getIdUsuario());
            totalObras = obras.size();
            totalSeguidores = interacaoDAO.contarSeguidores(usuario.getIdUsuario());
        }

        String nomeRegiao = null;
        if (usuario.getIdRegiao() != null) {
            RegiaoModel regiao = regiaoDAO.buscarPorId(usuario.getIdRegiao());
            if (regiao != null) nomeRegiao = regiao.getNomeRegiao();
        }

        String nomeCategoria = null;
        if (usuario.getCategoriaPrincipal() != null) {
            CategoriaModel cat = categoriaDAO.buscarPorId(usuario.getCategoriaPrincipal());
            if (cat != null) nomeCategoria = cat.getNomeCategoria();
        }

        request.setAttribute("obras", obras);
        request.setAttribute("totalObras", totalObras);
        request.setAttribute("totalSeguidores", totalSeguidores);
        request.setAttribute("nomeRegiao", nomeRegiao);
        request.setAttribute("nomeCategoria", nomeCategoria);

        request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}