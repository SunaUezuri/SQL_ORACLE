set serveroutput on
set VERIFY off

/*
    Tipos para dar dinamismo para as procedures
    assim automatizando mais o processo
*/
-- Tipo para um item
CREATE OR REPLACE TYPE item_pedido_obj AS OBJECT (
    cod_prod NUMBER,
    quantidade NUMBER
);


-- Tipo para uma lista de itens
CREATE OR REPLACE TYPE lista_itens_pedido AS TABLE OF item_pedido_obj;



/*
    Função para criar automaticamente um número de pedido novo
*/
CREATE OR REPLACE FUNCTION proximo_num_pedido
RETURN NUMBER
IS
    v_num NUMBER;
BEGIN
    SELECT NVL(MAX(num_pedido), 0) + 1
    INTO v_num
    FROM pedido;
    RETURN v_num;
END;

/*
    Procedure para fazer a inserção na tabela item_pedido
*/
CREATE OR REPLACE PROCEDURE inserir_item_pedido(
    p_num_pedido IN pedido.num_pedido%TYPE,
    p_cod_prod   IN produto.cod_prod%TYPE,
    p_quant      IN item_pedido.quant%TYPE
)
IS
BEGIN
    INSERT INTO item_pedido (num_pedido, cod_prod, quant)
    VALUES (p_num_pedido, p_cod_prod, p_quant);
    
    DBMS_OUTPUT.PUT_LINE('Item adicionado: Produto ' || p_cod_prod || ', Quantidade ' || p_quant);
END;


/*
    Procedure para realizar a inserção automática de um pedido
*/
CREATE OR REPLACE PROCEDURE inserir_pedido(
    p_cod_clie IN cliente.cod_clie%TYPE,
    p_cod_ven  IN vendedor.cod_ven%TYPE,
    p_pr_entrega IN pedido.pr_entrega%TYPE,
    p_num_pedido OUT pedido.num_pedido%TYPE
)
IS
BEGIN
    p_num_pedido := proximo_num_pedido;
    
    INSERT INTO pedido (num_pedido, pr_entrega, cod_clie, cod_ven)
    VALUES (p_num_pedido, p_pr_entrega, p_cod_clie, p_cod_ven);

    DBMS_OUTPUT.PUT_LINE('Pedido criado: ' || p_num_pedido);
END;

/*
    Procedure principal para automatizar os
    processos.
    
    Ele recebe uma lista de pedidos permitindo com que sejam preenchidos
    de maneira fácil e rápida.
*/
CREATE OR REPLACE PROCEDURE criar_pedido_dinamico(
    p_cod_clie     IN cliente.cod_clie%TYPE,
    p_cod_ven      IN vendedor.cod_ven%TYPE,
    p_pr_entrega   IN pedido.pr_entrega%TYPE,
    p_itens        IN lista_itens_pedido
)
IS
    v_num_pedido NUMBER;
BEGIN
    -- Criar o pedido
    inserir_pedido(
        p_cod_clie   => p_cod_clie,
        p_cod_ven    => p_cod_ven,
        p_pr_entrega => p_pr_entrega,
        p_num_pedido => v_num_pedido
    );

    -- Inserir todos os itens recebidos
    FOR i IN 1 .. p_itens.COUNT LOOP
        inserir_item_pedido(
            p_num_pedido => v_num_pedido,
            p_cod_prod   => p_itens(i).cod_prod,
            p_quant      => p_itens(i).quantidade
        );
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Pedido ' || v_num_pedido || ' criado com ' || p_itens.COUNT || ' itens.');
END;

-- Chamando a procedure
DECLARE
    v_itens lista_itens_pedido := lista_itens_pedido();
BEGIN
    -- Adicionando produtos à lista
    v_itens.EXTEND;
    v_itens(1) := item_pedido_obj(77, 20);
    v_itens.EXTEND;
    v_itens(2) := item_pedido_obj(53, 5);
    v_itens.EXTEND;
    v_itens(3) := item_pedido_obj(25, 2);

    -- Criar pedido
    criar_pedido_dinamico(
        p_cod_clie   => 720,
        p_cod_ven    => 101,
        p_pr_entrega => 20,
        p_itens      => v_itens
    );
END;


SELECT * FROM PEDIDO ORDER BY num_pedido;
SELECT * FROM PRODUTO;
SELECT * FROM ITEM_PEDIDO ORDER BY NUM_PEDIDO;