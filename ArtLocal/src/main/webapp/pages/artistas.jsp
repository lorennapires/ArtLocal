<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<UsuarioModel> artistas = (List<UsuarioModel>) request.getAttribute("artistas");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
%>

<section class="artistas-section">
    <div class="container">
        <h1>Artistas de Camaçari</h1>
        
        <!-- Filtros -->
        <div class="filtros-bar">
            <form action="<%= request.getContextPath() %>/artistas" method="get">
                <select name="regiao">
                    <option value="">Todas as regiões</option>
                    <% if (regioes != null) {
                        for (RegiaoModel regiao : regioes) { %>
                            <option value="<%= regiao.getIdRegiao() %>"><%= regiao.getNomeRegiao() %></option>
                    <%  }
                    } %>
                </select>
                
                <select name="ordem">
                    <option value="alfabetica">Ordem Alfabética</option>
                    <option value="seguidores">Mais Seguidos</option>
                    <option value="recentes">Mais Recentes</option>
                </select>
                
                <button type="submit" class="btn-primary">Filtrar</button>
            </form>
        </div>
        
        <!-- Grid de artistas -->
        <div class="grid artistas-grid">
            <% if (artistas != null && !artistas.isEmpty()) {
                for (UsuarioModel artista : artistas) { %>
                    <div class="card-artista">
                        <div class="artista-avatar">
                            <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>">
                        </div>
                        <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                        <p class="artista-regiao">📍 Região ID: <%= artista.getIdRegiao() %></p>
                        <p class="artista-categoria">🎨 Categoria ID: <%= artista.getCategoriaPrincipal() %></p>
                        
                        <% if (artista.getTagsPrincipais() != null) { %>
                            <div class="tags">
                                <% for (String tag : artista.getTagsPrincipais().split(",")) { %>
                                    <span class="badge"><%= tag.trim() %></span>
                                <% } %>
                            </div>
                        <% } %>
                        
                        <div class="artista-stats">
                            <span>📊 Obras: 0</span>
                            <span>👥 Seguidores: 0</span>
                        </div>
                        
                        <div class="artista-actions">
                            <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-primary">Ver Perfil</a>
                            <button class="btn-secondary">Seguir</button>
                        </div>
                    </div>
            <%  }
            } else { %>
                <p class="no-results">Nenhum artista encontrado.</p>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />