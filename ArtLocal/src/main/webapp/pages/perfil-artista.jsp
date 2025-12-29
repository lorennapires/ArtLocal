<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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
%>

<section class="perfil-artista">
    <div class="container">
        <!-- Header do perfil -->
        <div class="perfil-header">
            <div class="perfil-cover"></div>
            <div class="perfil-info">
                <div class="perfil-avatar">
                    <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>">
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
                        <button class="btn-primary">Seguir</button>
                        <button class="btn-secondary">Compartilhar</button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Abas -->
        <div class="perfil-tabs">
            <button class="tab active" data-tab="sobre">Sobre</button>
            <button class="tab" data-tab="obras">Obras</button>
        </div>
        
        <!-- Conteúdo das abas -->
        <div class="tab-content active" id="sobre">
            <div class="sobre-content">
                <h2>Biografia</h2>
                <p><%= artista.getBiografia() != null ? artista.getBiografia() : "Sem biografia" %></p>
                
                <h3>Categoria Principal</h3>
                <p>Categoria ID: <%= artista.getCategoriaPrincipal() %></p>
                
                <% if (artista.getTagsPrincipais() != null) { %>
                    <h3>Tags Principais</h3>
                    <div class="tags">
                        <% for (String tag : artista.getTagsPrincipais().split(",")) { %>
                            <span class="badge"><%= tag.trim() %></span>
                        <% } %>
                    </div>
                <% } %>
                
                <% if (artista.getPortfolio() != null && !artista.getPortfolio().isEmpty()) { %>
                    <h3>Portfólio</h3>
                    <a href="<%= artista.getPortfolio() %>" target="_blank" class="btn-primary">Visitar Portfólio</a>
                <% } %>
            </div>
        </div>
        
        <div class="tab-content" id="obras">
            <div class="obras-do-artista">
                <div class="obras-header">
                    <h2>Obras de <%= artista.getNomeArtistico() %></h2>
                    <select name="ordem">
                        <option value="recentes">Mais recentes</option>
                        <option value="curtidas">Mais curtidas</option>
                    </select>
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
                    <%  }
                    } else { %>
                        <p>Nenhuma obra publicada ainda.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // Script simples para troca de abas
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active de todas as abas
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            // Adiciona active na aba clicada
            this.classList.add('active');
            const tabId = this.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
        });
    });
</script>

<jsp:include page="/includes/footer.jsp" />