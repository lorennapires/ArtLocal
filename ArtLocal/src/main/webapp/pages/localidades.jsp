<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.RegiaoModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
%>

<section class="localidades-section">
    <div class="container">
        <h1>Arte Local por Região</h1>
        <p class="subtitulo">Descubra artistas e obras de cada localidade de Camaçari</p>
        
        <div class="grid localidades-grid">
            <% if (regioes != null && !regioes.isEmpty()) {
                for (RegiaoModel regiao : regioes) { %>
                    <div class="card-localidade">
                        <div class="localidade-image">
                            <img src="<%= request.getContextPath() %>/images/regioes/placeholder.jpg" alt="<%= regiao.getNomeRegiao() %>">
                        </div>
                        <div class="localidade-info">
                            <h2><%= regiao.getNomeRegiao() %></h2>
                            <div class="localidade-stats">
                                <p>👤 X artistas</p>
                                <p>🎨 Y obras</p>
                            </div>
                            <a href="<%= request.getContextPath() %>/explorar?regiao=<%= regiao.getIdRegiao() %>" class="btn-primary">Explorar Região</a>
                        </div>
                    </div>
            <%  }
            } else { %>
                <p>Nenhuma região cadastrada.</p>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />