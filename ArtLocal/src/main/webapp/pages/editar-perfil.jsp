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
    String tagsJson = (String) request.getAttribute("tagsJson");
    if (tagsJson == null) tagsJson = "{}";
    String erro = (String) request.getAttribute("erro");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<section class="editar-perfil-section">
    <div class="container">
        <div class="editar-perfil-card">
            <div class="header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: var(--spacing-lg);">
                <h1>Editar Perfil</h1>
                <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
            </div>

            <% if (erro != null) { %>
                <div class="alert alert-error"><%= erro %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/editar-perfil" method="post">

                <%-- Avatar --%>
                <div class="form-section" style="margin-bottom: var(--spacing-lg);">
                    <h2>Avatar</h2>
                    <div style="display:flex; align-items:center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                        <img src="<%= request.getContextPath() %>/images/avatares/<%= usuario.getIdIcone() != null ? usuario.getIdIcone() : "avatar1.png" %>"
                             alt="Avatar atual"
                             style="width:80px; height:80px; border-radius:50%; object-fit:cover; border:3px solid var(--gold);">
                        <p style="color:var(--gray);">Avatar atual</p>
                    </div>
                    <div class="avatars-grid">
                        <% for (int i = 1; i <= 60; i++) {
                            String nomeAvatar = "avatar" + i + ".png";
                            boolean selecionado = nomeAvatar.equals(usuario.getIdIcone()); %>
                            <label class="avatar-option">
                                <input type="radio" name="idIcone" value="<%= nomeAvatar %>" <%= selecionado ? "checked" : "" %>>
                                <img src="<%= request.getContextPath() %>/images/avatares/<%= nomeAvatar %>" alt="Avatar <%= i %>">
                            </label>
                        <% } %>
                    </div>
                </div>

                <%-- Dados Básicos --%>
                <div class="form-section" style="margin-bottom: var(--spacing-lg);">
                    <h2>Dados Básicos</h2>
                    <div class="form-group">
                        <label for="nomeCompleto">Nome Completo *</label>
                        <input type="text" id="nomeCompleto" name="nomeCompleto"
                               value="<%= usuario.getNomeCompleto() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email"
                               value="<%= usuario.getEmail() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="idRegiao">Região *</label>
                        <select id="idRegiao" name="idRegiao" required>
                            <option value="">Selecione...</option>
                            <% if (regioes != null) {
                                for (RegiaoModel regiao : regioes) {
                                    boolean sel = usuario.getIdRegiao() != null &&
                                                  regiao.getIdRegiao().equals(usuario.getIdRegiao()); %>
                                    <option value="<%= regiao.getIdRegiao() %>" <%= sel ? "selected" : "" %>>
                                        <%= regiao.getNomeRegiao() %>
                                    </option>
                            <%  } } %>
                        </select>
                    </div>
                </div>

                <%-- Dados do Artista --%>
                <% if ("artista".equals(usuario.getTipoUsuario())) { %>
                    <div class="form-section" style="margin-bottom: var(--spacing-lg);">
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
                            <select id="categoriaPrincipal" name="categoriaPrincipal" onchange="carregarTagsEdicao(this.value)">
                                <option value="">Selecione...</option>
                                <% if (categorias != null) {
                                    for (CategoriaModel categoria : categorias) {
                                        boolean sel = usuario.getCategoriaPrincipal() != null &&
                                                      categoria.getIdCategoria().equals(usuario.getCategoriaPrincipal()); %>
                                        <option value="<%= categoria.getIdCategoria() %>" <%= sel ? "selected" : "" %>>
                                            <%= categoria.getNomeCategoria() %>
                                        </option>
                                <%  } } %>
                            </select>
                        </div>
                        <div class="form-group" id="grupoTagsEdicao">
                            <label>Tags Principais <small style="font-weight:normal;">(selecione as que descrevem seu trabalho)</small></label>
                            <div class="tags-container" id="tagsContainerEdicao"></div>
                            <input type="hidden" name="tagsPrincipais" id="tagsPrincipaisHiddenEdicao"
                                   value="<%= usuario.getTagsPrincipais() != null ? usuario.getTagsPrincipais() : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="portfolio">Link do Portfólio</label>
                            <input type="url" id="portfolio" name="portfolio"
                                   value="<%= usuario.getPortfolio() != null ? usuario.getPortfolio() : "" %>"
                                   placeholder="https://...">
                        </div>
                    </div>
                <% } %>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">Salvar Alterações</button>
                    <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    var todasAsTags = <%= tagsJson %>;
    var tagsSalvas = document.getElementById('tagsPrincipaisHiddenEdicao').value
                        .split(',').map(function(t) { return t.trim(); }).filter(Boolean);

    function carregarTagsEdicao(idCategoria) {
        var container = document.getElementById('tagsContainerEdicao');
        container.innerHTML = '';

        if (!idCategoria || !todasAsTags[idCategoria]) return;

        todasAsTags[idCategoria].forEach(function(tag) {
            var label = document.createElement('label');
            label.className = 'tag-opcao';

            var input = document.createElement('input');
            input.type = 'checkbox';
            input.value = tag.id;
            if (tagsSalvas.indexOf(String(tag.id)) !== -1) {
                input.checked = true;
            }
            input.addEventListener('change', atualizarTagsHiddenEdicao);

            var span = document.createElement('span');
            span.textContent = tag.nome;

            label.appendChild(input);
            label.appendChild(span);
            container.appendChild(label);
        });
    }

    function atualizarTagsHiddenEdicao() {
        var selecionadas = [];
        document.querySelectorAll('#tagsContainerEdicao input:checked').forEach(function(cb) {
            selecionadas.push(cb.value);
        });
        document.getElementById('tagsPrincipaisHiddenEdicao').value = selecionadas.join(',');
    }

    // Carrega as tags da categoria já selecionada ao abrir a página
    var catAtual = document.getElementById('categoriaPrincipal');
    if (catAtual && catAtual.value) {
        carregarTagsEdicao(catAtual.value);
    }
</script>

<jsp:include page="/includes/footer.jsp" />