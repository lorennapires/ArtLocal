<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.UsuarioModel, model.ObraModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    List<ObraModel> obrasFavoritadas = (List<ObraModel>) request.getAttribute("obrasFavoritadas");
    Map<Integer,String> nomesCategorias = (Map<Integer,String>) request.getAttribute("nomesCategorias");
    Integer totalSeguidores = (Integer) request.getAttribute("totalSeguidores");
    Integer totalObras = (Integer) request.getAttribute("totalObras");
    String nomeRegiao = (String) request.getAttribute("nomeRegiao");
    String nomeCategoria = (String) request.getAttribute("nomeCategoria");

    boolean ehArtista = "artista".equals(usuarioLogado.getTipoUsuario());
%>

<section class="perfil-section">
    <div class="container">

        <div class="perfil-capa"></div>

        <div class="perfil-info">
            <div class="perfil-avatar">
                <img src="<%= request.getContextPath() %>/images/avatares/<%= usuarioLogado.getIdIcone() != null ? usuarioLogado.getIdIcone() : "avatar1.png" %>"
                     alt="Avatar"
                     onerror="this.src='<%= request.getContextPath() %>/images/avatares/avatar1.png'">
            </div>
            <div class="perfil-dados">
                <h1><%= usuarioLogado.getNomeArtistico() != null ? usuarioLogado.getNomeArtistico() : usuarioLogado.getNomeCompleto() %></h1>
                <p class="perfil-email"><%= usuarioLogado.getEmail() %></p>
                <% if (nomeRegiao != null) { %>
                    <p style="color:var(--gray);">📍 <%= nomeRegiao %></p>
                <% } %>
                <% if (ehArtista && nomeCategoria != null) { %>
                    <p style="color:var(--gold); font-weight:600;">🎨 <%= nomeCategoria %></p>
                <% } %>
                <div class="perfil-stats">
                    <span><strong><%= totalObras != null ? totalObras : 0 %></strong> obras</span>
                    <span><strong><%= totalSeguidores != null ? totalSeguidores : 0 %></strong> seguidores</span>
                </div>
            </div>
        </div>

        <div class="perfil-tabs">
            <% if (ehArtista) { %>
                <button class="tab active" data-tab="obras">Minhas Obras</button>
            <% } %>
            <button class="tab <%= !ehArtista ? "active" : "" %>" data-tab="favoritos">Favoritos</button>
            <button class="tab" data-tab="seguindo">Seguindo</button>
            <button class="tab" data-tab="configuracoes">Configurações</button>
        </div>

        <%-- Aba Minhas Obras --%>
        <% if (ehArtista) { %>
        <div class="tab-content active" id="obras">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                <h2>Minhas Obras</h2>
                <a href="<%= request.getContextPath() %>/nova-obra" class="btn-primary">+ Publicar Nova Obra</a>
            </div>
            <% if (obras != null && !obras.isEmpty()) { %>
                <div class="grid">
                    <% for (ObraModel obra : obras) {
                        String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().isEmpty())
                                         ? obra.getImagemObra() : "placeholder.jpg";
                    %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                                     alt="<%= obra.getNomeObra() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
                            </div>
                            <div class="obra-info" style="display:flex; flex-direction:column; flex:1;">
                                <h3><%= obra.getNomeObra() %></h3>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <div style="display:flex; gap:0.5rem; margin-top:auto;">
                                    <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                                       class="btn-ver" style="flex:1; text-align:center; display:flex; align-items:center; justify-content:center;">Ver</a>
                                    <a href="<%= request.getContextPath() %>/editar-obra?id=<%= obra.getIdObra() %>"
                                       class="btn-secondary btn-small" style="flex:1; text-align:center; display:flex; align-items:center; justify-content:center;">Editar</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <p>Você ainda não publicou nenhuma obra.</p>
                    <a href="<%= request.getContextPath() %>/nova-obra" class="btn-primary">Publicar primeira obra</a>
                </div>
            <% } %>
        </div>
        <% } %>

        <%-- Aba Favoritos --%>
        <div class="tab-content <%= !ehArtista ? "active" : "" %>" id="favoritos">
            <h2 style="margin-bottom:var(--spacing-md);">Obras Favoritas</h2>
            <% if (obrasFavoritadas != null && !obrasFavoritadas.isEmpty()) { %>
                <div class="grid">
                    <% for (ObraModel obra : obrasFavoritadas) {
                        String imgObra = (obra.getImagemObra() != null && !obra.getImagemObra().isEmpty())
                                         ? obra.getImagemObra() : "placeholder.jpg";
                        String nomeCat = nomesCategorias != null ? nomesCategorias.get(obra.getIdCategoria()) : null;
                    %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/<%= imgObra %>"
                                     alt="<%= obra.getNomeObra() %>"
                                     onerror="this.src='<%= request.getContextPath() %>/images/obras/placeholder.jpg'">
                            </div>
                            <div class="obra-info" style="display:flex; flex-direction:column; flex:1;">
                                <h3><%= obra.getNomeObra() %></h3>
                                <% if (nomeCat != null) { %>
                                    <p style="color:var(--gray); font-size:0.85rem;">🎨 <%= nomeCat %></p>
                                <% } %>
                                <% if (obra.getPreco() != null) { %>
                                    <p class="preco">R$ <%= obra.getPreco() %></p>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>"
                                   class="btn-ver" style="margin-top:auto;">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <p>Você ainda não favoritou nenhuma obra.</p>
                    <a href="<%= request.getContextPath() %>/explorar" class="btn-primary">Explorar obras</a>
                </div>
            <% } %>
        </div>

        <%-- Aba Seguindo --%>
        <div class="tab-content" id="seguindo">
            <div class="empty-state">
                <p>Você ainda não segue nenhum artista.</p>
                <a href="<%= request.getContextPath() %>/artistas" class="btn-primary">Descobrir artistas</a>
            </div>
        </div>

        <%-- Aba Configurações --%>
        <div class="tab-content" id="configuracoes">
            <div class="config-section">
                <h2>Configurações da Conta</h2>
                <div class="config-card">
                    <h3>Alterar Senha</h3>
                    <form action="<%= request.getContextPath() %>/alterar-senha" method="post">
                        <div class="form-group">
                            <label>Senha Atual</label>
                            <input type="password" name="senhaAtual" required>
                        </div>
                        <div class="form-group">
                            <label>Nova Senha</label>
                            <input type="password" name="novaSenha" required minlength="6">
                        </div>
                        <div class="form-group">
                            <label>Confirmar Nova Senha</label>
                            <input type="password" name="confirmarSenha" required minlength="6">
                        </div>
                        <button type="submit" class="btn-primary">Salvar Nova Senha</button>
                    </form>
                </div>
                <div class="config-card" style="margin-top:var(--spacing-lg); border:1px solid #e53e3e; border-radius:var(--radius-md); padding:var(--spacing-md);">
                    <h3 style="color:#e53e3e;">Excluir Conta</h3>
                    <p style="color:var(--gray); margin-bottom:var(--spacing-md);">
                        Esta ação é permanente e não pode ser desfeita.
                    </p>
                    <button class="btn-danger" onclick="document.getElementById('modalExcluir').style.display='flex'">
                        Excluir Conta
                    </button>
                </div>
            </div>
        </div>

    </div>
</section>

<div id="modalExcluir" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; border-radius:var(--radius-lg); padding:var(--spacing-xl);
                max-width:400px; width:90%; text-align:center;">
        <h3 style="margin-bottom:var(--spacing-md);">Tem certeza?</h3>
        <p style="color:var(--gray); margin-bottom:var(--spacing-lg);">
            Sua conta e todas as obras serão excluídas permanentemente.
        </p>
        <div style="display:flex; gap:var(--spacing-sm); justify-content:center;">
            <button class="btn-secondary"
                    onclick="document.getElementById('modalExcluir').style.display='none'">Cancelar</button>
            <form action="<%= request.getContextPath() %>/excluir-conta" method="post" style="margin:0;">
                <button type="submit" class="btn-danger">Sim, excluir minha conta</button>
            </form>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            document.getElementById(this.getAttribute('data-tab')).classList.add('active');
        });
    });
</script>

<jsp:include page="/includes/footer.jsp" />