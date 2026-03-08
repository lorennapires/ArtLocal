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

@WebServlet("/alterar-senha")
public class AlterarSenhaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");

        String senhaAtual    = request.getParameter("senhaAtual");
        String novaSenha     = request.getParameter("novaSenha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        if (!usuario.getSenha().equals(senhaAtual)) {
            request.setAttribute("erro", "Senha atual incorreta.");
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
            return;
        }

        if (novaSenha == null || novaSenha.length() < 6) {
            request.setAttribute("erro", "A nova senha deve ter pelo menos 6 caracteres.");
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
            return;
        }

        if (!novaSenha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem.");
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
            return;
        }

        usuario.setSenha(novaSenha);

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean sucesso = usuarioDAO.atualizar(usuario);

        if (sucesso) {
            session.setAttribute("usuarioLogado", usuario);
            request.setAttribute("sucesso", "Senha alterada com sucesso.");
        } else {
            request.setAttribute("erro", "Erro ao alterar senha. Tente novamente.");
        }

        request.setAttribute("usuario", usuario);
        request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
    }
}