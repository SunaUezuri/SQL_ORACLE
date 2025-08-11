set serveroutput on
set VERIFY off

CREATE OR REPLACE FUNCTION validar_nome_cliente(p_nome IN cliente.nome_clie%TYPE)
RETURN BOOLEAN
IS
BEGIN
    RETURN p_nome IS NOT NULL AND NOT REGEXP_LIKE(p_nome, '[0-9]');
END;

CREATE OR REPLACE FUNCTION validar_cnpj_cliente(p_cnpj IN cliente.cnpj%TYPE)
RETURN BOOLEAN
IS
BEGIN
    RETURN p_cnpj IS NOT NULL
        AND REGEXP_LIKE(p_cnpj, '^[0-9]{8}/[0-9]{4}-[0-9]{2}$')
        AND NOT REGEXP_LIKE(p_cnpj, '[A-Za-z]');
END;



CREATE OR REPLACE PROCEDURE inserir_cliente_validado (
    p_cod_clie   IN cliente.cod_clie%TYPE,
    p_nome_clie  IN cliente.nome_clie%TYPE,
    p_endereco   IN cliente.endereco%TYPE,
    p_cidade     IN cliente.cidade%TYPE,
    p_cep        IN cliente.cep%TYPE,
    p_uf         IN cliente.uf%TYPE,
    p_cnpj       IN cliente.cnpj%TYPE,
    p_ie         IN cliente.ie%TYPE
) AS
    ex_nome_invalido EXCEPTION;
    ex_cnpj_invalida EXCEPTION;
BEGIN
    IF NOT validar_nome_cliente(p_nome_clie) THEN
        RAISE ex_nome_invalido;
    ELSIF NOT validar_cnpj_cliente(p_cnpj) THEN
        RAISE ex_cnpj_invalida;
    END IF;

    INSERT INTO cliente (
        cod_clie, nome_clie, endereco, cidade, cep, uf, cnpj, ie
    ) VALUES (
        p_cod_clie, p_nome_clie, p_endereco, p_cidade, p_cep, p_uf, p_cnpj, p_ie
    );

    DBMS_OUTPUT.PUT_LINE('Cliente inserido com sucesso.');
    
EXCEPTION
    WHEN ex_nome_invalido THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome inválido. Não pode ser nulo nem conter números.');
    WHEN ex_cnpj_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CNPJ inválidA. Não pode ser nula, não pode conter letras e tem que estar no formato: 00000000/0000-00.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;

BEGIN
    inserir_cliente_validado(
        502,
        'Letícia Souza',
        'Rua ABC, 123',
        'São Paulo',
        '01234567',
        'SP',
        'A2345678/9012-34',
        '123456789012'
    );
END;


SELECT * FROM CLIENTE WHERE COD_CLIE = 1001; 

DELETE FROM CLIENTE WHERE COD_CLIE = 502;
