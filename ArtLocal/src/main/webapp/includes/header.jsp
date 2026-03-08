<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UsuarioModel" %>
<%
    UsuarioModel usuarioLogado = (UsuarioModel) session.getAttribute("usuarioLogado");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ArtLocal - Camaçari</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/logo.png">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="container">
                <a href="<%= request.getContextPath() %>/home" class="logo-link">
                    <img src="<%= request.getContextPath() %>/images/LogoArtLocal.png" alt="Logo ArtLocal" class="logo-icon">
                    <span class="logo">ArtLocal</span>
                </a>

                  
                                <ul class="nav-menu">
                    <li><a href="<%= request.getContextPath() %>/explorar">Explorar</a></li>
                    <li><a href="<%= request.getContextPath() %>/artistas">Artistas</a></li>
                    <li><a href="<%= request.getContextPath() %>/categorias">Categorias</a></li>
                    <li><a href="<%= request.getContextPath() %>/localidades">Localidades</a></li>
                    <li><a href="<%= request.getContextPath() %>/sobre">Sobre</a></li>
                </ul>

                <form action="<%= request.getContextPath() %>/busca" method="get" class="search-form">
                    <input type="text" name="q" placeholder="Buscar obras e artistas..." required>
                    <button type="submit">🔍</button>
                </form>

                <div class="nav-actions">
                    <% if (usuarioLogado == null) { %>
                        <a href="<%= request.getContextPath() %>/login" class="btn-login">Entrar</a>
                        <a href="<%= request.getContextPath() %>/cadastro" class="btn-signup">Cadastrar</a>
                    <% } else { %>
                        <div class="user-menu" id="userMenu">
                            <div class="user-menu-trigger" onclick="toggleMenu(event)">
                                <img src="<%= request.getContextPath() %>/images/avatares/<%= usuarioLogado.getIdIcone() != null ? usuarioLogado.getIdIcone() : "avatar1.png" %>"
                                     alt="Avatar"
                                     class="navbar-avatar">
                                <span><%= usuarioLogado.getNomeArtistico() != null ? usuarioLogado.getNomeArtistico() : usuarioLogado.getNomeCompleto() %></span>
                            </div>
                            <div class="dropdown" id="userDropdown">
                                <a href="<%= request.getContextPath() %>/perfil">Meu Perfil</a>
                                <a href="<%= request.getContextPath() %>/editar-perfil">Editar Perfil</a>
                                <a href="<%= request.getContextPath() %>/logout">Sair</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </nav>
    </header>
    <main>

<script>
    function toggleMenu(e) {
        e.stopPropagation();
        var dropdown = document.getElementById('userDropdown');
        dropdown.classList.toggle('dropdown-open');
    }

    document.addEventListener('click', function() {
        var dropdown = document.getElementById('userDropdown');
        if (dropdown) dropdown.classList.remove('dropdown-open');
    });
</script>