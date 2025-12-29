<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.TagModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    ObraModel obra = (ObraModel) request.getAttribute("obra");
    UsuarioModel artista = (UsuarioModel) request.getAttribute("artista");
    List<TagModel> tags = (List<TagModel>) request.getAttribute("tags");
    Integer totalCurtidas = (Integer) request.getAttribute("totalCurtidas");
    List<ObraModel> obrasRelacionadas = (List<ObraModel>) request.getAttribute("obrasRelacionadas");
%>

<section class="obra-detalhes">
    <div class="container">
        <div class="obra-layout">
            <!-- Imagem da obra -->
            <div class="obra-imagem-grande">
                <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
            </div>
            
            <!-- Informações da obra -->
            <div class="obra-info-detalhada">
                <h1><%= obra.getNomeObra() %></h1>
                
                <div class="artista-mini">
                    <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>" class="avatar-small">
                    <div>
                        <p class="artista-nome"><a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>"><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></a></p>
                        <p class="artista-regiao">Região ID: <%= artista.getIdRegiao() %></p>
                    </div>
                </div>
                
                <div class="obra-tags">
                    <span class="badge">Categoria ID: <%= obra.getIdCategoria() %></span>
                    <% if (tags != null) {
                        for (TagModel tag : tags) { %>
                            <span class="badge"><%= tag.getNomeTag() %></span>
                    <%  }
                    } %>
                </div>
                
                <div class="obra-descricao">
                    <h3>Descrição</h3>
                    <p><%= obra.getDescricao() %></p>
                </div>
                
                <% if (obra.getPreco() != null) { %>
                    <div class="obra-preco">
                        <h3>Preço</h3>
                        <p class="preco-grande">R$ <%= obra.getPreco() %></p>
                    </div>
                <% } %>
                
                <% if (obra.getLinkExterno() != null && !obra.getLinkExterno().isEmpty()) { %>
                    <a href="<%= obra.getLinkExterno() %>" target="_blank" class="btn-primary">Visitar Link Externo</a>
                <% } %>
                
                <div class="obra-acoes">
                    <button class="btn-action">❤️ Curtir (<%= totalCurtidas %>)</button>
                    <button class="btn-action">⭐ Favoritar</button>
                    <button class="btn-action">🔗 Compartilhar</button>
                </div>
                
                <div class="artista-box">
                    <h3>Sobre o Artista</h3>
                    <p><%= artista.getBiografia() != null ? artista.getBiografia() : "Sem biografia" %></p>
                    <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-secondary">Ver Perfil Completo</a>
                    <button class="btn-secondary">Seguir Artista</button>
                </div>
            </div>
        </div>
        
        <!-- Obras relacionadas -->
        <% if (obrasRelacionadas != null && !obrasRelacionadas.isEmpty()) { %>
            <section class="obras-relacionadas">
                <h2>Obras Relacionadas</h2>
                <div class="grid">
                    <% for (ObraModel obraRel : obrasRelacionadas) { %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obraRel.getNomeObra() %>">
                            </div>
                            <div class="obra-info">
                                <h3><%= obraRel.getNomeObra() %></h3>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obraRel.getIdObra() %>" class="btn-ver">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />