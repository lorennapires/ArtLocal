package controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import dao.ObraDAO;
import dao.CategoriaDAO;
import dao.TagDAO;
import model.UsuarioModel;
import model.ObraModel;
import model.CategoriaModel;
import model.TagModel;
import java.math.BigDecimal;

@WebServlet("/editar-obra")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 10 * 1024 * 1024,
    maxRequestSize    = 20 * 1024 * 1024
)
public class EditarObraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login");
            return;
        }

        UsuarioModel usuario = (UsuarioModel) session.getAttribute("usuarioLogado");
        if (!"artista".equals(usuario.getTipoUsuario())) {
            response.sendRedirect("perfil");
            return;
        }

        String idObraStr = request.getParameter("id");
        if (idObraStr == null || idObraStr.isEmpty()) {
            response.sendRedirect("perfil");
            return;
        }

        int idObra = Integer.parseInt(idObraStr);
        ObraDAO obraDAO = new ObraDAO();
        ObraModel obra = obraDAO.buscarPorId(idObra);

        if (obra == null || obra.getIdUsuario() != usuario.getIdUsuario()) {
            response.sendRedirect("perfil");
            return;
        }

        CategoriaDAO categoriaDAO = new CategoriaDAO();
        TagDAO tagDAO = new TagDAO();
        List<CategoriaModel> categorias = categoriaDAO.listarTodas();
        List<TagModel> tags = tagDAO.listarTodas();

        StringBuilder json = new StringBuilder("{");
        Integer catAtual = null;
        boolean primeiraTag = true;
        for (TagModel tag : tags) {
            if (!tag.getIdCategoria().equals(catAtual)) {
                if (catAtual != null) json.append("],");
                catAtual = tag.getIdCategoria();
                primeiraTag = true;
                json.append("\"").append(catAtual).append("\":[");
            }
            if (!primeiraTag) json.append(",");
            primeiraTag = false;
            json.append("{\"id\":").append(tag.getIdTag())
                .append(",\"nome\":\"").append(tag.getNomeTag().replace("\"", "\\\"")).append("\"}");
        }
        if (catAtual != null) json.append("]");
        json.append("}");

        request.setAttribute("obra", obra);
        request.setAttribute("categorias", categorias);
        request.setAttribute("tagsJson", json.toString());
        request.getRequestDispatcher("/pages/editar-obra.jsp").forward(request, response);
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
        if (!"artista".equals(usuario.getTipoUsuario())) {
            response.sendRedirect("perfil");
            return;
        }

        String acao      = request.getParameter("acao");
        String idObraStr = request.getParameter("idObra");
        if (idObraStr == null || idObraStr.isEmpty()) {
            response.sendRedirect("perfil");
            return;
        }

        int idObra = Integer.parseInt(idObraStr);
        ObraDAO obraDAO = new ObraDAO();
        ObraModel obraExistente = obraDAO.buscarPorId(idObra);

        if (obraExistente == null || obraExistente.getIdUsuario() != usuario.getIdUsuario()) {
            response.sendRedirect("perfil");
            return;
        }

        if ("excluir".equals(acao)) {
            obraDAO.deletar(idObra);
            response.sendRedirect("perfil");
            return;
        }

        String nomeObra       = request.getParameter("nomeObra");
        String descricao      = request.getParameter("descricao");
        String idCategoriaStr = request.getParameter("idCategoria");
        String linkExterno    = request.getParameter("linkExterno");
        String precoStr       = request.getParameter("preco");

        obraExistente.setNomeObra(nomeObra);
        obraExistente.setDescricao(descricao);
        obraExistente.setIdCategoria(Integer.parseInt(idCategoriaStr));
        obraExistente.setLinkExterno(linkExterno);

        if (precoStr != null && !precoStr.trim().isEmpty()) {
            obraExistente.setPreco(new BigDecimal(precoStr));
        } else {
            obraExistente.setPreco(null);
        }

        // Atualizar imagem se enviada
        Part filePart = request.getPart("novaImagem");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extrairNomeArquivo(filePart);
            if (fileName != null && !fileName.isEmpty()) {
                String extensao = fileName.substring(fileName.lastIndexOf('.'));
                String nomeArquivo = "obra_" + usuario.getIdUsuario() + "_" + System.currentTimeMillis() + extensao;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "obras";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + nomeArquivo);
                obraExistente.setImagemObra(nomeArquivo);
            }
        }

        boolean sucesso = obraDAO.atualizar(obraExistente);

        if (sucesso) {
            response.sendRedirect("perfil");
        } else {
            request.setAttribute("erro", "Erro ao atualizar obra. Tente novamente.");
            request.setAttribute("obra", obraExistente);
            request.setAttribute("tagsJson", "{}");
            doGet(request, response);
        }
    }

    private String extrairNomeArquivo(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                String nome = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return nome.isEmpty() ? null : nome;
            }
        }
        return null;
    }
}