<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UsuarioModel" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.RegiaoModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    UsuarioModel usuario = (UsuarioModel) request.getAttribute("usuario");
    List<ObraModel> minhasObras = (List<ObraModel>) request.getAttribute("minhasObras");
    Integer totalObras = (Integer) request.getAttribute("totalObras");
    Integer totalSeguidores = (Integer) request.getAttribute("totalSeguidores");
    RegiaoModel regiao = (RegiaoModel) request.getAttribute("regiao");
    
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<section class="perfil-section">
    <div class="container">
        <!-- Header do perfil -->
        <div class="perfil-header-privado">
            <div class="perfil-avatar-edit">
                <img src="<%= request.getContextPath() %>/images/avatars/<%= usuario.getIdIcone() %>" alt="Avatar">
                <button class="btn-edit-avatar">✏️ Alterar</button>
            </div>
            
            <div class="perfil-info-privado">
                <h1><%= usuario.getNomeArtistico() != null ? usuario.getNomeArtistico() : usuario.getNomeCompleto() %></h1>
                <p class="perfil-email"><%= usuario.getEmail() %></p>
                <p class="perfil-regiao">📍 <%= regiao != null ? regiao.getNomeRegiao() : "Região não informada" %></p>
                <a href="<%= request.getContextPath() %>/editar-perfil" class="btn-primary">Editar Perfil</a>
            </div>
        </div>
        
        <!-- Abas -->
        <div class="perfil-tabs">
            <button class="tab active" data-tab="visao-geral">Visão Geral</button>
            <% if ("artista".equals(usuario.getTipoUsuario())) { %>
                <button class="tab" data-tab="obras">Minhas Obras</button>
            <% } %>
            <button class="tab" data-tab="favoritos">Favoritos</button>
            <button class="tab" data-tab="seguindo">Seguindo</button>
            <button class="tab" data-tab="configuracoes">Configurações</button>
        </div>
        
        <!-- Conteúdo: Visão Geral -->
        <div class="tab-content active" id="visao-geral">
            <% if ("artista".equals(usuario.getTipoUsuario())) { %>
                <div class="estatisticas-grid">
                    <div class="stat-card">
                        <div class="stat-icon">🎨</div>
                        <div class="stat-info">
                            <h3><%= totalObras %></h3>
                            <p>Obras Publicadas</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">👥</div>
                        <div class="stat-info">
                            <h3><%= totalSeguidores %></h3>
                            <p>Seguidores</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">❤️</div>
                        <div class="stat-info">
                            <h3>0</h3>
                            <p>Curtidas Recebidas</p>
                        </div>
                    </div>
                </div>
            <% } %>
            
            <div class="atividade-recente">
                <h2>Atividade Recente</h2>
                <p>Suas últimas interações aparecerão aqui</p>
            </div>
        </div>
        
        <!-- Conteúdo: Minhas Obras (só para artistas) -->
        <% if ("artista".equals(usuario.getTipoUsuario())) { %>
            <div class="tab-content" id="obras">
                <div class="obras-header">
                    <h2>Minhas Obras</h2>
                    <a href="<%= request.getContextPath() %>/nova-obra" class="btn-primary">+ Nova Obra</a>
                </div>
                
                <div class="grid">
                    <% if (minhasObras != null && !minhasObras.isEmpty()) {
                        for (ObraModel obra : minhasObras) { %>
                            <div class="card-obra-gerenciar">
                                <div class="obra-image">
                                    <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                                </div>
                                <div class="obra-info">
                                    <h3><%= obra.getNomeObra() %></h3>
                                    <p class="obra-stats">❤️ 0 curtidas</p>
                                    <div class="obra-actions">
                                        <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-small">Ver</a>
                                        <a href="<%= request.getContextPath() %>/editar-obra?id=<%= obra.getIdObra() %>" class="btn-small">Editar</a>
                                    </div>
                                </div>
                            </div>
                    <%  }
                    } else { %>
                        <div class="empty-state">
                            <p>Você ainda não publicou nenhuma obra</p>
                            <a href="<%= request.getContextPath() %>/nova-obra" class="btn-primary">Publicar Primeira Obra</a>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
        
        <!-- Conteúdo: Favoritos -->
        <div class="tab-content" id="favoritos">
            <h2>Obras Favoritadas</h2>
            <div class="empty-state">
                <p>Você ainda não favoritou nenhuma obra</p>
                <a href="<%= request.getContextPath() %>/explorar" class="btn-primary">Explorar Obras</a>
            </div>
        </div>
        
        <!-- Conteúdo: Seguindo -->
        <div class="tab-content" id="seguindo">
            <h2>Artistas que Você Segue</h2>
            <div class="empty-state">
                <p>Você ainda não está seguindo nenhum artista</p>
                <a href="<%= request.getContextPath() %>/artistas" class="btn-primary">Descobrir Artistas</a>
            </div>
        </div>
        
        <!-- Conteúdo: Configurações -->
        <div class="tab-content" id="configuracoes">
            <h2>Configurações da Conta</h2>
            
            <div class="config-section">
                <h3>Alterar Senha</h3>
                <form action="<%= request.getContextPath() %>/alterar-senha" method="post">
                    <div class="form-group">
                        <label>Senha Atual</label>
                        <input type="password" name="senhaAtual" required>
                    </div>
                    <div class="form-group">
                        <label>Nova Senha</label>
                        <input type="password" name="novaSenha" required>
                    </div>
                    <div class="form-group">
                        <label>Confirmar Nova Senha</label>
                        <input type="password" name="confirmarSenha" required>
                    </div>
                    <button type="submit" class="btn-primary">Alterar Senha</button>
                </form>
            </div>
            
            <div class="config-section danger-zone">
                <h3>Zona de Perigo</h3>
                <p>Ações irreversíveis</p>
                <button class="btn-danger" onclick="if(confirm('Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.')) { alert('Funcionalidade em desenvolvimento'); }">Excluir Conta</button>
            </div>
        </div>
    </div>
</section>

<script>
    // Script para troca de abas
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            this.classList.add('active');
            const tabId = this.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
        });
    });
</script>

<jsp:include page="/includes/footer.jsp" />