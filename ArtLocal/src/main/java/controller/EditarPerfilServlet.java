package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.UsuarioDAO;
import dao.RegiaoDAO;
import dao.CategoriaDAO;
import dao.TagDAO;
import model.UsuarioModel;
import model.RegiaoModel;
import model.CategoriaModel;
import model.TagModel;

@WebServlet("/editar-perfil")
public class EditarPerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");

        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        TagDAO tagDAO = new TagDAO();

        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<TagModel> tags = tagDAO.listarTodas();

        StringBuilder json = new StringBuilder("{");
        Integer categoriaAtual = null;
        boolean primeiraTag = true;

        for (TagModel tag : tags) {
            if (!tag.getIdCategoria().equals(categoriaAtual)) {
                if (categoriaAtual != null) json.append("],");
                categoriaAtual = tag.getIdCategoria();
                primeiraTag = true;
                json.append("\"").append(categoriaAtual).append("\":[");
            }
            if (!primeiraTag) json.append(",");
            primeiraTag = false;
            json.append("{\"id\":").append(tag.getIdTag())
                .append(",\"nome\":\"").append(tag.getNomeTag().replace("\"", "\\\"")).append("\"}");
        }
        if (categoriaAtual != null) json.append("]");
        json.append("}");

        request.setAttribute("usuario", usuario);
        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        request.setAttribute("tagsJson", json.toString());

        request.getRequestDispatcher("/pages/editar-perfil.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");

        String nomeCompleto = request.getParameter("nomeCompleto");
        String email        = request.getParameter("email");
        String idIcone      = request.getParameter("idIcone");
        String idRegiaoStr  = request.getParameter("idRegiao");

        usuario.setNomeCompleto(nomeCompleto);
        usuario.setEmail(email);
        if (idIcone != null && !idIcone.isEmpty()) usuario.setIdIcone(idIcone);
        if (idRegiaoStr != null && !idRegiaoStr.isEmpty()) usuario.setIdRegiao(Integer.parseInt(idRegiaoStr));

        if ("artista".equals(usuario.getTipoUsuario())) {
            usuario.setNomeArtistico(request.getParameter("nomeArtistico"));
            usuario.setBiografia(request.getParameter("biografia"));
            usuario.setTagsPrincipais(request.getParameter("tagsPrincipais"));
            usuario.setPortfolio(request.getParameter("portfolio"));
            String catStr = request.getParameter("categoriaPrincipal");
            if (catStr != null && !catStr.isEmpty()) usuario.setCategoriaPrincipal(Integer.parseInt(catStr));
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean sucesso = usuarioDAO.atualizar(usuario);

        if (sucesso) {
            session.setAttribute("usuarioLogado", usuario);
            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao atualizar perfil. Tente novamente.");
            doGet(request, response);
        }
    }
}