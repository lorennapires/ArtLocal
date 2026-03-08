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

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RegiaoDAO regiaoDAO = new RegiaoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        TagDAO tagDAO = new TagDAO();

        List<RegiaoModel> regioes = regiaoDAO.listarTodas();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<TagModel> tags = tagDAO.listarTodas();

        // Gera JSON das tags agrupadas por id_categoria
        StringBuilder json = new StringBuilder("{");
        Integer categoriaAtual = null;
        boolean primeiraCategoria = true;
        boolean primeiraTag = true;

        for (TagModel tag : tags) {
            if (!tag.getIdCategoria().equals(categoriaAtual)) {
                if (categoriaAtual != null) {
                    json.append("]");
                    json.append(",");
                }
                if (!primeiraCategoria) {
                    // já fechou a vírgula acima
                }
                categoriaAtual = tag.getIdCategoria();
                primeiraCategoria = false;
                primeiraTag = true;
                json.append("\"").append(categoriaAtual).append("\":[");
            }
            if (!primeiraTag) {
                json.append(",");
            }
            primeiraTag = false;
            json.append("{\"id\":").append(tag.getIdTag())
                .append(",\"nome\":\"").append(tag.getNomeTag().replace("\"", "\\\"")).append("\"}");
        }
        if (categoriaAtual != null) {
            json.append("]");
        }
        json.append("}");

        request.setAttribute("regioes", regioes);
        request.setAttribute("categorias", categorias);
        request.setAttribute("tagsJson", json.toString());

        request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String tipoUsuario = request.getParameter("tipoUsuario");
        String nomeCompleto = request.getParameter("nomeCompleto");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String idIcone = request.getParameter("idIcone");
        String idRegiaoStr = request.getParameter("idRegiao");

        if (tipoUsuario == null || nomeCompleto == null || email == null ||
            senha == null || confirmarSenha == null) {
            request.setAttribute("erro", "Todos os campos obrigatórios devem ser preenchidos.");
            doGet(request, response);
            return;
        }

        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem.");
            doGet(request, response);
            return;
        }

        if (senha.length() < 6) {
            request.setAttribute("erro", "A senha deve ter pelo menos 6 caracteres.");
            doGet(request, response);
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        if (usuarioDAO.buscarPorEmail(email) != null) {
            request.setAttribute("erro", "Este email já está cadastrado.");
            doGet(request, response);
            return;
        }

        UsuarioModel usuario = new UsuarioModel();
        usuario.setNomeCompleto(nomeCompleto);
        usuario.setEmail(email);
        usuario.setSenha(senha);
        usuario.setTipoUsuario(tipoUsuario);
        usuario.setIdIcone(idIcone);

        if (idRegiaoStr != null && !idRegiaoStr.isEmpty()) {
            usuario.setIdRegiao(Integer.parseInt(idRegiaoStr));
        }

        if ("artista".equals(tipoUsuario)) {
            String nomeArtistico = request.getParameter("nomeArtistico");
            String biografia = request.getParameter("biografia");
            String categoriaPrincipalStr = request.getParameter("categoriaPrincipal");
            String tagsPrincipais = request.getParameter("tagsPrincipais");
            String portfolio = request.getParameter("portfolio");

            usuario.setNomeArtistico(nomeArtistico);
            usuario.setBiografia(biografia);
            usuario.setTagsPrincipais(tagsPrincipais);
            usuario.setPortfolio(portfolio);

            if (categoriaPrincipalStr != null && !categoriaPrincipalStr.isEmpty()) {
                usuario.setCategoriaPrincipal(Integer.parseInt(categoriaPrincipalStr));
            }
        }

        boolean sucesso = usuarioDAO.inserir(usuario);

        if (sucesso) {
            UsuarioModel usuarioCriado = usuarioDAO.buscarPorEmail(email);

            if (usuarioCriado != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuarioCriado);
                session.setAttribute("idUsuario", usuarioCriado.getIdUsuario());
                session.setAttribute("tipoUsuario", usuarioCriado.getTipoUsuario());
            }

            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao criar conta. Verifique os dados e tente novamente.");
            doGet(request, response);
        }
    }
}