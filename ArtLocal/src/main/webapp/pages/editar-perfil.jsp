<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    UsuarioModel usuario = (UsuarioModel) request.getAttribute("usuario");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    String erro = (String) request.getAttribute("erro");
    
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<section class="editar-perfil-section">
    <div class="container">
        <div class="editar-perfil-card">
            <div class="header">
                <h1>Editar Perfil</h1>
                <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
            </div>
            
            <% if (erro != null) { %>
                <div class="alert alert-error">
                    <%= erro %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/editar-perfil" method="post" enctype="multipart/form-data">
                
                <!-- Avatar -->
                <div class="form-section">
                    <h2>Avatar</h2>
                    <div class="avatar-edit-container">
                        <img src="<%= request.getContextPath() %>/images/avatars/<%= usuario.getIdIcone() %>" alt="Avatar atual" class="avatar-preview">
                        
                        <% if ("visitante".equals(usuario.getTipoUsuario())) { %>
                            <div class="form-group">
                                <label>Escolher outro avatar</label>
                                <div class="avatars-grid-small">
                                    <% for (int i = 1; i <= 18; i++) { %>
                                        <label class="avatar-option-small">
                                            <input type="radio" name="idIcone" value="avatar<%= i %>.png" 
                                                <%= ("avatar" + i + ".png").equals(usuario.getIdIcone()) ? "checked" : "" %>>
                                            <img src="<%= request.getContextPath() %>/images/avatars/avatar<%= i %>.png" alt="Avatar <%= i %>">
                                        </label>
                                    <% } %>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="form-group">
                                <label>Alterar foto (artistas podem fazer upload)</label>
                                <input type="file" name="avatarUpload" accept="image/*">
                                <small>Ou escolha um avatar da galeria acima</small>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Dados Básicos -->
                <div class="form-section">
                    <h2>Dados Básicos</h2>
                    
                    <div class="form-group">
                        <label for="nomeCompleto">Nome Completo *</label>
                        <input type="text" id="nomeCompleto" name="nomeCompleto" value="<%= usuario.getNomeCompleto() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="<%= usuario.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="idRegiao">Região *</label>
                        <select id="idRegiao" name="idRegiao" required>
                            <option value="">Selecione...</option>
                            <% if (regioes != null) {
                                for (RegiaoModel regiao : regioes) { %>
                                    <option value="<%= regiao.getIdRegiao() %>" 
                                        <%= regiao.getIdRegiao().equals(usuario.getIdRegiao()) ? "selected" : "" %>>
                                        <%= regiao.getNomeRegiao() %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>
                
                <!-- Dados do Artista (se for artista) -->
                <% if ("artista".equals(usuario.getTipoUsuario())) { %>
                    <div class="form-section">
                        <h2>Dados Artísticos</h2>
                        
                        <div class="form-group">
                            <label for="nomeArtistico">Nome Artístico</label>
                            <input type="text" id="nomeArtistico" name="nomeArtistico" 
                                value="<%= usuario.getNomeArtistico() != null ? usuario.getNomeArtistico() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="biografia">Biografia</label>
                            <textarea id="biografia" name="biografia" rows="5"><%= usuario.getBiografia() != null ? usuario.getBiografia() : "" %></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="categoriaPrincipal">Categoria Principal</label>
                            <select id="categoriaPrincipal" name="categoriaPrincipal">
                                <option value="">Selecione...</option>
                                <% if (categorias != null) {
                                    for (CategoriaModel categoria : categorias) { %>
                                        <option value="<%= categoria.getIdCategoria() %>"
                                            <%= categoria.getIdCategoria().equals(usuario.getCategoriaPrincipal()) ? "selected" : "" %>>
                                            <%= categoria.getNomeCategoria() %>
                                        </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="tagsPrincipais">Tags Principais</label>
                            <input type="text" id="tagsPrincipais" name="tagsPrincipais" 
                                value="<%= usuario.getTagsPrincipais() != null ? usuario.getTagsPrincipais() : "" %>"
                                placeholder="Ex: aquarela, paisagem, realismo">
                            <small>Separe as tags por vírgula</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="portfolio">Link do Portfólio</label>
                            <input type="url" id="portfolio" name="portfolio" 
                                value="<%= usuario.getPortfolio() != null ? usuario.getPortfolio() : "" %>"
                                placeholder="https://...">
                        </div>
                    </div>
                <% } %>
                
                <!-- Botões de ação -->
                <div class="form-actions">
                    <button type="submit" class="btn-primary">Salvar Alterações</button>
                    <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />