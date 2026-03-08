<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CategoriaModel" %>
<%@ page import="model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    String tagsJson = (String) request.getAttribute("tagsJson");
    if (tagsJson == null) tagsJson = "{}";
    String erro = (String) request.getAttribute("erro");

    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null || !"artista".equals(usuarioLogado.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/perfil");
        return;
    }
%>

<section class="nova-obra-section">
    <div class="container">
        <div class="nova-obra-card">
            <h1>Publicar Nova Obra</h1>

            <% if (erro != null) { %>
                <div class="alert alert-error"><%= erro %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/nova-obra" method="post" enctype="multipart/form-data">

                <div class="form-section">
                    <h2>Imagem da Obra *</h2>
                    <div class="upload-area" id="uploadArea">
                        <div class="upload-placeholder">
                            <div class="upload-icon">🖼️</div>
                            <p>Arraste a imagem aqui ou clique para selecionar</p>
                            <input type="file" name="imagemObra" id="imagemObra" accept="image/*" required>
                        </div>
                        <div class="image-preview" id="imagePreview" style="display:none;">
                            <img id="previewImg" src="" alt="Preview">
                            <button type="button" class="btn-remove" onclick="removeImage()">❌ Remover</button>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h2>Informações da Obra</h2>
                    <div class="form-group">
                        <label for="nomeObra">Nome da Obra *</label>
                        <input type="text" id="nomeObra" name="nomeObra" required placeholder="Ex: Pôr do Sol em Arembepe">
                    </div>
                    <div class="form-group">
                        <label for="descricao">Descrição *</label>
                        <textarea id="descricao" name="descricao" rows="5" required
                            placeholder="Descreva sua obra, técnica utilizada, inspiração..."></textarea>
                    </div>
                    <div class="form-group">
                        <label for="idCategoria">Categoria *</label>
                        <select id="idCategoria" name="idCategoria" required onchange="carregarTagsObra(this.value)">
                            <option value="">Selecione uma categoria...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>"><%= categoria.getNomeCategoria() %></option>
                            <%  } } %>
                        </select>
                    </div>
                    <div class="form-group" id="grupoTagsObra" style="display:none;">
                        <label>Tags <small style="font-weight:normal;">(opcional)</small></label>
                        <div class="tags-container" id="tagsContainerObra"></div>
                        <input type="hidden" name="tags" id="tagsHiddenObra">
                    </div>
                </div>

                <div class="form-section">
                    <h2>Informações Comerciais (Opcional)</h2>
                    <div class="form-group">
                        <label for="linkExterno">Link Externo</label>
                        <input type="url" id="linkExterno" name="linkExterno"
                            placeholder="https://... (link para loja, site, etc)">
                    </div>
                    <div class="form-group">
                        <label for="preco">Preço (R$)</label>
                        <input type="number" id="preco" name="preco" step="0.01" min="0" placeholder="0.00">
                        <small>Deixe em branco se não for vender</small>
                    </div>
                </div>

                <div class="form-actions" style="display:flex; gap:1rem;">
                    <button type="submit" class="btn-primary" style="flex:1;">Publicar Obra</button>
                    <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary" style="flex:1; display:flex; align-items:center; justify-content:center; text-decoration:none;">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    var todasAsTags = <%= tagsJson %>;

    function carregarTagsObra(idCategoria) {
        var container = document.getElementById('tagsContainerObra');
        var grupo = document.getElementById('grupoTagsObra');
        container.innerHTML = '';
        document.getElementById('tagsHiddenObra').value = '';

        if (!idCategoria || !todasAsTags[idCategoria]) {
            grupo.style.display = 'none';
            return;
        }

        grupo.style.display = 'block';
        todasAsTags[idCategoria].forEach(function(tag) {
            var label = document.createElement('label');
            label.className = 'tag-opcao';
            var input = document.createElement('input');
            input.type = 'checkbox';
            input.value = tag.id;
            input.addEventListener('change', atualizarTagsObra);
            var span = document.createElement('span');
            span.textContent = tag.nome;
            label.appendChild(input);
            label.appendChild(span);
            container.appendChild(label);
        });
    }

    function atualizarTagsObra() {
        var selecionadas = [];
        document.querySelectorAll('#tagsContainerObra input:checked').forEach(function(cb) {
            selecionadas.push(cb.value);
        });
        document.getElementById('tagsHiddenObra').value = selecionadas.join(',');
    }

    const input = document.getElementById('imagemObra');
    const uploadArea = document.getElementById('uploadArea');
    const preview = document.getElementById('imagePreview');
    const previewImg = document.getElementById('previewImg');

    input.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                uploadArea.querySelector('.upload-placeholder').style.display = 'none';
                preview.style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    });

    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });
    uploadArea.addEventListener('dragleave', function() {
        this.classList.remove('dragover');
    });
    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        const file = e.dataTransfer.files[0];
        if (file && file.type.startsWith('image/')) {
            input.files = e.dataTransfer.files;
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                uploadArea.querySelector('.upload-placeholder').style.display = 'none';
                preview.style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    });

    function removeImage() {
        input.value = '';
        previewImg.src = '';
        uploadArea.querySelector('.upload-placeholder').style.display = 'flex';
        preview.style.display = 'none';
    }
</script>

<jsp:include page="/includes/footer.jsp" />