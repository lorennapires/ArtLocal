<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.RegiaoModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    Map<String,String> imagensRegioes = new java.util.LinkedHashMap<>();
    imagensRegioes.put("Arembepe", "Arembepe.png");
    imagensRegioes.put("Vila de Abrantes", "Abrantes.png");
    imagensRegioes.put("Camaçari", "Camacari.png");
    imagensRegioes.put("Guarajuba", "Guarajuba.png");
    imagensRegioes.put("Itacimirim", "Itacimirim.png");
    imagensRegioes.put("Barra do Jacuípe", "Jacuipe.png");
    imagensRegioes.put("Jauá", "Jaua.png");
    imagensRegioes.put("Monte Gordo", "Monte-Gordo.png");
    imagensRegioes.put("Barra do Pojuca", "Pojuca.png");
%>

<section class="localidades-section">
    <div class="container">
        <h1>Localidades de Camaçari</h1>
        <p style="color:var(--gray); margin-bottom:var(--spacing-lg);">
            Explore a arte produzida em cada região do município.
        </p>

        <div class="grid localidades-grid">
            <% if (regioes != null) {
                for (RegiaoModel regiao : regioes) {
                    String imgFile = imagensRegioes.get(regiao.getNomeRegiao());
                    if (imgFile == null) imgFile = "Camacari.png";
            %>
                <div class="card-localidade">
                    <div class="localidade-image">
                        <img src="<%= request.getContextPath() %>/images/regioes/<%= imgFile %>"
                             alt="<%= regiao.getNomeRegiao() %>"
                             onerror="this.src='<%= request.getContextPath() %>/images/regioes/Camacari.png'">
                    </div>
                    <div class="localidade-info">
                        <h3><%= regiao.getNomeRegiao() %></h3>
                        <div class="localidade-stats">
                            <span>👨‍🎨 <%= regiao.getTotalArtistas() %> artistas</span>
                            <span>🖼️ <%= regiao.getTotalObras() %> obras</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/explorar?regiao=<%= regiao.getIdRegiao() %>"
                           class="btn-ver">Explorar Região</a>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />