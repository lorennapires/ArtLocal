<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.ObraModel, model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    String termoBusca = (String) request.getAttribute("termoBusca");
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    List<UsuarioModel> artistas = (List<UsuarioModel>) request.getAttribute("artistas");
    Map<Integer,String> nomesCategorias = (Map<Integer,String>) request.getAttribute("nomesCategorias");
    Map<Integer,String> nomesTags = (Map<Integer,String>) request.getAttribute("nomesTags");
%>

<section class="busca-section">
    <div class="container">
        <h1>Resultados para: "<%= termoBusca %>"</h1>

        <div class="perfil-tabs">
            <button class="tab active" data-tab="todos">Todos</button>
            <button class="tab" data-tab="obras-tab">Obras (<%= obras != null ? obras.size() : 0 %>)</button>
            <button class="tab" data-tab="artistas-tab">Artistas (<%= artistas != null ? artistas.size() : 0 %>)</button>
        </div>

        <div class="tab-content active" id="todos">
            <% if (obras != null && !obras.isEmpty()) { %>
                <h2 style="margin:var(--spacing-md) 0;">Obras</h2>
                <div class="grid" style="margin-bottom:var(--spacing-lg);">
                    <% for (ObraModel obra : obras) {
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
                                <% if (nomesCategorias != null && obra.getIdCategoria() != null) { %>
                                    <p style="color:var(--gray); font-size:0.85rem;">🎨 <%= nomesCategorias.get(obra.getIdCategoria()) %></p>
                                <% } %>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                                   class="btn-ver" style="margin-top:auto;">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <% if (artistas != null && !artistas.isEmpty()) { %>
                <h2 style="margin:var(--spacing-md) 0;">Artistas</h2>
                <div class="grid artistas-grid">
                    <% for (UsuarioModel artista : artistas) { %>
                        <div class="card-artista">
                            <div class="artista-avatar">
                                <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                                     alt="<%= artista.getNomeCompleto() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
                            </div>
                            <div class="artista-body">
                                <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                                <% if (nomesCategorias != null && artista.getCategoriaPrincipal() != null) { %>
                                    <p style="color:var(--gold); font-size:0.85rem; font-weight:600;">
                                        🎨 <%= nomesCategorias.get(artista.getCategoriaPrincipal()) %>
                                    </p>
                                <% } %>
                                <% if (artista.getBiografia() != null && !artista.getBiografia().isEmpty()) { %>
                                    <p style="color:var(--gray); font-size:0.85rem; margin:4px 0;
                                              display:-webkit-box; -webkit-line-clamp:2;
                                              -webkit-box-orient:vertical; overflow:hidden;">
                                        <%= artista.getBiografia() %>
                                    </p>
                                <% } %>
                                <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty() && nomesTags != null) {
                                    String[] tagIds = artista.getTagsPrincipais().split(","); %>
                                    <div style="display:flex; flex-wrap:wrap; gap:4px; margin:6px 0;">
                                    <% for (String tid : tagIds) {
                                        try {
                                            String nomeTag = nomesTags.get(Integer.parseInt(tid.trim()));
                                            if (nomeTag != null) { %>
                                                <span class="badge" style="font-size:0.75rem;"><%= nomeTag %></span>
                                    <%      }
                                        } catch(Exception e) {} }%>
                                    </div>
                                <% } %>
                            </div>
                            <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                               class="btn-ver">Ver Perfil</a>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <% if ((obras == null || obras.isEmpty()) && (artistas == null || artistas.isEmpty())) { %>
                <div class="no-results" style="text-align:center; padding:var(--spacing-xl);">
                    <p>Nenhum resultado encontrado para "<%= termoBusca %>".</p>
                    <a href="<%= request.getContextPath() %>/explorar" class="btn-primary" style="margin-top:var(--spacing-md); display:inline-block;">Explorar todas as obras</a>
                </div>
            <% } %>
        </div>

        <div class="tab-content" id="obras-tab">
            <% if (obras != null && !obras.isEmpty()) { %>
                <div class="grid">
                    <% for (ObraModel obra : obras) {
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
                                <% if (nomesCategorias != null && obra.getIdCategoria() != null) { %>
                                    <p style="color:var(--gray); font-size:0.85rem;">🎨 <%= nomesCategorias.get(obra.getIdCategoria()) %></p>
                                <% } %>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                                   class="btn-ver" style="margin-top:auto;">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <p class="no-results">Nenhuma obra encontrada.</p>
            <% } %>
        </div>

        <div class="tab-content" id="artistas-tab">
            <% if (artistas != null && !artistas.isEmpty()) { %>
                <div class="grid artistas-grid">
                    <% for (UsuarioModel artista : artistas) { %>
                        <div class="card-artista">
                            <div class="artista-avatar">
                                <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                                     alt="<%= artista.getNomeCompleto() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
                            </div>
                            <div class="artista-body">
                                <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                                <% if (nomesCategorias != null && artista.getCategoriaPrincipal() != null) { %>
                                    <p style="color:var(--gold); font-size:0.85rem; font-weight:600;">
                                        🎨 <%= nomesCategorias.get(artista.getCategoriaPrincipal()) %>
                                    </p>
                                <% } %>
                                <% if (artista.getBiografia() != null && !artista.getBiografia().isEmpty()) { %>
                                    <p style="color:var(--gray); font-size:0.85rem; margin:4px 0;
                                              display:-webkit-box; -webkit-line-clamp:2;
                                              -webkit-box-orient:vertical; overflow:hidden;">
                                        <%= artista.getBiografia() %>
                                    </p>
                                <% } %>
                                <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty() && nomesTags != null) {
                                    String[] tagIds = artista.getTagsPrincipais().split(","); %>
                                    <div style="display:flex; flex-wrap:wrap; gap:4px; margin:6px 0;">
                                    <% for (String tid : tagIds) {
                                        try {
                                            String nomeTag = nomesTags.get(Integer.parseInt(tid.trim()));
                                            if (nomeTag != null) { %>
                                                <span class="badge" style="font-size:0.75rem;"><%= nomeTag %></span>
                                    <%      }
                                        } catch(Exception e) {} } %>
                                    </div>
                                <% } %>
                            </div>
                            <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                               class="btn-ver">Ver Perfil</a>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <p class="no-results">Nenhum artista encontrado.</p>
            <% } %>
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
</script>

<jsp:include page="/includes/footer.jsp" />