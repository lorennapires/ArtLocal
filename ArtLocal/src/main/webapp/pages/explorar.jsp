<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.ObraModel, model.CategoriaModel, model.RegiaoModel, model.TagModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    Map<Integer,String> nomesCategorias = (Map<Integer,String>) request.getAttribute("nomesCategorias");
    Map<Integer,List<TagModel>> tagsPorObra = (Map<Integer,List<TagModel>>) request.getAttribute("tagsPorObra");
    String categoriaParam = (String) request.getAttribute("categoriaParam");
    String regiaoParam    = (String) request.getAttribute("regiaoParam");
    String ordem          = (String) request.getAttribute("ordem");
    if (ordem == null) ordem = "recentes";
%>

<section class="explorar-section">
    <div class="container">
        <h1>Explorar Obras</h1>

        <div class="explorar-layout">
            <aside class="filtros">
                <h3>Filtros</h3>
                <form action="<%= request.getContextPath() %>/explorar" method="get">
                    <div class="filtro-group">
                        <h4>Categoria</h4>
                        <label>
                            <input type="radio" name="categoria" value=""
                                <%= (categoriaParam == null || categoriaParam.isEmpty()) ? "checked" : "" %>>
                            Todas
                        </label>
                        <% if (categorias != null) {
                            for (CategoriaModel cat : categorias) {
                                boolean sel = String.valueOf(cat.getIdCategoria()).equals(categoriaParam);
                        %>
                            <label>
                                <input type="radio" name="categoria" value="<%= cat.getIdCategoria() %>"
                                    <%= sel ? "checked" : "" %>>
                                <%= cat.getNomeCategoria() %>
                            </label>
                        <% } } %>
                    </div>

                    <div class="filtro-group">
                        <h4>Localidade</h4>
                        <label>
                            <input type="radio" name="regiao" value=""
                                <%= (regiaoParam == null || regiaoParam.isEmpty()) ? "checked" : "" %>>
                            Todas
                        </label>
                        <% if (regioes != null) {
                            for (RegiaoModel regiao : regioes) {
                                boolean sel = String.valueOf(regiao.getIdRegiao()).equals(regiaoParam);
                        %>
                            <label>
                                <input type="radio" name="regiao" value="<%= regiao.getIdRegiao() %>"
                                    <%= sel ? "checked" : "" %>>
                                <%= regiao.getNomeRegiao() %>
                            </label>
                        <% } } %>
                    </div>

                    <button type="submit" class="btn-primary btn-block">Aplicar Filtros</button>
                    <a href="<%= request.getContextPath() %>/explorar"
                       class="btn-secondary btn-block"
                       style="display:block; text-align:center; margin-top:0.5rem;">Limpar</a>
                </form>
            </aside>

            <div class="obras-grid">
                <div class="obras-header">
                    <p><%= obras != null ? obras.size() : 0 %> obras encontradas</p>
                    <form action="<%= request.getContextPath() %>/explorar" method="get" style="margin:0;">
                        <% if (categoriaParam != null && !categoriaParam.isEmpty()) { %>
                            <input type="hidden" name="categoria" value="<%= categoriaParam %>">
                        <% } %>
                        <% if (regiaoParam != null && !regiaoParam.isEmpty()) { %>
                            <input type="hidden" name="regiao" value="<%= regiaoParam %>">
                        <% } %>
                        <select name="ordem" onchange="this.form.submit()">
                            <option value="recentes" <%= "recentes".equals(ordem) ? "selected" : "" %>>Mais recentes</option>
                            <option value="menor-preco" <%= "menor-preco".equals(ordem) ? "selected" : "" %>>Menor preço</option>
                            <option value="maior-preco" <%= "maior-preco".equals(ordem) ? "selected" : "" %>>Maior preço</option>
                        </select>
                    </form>
                </div>

                <div class="grid">
                    <% if (obras != null && !obras.isEmpty()) {
                        for (ObraModel obra : obras) {
                            String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().isEmpty())
                                             ? obra.getImagemObra() : "placeholder.jpg";
                            String nomeCat = nomesCategorias != null ? nomesCategorias.get(obra.getIdCategoria()) : null;
                            List<TagModel> tagsObra = tagsPorObra != null ? tagsPorObra.get(obra.getIdObra()) : null;
                    %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                                     alt="<%= obra.getNomeObra() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
                                <div class="obra-actions">
                                    <button class="btn-icon" title="Curtir">❤️</button>
                                    <button class="btn-icon" title="Favoritar">⭐</button>
                                </div>
                            </div>
                            <div class="obra-info" style="display:flex; flex-direction:column; flex:1;">
                                <h3><%= obra.getNomeObra() %></h3>
                                <div style="display:flex; flex-wrap:wrap; gap:4px; margin-bottom:6px; align-items:center;">
                                    <% if (nomeCat != null) { %>
                                        <span style="background:var(--gold); color:#fff; font-size:0.75rem;
                                                     padding:2px 8px; border-radius:20px; font-weight:600;">
                                            🎨 <%= nomeCat %>
                                        </span>
                                    <% } %>
                                    <% if (tagsObra != null) {
                                        for (TagModel tag : tagsObra) { %>
                                            <span style="background:#f06292; color:#fff; font-size:0.75rem;
                                                         padding:2px 8px; border-radius:20px;">
                                                <%= tag.getNomeTag() %>
                                            </span>
                                    <% } } %>
                                </div>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                                   class="btn-ver" style="margin-top:auto;">Ver Detalhes</a>
                            </div>
                        </div>
                    <% } } else { %>
                        <p class="no-results">Nenhuma obra encontrada.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />