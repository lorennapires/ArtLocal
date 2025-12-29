<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
%>

<section class="categorias-section">
    <div class="container">
        <h1>Categorias de Arte</h1>
        <p class="subtitulo">Explore obras por categoria artística</p>
        
        <div class="grid categorias-grid">
            <% if (categorias != null && !categorias.isEmpty()) {
                for (CategoriaModel categoria : categorias) { %>
                    <div class="card-categoria-grande">
                        <div class="categoria-icon">🎨</div>
                        <h2><%= categoria.getNomeCategoria() %></h2>
                        <p><%= categoria.getDescricao() != null ? categoria.getDescricao() : "Explore esta categoria" %></p>
                        <p class="categoria-count">X obras</p>
                        <a href="<%= request.getContextPath() %>/explorar?categoria=<%= categoria.getIdCategoria() %>" class="btn-primary">Explorar</a>
                    </div>
            <%  }
            } else { %>
                <p>Nenhuma categoria cadastrada.</p>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />