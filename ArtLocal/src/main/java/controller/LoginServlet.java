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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar se já está logado
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            response.sendRedirect("perfil");
            return;
        }
        
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        // Validar campos
        if (email == null || email.trim().isEmpty() || 
            senha == null || senha.trim().isEmpty()) {
            request.setAttribute("erro", "Email e senha são obrigatórios");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        UsuarioModel usuario = usuarioDAO.validarLogin(email, senha);
        
        if (usuario != null) {
            // Login bem-sucedido
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuario);
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("tipoUsuario", usuario.getTipoUsuario());
            
            response.sendRedirect("perfil");
        } else {
            // Login falhou
            request.setAttribute("erro", "Email ou senha incorretos");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
}