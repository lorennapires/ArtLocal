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

    String msgSucesso = request.getParameter("msg");
%>

<section class="obra-detalhes">
    <div class="container" style="max-width:800px;">

        <% if ("curtiu".equals(msgSucesso)) { %>
            <div style="background:#d4edda; color:#155724; padding:0.75rem 1rem;
                        border-radius:var(--radius-md); margin-bottom:var(--spacing-md);">
                ✅ Obra curtida com sucesso!
            </div>
        <% } else if ("favoritou".equals(msgSucesso)) { %>
            <div style="background:#d4edda; color:#155724; padding:0.75rem 1rem;
                        border-radius:var(--radius-md); margin-bottom:var(--spacing-md);">
                ✅ Obra adicionada aos favoritos!
            </div>
        <% } %>

        <h1 style="margin-bottom:var(--spacing-md);"><%= obra.getNomeObra() %></h1>

        <%-- Artista — só aqui, não aparece mais abaixo --%>
        <% if (artista != null) { %>
        <div style="display:flex; align-items:flex-start; gap:var(--spacing-md); margin-bottom:var(--spacing-lg);
                    background:var(--light); border-radius:var(--radius-md); padding:var(--spacing-md);">
            <img src="<%= request.getContextPath() %>/images/avatares/<%= imgArtista %>"
                 alt="<%= artista.getNomeCompleto() %>"
                 style="width:75px; height:75px; border-radius:50%; object-fit:cover; border:3px solid var(--gold); flex-shrink:0;"
                 onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
            <div style="flex:1;">
                <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                   style="font-weight:700; color:var(--dark); text-decoration:none; font-size:1.1rem;">
                    <%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %>
                </a>
                <% if (nomeRegiao != null) { %>
                    <p style="color:var(--gray); font-size:0.85rem; margin:3px 0;">📍 <%= nomeRegiao %></p>
                <% } %>
                <% if (artista.getBiografia() != null && !artista.getBiografia().isEmpty()) { %>
                    <p style="color:var(--gray); font-size:0.88rem; margin:6px 0;"><%= artista.getBiografia() %></p>
                <% } %>
                <div style="margin-top:8px;">
                    <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                       class="btn-secondary" style="font-size:0.85rem; padding:4px 12px;">Ver Perfil Completo</a>
                </div>
            </div>
        </div>
        <% } %>

        <%-- Imagem da obra --%>
        <div style="margin-bottom:var(--spacing-lg);">
            <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                 alt="<%= obra.getNomeObra() %>"
                 style="width:100%; max-height:500px; object-fit:cover; border-radius:var(--radius-lg);"
                 onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
        </div>

        <%-- Categoria (dourado) + Tags da OBRA (rosa) --%>
        <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:var(--spacing-md); align-items:center;">
            <% if (nomeCategoria != null) { %>
                <span style="background:var(--gold); color:#fff; font-size:0.8rem;
                             padding:3px 10px; border-radius:20px; font-weight:600;">
                    🎨 <%= nomeCategoria %>
                </span>
            <% } %>
            <% if (tags != null) { for (TagModel tag : tags) { %>
                <span style="background:#f06292; color:#fff; font-size:0.8rem;
                             padding:3px 10px; border-radius:20px;">
                    <%= tag.getNomeTag() %>
                </span>
            <% } } %>
        </div>

        <%-- Descrição --%>
        <div style="margin-bottom:var(--spacing-md);">
            <h3>Descrição</h3>
            <p style="color:var(--gray); line-height:1.7;"><%= obra.getDescricao() %></p>
        </div>

        <%-- Preço --%>
        <% if (obra.getPreco() != null) { %>
            <p style="font-size:1.5rem; font-weight:700; color:var(--primary); margin-bottom:var(--spacing-md);">
                R$ <%= obra.getPreco() %>
            </p>
        <% } %>

        <%-- Link externo --%>
        <% if (obra.getLinkExterno() != null && !obra.getLinkExterno().isEmpty()) { %>
            <a href="<%= obra.getLinkExterno() %>" target="_blank" class="btn-primary"
               style="display:inline-block; margin-bottom:var(--spacing-md);">Visitar Link Externo</a>
        <% } %>

        <%-- Ações curtir/favoritar/compartilhar/editar --%>
        <div style="display:flex; gap:0.5rem; flex-wrap:wrap; margin-bottom:var(--spacing-xl);">
            <% if (usuarioLogado != null) { %>
                <form action="<%= request.getContextPath() %>/interacao" method="post" style="margin:0;">
                    <input type="hidden" name="acao" value="adicionar">
                    <input type="hidden" name="tipo" value="curtir">
                    <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">
                    <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>&msg=curtiu">
                    <button type="submit" class="btn-action">❤️ Curtir (<%= totalCurtidas != null ? totalCurtidas : 0 %>)</button>
                </form>
                <form action="<%= request.getContextPath() %>/interacao" method="post" style="margin:0;">
                    <input type="hidden" name="acao" value="adicionar">
                    <input type="hidden" name="tipo" value="favorito">
                    <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">
                    <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>&msg=favoritou">
                    <button type="submit" class="btn-action">⭐ Favoritar</button>
                </form>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="btn-action">❤️ Curtir (<%= totalCurtidas != null ? totalCurtidas : 0 %>)</a>
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

        <%-- Obras relacionadas --%>
        <% if (obrasRelacionadas != null && !obrasRelacionadas.isEmpty()) { %>
            <div>
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