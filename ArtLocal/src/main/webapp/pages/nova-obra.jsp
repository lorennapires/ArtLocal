<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CategoriaModel" %>
<%@ page import="model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
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
            <div class="header">
                <h1>Publicar Nova Obra</h1>
                <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
            </div>
            
            <% if (erro != null) { %>
                <div class="alert alert-error">
                    <%= erro %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/nova-obra" method="post" enctype="multipart/form-data">
                
                <!-- Upload de Imagem -->
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
                
                <!-- Informações da Obra -->
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
                        <select id="idCategoria" name="idCategoria" required>
                            <option value="">Selecione uma categoria...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>"><%= categoria.getNomeCategoria() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="tags">Tags</label>
                        <input type="text" id="tags" name="tags" 
                            placeholder="Ex: aquarela, natureza, mar">
                        <small>Separe as tags por vírgula (opcional)</small>
                    </div>
                </div>
                
                <!-- Informações Comerciais -->
                <div class="form-section">
                    <h2>Informações Comerciais (Opcional)</h2>
                    
                    <div class="form-group">
                        <label for="linkExterno">Link Externo</label>
                        <input type="url" id="linkExterno" name="linkExterno" 
                            placeholder="https://... (link para loja, site, etc)">
                        <small>Link para onde a obra pode ser adquirida ou mais informações</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="preco">Preço (R$)</label>
                        <input type="number" id="preco" name="preco" step="0.01" min="0" 
                            placeholder="0.00">
                        <small>Deixe em branco se não for vender</small>
                    </div>
                </div>
                
                <!-- Botões de ação -->
                <div class="form-actions">
                    <button type="submit" class="btn-primary btn-large">🚀 Publicar Obra</button>
                    <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    // Preview de imagem
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
    
    // Drag and drop
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });
    
    uploadArea.addEventListener('dragleave', function(e) {
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