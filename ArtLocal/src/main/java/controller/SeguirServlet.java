package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.InteracaoDAO;
import model.UsuarioModel;
import model.InteracaoModel;

@WebServlet("/seguir")
public class SeguirServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        String idArtistaAlvoStr = request.getParameter("idArtistaAlvo");
        String redirect = request.getParameter("redirect");

        if (idArtistaAlvoStr != null && !idArtistaAlvoStr.isEmpty()) {
            int idArtistaAlvo = Integer.parseInt(idArtistaAlvoStr);
            InteracaoDAO interacaoDAO = new InteracaoDAO();

            if (!interacaoDAO.verificarInteracao(usuario.getIdUsuario(), "seguir", null, idArtistaAlvo)) {
                InteracaoModel interacao = new InteracaoModel();
                interacao.setIdUsuario(usuario.getIdUsuario());
                interacao.setIdUsuarioSeguido(idArtistaAlvo);
                interacao.setTipo("seguir");
                interacaoDAO.inserir(interacao);
            }
        }

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "artistas");
        }
    }
}