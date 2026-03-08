<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
%>

<section class="categorias-section">
    <div class="container">
        <h1>Categorias</h1>
        <p style="color:var(--gray); margin-bottom:var(--spacing-lg);">
            Explore obras por tipo de expressão artística.
        </p>

        <div class="grid categorias-grid">
            <% if (categorias != null) {
                for (CategoriaModel cat : categorias) { %>
                    <div class="card-categoria">
                        <div class="categoria-info">
                            <h3><%= cat.getNomeCategoria() %></h3>
                            <% if (cat.getDescricao() != null) { %>
                                <p><%= cat.getDescricao() %></p>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/explorar?categoria=<%= cat.getIdCategoria() %>"
                               class="btn-ver">Explorar Categoria</a>
                        </div>
                    </div>
            <% } } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />