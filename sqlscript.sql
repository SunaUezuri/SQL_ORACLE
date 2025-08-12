REM   Script: nosso_sistema
REM   gtkojorthjoijurth

/*
    Integrantes: Wesley Sena dos Santos - RM: 558043
                 Samara Victoria dos Santos - RM: 558719
                 Vanessa Yukari Iwamoto - RM: 558092
                 Rafael de Souza Pinto - RM: 555130
                

*/

DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE vendedor CASCADE CONSTRAINTS;
DROP TABLE produto CASCADE CONSTRAINTS;
DROP TABLE pedido CASCADE CONSTRAINTS;
DROP TABLE item_pedido CASCADE CONSTRAINTS;

CREATE TABLE cliente (
    cod_clie NUMBER(4) CONSTRAINT clie_cd_pk PRIMARY KEY,
    nome_clie VARCHAR2(50) CONSTRAINT clie_no_nn NOT NULL,
    endereco VARCHAR2(100),
    cidade VARCHAR2(50),
    cep CHAR(8),
    uf CHAR(2),
    cnpj VARCHAR2(16),
    ie VARCHAR2(12)
);

CREATE TABLE vendedor (
    cod_ven NUMBER(4) CONSTRAINT ven_cod_pk PRIMARY KEY,
    nome_ven VARCHAR2(50) CONSTRAINT ven_no_nn NOT NULL,
    salario_fixo NUMBER(12,2),
    comissao NUMBER(5,2)
);

CREATE TABLE produto (
    cod_prod NUMBER(4) CONSTRAINT prod_cod_pk PRIMARY KEY,
    unidade VARCHAR2(5),
    descricao VARCHAR2(100),
    val_unit NUMBER(10,2),
    qtd_estoque NUMBER(10),
    qtd_minima NUMBER(10)
);

CREATE TABLE pedido (
    num_pedido NUMBER(6) CONSTRAINT pedido_num_pk PRIMARY KEY,
    data_pedido DATE DEFAULT SYSDATE CONSTRAINT pedido_data_nn NOT NULL,
    pr_entrega NUMBER(3) CONSTRAINT entrega_pr_nn NOT NULL,
    cod_clie NUMBER(4) CONSTRAINT pedido_clie_fk REFERENCES cliente(cod_clie),
    cod_ven NUMBER(4) CONSTRAINT pedido_ven_fk REFERENCES vendedor(cod_ven),
    status_pedido VARCHAR2(20) DEFAULT 'ABERTO' NOT NULL
);

CREATE TABLE item_pedido (
    num_pedido NUMBER(6) CONSTRAINT item_pedido_pedido_fk REFERENCES pedido(num_pedido),
    cod_prod NUMBER(4) CONSTRAINT item_pedido_prod_fk REFERENCES produto(cod_prod),
    quant NUMBER(10,2) CONSTRAINT item_quant_nn NOT NULL,
    CONSTRAINT item_pedido_pk PRIMARY KEY (num_pedido, cod_prod)
);

CREATE TABLE forma_pagamento (
    id_forma NUMBER(3) CONSTRAINT forma_pag_pk PRIMARY KEY,
    descricao VARCHAR2(50) CONSTRAINT forma_desc_nn NOT NULL
);

CREATE TABLE pedido_pagamento (
    num_pedido NUMBER(6) CONSTRAINT pedpag_pedido_fk REFERENCES pedido(num_pedido),
    id_forma NUMBER(3) CONSTRAINT pedpag_forma_fk REFERENCES forma_pagamento(id_forma),
    valor_pago NUMBER(12,2) CONSTRAINT pedpag_valor_nn NOT NULL,
    data_pagamento DATE DEFAULT SYSDATE,
    CONSTRAINT pedpag_pk PRIMARY KEY (num_pedido, id_forma)
);


-- Clientes
INSERT INTO cliente VALUES (720, 'Ana', 'Rua 17 n.19', 'Niteroi', '24358310', 'RJ', '12113231000134', '2134');
INSERT INTO cliente VALUES (870, 'Flavio', 'Av. Pres. Vargas, 10', 'Sao Paulo', '22763931', 'SP', '22534126938709', '4631');
INSERT INTO cliente VALUES (110, 'Jorge', 'Rua Caiapo, 13', 'Curitiba', '30078500', 'PR', '14512764983409', NULL);
INSERT INTO cliente VALUES (222, 'Lucia', 'Rua Itabira, 123', 'Belo Horizonte', '22124391', 'MG', '28315212393488', '2985');
INSERT INTO cliente VALUES (830, 'Mauricio', 'Av. Paulista, 1236', 'Sao Paulo', '03012683', 'SP', '32816985746506', '9343');
INSERT INTO cliente VALUES (130, 'Edmar', 'Rua da Praia, s/n', 'Salvador', '30079300', 'BA', '23463284234909', '7121');
INSERT INTO cliente VALUES (410, 'Rodolfo', 'Largo da Lapa, 27', 'Rio de Janeiro', '30078900', 'RJ', '12835128234609', '743');
INSERT INTO cliente VALUES (20, 'Beth', 'Av. Climerio, 45', 'Sao Paulo', '25679300', 'SP', '32485126732608', '9280');
INSERT INTO cliente VALUES (157, 'Paulo', 'Trav. Moraes, casa 3', 'Londrina', NULL, 'PR', '32848223324202', '1923');
INSERT INTO cliente VALUES (180, 'Livio', 'Av. Beira Mar, 1256', 'Florianopolis', '30077500', 'SC', '12736571234704', '1111');
INSERT INTO cliente VALUES (260, 'Susana', 'Rua Lopes Mandes, 12', 'Niteroi', '30046500', 'RJ', '21763571232909', '2530');
INSERT INTO cliente VALUES (290, 'Renato', 'Rua Meireles, 123', 'Sao Paulo', '30225900', 'SP', '13276571123104', '1820');
INSERT INTO cliente VALUES (390, 'Sebastiao', 'Rua da Igreja, 10', 'Uberaba', '30438700', 'MG', '32176547213303', '9071');
INSERT INTO cliente VALUES (234, 'Jose', 'Quadra 3, Bl. 3, sl. 1003', 'Brasilia', '22841650', 'DF', '21763576123203', '2931');

