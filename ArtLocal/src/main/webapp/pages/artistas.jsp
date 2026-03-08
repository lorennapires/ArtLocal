<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<UsuarioModel> artistas = (List<UsuarioModel>) request.getAttribute("artistas");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    Map<Integer, String> nomesRegioes = (Map<Integer, String>) request.getAttribute("nomesRegioes");
    Map<Integer, String> nomesCategorias = (Map<Integer, String>) request.getAttribute("nomesCategorias");
    Map<Integer, String> nomesTags = (Map<Integer, String>) request.getAttribute("nomesTags");

    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
%>

<section class="artistas-section">
    <div class="container">
        <h1>Artistas de Camaçari</h1>

        <div class="filtros-bar">
            <form action="<%= request.getContextPath() %>/artistas" method="get">
                <select name="regiao">
                    <option value="">Todas as regiões</option>
                    <% if (regioes != null) {
                        for (RegiaoModel regiao : regioes) { %>
                            <option value="<%= regiao.getIdRegiao() %>"><%= regiao.getNomeRegiao() %></option>
                    <%  } } %>
                </select>
                <select name="ordem">
                    <option value="alfabetica">Ordem Alfabética</option>
                    <option value="recentes">Mais Recentes</option>
                </select>
                <button type="submit" class="btn-primary">Filtrar</button>
            </form>
        </div>

        <div class="grid artistas-grid">
            <% if (artistas != null && !artistas.isEmpty()) {
                for (UsuarioModel artista : artistas) {
                    boolean ehOProprio = usuarioLogado != null &&
                                        usuarioLogado.getIdUsuario().equals(artista.getIdUsuario());
            %>
                <div class="card-artista">
                    <div class="artista-avatar">
                        <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                             alt="<%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %>">
                    </div>
                    <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                    <% if (nomesRegioes != null && artista.getIdRegiao() != null) { %>
                        <p class="artista-regiao">📍 <%= nomesRegioes.get(artista.getIdRegiao()) %></p>
                    <% } %>
                    <% if (nomesCategorias != null && artista.getCategoriaPrincipal() != null) { %>
                        <p class="artista-categoria">🎨 <%= nomesCategorias.get(artista.getCategoriaPrincipal()) %></p>
                    <% } %>

                    <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty()) { %>
                        <div class="tags">
                            <% for (String idTagStr : artista.getTagsPrincipais().split(",")) {
                                idTagStr = idTagStr.trim();
                                if (!idTagStr.isEmpty()) {
                                    String nomeTag = null;
                                    if (nomesTags != null) {
                                        try { nomeTag = nomesTags.get(Integer.parseInt(idTagStr)); } catch (NumberFormatException e) { nomeTag = idTagStr; }
                                    }
                            %>
                                <span class="badge"><%= nomeTag != null ? nomeTag : idTagStr %></span>
                            <% } } %>
                        </div>
                    <% } %>

                    <div class="artista-actions">
                        <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-ver">Ver Perfil</a>
                        <% if (!ehOProprio) { %>
                            <form action="<%= request.getContextPath() %>/seguir" method="post" style="margin:0;">
                                <input type="hidden" name="idArtistaAlvo" value="<%= artista.getIdUsuario() %>">
                                <button type="submit" class="btn-secondary">Seguir</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } } else { %>
                <p class="no-results">Nenhum artista encontrado.</p>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />