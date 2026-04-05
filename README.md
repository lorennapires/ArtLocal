# ArtLocal

Plataforma web para divulgação de artistas locais da região de Camaçari, Bahia.

---

## Sobre o projeto

O objetivo do ArtLocal é reunir, em um único ambiente, artistas da cidade e pessoas que desejam conhecer, acompanhar e valorizar a produção artística local.

---

## Funcionalidades

**Para artistas:** criação de perfil com nome artístico, biografia, categoria e tags, publicação de obras com imagem, descrição, preço e link externo, edição e exclusão de obras e visualização de seguidores.

**Para visitantes:** exploração de obras com filtros por categoria e região, ordenação por data ou preço, curtidas, favoritos, seguir artistas e busca por nome.

---

## Tecnologias utilizadas

- Java com Java Servlets
- JSP (Java Server Pages)
- MySQL 8.0
- Apache Tomcat 9.0
- HTML, CSS e JavaScript
- Eclipse Enterprise Edition


## Estrutura do projeto
```
ArtLocal/
├── src/main/java/
│   ├── controller/    # Servlets
│   ├── dao/           # Acesso ao banco
│   ├── model/         # Modelos de dados
│   └── util/          # Conexão JDBC
└── src/main/webapp/
    ├── css/           
    ├── images/        
    ├── includes/      # Header e footer
    └── pages/         # Páginas JSP
```

---

Desenvolvido por **Lorenna Macêdo Ramiro Pires** — IFBA Camaçari, 2025.2
