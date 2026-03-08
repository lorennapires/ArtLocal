<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.UsuarioModel, model.ObraModel, model.RegiaoModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    UsuarioModel artista = (UsuarioModel) request.getAttribute("artista");
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    Integer totalObras = (Integer) request.getAttribute("totalObras");
    Integer totalSeguidores = (Integer) request.getAttribute("totalSeguidores");
    RegiaoModel regiao = (RegiaoModel) request.getAttribute("regiao");
    String nomeCategoria = (String) request.getAttribute("nomeCategoria");
    Map<Integer,String> nomesTags = (Map<Integer,String>) request.getAttribute("nomesTags");

    UsuarioModel usuarioLogado = null;
    javax.servlet.http.HttpSession sessao = request.getSession(false);
    if (sessao != null) usuarioLogado = (UsuarioModel) sessao.getAttribute("usuarioLogado");

    boolean ehOProprioPerfil = usuarioLogado != null &&
                                usuarioLogado.getIdUsuario().equals(artista.getIdUsuario());

    String msgParam = request.getParameter("msg");
%>

<% if ("seguindo".equals(msgParam)) { %>
    <div style="background:#d4edda; color:#155724; padding:0.75rem 1rem; text-align:center; border-bottom:1px solid #c3e6cb;">
        ✅ Você agora está seguindo <%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %>!
    </div>
<% } %>

<section class="perfil-artista">
    <div class="container">

        <div class="perfil-header">
            <div class="perfil-cover"></div>
            <div class="perfil-info">
                <div class="perfil-avatar">
                    <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                         alt="<%= artista.getNomeArtistico() %>"
                         onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
                </div>
                <div class="perfil-dados">
                    <h1><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h1>
                    <p class="perfil-regiao">📍 <%= regiao != null ? regiao.getNomeRegiao() : "Região não informada" %></p>
                    <div class="perfil-stats">
                        <div class="stat"><strong><%= totalObras %></strong><span>Obras</span></div>
                        <div class="stat"><strong><%= totalSeguidores %></strong><span>Seguidores</span></div>
                    </div>
                    <div class="perfil-actions">
                        <% if (!ehOProprioPerfil) { %>
                            <form action="<%= request.getContextPath() %>/seguir" method="post" style="margin:0;">
                                <input type="hidden" name="idArtistaAlvo" value="<%= artista.getIdUsuario() %>">
                                <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>&msg=seguindo">
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

        <%-- Aba Sobre --%>
        <div class="tab-content active" id="sobre">
            <div class="sobre-content">
                <h2>Biografia</h2>
                <p><%= artista.getBiografia() != null && !artista.getBiografia().isEmpty() ? artista.getBiografia() : "Sem biografia." %></p>

                <% if (nomeCategoria != null) { %>
                    <h3>Categoria Principal</h3>
                    <span style="background:var(--gold); color:#fff; padding:3px 12px; border-radius:20px; font-size:0.9rem;">
                        🎨 <%= nomeCategoria %>
                    </span>
                <% } %>

                <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty()) { %>
                    <h3 style="margin-top:var(--spacing-md);">Tags</h3>
                    <div class="tags" style="display:flex; flex-wrap:wrap; gap:6px;">
                        <% for (String idTag : artista.getTagsPrincipais().split(",")) {
                            idTag = idTag.trim();
                            if (!idTag.isEmpty()) {
                                String nomeTag = null;
                                if (nomesTags != null) {
                                    try { nomeTag = nomesTags.get(Integer.parseInt(idTag)); } catch (NumberFormatException e) { nomeTag = idTag; }
                                }
                        %>
                            <span style="background:#f06292; color:#fff; padding:3px 10px; border-radius:20px; font-size:0.85rem;">
                                <%= nomeTag != null ? nomeTag : idTag %>
                            </span>
                        <% } } %>
                    </div>
                <% } %>

                <% if (artista.getPortfolio() != null && !artista.getPortfolio().isEmpty()) { %>
                    <h3 style="margin-top:var(--spacing-md);">Portfólio</h3>
                    <a href="<%= artista.getPortfolio() %>" target="_blank" class="btn-primary">Visitar Portfólio</a>
                <% } %>
            </div>
        </div>

        <%-- Aba Obras --%>
        <div class="tab-content" id="obras">
            <h2 style="margin-bottom:var(--spacing-md);">Obras de <%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h2>
            <div class="grid">
                <% if (obras != null && !obras.isEmpty()) {
                    for (ObraModel obra : obras) {
                        String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().isEmpty())
                                         ? obra.getImagemObra() : "placeholder.jpg";
                %>
                    <div class="card-obra">
                        <div class="obra-image">
                            <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                                 alt="<%= obra.getNomeObra() %>"
                                 onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
                        </div>
                        <div class="obra-info" style="display:flex; flex-direction:column; flex:1;">
                            <h3><%= obra.getNomeObra() %></h3>
                            <% if (obra.getPreco() != null) { %>
                                <p class="preco">R$ <%= obra.getPreco() %></p>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                               class="btn-ver" style="margin-top:auto;">Ver Detalhes</a>
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
                alert('Link copiado!');
            });
        }
    }
</script>

<jsp:include page="/includes/footer.jsp" />