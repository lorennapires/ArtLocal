<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    String erro = (String) request.getAttribute("erro");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
    String tagsJson = (String) request.getAttribute("tagsJson");
    if (tagsJson == null) tagsJson = "{}";
%>

<section class="cadastro-section">
    <div class="container">
        <div class="cadastro-card">
            <div class="cadastro-header">
                <h1>Criar Conta no ArtLocal</h1>
                <p>Junte-se à comunidade artística de Camaçari</p>
            </div>

            <% if (erro != null) { %>
                <div class="alert alert-error"><%= erro %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/cadastro" method="post" id="formCadastro">

                <%-- STEP 1: Tipo --%>
                <div class="form-step active" data-step="1">
                    <h2>Como você quer se cadastrar?</h2>
                    <div class="tipo-usuario-options">
                        <label class="tipo-card">
                            <input type="radio" name="tipoUsuario" value="visitante">
                            <div class="card-content">
                                <h3>Visitante</h3>
                                <p>Explorar obras e seguir artistas</p>
                            </div>
                        </label>
                        <label class="tipo-card">
                            <input type="radio" name="tipoUsuario" value="artista">
                            <div class="card-content">
                                <h3>Artista</h3>
                                <p>Publicar suas obras e conectar-se com o público</p>
                            </div>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>

                <%-- STEP 2: Dados básicos --%>
                <div class="form-step" data-step="2">
                    <h2>Dados Básicos</h2>
                    <div class="form-group">
                        <label for="nomeCompleto">Nome Completo *</label>
                        <input type="text" id="nomeCompleto" name="nomeCompleto">
                    </div>
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email">
                    </div>
                    <div class="form-group">
                        <label for="senha">Senha *</label>
                        <input type="password" id="senha" name="senha">
                        <small>Mínimo 6 caracteres</small>
                    </div>
                    <div class="form-group">
                        <label for="confirmarSenha">Confirmar Senha *</label>
                        <input type="password" id="confirmarSenha" name="confirmarSenha">
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>

                <%-- STEP 3: Avatar --%>
                <div class="form-step" data-step="3">
                    <h2>Escolha seu Avatar</h2>
                    <div class="avatars-grid">
                        <% for (int i = 1; i <= 60; i++) { %>
                            <label class="avatar-option">
                                <input type="radio" name="idIcone" value="avatar<%= i %>.png">
                                <img src="<%= request.getContextPath() %>/images/avatares/avatar<%= i %>.png"
                                     alt="Avatar <%= i %>">
                            </label>
                        <% } %>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>

                <%-- STEP 4: Localização --%>
                <div class="form-step" data-step="4">
                    <h2>Localização</h2>
                    <div class="form-group">
                        <label for="idRegiao">Sua região em Camaçari *</label>
                        <select id="idRegiao" name="idRegiao">
                            <option value="">Selecione...</option>
                            <% if (regioes != null) {
                                for (RegiaoModel regiao : regioes) { %>
                                    <option value="<%= regiao.getIdRegiao() %>"><%= regiao.getNomeRegiao() %></option>
                            <%  } } %>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>

                <%-- STEP 5A: Dados do Artista --%>
                <div class="form-step" id="stepArtista">
                    <h2>Dados do Artista</h2>
                    <div class="form-group">
                        <label for="nomeArtistico">Nome Artístico *</label>
                        <input type="text" id="nomeArtistico" name="nomeArtistico">
                    </div>
                    <div class="form-group">
                        <label for="biografia">Biografia</label>
                        <textarea id="biografia" name="biografia" rows="4"
                                  placeholder="Conte um pouco sobre você e sua arte..."></textarea>
                    </div>
                    <div class="form-group">
                        <label for="categoriaPrincipal">Categoria Principal *</label>
                        <select id="categoriaPrincipal" name="categoriaPrincipal"
                                onchange="carregarTags(this.value)">
                            <option value="">Selecione...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>">
                                        <%= categoria.getNomeCategoria() %>
                                    </option>
                            <%  } } %>
                        </select>
                    </div>
                    <div class="form-group" id="grupoTags" style="display:none;">
                        <label>Tags Principais <small style="font-weight:normal;">(opcional)</small></label>
                        <div class="tags-container" id="tagsContainer"></div>
                        <input type="hidden" name="tagsPrincipais" id="tagsPrincipaisHidden">
                    </div>
                    <div class="form-group">
                        <label for="portfolio">Link do Portfólio (opcional)</label>
                        <input type="url" id="portfolio" name="portfolio" placeholder="https://...">
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="finalizar()">Criar Conta</button>
                    </div>
                </div>

                <%-- STEP 5B: Finalizar Visitante --%>
                <div class="form-step" id="stepVisitante">
                    <h2>Tudo pronto!</h2>
                    <p style="color:var(--gray); margin-bottom:var(--spacing-lg);">
                        Clique em Criar Conta para finalizar seu cadastro como visitante.
                    </p>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="finalizar()">Criar Conta</button>
                    </div>
                </div>

                <%-- STEP 6: Confirmação --%>
                <div class="form-step" id="stepConfirmacao">
                    <div style="text-align:center; padding:var(--spacing-lg) 0;">
                        <div style="font-size:3rem; margin-bottom:var(--spacing-md);">✅</div>
                        <h2>Conta criada com sucesso!</h2>
                        <p style="color:var(--gray); margin-bottom:var(--spacing-lg);">
                            Você será redirecionado para seu perfil...
                        </p>
                        <div style="width:40px; height:40px; border:4px solid var(--gray-light);
                                    border-top-color:var(--primary); border-radius:50%;
                                    animation:spin 0.8s linear infinite; margin:0 auto;"></div>
                    </div>
                </div>

                <%-- Progresso --%>
                <div class="progress-indicator">
                    <div class="progress-step active" data-step="1">1</div>
                    <div class="progress-step" data-step="2">2</div>
                    <div class="progress-step" data-step="3">3</div>
                    <div class="progress-step" data-step="4">4</div>
                    <div class="progress-step" data-step="5">5</div>
                </div>
            </form>

            <div class="form-footer">
                <p>Já tem conta? <a href="<%= request.getContextPath() %>/login">Faça login</a></p>
            </div>
        </div>
    </div>
