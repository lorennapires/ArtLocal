<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.CategoriaModel" %>
<%@ page import="model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    ObraModel obra = (ObraModel) request.getAttribute("obra");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    String erro = (String) request.getAttribute("erro");
    
    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null || obra == null) {
        response.sendRedirect(request.getContextPath() + "/perfil");
        return;
    }
%>

<section class="editar-obra-section">
    <div class="container">
        <div class="editar-obra-card">
            <div class="header">
                <h1>Editar Obra</h1>
                <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
            </div>
            
            <% if (erro != null) { %>
                <div class="alert alert-error">
                    <%= erro %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/editar-obra" method="post" enctype="multipart/form-data">
                <input type="hidden" name="idObra" value="<%= obra.getIdObra() %>">
                
                <!-- Imagem Atual -->
                <div class="form-section">
                    <h2>Imagem da Obra</h2>
                    <div class="current-image">
                        <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                    </div>
                    <div class="form-group">
                        <label>Alterar Imagem</label>
                        <input type="file" name="novaImagem" accept="image/*">
                        <small>Deixe em branco para manter a imagem atual</small>
                    </div>
                </div>
                
                <!-- Informações da Obra -->
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
                        <select id="idCategoria" name="idCategoria" required>
                            <option value="">Selecione...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>"
                                        <%= categoria.getIdCategoria().equals(obra.getIdCategoria()) ? "selected" : "" %>>
                                        <%= categoria.getNomeCategoria() %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>
                
                <!-- Informações Comerciais -->
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
                
                <!-- Botões de ação -->
                <div class="form-actions">
                    <button type="submit" class="btn-primary" name="acao" value="atualizar">💾 Salvar Alterações</button>
                    <a href="<%= request.getContextPath() %>/perfil" class="btn-secondary">Cancelar</a>
                    <button type="submit" class="btn-danger" name="acao" value="excluir" 
                        onclick="return confirm('Tem certeza que deseja excluir esta obra? Esta ação não pode ser desfeita.')">
                        🗑️ Excluir Obra
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />