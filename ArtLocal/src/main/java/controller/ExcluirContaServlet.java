package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.UsuarioDAO;
import model.UsuarioModel;

@WebServlet("/excluir-conta")
public class ExcluirContaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean sucesso = usuarioDAO.deletar(usuario.getIdUsuario());

        if (sucesso) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/home?msg=conta-excluida");
        } else {
            request.setAttribute("erro", "Erro ao excluir conta. Tente novamente.");
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
        }
    }
}