</section>

<script>
var todasAsTags = <%= tagsJson %>;
var currentStep = 1;
var tipoUsuario = '';

// Bloqueia submit com Enter
document.getElementById('formCadastro').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') e.preventDefault();
});

// Detecta tipo selecionado
document.querySelectorAll('input[name="tipoUsuario"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        tipoUsuario = this.value;
    });
});

function mostrarStep(stepNum) {
    // Esconde todos
    document.querySelectorAll('.form-step[data-step]').forEach(function(s) {
        s.classList.remove('active');
    });
    document.getElementById('stepArtista').classList.remove('active');
    document.getElementById('stepVisitante').classList.remove('active');
    document.getElementById('stepConfirmacao').classList.remove('active');

    // Mostra o correto
    if (stepNum === 5) {
        if (tipoUsuario === 'artista') {
            document.getElementById('stepArtista').classList.add('active');
        } else {
            document.getElementById('stepVisitante').classList.add('active');
        }
    } else if (stepNum === 6) {
        document.getElementById('stepConfirmacao').classList.add('active');
    } else {
        var el = document.querySelector('.form-step[data-step="' + stepNum + '"]');
        if (el) el.classList.add('active');
    }

    // Atualiza progresso
    document.querySelectorAll('.progress-step').forEach(function(p) {
        var s = parseInt(p.getAttribute('data-step'));
        p.classList.toggle('active', s <= stepNum);
    });
}

function nextStep() {
    if (currentStep === 1) {
        var sel = document.querySelector('input[name="tipoUsuario"]:checked');
        if (!sel) { alert('Selecione Visitante ou Artista.'); return; }
        tipoUsuario = sel.value;
    }
    if (currentStep === 2) {
        var nome  = document.getElementById('nomeCompleto').value.trim();
        var email = document.getElementById('email').value.trim();
        var senha = document.getElementById('senha').value;
        var conf  = document.getElementById('confirmarSenha').value;
        if (!nome || !email || !senha || !conf) { alert('Preencha todos os campos.'); return; }
        if (senha.length < 6) { alert('A senha deve ter pelo menos 6 caracteres.'); return; }
        if (senha !== conf) { alert('As senhas não coincidem.'); return; }
    }
    if (currentStep === 3) {
        var av = document.querySelector('input[name="idIcone"]:checked');
        if (!av) { alert('Selecione um avatar.'); return; }
    }
    if (currentStep === 4) {
        var reg = document.getElementById('idRegiao').value;
        if (!reg) { alert('Selecione sua região.'); return; }
    }
    currentStep++;
    mostrarStep(currentStep);
}

function prevStep() {
    if (currentStep > 1) {
        currentStep--;
        mostrarStep(currentStep);
    }
}

function finalizar() {
    if (tipoUsuario === 'artista') {
        var nomeArt = document.getElementById('nomeArtistico').value.trim();
        if (!nomeArt) { alert('Informe seu nome artístico.'); return; }
        var cat = document.getElementById('categoriaPrincipal').value;
        if (!cat) { alert('Selecione sua categoria principal.'); return; }
    }
    mostrarStep(6);
    setTimeout(function() {
        document.getElementById('formCadastro').submit();
    }, 1500);
}

function carregarTags(idCategoria) {
    var container = document.getElementById('tagsContainer');
    var grupo = document.getElementById('grupoTags');
    container.innerHTML = '';
    document.getElementById('tagsPrincipaisHidden').value = '';
    if (!idCategoria || !todasAsTags[idCategoria]) { grupo.style.display = 'none'; return; }
    grupo.style.display = 'block';
    todasAsTags[idCategoria].forEach(function(tag) {
        var label = document.createElement('label');
        label.className = 'tag-opcao';
        var input = document.createElement('input');
        input.type = 'checkbox';
        input.value = tag.id;
        input.addEventListener('change', function() {
            var sel = [];
            document.querySelectorAll('#tagsContainer input:checked').forEach(function(cb) { sel.push(cb.value); });
            document.getElementById('tagsPrincipaisHidden').value = sel.join(',');
        });
        var span = document.createElement('span');
        span.textContent = tag.nome;
        label.appendChild(input);
        label.appendChild(span);
        container.appendChild(label);
    });
}

<% if (erro != null) { %>
    tipoUsuario = '<%= request.getParameter("tipoUsuario") != null ? request.getParameter("tipoUsuario") : "artista" %>';
    currentStep = 5;
    mostrarStep(5);
<% } else { %>
    mostrarStep(1);
<% } %>
</script>

<jsp:include page="/includes/footer.jsp" />