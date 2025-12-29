<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.RegiaoModel" %>
<%@ page import="model.CategoriaModel" %>

<jsp:include page="/includes/header.jsp" />

<%
    String erro = (String) request.getAttribute("erro");
    List<RegiaoModel> regioes = (List<RegiaoModel>) request.getAttribute("regioes");
    List<CategoriaModel> categorias = (List<CategoriaModel>) request.getAttribute("categorias");
%>

<section class="cadastro-section">
    <div class="container">
        <div class="cadastro-card">
            <div class="cadastro-header">
                <h1>Criar Conta no Art Local</h1>
                <p>Junte-se à comunidade artística de Camaçari</p>
            </div>
            
            <% if (erro != null) { %>
                <div class="alert alert-error">
                    <%= erro %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/cadastro" method="post" class="cadastro-form" id="formCadastro">
                
                <!-- Step 1: Tipo de usuário -->
                <div class="form-step active" data-step="1">
                    <h2>Como você quer se cadastrar?</h2>
                    
                    <div class="tipo-usuario-options">
                        <label class="tipo-card">
                            <input type="radio" name="tipoUsuario" value="visitante" required>
                            <div class="card-content">
                                <div class="icon">👤</div>
                                <h3>Visitante</h3>
                                <p>Explorar obras e seguir artistas</p>
                            </div>
                        </label>
                        
                        <label class="tipo-card">
                            <input type="radio" name="tipoUsuario" value="artista" required>
                            <div class="card-content">
                                <div class="icon">🎨</div>
                                <h3>Artista</h3>
                                <p>Publicar suas obras e conectar-se com público</p>
                            </div>
                        </label>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>
                
                <!-- Step 2: Dados básicos -->
                <div class="form-step" data-step="2">
                    <h2>Dados Básicos</h2>
                    
                    <div class="form-group">
                        <label for="nomeCompleto">Nome Completo *</label>
                        <input type="text" id="nomeCompleto" name="nomeCompleto" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="senha">Senha *</label>
                        <input type="password" id="senha" name="senha" required minlength="6">
                        <small>Mínimo 6 caracteres</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmarSenha">Confirmar Senha *</label>
                        <input type="password" id="confirmarSenha" name="confirmarSenha" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>
                
                <!-- Step 3: Avatar -->
                <div class="form-step" data-step="3">
                    <h2>Escolha seu Avatar</h2>
                    <p id="avatarMessage">Selecione um avatar da galeria</p>
                    
                    <div class="avatars-grid" id="avatarsGrid">
                        <% for (int i = 1; i <= 18; i++) { %>
                            <label class="avatar-option">
                                <input type="radio" name="idIcone" value="avatar<%= i %>.png" required>
                                <img src="<%= request.getContextPath() %>/images/avatars/avatar<%= i %>.png" alt="Avatar <%= i %>">
                            </label>
                        <% } %>
                    </div>
                    
                    <div id="uploadAvatarSection" style="display:none;">
                        <div class="form-group">
                            <label>Ou faça upload de sua foto</label>
                            <input type="file" name="avatarUpload" accept="image/*">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>
                
                <!-- Step 4: Localização -->
                <div class="form-step" data-step="4">
                    <h2>Localização</h2>
                    
                    <div class="form-group">
                        <label for="idRegiao">Selecione sua região em Camaçari *</label>
                        <select id="idRegiao" name="idRegiao" required>
                            <option value="">Selecione...</option>
                            <% if (regioes != null) {
                                for (RegiaoModel regiao : regioes) { %>
                                    <option value="<%= regiao.getIdRegiao() %>"><%= regiao.getNomeRegiao() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="button" class="btn-primary" onclick="nextStep()">Próximo</button>
                    </div>
                </div>
                
                <!-- Step 5: Dados do Artista (condicional) -->
                <div class="form-step" data-step="5" id="stepArtista">
                    <h2>Dados do Artista</h2>
                    
                    <div class="form-group">
                        <label for="nomeArtistico">Nome Artístico *</label>
                        <input type="text" id="nomeArtistico" name="nomeArtistico">
                    </div>
                    
                    <div class="form-group">
                        <label for="biografia">Biografia</label>
                        <textarea id="biografia" name="biografia" rows="4" placeholder="Conte um pouco sobre você e sua arte..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoriaPrincipal">Categoria Principal</label>
                        <select id="categoriaPrincipal" name="categoriaPrincipal">
                            <option value="">Selecione...</option>
                            <% if (categorias != null) {
                                for (CategoriaModel categoria : categorias) { %>
                                    <option value="<%= categoria.getIdCategoria() %>"><%= categoria.getNomeCategoria() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="tagsPrincipais">Tags Principais</label>
                        <input type="text" id="tagsPrincipais" name="tagsPrincipais" placeholder="Ex: aquarela, paisagem, realismo">
                        <small>Separe as tags por vírgula</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="portfolio">Link do Portfólio (opcional)</label>
                        <input type="url" id="portfolio" name="portfolio" placeholder="https://...">
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="submit" class="btn-primary">Finalizar Cadastro</button>
                    </div>
                </div>
                
                <!-- Step final para visitante -->
                <div class="form-step" data-step="5" id="stepVisitante">
                    <h2>Tudo Pronto!</h2>
                    <p>Clique em finalizar para criar sua conta</p>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep()">Voltar</button>
                        <button type="submit" class="btn-primary">Finalizar Cadastro</button>
                    </div>
                </div>
                
                <!-- Indicador de progresso -->
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
    let currentStep = 1;
    let tipoUsuario = '';
    
    // Detectar mudança no tipo de usuário
    document.querySelectorAll('input[name="tipoUsuario"]').forEach(radio => {
        radio.addEventListener('change', function() {
            tipoUsuario = this.value;
            
            // Mostrar/ocultar opção de upload para artista
            if (tipoUsuario === 'artista') {
                document.getElementById('avatarMessage').textContent = 'Artistas podem fazer upload de foto própria';
                document.getElementById('uploadAvatarSection').style.display = 'block';
            } else {
                document.getElementById('avatarMessage').textContent = 'Selecione um avatar da galeria';
                document.getElementById('uploadAvatarSection').style.display = 'none';
            }
        });
    });
    
    function nextStep() {
        // Validar step atual
        const currentStepDiv = document.querySelector(`.form-step[data-step="${currentStep}"]`);
        const inputs = currentStepDiv.querySelectorAll('input[required], select[required], textarea[required]');
        let valid = true;
        
        inputs.forEach(input => {
            if (!input.value) {
                valid = false;
                input.classList.add('error');
            } else {
                input.classList.remove('error');
            }
        });
        
        // Validar senhas iguais no step 2
        if (currentStep === 2) {
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;
            if (senha !== confirmarSenha) {
                alert('As senhas não coincidem!');
                return;
            }
        }
        
        if (!valid) {
            alert('Por favor, preencha todos os campos obrigatórios');
            return;
        }
        
        // Ocultar step atual
        currentStepDiv.classList.remove('active');
        
        currentStep++;
        
        // No step 5, decidir qual mostrar baseado no tipo
        if (currentStep === 5) {
            if (tipoUsuario === 'artista') {
                document.getElementById('stepArtista').classList.add('active');
                document.getElementById('stepVisitante').style.display = 'none';
            } else {
                document.getElementById('stepVisitante').classList.add('active');
                document.getElementById('stepArtista').style.display = 'none';
            }
        } else {
            document.querySelector(`.form-step[data-step="${currentStep}"]`).classList.add('active');
        }
        
        // Atualizar indicador de progresso
        document.querySelector(`.progress-step[data-step="${currentStep}"]`).classList.add('active');
    }
    
    function prevStep() {
        document.querySelector(`.form-step[data-step="${currentStep}"]`).classList.remove('active');
        document.querySelector(`.progress-step[data-step="${currentStep}"]`).classList.remove('active');
        
        currentStep--;
        
        document.querySelector(`.form-step[data-step="${currentStep}"]`).classList.add('active');
    }
</script>

<jsp:include page="/includes/footer.jsp" />