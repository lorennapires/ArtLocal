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
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="container">
                <div class="logo">ArtLocal</div>
                
                <ul class="nav-menu">
                    <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/explorar">Explorar</a></li>
                    <li><a href="<%= request.getContextPath() %>/categorias">Categorias</a></li>
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
                        <div class="user-menu">
                            <span>Olá, <%= usuarioLogado.getNomeArtistico() != null ? usuarioLogado.getNomeArtistico() : usuarioLogado.getNomeCompleto() %></span>
                            <div class="dropdown">
                                <a href="<%= request.getContextPath() %>/perfil">Meu Perfil</a>
                                <a href="<%= request.getContextPath() %>/logout">Sair</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </nav>
    </header>
    <main>