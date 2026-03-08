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

@WebServlet("/interacao")
public class InteracaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");

        String acao               = request.getParameter("acao");
        String tipo               = request.getParameter("tipo");
        String idObraStr          = request.getParameter("idObra");
        String idUsuarioSeguidoStr = request.getParameter("idUsuarioSeguido");
        String redirect           = request.getParameter("redirect");

        InteracaoDAO interacaoDAO = new InteracaoDAO();

        Integer idObra = (idObraStr != null && !idObraStr.isEmpty()) ? Integer.parseInt(idObraStr) : null;
        Integer idUsuarioSeguido = (idUsuarioSeguidoStr != null && !idUsuarioSeguidoStr.isEmpty())
                                   ? Integer.parseInt(idUsuarioSeguidoStr) : null;

        if ("adicionar".equals(acao)) {
            if (!interacaoDAO.verificarInteracao(usuario.getIdUsuario(), tipo, idObra, idUsuarioSeguido)) {
                InteracaoModel interacao = new InteracaoModel();
                interacao.setIdUsuario(usuario.getIdUsuario());
                interacao.setIdObra(idObra);
                interacao.setIdUsuarioSeguido(idUsuarioSeguido);
                interacao.setTipo(tipo);
                interacaoDAO.inserir(interacao);
            }
        } else if ("remover".equals(acao)) {
            interacaoDAO.deletar(usuario.getIdUsuario(), tipo, idObra, idUsuarioSeguido);
        }

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "explorar");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}