COMMIT;

-- Vendedores (ajustei comissao para números decimais)
INSERT INTO vendedor VALUES (209, 'Jose', 1800, 0.03);
INSERT INTO vendedor VALUES (111, 'Carlos', 2490, 0.01);
INSERT INTO vendedor VALUES (11, 'Joao', 2780, 0.03);
INSERT INTO vendedor VALUES (240, 'Antonio', 9500, 0.03);
INSERT INTO vendedor VALUES (720, 'Felipe', 4600, 0.01);
INSERT INTO vendedor VALUES (213, 'Jonas', 2300, 0.01);
INSERT INTO vendedor VALUES (101, 'Joao', 2650, 0.03);
INSERT INTO vendedor VALUES (310, 'Josias', 870, 0.02);
INSERT INTO vendedor VALUES (250, 'Mauricio', 2930, 0.02);

COMMIT;

-- Produtos (números sem aspas e descrição entre aspas)
INSERT INTO produto VALUES (25, 'KG', 'Queijo', 0.97, 1000, 50);
INSERT INTO produto VALUES (31, 'BAR', 'Chocolate', 0.87, 500, 30);
INSERT INTO produto VALUES (78, 'L', 'Vinho', 2.00, 200, 20);
INSERT INTO produto VALUES (22, 'M', 'Linho', 0.11, 1500, 100);
INSERT INTO produto VALUES (30, 'SAC', 'Acucar', 0.30, 800, 40);
INSERT INTO produto VALUES (53, 'M', 'Linha', 1.80, 300, 15);
INSERT INTO produto VALUES (13, 'G', 'Ouro', 6.18, 50, 5);
INSERT INTO produto VALUES (45, 'M', 'Madeira', 0.25, 400, 25);
INSERT INTO produto VALUES (87, 'M', 'Cano', 1.97, 600, 40);
INSERT INTO produto VALUES (77, 'M', 'Papel', 1.05, 900, 60);

COMMIT;

-- Pedidos (incluí data_pedido e status default, removi aspas dos números)
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (121, 20, 410, 209, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (97, 20, 720, 101, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (101, 15, 720, 101, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (137, 20, 720, 720, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (148, 20, 720, 101, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (189, 15, 870, 213, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (104, 30, 110, 101, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (203, 30, 830, 250, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (98, 20, 410, 209, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (143, 30, 20, 11, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (105, 30, 180, 240, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (111, 15, 260, 240, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (103, 20, 260, 11, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (91, 20, 260, 11, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (138, 20, 260, 11, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (108, 15, 290, 310, SYSDATE, 'ABERTO');
INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven, data_pedido, status_pedido) VALUES (119, 30, 390, 250, SYSDATE, 'ABERTO');

COMMIT;

-- Itens do pedido (números sem aspas)
INSERT INTO item_pedido VALUES (121, 25, 10);
INSERT INTO item_pedido VALUES (121, 31, 35);
INSERT INTO item_pedido VALUES (97, 77, 20);
INSERT INTO item_pedido VALUES (101, 31, 9);
INSERT INTO item_pedido VALUES (101, 78, 18);
INSERT INTO item_pedido VALUES (101, 13, 5);
INSERT INTO item_pedido VALUES (98, 77, 5);
INSERT INTO item_pedido VALUES (148, 45, 8);
INSERT INTO item_pedido VALUES (148, 31, 7);
INSERT INTO item_pedido VALUES (148, 77, 3);
INSERT INTO item_pedido VALUES (148, 25, 10);
INSERT INTO item_pedido VALUES (148, 78, 30);
INSERT INTO item_pedido VALUES (104, 53, 32);
INSERT INTO item_pedido VALUES (203, 31, 6);
INSERT INTO item_pedido VALUES (189, 78, 45);
INSERT INTO item_pedido VALUES (143, 31, 20);
INSERT INTO item_pedido VALUES (143, 78, 10);

COMMIT;

INSERT INTO forma_pagamento (id_forma, descricao) VALUES (1, 'Dinheiro');
INSERT INTO forma_pagamento (id_forma, descricao) VALUES (2, 'Cartão de Crédito');
INSERT INTO forma_pagamento (id_forma, descricao) VALUES (3, 'Cartão de Débito');
INSERT INTO forma_pagamento (id_forma, descricao) VALUES (4, 'Boleto Bancário');
INSERT INTO forma_pagamento (id_forma, descricao) VALUES (5, 'Pix');

COMMIT;

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (121, 2, 500.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (121, 5, 200.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (97, 1, 300.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (101, 4, 1000.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (137, 2, 750.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (148, 5, 1200.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (189, 3, 450.00, SYSDATE);

INSERT INTO pedido_pagamento (num_pedido, id_forma, valor_pago, data_pagamento) VALUES (104, 1, 700.00, SYSDATE);

COMMIT;


