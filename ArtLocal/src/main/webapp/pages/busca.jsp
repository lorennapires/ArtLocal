<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObraModel" %>
<%@ page import="model.UsuarioModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    String termoBusca = (String) request.getAttribute("termoBusca");
    List<ObraModel> obras = (List<ObraModel>) request.getAttribute("obras");
    List<UsuarioModel> artistas = (List<UsuarioModel>) request.getAttribute("artistas");
%>

<section class="busca-section">
    <div class="container">
        <h1>Resultados para: "<%= termoBusca %>"</h1>
        
        <div class="busca-tabs">
            <button class="tab active" data-tab="todos">Todos</button>
            <button class="tab" data-tab="obras-tab">Obras (<%= obras != null ? obras.size() : 0 %>)</button>
            <button class="tab" data-tab="artistas-tab">Artistas (<%= artistas != null ? artistas.size() : 0 %>)</button>
        </div>
        
        <!-- Tab: Todos -->
        <div class="tab-content active" id="todos">
            <!-- Obras encontradas -->
            <% if (obras != null && !obras.isEmpty()) { %>
                <section class="resultados-obras">
                    <h2>Obras Encontradas</h2>
                    <div class="grid">
                        <% for (ObraModel obra : obras) { %>
                            <div class="card-obra">
                                <div class="obra-image">
                                    <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                                </div>
                                <div class="obra-info">
                                    <h3><%= obra.getNomeObra() %></h3>
                                    <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-ver">Ver</a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </section>
            <% } %>
            
            <!-- Artistas encontrados -->
            <% if (artistas != null && !artistas.isEmpty()) { %>
                <section class="resultados-artistas">
                    <h2>Artistas Encontrados</h2>
                    <div class="grid">
                        <% for (UsuarioModel artista : artistas) { %>
                            <div class="card-artista">
                                <div class="artista-avatar">
                                    <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>">
                                </div>
                                <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                                <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-ver">Ver Perfil</a>
                            </div>
                        <% } %>
                    </div>
                </section>
            <% } %>
            
            <% if ((obras == null || obras.isEmpty()) && (artistas == null || artistas.isEmpty())) { %>
                <div class="no-results">
                    <p>Nenhum resultado encontrado para "<%= termoBusca %>"</p>
                    <p>Sugestões:</p>
                    <ul>
                        <li>Verifique a ortografia</li>
                        <li>Tente termos mais genéricos</li>
                        <li><a href="<%= request.getContextPath() %>/explorar">Explore todas as obras</a></li>
                        <li><a href="<%= request.getContextPath() %>/categorias">Navegue por categorias</a></li>
                    </ul>
                </div>
            <% } %>
        </div>
        
        <!-- Tab: Apenas Obras -->
        <div class="tab-content" id="obras-tab">
            <% if (obras != null && !obras.isEmpty()) { %>
                <div class="grid">
                    <% for (ObraModel obra : obras) { %>
                        <div class="card-obra">
                            <div class="obra-image">
                                <img src="<%= request.getContextPath() %>/images/obras/placeholder.jpg" alt="<%= obra.getNomeObra() %>">
                            </div>
                            <div class="obra-info">
                                <h3><%= obra.getNomeObra() %></h3>
                                <a href="<%= request.getContextPath() %>/obra?id=<%= obra.getIdObra() %>" class="btn-ver">Ver</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <p class="no-results">Nenhuma obra encontrada.</p>
            <% } %>
        </div>
        
        <!-- Tab: Apenas Artistas -->
        <div class="tab-content" id="artistas-tab">
            <% if (artistas != null && !artistas.isEmpty()) { %>
                <div class="grid">
                    <% for (UsuarioModel artista : artistas) { %>
                        <div class="card-artista">
                            <div class="artista-avatar">
                                <img src="<%= request.getContextPath() %>/images/avatars/<%= artista.getIdIcone() %>" alt="<%= artista.getNomeArtistico() %>">
                            </div>
                            <h3><%= artista.getNomeArtistico() != null ? artista.getNomeArtistico() : artista.getNomeCompleto() %></h3>
                            <a href="<%= request.getContextPath() %>/artista?id=<%= artista.getIdUsuario() %>" class="btn-ver">Ver Perfil</a>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <p class="no-results">Nenhum artista encontrado.</p>
            <% } %>
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