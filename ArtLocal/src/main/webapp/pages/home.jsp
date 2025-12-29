<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<ObraModel> obrasDestaque = (List<ObraModel>) request.getAttribute("obrasDestaque");
    List<UsuarioModel> artistasDestaque = (List<UsuarioModel>) request.getAttribute("artistasDestaque");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
%>

<section class="welcome-section">
    <div class="container">
        <h1>Descubra a Arte de Camaçari</h1>
        <p>Conecte-se com artistas locais e suas obras</p>
        <a href="<%= request.getContextPath() %>/explorar" class="btn-primary">Explorar Obras</a>
    </div>
</section>

<section class="obras-destaque">
    <div class="container">
        <h2>Obras em Destaque</h2>
        <div class="grid">
            <% if (obrasDestaque != null) {
                for (ObraModel obra : obrasDestaque) { %>
                    <div class="card-obra">
                        <div class="obra-image">
                            <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                        </div>
                        <div class="obra-info">
                            <h3><%= obra.getNomeObra() %></h3>
                            <p class="artista">Artista ID: <%= obra.getIdUsuario() %></p>
                            <% if (obra.getPreco() != null) { %>
                                <p class="preco">R$ <%= obra.getPreco() %></p>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-ver">Ver Detalhes</a>
                        </div>
                    </div>
            <%  }
            } %>
        </div>
    </div>
</section>

<section class="artistas-destaque">
    <div class="container">
        <h2>Artistas em Destaque</h2>
        <div class="grid">
            <% if (artistasDestaque != null) {
                for (UsuarioModel artista : artistasDestaque) { %>
                    <div class="card-artista">
                        <div class="artista-avatar">
                            <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>">
                        </div>
                        <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                        <p>Região ID: <%= artista.getIdRegiao() %></p>
                        <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-ver">Ver Perfil</a>
                    </div>
            <%  }
            } %>
        </div>
    </div>
</section>

<section class="categorias-section">
    <div class="container">
        <h2>Explore por Categoria</h2>
        <div class="grid">
            <% if (categorias != null) {
                for (CategoriaModel categoria : categorias) { %>
                    <div class="card-categoria">
                        <h3><%= categoria.getNomeCategoria() %></h3>
                        <p><%= categoria.getDescricao() %></p>
                        <a href="<%= request.getContextPath() %>/explorar?categoria=<%= categoria.getIdCategoria() %>" class="btn-ver">Explorar</a>
                    </div>
            <%  }
            } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />