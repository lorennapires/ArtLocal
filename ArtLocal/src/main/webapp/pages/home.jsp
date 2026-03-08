<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.ObraModel, model.UsuarioModel, model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<ObraModel> obrasDestaque = (List<ObraModel>) request.getAttribute("obrasDestaque");
    List<UsuarioModel> artistasDestaque = (List<UsuarioModel>) request.getAttribute("artistasDestaque");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    Map<Integer,String> nomesCategorias = (Map<Integer,String>) request.getAttribute("nomesCategorias");
    String msg = request.getParameter("msg");
%>

<% if ("conta-excluida".equals(msg)) { %>
    <div style="background:#d4edda; color:#155724; padding:1rem; text-align:center; border-bottom:1px solid #c3e6cb;">
        ✅ Sua conta foi excluída com sucesso.
    </div>
<% } %>

<section class="welcome-section">
    <div class="container">
        <h1>Descubra a Arte de Camaçari</h1>
        <p>Conecte-se com artistas locais e suas obras</p>
        <a href="<%= request.getContextPath() %>/explorar" class="btn-primary btn-large">Explorar Obras</a>
    </div>
</section>

<section class="obras-destaque">
    <div class="container">
        <div class="obras-header">
            <h2>Obras em Destaque</h2>
            <a href="<%= request.getContextPath() %>/explorar" class="btn-primary">Ver Mais</a>
        </div>
        <div class="grid">
            <% if (obrasDestaque != null) {
                for (ObraModel obra : obrasDestaque) {
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
                           class="btn-ver" style="margin-top:auto;">Ver Detalhes</a>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
</section>

<section class="artistas-destaque">
    <div class="container">
        <div class="obras-header">
            <h2>Artistas em Destaque</h2>
            <a href="<%= request.getContextPath() %>/artistas" class="btn-primary">Ver Mais</a>
        </div>
        <div class="grid artistas-grid">
            <% if (artistasDestaque != null) {
                for (UsuarioModel artista : artistasDestaque) {
                    String nomeExibicao = artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto();
                    String nomeCategoria = "Artista Local";
                    if (nomesCategorias != null && artista.getCategoriaPrincipal() != null) {
                        String nc = nomesCategorias.get(artista.getCategoriaPrincipal());
                        if (nc != null) nomeCategoria = nc;
                    }
            %>
                <div class="card-artista">
                    <div class="artista-avatar">
                        <img src="<%= request.getContextPath() %>/images/avatares/<%= artista.getIdIcone() != null ? artista.getIdIcone() : "avatar1.png" %>"
                             alt="<%= nomeExibicao %>"
                             onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
                    </div>
                    <div class="artista-body">
                        <h3><%= nomeExibicao %></h3>
                        <p class="artista-categoria"><%= nomeCategoria %></p>
                    </div>
                    <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"
                       class="btn-ver">Ver Perfil</a>
                </div>
            <% } } %>
        </div>
    </div>
</section>

<section class="categorias-home">
    <div class="container">
        <div class="obras-header">
            <h2>Explore por Categoria</h2>
            <a href="<%= request.getContextPath() %>/categorias" class="btn-primary">Ver Todas</a>
        </div>
        <div class="grid">
            <% if (categorias != null) {
                for (CategoriaModel categoria : categorias) { %>
                    <div class="card-categoria">
                        <h3><%= categoria.getNomeCategoria() %></h3>
                        <p><%= categoria.getDescricao() != null ? categoria.getDescricao() : "" %></p>
                        <a href="<%= request.getContextPath() %>/explorar?categoria=<%= categoria.getIdCategoria() %>"
                           class="btn-ver">Explorar</a>
                    </div>
            <% } } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />