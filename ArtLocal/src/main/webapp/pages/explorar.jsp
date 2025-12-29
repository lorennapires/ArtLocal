<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.CategoriaModel" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.TagModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<TagModel> tags = (List<TagModel>) request.getAttribute("tags");
%>

<section class="explorar-section">
    <div class="container">
        <h1>Explorar Obras</h1>
        
        <div class="explorar-layout">
            <!-- Filtros laterais -->
            <aside class="filtros">
                <h3>Filtros</h3>
                
                <form action="<%= request.getContextPath() %>/explorar" method="get">
                    <div class="filtro-group">
                        <h4>Categoria</h4>
                        <% if (categorias != null) {
                            for (CategoriaModel cat : categorias) { %>
                                <label>
                                    <input type="radio" name="categoria" value="<%= cat.getIdCategoria() %>">
                                    <%= cat.getNomeCategoria() %>
                                </label>
                        <%  }
                        } %>
                    </div>
                    
                    <div class="filtro-group">
                        <h4>Localidade</h4>
                        <% if (regioes != null) {
                            for (RegiaoModel regiao : regioes) { %>
                                <label>
                                    <input type="radio" name="regiao" value="<%= regiao.getIdRegiao() %>">
                                    <%= regiao.getNomeRegiao() %>
                                </label>
                        <%  }
                        } %>
                    </div>
                    
                    <button type="submit" class="btn-primary">Aplicar Filtros</button>
                    <a href="<%= request.getContextPath() %>/explorar" class="btn-secondary">Limpar</a>
                </form>
            </aside>
            
            <!-- Grid de obras -->
            <div class="obras-grid">
                <div class="obras-header">
                    <p><%= obras != null ? obras.size() : 0 %> obras encontradas</p>
                    <select name="ordem">
                        <option value="recentes">Mais recentes</option>
                        <option value="curtidas">Mais curtidas</option>
                        <option value="preco">Preço</option>
                    </select>
                </div>
                
                <div class="grid">
                    <% if (obras != null && !obras.isEmpty()) {
                        for (ObraModel obra : obras) { %>
                            <div class="card-obra">
                                <div class="obra-image">
                                    <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                                    <div class="obra-actions">
                                        <button class="btn-icon" title="Curtir">❤️</button>
                                        <button class="btn-icon" title="Favoritar">⭐</button>
                                    </div>
                                </div>
                                <div class="obra-info">
                                    <h3><%= obra.getNomeObra() %></h3>
                                    <p>Categoria ID: <%= obra.getIdCategoria() %></p>
                                    <% if (obra.getPreco() != null) { %>
                                        <p class="preco">R$ <%= obra.getPreco() %></p>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-ver">Ver Detalhes</a>
                                </div>
                            </div>
                    <%  }
                    } else { %>
                        <p class="no-results">Nenhuma obra encontrada.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />