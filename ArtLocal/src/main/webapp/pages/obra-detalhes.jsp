<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.ObraModel, model.UsuarioModel, model.TagModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    ObraModel obra = (ObraModel) request.getAttribute("obra");
    UsuarioModel artista = (UsuarioModel) request.getAttribute("artista");
    List<TagModel> tags = (List<TagModel>) request.getAttribute("tags");
    Integer totalCurtidas = (Integer) request.getAttribute("totalCurtidas");
    List<ObraModel> obrasRelacionadas = (List<ObraModel>) request.getAttribute("obrasRelacionadas");
    String nomeCategoria = (String) request.getAttribute("nomeCategoria");
    String nomeRegiao = (String) request.getAttribute("nomeRegiao");
    Map<Integer,String> nomesTags = (Map<Integer,String>) request.getAttribute("nomesTags");

    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
    boolean ehOProprio = usuarioLogado != null && artista != null &&
                         usuarioLogado.getIdUsuario().equals(artista.getIdUsuario());

    String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().isEmpty())
                     ? obra.getImagemObra() : "placeholder.jpg";
    String imgArtista = (artista != null && artista.getIdIcone() != null)
                        ? artista.getIdIcone() : "avatar1.png";

    String msgParam = request.getParameter("msg");
%>

<section style="background:var(--light); min-height:100vh; padding:var(--spacing-lg) 0;">
    <div class="container" style="max-width:860px;">

        <% if ("curtiu".equals(msgParam)) { %>
            <div style="background:#d4edda; color:#155724; padding:0.75rem 1rem;
                        border-radius:var(--radius-md); margin-bottom:var(--spacing-md);">✅ Obra curtida!</div>
        <% } else if ("favoritou".equals(msgParam)) { %>
            <div style="background:#d4edda; color:#155724; padding:0.75rem 1rem;
                        border-radius:var(--radius-md); margin-bottom:var(--spacing-md);">✅ Adicionada aos favoritos!</div>
        <% } %>

        <div style="background:#fff; border-radius:var(--radius-lg); box-shadow:var(--shadow-md); overflow:hidden;">

            <%-- 1. FOTO NO TOPO, SEM CORTE --%>
            <div style="background:#1a1a1a; display:flex; align-items:center;
                        justify-content:center; width:100%;">
                <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                     alt="<%= obra.getNomeObra() %>"
                     style="max-width:100%; max-height:480px; object-fit:contain; display:block;"
                     onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
            </div>

            <div style="padding:var(--spacing-lg);">

                <%-- 2. TÍTULO --%>
                <h1 style="font-size:1.6rem; margin-bottom:0.5rem;"><%= obra.getNomeObra() %></h1>

                <%-- 3. CATEGORIA + TAGS DA OBRA --%>
                <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:var(--spacing-md); align-items:center;">
                    <% if (nomeCategoria != null) { %>
                        <span style="background:var(--gold); color:#fff; font-size:0.78rem;
                                     padding:3px 10px; border-radius:20px; font-weight:600;">
                            🎨 <%= nomeCategoria %>
                        </span>
                    <% } %>
                    <% if (tags != null && !tags.isEmpty()) {
                        for (TagModel tag : tags) { %>
                            <span style="background:#f06292; color:#fff; font-size:0.78rem;
                                         padding:3px 10px; border-radius:20px;">
                                <%= tag.getNomeTag() %>
                            </span>
                    <% } } %>
                </div>

                <%-- 4. ARTISTA --%>
                <% if (artista != null) { %>
                <div style="display:flex; align-items:center; gap:var(--spacing-sm);
                            padding:var(--spacing-sm) var(--spacing-md);
                            background:var(--light); border-radius:var(--radius-md);
                            margin-bottom:var(--spacing-lg);">
                    <img src="<%= request.getContextPath() %>/images/avatares/<%= imgArtista %>"
                         style="width:48px; height:48px; border-radius:50%; object-fit:cover;
                                border:2px solid var(--gold); flex-shrink:0;"
                         onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
                    <div style="flex:1; min-width:0;">
                        <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                           style="font-weight:700; color:var(--dark); text-decoration:none; font-size:0.95rem;">
                            <%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %>
                        </a>
                        <% if (nomeRegiao != null) { %>
                            <p style="color:var(--gray); font-size:0.8rem; margin:2px 0 0;">📍 <%= nomeRegiao %></p>
                        <% } %>
                        <% if (artista.getBiografia() != null && !artista.getBiografia().isEmpty()) { %>
                            <p style="color:var(--gray); font-size:0.8rem; margin:4px 0 0;
                                      display:-webkit-box; -webkit-line-clamp:2;
                                      -webkit-box-orient:vertical; overflow:hidden;">
                                <%= artista.getBiografia() %>
                            </p>
                        <% } %>
                        <%-- Tags do artista --%>
                        <% if (artista.getTagsPrincipais() != null && !artista.getTagsPrincipais().isEmpty() && nomesTags != null) { %>
                            <div style="display:flex; flex-wrap:wrap; gap:4px; margin-top:5px;">
                            <% for (String tid : artista.getTagsPrincipais().split(",")) {
                                try {
                                    String nt = nomesTags.get(Integer.parseInt(tid.trim()));
                                    if (nt != null) { %>
                                        <span style="background:#f06292; color:#fff; font-size:0.7rem;
                                                     padding:2px 7px; border-radius:20px;"><%= nt %></span>
                            <%      }
                                } catch(Exception e2) {} } %>
                            </div>
                        <% } %>
                    </div>
                    <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                       class="btn-secondary"
                       style="font-size:0.8rem; padding:4px 10px; white-space:nowrap; flex-shrink:0;">Ver Perfil</a>
                </div>
                <% } %>

                <%-- 5. DESCRIÇÃO --%>
                <h3 style="margin-bottom:0.4rem;">Descrição</h3>
                <p style="color:var(--gray); line-height:1.7; margin-bottom:var(--spacing-md);"><%= obra.getDescricao() %></p>

                <%-- 6. PREÇO --%>
                <% if (obra.getPreco() != null) { %>
                    <p style="font-size:1.4rem; font-weight:700; color:var(--primary);
                               margin-bottom:var(--spacing-md);">R$ <%= obra.getPreco() %></p>
                <% } %>

                <%-- 7. LINK EXTERNO --%>
                <% if (obra.getLinkExterno() != null && !obra.getLinkExterno().isEmpty()) { %>
                    <a href="<%= obra.getLinkExterno() %>" target="_blank" class="btn-primary"
                       style="display:inline-block; margin-bottom:var(--spacing-md);">Visitar Link Externo</a>
                <% } %>

                <%-- 8. AÇÕES --%>
                <div style="display:flex; gap:0.5rem; flex-wrap:wrap;
                            padding-top:var(--spacing-md); border-top:1px solid var(--gray-light);">
                    <% if (usuarioLogado != null) { %>
                        <form action="<%= request.getContextPath() %>/interacao" method="post" style="margin:0;">
                            <input type="hidden" name="acao" value="adicionar">
                            <input type="hidden" name="tipo" value="curtir">
                            <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">
                            <input type="hidden" name="redirect"
                                   value="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>&msg=curtiu">
                            <button type="submit" class="btn-action">
                                ❤️ Curtir (<%= totalCurtidas != null ? totalCurtidas : 0 %>)
                            </button>
                        </form>
                        <form action="<%= request.getContextPath() %>/interacao" method="post" style="margin:0;">
                            <input type="hidden" name="acao" value="adicionar">
                            <input type="hidden" name="tipo" value="favorito">
                            <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">
                            <input type="hidden" name="redirect"
                                   value="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>&msg=favoritou">
                            <button type="submit" class="btn-action">⭐ Favoritar</button>
                        </form>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login" class="btn-action">
                            ❤️ Curtir (<%= totalCurtidas != null ? totalCurtidas : 0 %>)
                        </a>
                        <a href="<%= request.getContextPath() %>/login" class="btn-action">⭐ Favoritar</a>
                    <% } %>
                    <button class="btn-action"
                        onclick="if(navigator.share){navigator.share({title:'<%= obra.getNomeObra() %>',url:window.location.href})}else{navigator.clipboard.writeText(window.location.href).then(()=>alert('Link copiado!'))}">
                        🔗 Compartilhar
                    </button>
                    <% if (usuarioLogado != null && ehOProprio) { %>
                        <a href="<%= request.getContextPath() %>/editar-obra?id=<%= obra.getIdObra() %>"
                           class="btn-secondary">✏️ Editar Obra</a>
                    <% } %>
                </div>
            </div>
        </div>

        <%-- OBRAS RELACIONADAS --%>
        <% if (obrasRelacionadas != null && !obrasRelacionadas.isEmpty()) { %>
            <div style="margin-top:var(--spacing-xl);">
                <h2 style="margin-bottom:var(--spacing-md);">Obras Relacionadas</h2>
                <div class="grid">
                    <% for (ObraModel obraRel : obrasRelacionadas) {
                        String imgRel = (obraRel.getImagemObra() != null && !obraRel.getImagemObra().isEmpty())
                                        ? obraRel.getImagemObra() : "placeholder.jpg";
                    %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/<%= imgRel %>"
                                     alt="<%= obraRel.getNomeObra() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
                            </div>
                            <div class="obra-info" style="display:flex; flex-direction:column; flex:1;">
                                <h3><%= obraRel.getNomeObra() %></h3>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obraRel.getIdObra() %>"
                                   class="btn-ver" style="margin-top:auto;">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>

    </div>
</section>

<jsp:include page="/includes/footer.jsp" />