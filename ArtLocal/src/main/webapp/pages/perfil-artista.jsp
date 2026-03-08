<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.RegiaoModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    UsuarioModel artista = (UsuarioModel) request.getAttribute("artista");
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    Integer totalObras = (Integer) request.getAttribute("totalObras");
    Integer totalSeguidores = (Integer) request.getAttribute("totalSeguidores");
    RegiaoModel regiao = (RegiaoModel) request.getAttribute("regiao");
    String nomeCategoria = (String) request.getAttribute("nomeCategoria");
    Map<Integer, String> nomesTags = (Map<Integer, String>) request.getAttribute("nomesTags");

    UsuarioModel usuarioLogado = null;
    javax.servlet.http.HttpSession sessao = request.getSession(false);
    if (sessao != null) {
        usuarioLogado = (UsuarioModel) sessao.getAttribute("usuarioLogado");
    }

    boolean ehOProprioPerfil = usuarioLogado != null &&
                                usuarioLogado.getIdUsuario().equals(artista.getIdUsuario());
%>

<section class="perfil-artista">
    <div class="container">

        <div class="perfil-header">
            <div class="perfil-cover"></div>
            <div class="perfil-info">
                <div class="perfil-avatar">
                    <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                         alt="<%= artista.getNomeArtistico() %>">
                </div>
                <div class="perfil-dados">
                    <h1><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h1>
                    <p class="perfil-regiao">📍 <%= regiao != null ? regiao.getNomeRegiao() : "Região não informada" %></p>

                    <div class="perfil-stats">
                        <div class="stat">
                            <strong><%= totalObras %></strong>
                            <span>Obras</span>
                        </div>
                        <div class="stat">
                            <strong><%= totalSeguidores %></strong>
                            <span>Seguidores</span>
                        </div>
                    </div>

                    <div class="perfil-actions">
                        <% if (!ehOProprioPerfil) { %>
                            <form action="<%= request.getContextPath() %>/seguir" method="post" style="margin:0;">
                                <input type="hidden" name="idArtistaAlvo" value="<%= artista.getIdUsuario() %>">
                                <button type="submit" class="btn-primary">Seguir</button>
                            </form>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/editar-perfil" class="btn-primary">Editar Perfil</a>
                        <% } %>
                        <button class="btn-secondary" onclick="compartilhar()">Compartilhar</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="perfil-tabs">
            <button class="tab active" data-tab="sobre">Sobre</button>
            <button class="tab" data-tab="obras">Obras</button>
        </div>

        <div class="tab-content active" id="sobre">
            <div class="sobre-content">
                <h2>Biografia</h2>
                <p><%= artista.getBiografia() != null && !artista.getBiografia().isEmpty() ? artista.getBiografia() : "Sem biografia." %></p>

                <% if (nomeCategoria != null) { %>
                    <h3>Categoria Principal</h3>
                    <p><%= nomeCategoria %></p>
                <% } %>

                <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty()) { %>
                    <h3>Tags</h3>
                    <div class="tags">
                        <% for (String idTag : artista.getTagsPrincipais().split(",")) {
                            idTag = idTag.trim();
                            if (!idTag.isEmpty()) {
                                String nomeTag = null;
                                if (nomesTags != null) {
                                    try { nomeTag = nomesTags.get(Integer.parseInt(idTag)); } catch (NumberFormatException e) { nomeTag = idTag; }
                                }
                        %>
                            <span class="badge"><%= nomeTag != null ? nomeTag : idTag %></span>
                        <% } } %>
                    </div>
                <% } %>

                <% if (artista.getPortfolio() != null && !artista.getPortfolio().isEmpty()) { %>
                    <h3>Portfólio</h3>
                    <a href="<%= artista.getPortfolio() %>" target="_blank" class="btn-primary">Visitar Portfólio</a>
                <% } %>
            </div>
        </div>

        <div class="tab-content" id="obras">
            <div class="obras-header">
                <h2>Obras de <%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h2>
            </div>
            <div class="grid">
                <% if (obras != null && !obras.isEmpty()) {
                    for (ObraModel obra : obras) { %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                            </div>
                            <div class="obra-info">
                                <h3><%= obra.getNomeObra() %></h3>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-ver">Ver Detalhes</a>
                            </div>
                        </div>
                <% } } else { %>
                    <p style="color:var(--gray);">Nenhuma obra publicada ainda.</p>
                <% } %>
            </div>
        </div>

    </div>
</section>

<script>
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            document.getElementById(this.getAttribute('data-tab')).classList.add('active');
        });
    });

    function compartilhar() {
        if (navigator.share) {
            navigator.share({
                title: '<%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %>',
                url: window.location.href
            });
        } else {
            navigator.clipboard.writeText(window.location.href).then(function() {
                alert('Link copiado para a área de transferência!');
            });
        }
    }
</script>

<jsp:include page="/includes/footer.jsp" />