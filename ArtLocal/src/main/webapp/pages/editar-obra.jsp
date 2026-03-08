<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.CategoriaModel" %>
<%@ page import="model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    ObraModel obra = (ObraModel) request.getAttribute("obra");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    String tagsJson = (String) request.getAttribute("tagsJson");
    if (tagsJson == null) tagsJson = "{}";
    String erro = (String) request.getAttribute("erro");

    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null || obra == null) {
        response.sendRedirect(request.getContextPath() + "/perfil");
        return;
    }

    String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().equals("placeholder.jpg"))
                     ? obra.getImagemObra() : "placeholder.jpg";
%>

<section class="nova-obra-section">
    <div class="container">
        <div class="nova-obra-card">
            <h1>Editar Obra</h1>

            <% if (erro != null) { %>
                <div class="alert alert-error"><%= erro %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/editar-obra" method="post" enctype="multipart/form-data">
                <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">

                <div class="form-section">
                    <h2>Imagem da Obra</h2>
                    <div style="margin-bottom:var(--spacing-sm);">
                        <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                             alt="<%= obra.getNomeObra() %>"
                             style="max-width:300px; border-radius:var(--radius-md); display:block;">
                    </div>
                    <div class="form-group">
                        <label>Alterar Imagem</label>
                        <input type="file" name="novaImagem" accept="image/*">
                        <small>Deixe em branco para manter a imagem atual</small>
                    </div>
                </div>

                <div class="form-section">
                    <h2>Informações da Obra</h2>
                    <div class="form-group">
                        <label for="nomeObra">Nome da Obra *</label>
                        <input type="text" id="nomeObra" name="nomeObra"
                               value="<%= obra.getNomeObra() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="descricao">Descrição *</label>
                        <textarea id="descricao" name="descricao" rows="5" required><%= obra.getDescricao() != null ? obra.getDescricao() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label for="idCategoria">Categoria *</label>
                        <select id="idCategoria" name="idCategoria" required onchange="carregarTagsEdicaoObra(this.value)">
                            <option value="">Selecione...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>"
                                        <%= categoria.getIdCategoria().equals(obra.getIdCategoria()) ? "selected" : "" %>>
                                        <%= categoria.getNomeCategoria() %>
                                    </option>
                            <%  } } %>
                        </select>
                    </div>
                    <div class="form-group" id="grupoTagsEdicaoObra">
                        <label>Tags <small style="font-weight:normal;">(opcional)</small></label>
                        <div class="tags-container" id="tagsContainerEdicaoObra"></div>
                        <input type="hidden" name="tags" id="tagsHiddenEdicaoObra">
                    </div>
                </div>

                <div class="form-section">
                    <h2>Informações Comerciais</h2>
                    <div class="form-group">
                        <label for="linkExterno">Link Externo</label>
                        <input type="url" id="linkExterno" name="linkExterno"
                               value="<%= obra.getLinkExterno() != null ? obra.getLinkExterno() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="preco">Preço (R$)</label>
                        <input type="number" id="preco" name="preco" step="0.01" min="0"
                               value="<%= obra.getPreco() != null ? obra.getPreco() : "" %>">
                    </div>
                </div>

                <div class="form-actions" style="display:flex; gap:1rem;">
                    <button type="submit" name="acao" value="atualizar"
                            class="btn-primary" style="flex:1;">Salvar Alterações</button>
                    <a href="<%= request.getContextPath() %>/perfil"
                       class="btn-secondary" style="flex:1; display:flex; align-items:center; justify-content:center;">Cancelar</a>
                    <button type="submit" name="acao" value="excluir"
                            class="btn-danger" style="flex:1;"
                            onclick="return confirm('Tem certeza que deseja excluir esta obra?')">Excluir Obra</button>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    var todasAsTags = <%= tagsJson %>;

    function carregarTagsEdicaoObra(idCategoria) {
        var container = document.getElementById('tagsContainerEdicaoObra');
        container.innerHTML = '';
        document.getElementById('tagsHiddenEdicaoObra').value = '';
        if (!idCategoria || !todasAsTags[idCategoria]) return;
        todasAsTags[idCategoria].forEach(function(tag) {
            var label = document.createElement('label');
            label.className = 'tag-opcao';
            var input = document.createElement('input');
            input.type = 'checkbox';
            input.value = tag.id;
            input.addEventListener('change', function() {
                var sel = [];
                document.querySelectorAll('#tagsContainerEdicaoObra input:checked').forEach(function(cb) { sel.push(cb.value); });
                document.getElementById('tagsHiddenEdicaoObra').value = sel.join(',');
            });
            var span = document.createElement('span');
            span.textContent = tag.nome;
            label.appendChild(input);
            label.appendChild(span);
            container.appendChild(label);
        });
    }

    var catAtual = document.getElementById('idCategoria');
    if (catAtual && catAtual.value) carregarTagsEdicaoObra(catAtual.value);
</script>

<jsp:include page="/includes/footer.jsp" />