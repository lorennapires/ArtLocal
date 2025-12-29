<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/includes/header.jsp" />

<%
    String erro = (String) request.getAttribute("erro");
%>

<section class="login-section">
    <div class="container">
        <div class="login-card">
            <div class="login-header">
                <h1>Entrar no Art Local</h1>
                <p>Conecte-se e explore a arte de Camaçari</p>
            </div>
            
            <% if (erro != null) { %>
                <div class="alert alert-error">
                    <%= erro %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/login" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="senha">Senha</label>
                    <input type="password" id="senha" name="senha" required>
                </div>
                
                <div class="form-group checkbox-group">
                    <label>
                        <input type="checkbox" name="lembrar">
                        Lembrar-me
                    </label>
                </div>
                
                <button type="submit" class="btn-primary btn-block">Entrar</button>
                
                <div class="form-links">
                    <a href="#">Esqueci minha senha</a>
                </div>
                
                <div class="form-divider">
                    <span>ou</span>
                </div>
                
                <a href="<%= request.getContextPath() %>/cadastro" class="btn-secondary btn-block">Criar conta</a>
                
                <div class="form-footer">
                    <a href="<%= request.getContextPath() %>/home">Voltar para home</a>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />