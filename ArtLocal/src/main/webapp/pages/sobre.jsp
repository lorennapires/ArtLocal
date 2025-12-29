<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/includes/header.jsp" />

<section class="sobre-section">
    <div class="container">
        <!-- Hero -->
        <div class="sobre-hero">
            <h1>Sobre o Art Local</h1>
            <p class="lead">Conectando artistas e arte em Camaçari</p>
        </div>
        
        <!-- O que é -->
        <div class="sobre-content">
            <div class="content-block">
                <h2>O que é o Art Local?</h2>
                <p>O Art Local é uma plataforma digital criada para valorizar e promover artistas independentes de Camaçari e suas nove regiões. Nossa missão é criar uma ponte entre artistas locais e pessoas interessadas em arte, facilitando a descoberta, divulgação e comercialização de obras de arte produzidas em nossa cidade.</p>
                <p>Através do Art Local, artistas podem criar perfis, publicar suas obras, conectar-se com o público e outros artistas, enquanto visitantes podem explorar a rica diversidade artística de Camaçari, seguir seus artistas favoritos e descobrir novas obras.</p>
            </div>
            
            <div class="content-block">
                <h2>Por que Camaçari?</h2>
                <p>Camaçari possui uma rica cena artística que merece ser reconhecida e valorizada. Das praias de Arembepe e Guarajuba à sede do município, cada uma das nove regiões de Camaçari contribui com sua identidade cultural única para o cenário artístico local.</p>
                <p>Nosso objetivo é dar visibilidade a esses talentos locais, facilitando o acesso do público à arte produzida em nossa região e fortalecendo a economia criativa local.</p>
            </div>
            
            <!-- Como Funciona -->
            <div class="content-block">
                <h2>Como Funciona</h2>
                
                <div class="funciona-grid">
                    <div class="funciona-card">
                        <div class="icon">🎨</div>
                        <h3>Para Artistas</h3>
                        <ul>
                            <li>Crie seu perfil artístico</li>
                            <li>Publique suas obras com descrição e categorias</li>
                            <li>Adicione links para venda ou portfólio</li>
                            <li>Conecte-se com outros artistas e público</li>
                            <li>Receba feedback através de curtidas e seguidores</li>
                        </ul>
                    </div>
                    
                    <div class="funciona-card">
                        <div class="icon">👤</div>
                        <h3>Para Visitantes</h3>
                        <ul>
                            <li>Explore obras por categoria ou região</li>
                            <li>Descubra novos artistas locais</li>
                            <li>Curta e favorite suas obras preferidas</li>
                            <li>Siga artistas para acompanhar novidades</li>
                            <li>Acesse links para aquisição de obras</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Regiões de Camaçari -->
            <div class="content-block">
                <h2>As 9 Regiões de Camaçari</h2>
                <p>Nossa plataforma representa toda a diversidade de Camaçari através de suas nove regiões:</p>
                <div class="regioes-lista">
                    <span class="badge-regiao">Arembepe</span>
                    <span class="badge-regiao">Barra do Jacuípe</span>
                    <span class="badge-regiao">Barra do Pojuca</span>
                    <span class="badge-regiao">Camaçari (Sede)</span>
                    <span class="badge-regiao">Guarajuba</span>
                    <span class="badge-regiao">Itacimirim</span>
                    <span class="badge-regiao">Jauá</span>
                    <span class="badge-regiao">Monte Gordo</span>
                    <span class="badge-regiao">Vila de Abrantes</span>
                </div>
            </div>
            
            <!-- Sobre o Projeto -->
            <div class="content-block">
                <h2>Sobre o Projeto</h2>
                <p>O Art Local é um projeto acadêmico desenvolvido para a disciplina de Laboratório de Programação I, do curso de Bacharelado em Ciência da Computação.</p>
                <p><strong>Desenvolvido por:</strong> Lorenna Macêdo Ramiro Pires</p>
                <p><strong>Instituição:</strong> [Nome da Instituição]</p>
                <p><strong>Ano:</strong> 2025</p>
            </div>
            
            <!-- Contato -->
            <div class="content-block contato-block">
                <h2>Entre em Contato</h2>
                <p>Tem sugestões, dúvidas ou quer saber mais sobre o Art Local?</p>
                
                <div class="contato-info">
                    <div class="contato-item">
                        <span class="icon">📧</span>
                        <div>
                            <strong>Email</strong>
                            <p>contato@artlocal.com</p>
                        </div>
                    </div>
                    
                    <div class="contato-item">
                        <span class="icon">📱</span>
                        <div>
                            <strong>Redes Sociais</strong>
                            <p>@artlocal</p>
                        </div>
                    </div>
                </div>
                
                <form action="#" method="post" class="contato-form">
                    <h3>Envie uma Mensagem</h3>
                    
                    <div class="form-group">
                        <label for="nome">Nome</label>
                        <input type="text" id="nome" name="nome" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="emailContato">Email</label>
                        <input type="email" id="emailContato" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="mensagem">Mensagem</label>
                        <textarea id="mensagem" name="mensagem" rows="5" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn-primary">Enviar Mensagem</button>
                </form>
            </div>
            
            <!-- CTA Final -->
            <div class="cta-block">
                <h2>Faça Parte do Art Local</h2>
                <p>Junte-se à nossa comunidade e ajude a fortalecer a arte em Camaçari</p>
                <div class="cta-buttons">
                    <a href="<%= request.getContextPath() %>/cadastro" class="btn-primary">Criar Conta</a>
                    <a href="<%= request.getContextPath() %>/explorar" class="btn-secondary">Explorar Obras</a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />