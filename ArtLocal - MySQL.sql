create database artlocalv1;
use artlocalv1;

create table usuario (
    id_usuario          int auto_increment primary key,
    nome_completo       varchar(100) not null,
    nome_artistico      varchar(100),
    id_icone            int,
    biografia           text,
    email               varchar(100) not null,
    senha               varchar(255) not null,
    tipo_usuario        enum('visitante','artista') not null,
    portfolio           text,
    categoria_principal int,
    tags_principais     varchar(255),
    data_criacao        timestamp,
    check (
        (tipo_usuario = 'visitante' and portfolio is null and categoria_principal is null and tags_principais is null)
        or
        (tipo_usuario = 'artista')
    )
);

create table categoria (
    id_categoria        int auto_increment primary key,
    nome_categoria      varchar(100) not null,
    descricao           varchar(255)
);

create table tag (
    id_tag              int auto_increment primary key,
    nome_tag            varchar(100) not null,
    id_categoria        int not null
);

create table obra (
    id_obra             int auto_increment primary key,
    id_usuario          int not null,
    id_categoria        int not null,
    nome_obra           varchar(100) not null,
    descricao           text,
    link_externo        varchar(255),
    preco               decimal(10,2),
    data_criacao        timestamp
);

create table obra_tag (
    id_obra             int not null,
    id_tag              int not null,
    primary key (id_obra, id_tag)
);

create table interacao (
    id_interacao        int auto_increment primary key,
    id_usuario          int not null,
    id_obra             int,
    id_usuario_seguido  int,
    tipo                enum('favorito','seguir','curtir') not null,
    data_interacao      timestamp
);

create table regiao (
    id_regiao           int auto_increment primary key,
    nome_regiao         varchar(50) not null
);


insert into regiao (nome_regiao) values
('Camaçari (Sede)'),
('Arembepe'),
('Barra do Jacuípe'),
('Barra do Pojuca'),
('Guarajuba'),
('Itacimirim'),
('Jauá'),
('Monte Gordo'),
('Vila de Abrantes');


alter table obra
    add constraint fk_obra_usuario     foreign key (id_usuario)   references usuario(id_usuario)    on delete cascade;
alter table obra
    add constraint fk_obra_categoria   foreign key (id_categoria) references categoria(id_categoria) on delete cascade;
alter table obra_tag
    add constraint fk_obra_tag_obra    foreign key (id_obra)      references obra(id_obra)           on delete cascade;
alter table obra_tag
    add constraint fk_obra_tag_tag     foreign key (id_tag)       references tag(id_tag)             on delete cascade;
alter table interacao
    add constraint fk_interacao_usuario         foreign key (id_usuario)         references usuario(id_usuario)  on delete cascade;
alter table interacao
    add constraint fk_interacao_obra            foreign key (id_obra)            references obra(id_obra)        on delete cascade;
alter table interacao
    add constraint fk_interacao_usuario_seguido foreign key (id_usuario_seguido) references usuario(id_usuario)  on delete cascade;
alter table tag
    add constraint fk_tag_categoria    foreign key (id_categoria) references categoria(id_categoria) on delete cascade;
alter table usuario modify id_icone varchar(100);
alter table usuario add column id_regiao int;
alter table usuario add constraint fk_usuario_regiao foreign key (id_regiao) references regiao(id_regiao);
alter table obra add column  imagem_obra varchar(255) default 'placeholder.jpg';

insert into categoria (id_categoria, nome_categoria, descricao) values
(1, 'Ilustração e Artes Visuais',           'Desenho, pintura, ilustração e arte digital'),
(2, 'Escultura e Modelagem',               'Escultura em argila, madeira, resina e miniaturas'),
(3, 'Cerâmica Artística',                'Peças utilitárias e decorativas em cerâmica'),
(4, 'Design de Moda ',                  'Moda autoral, bordado, crochê e cosplay'),
(5, 'Música e Performance',            'Composições, covers, bandas e gêneros musicais'),
(6, 'Artesanato',              'Bijuteria, velas, sabonetes e outros artesanatos');


-- categoria 1: artes visuais

insert into tag (nome_tag, id_categoria) values
('Desenho tradicional',   1),
('Desenho digital',       1),
('Ilustração realista',   1),
('Ilustração cartoon',    1),
('Ilustração anime',      1),
('Ilustração editorial',  1),
('Ilustração infantil',   1),
('Pintura em tela',       1),
('Pintura em tecido',     1),
('Aquarela',              1),
('Acrílica',              1),
('Tinta a óleo',          1),
('Ilustração digital',    1),
('Concept art',           1),
('Pixel art',             1),
('Modelagem 3D',          1),
('Animação 2D',           1),
('Animação 3D',           1);

-- categoria 2: escultura

insert into tag (nome_tag, id_categoria) values
('Escultura em argila',   2),
('Escultura em madeira',  2),
('Escultura em resina',   2),
('Miniatura artística',   2);

-- categoria 3: cerâmica

insert into tag (nome_tag, id_categoria) values
('Vaso',                  3),
('Tigela',                3),
('Prato',                 3),
('Caneca',                3),
('Copo',                  3),
('Travessa',              3),
('Azulejo artístico',     3),
('Escultura em cerâmica', 3);

-- categoria 4: design de moda
 
insert into tag (nome_tag, id_categoria) values
('Roupa customizada',     4),
('Bordado',               4),
('Crochê',                4),
('Tricô',                 4),
('Patchwork',             4),
('Fantasia',              4),
('Cosplay',               4),
('Figurino teatral',      4),
('Figurino para dança',   4);

-- categoria 5: música

insert into tag (nome_tag, id_categoria) values
('Cover',                 5),
('Remix',                 5),
('Banda',                 5),
('Solo',                  5),
('Instrumental',          5),
('Acústico',              5),
('Pop',                   5),
('Rock',                  5),
('Funk',                  5),
('Rap / Hip-Hop',         5),
('Trap',                  5),
('Eletrônica',            5),
('Sertanejo',             5),
('Reggae',                5),
('Gospel',                5);

-- categoria 6: artesanato

insert into tag (nome_tag, id_categoria) values
('Bijuteria artesanal',   6),
('Velas artesanais',      6),
('Sabonete artesanal',    6),
('Macramê',               6),
('Feltro',                6),
('Biscuit',               6);

SELECT * FROM usuario;