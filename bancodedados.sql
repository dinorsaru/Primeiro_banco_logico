-- Crie o banco de dados
CREATE DATABASE ecommerceSQL;

-- Use o banco de dados criado
USE ecommerceSQL;

-- Tabela Cliente
CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(20)
);

-- Tabelas ClientePJ e ClientePF
CREATE TABLE ClientePJ (
    cliente_id INT PRIMARY KEY,
    cnpj VARCHAR(14),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

CREATE TABLE ClientePF (
    cliente_id INT PRIMARY KEY,
    cpf VARCHAR(11),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

-- Tabela Conta
CREATE TABLE Conta (
    conta_id INT PRIMARY KEY,
    cliente_id INT,
    numero_conta VARCHAR(20),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

-- Tabela TipoConta
CREATE TABLE TipoConta (
    tipo_conta_id INT PRIMARY KEY,
    descricao VARCHAR(50)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    pagamento_id INT PRIMARY KEY,
    cliente_id INT,
    forma_pagamento_id INT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (forma_pagamento_id) REFERENCES FormaPagamento(forma_pagamento_id)
);

-- Tabela FormaPagamento
CREATE TABLE FormaPagamento (
    forma_pagamento_id INT PRIMARY KEY,
    descricao VARCHAR(50)
);

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.pedido_id) AS num_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.nome;

-- Algum vendedor também é fornecedor?
SELECT c.nome
FROM Cliente c
INNER JOIN Conta ct ON c.cliente_id = ct.cliente_id
WHERE ct.tipo_conta_id = (SELECT tipo_conta_id FROM TipoConta WHERE descricao = 'Vendedor')
AND c.cliente_id IN (SELECT fp.fornecedor_id FROM FornecedorProduto fp);

-- Relação de produtos fornecedores e estoques:
SELECT p.nome_produto, f.nome_fornecedor, e.quantidade
FROM Produto p
INNER JOIN FornecedorProduto fp ON p.produto_id = fp.produto_id
INNER JOIN Fornecedor f ON fp.fornecedor_id = f.fornecedor_id
INNER JOIN Estoque e ON p.produto_id = e.produto_id;

-- Relação de nomes dos fornecedores e nomes dos produtos:
SELECT f.nome_fornecedor, GROUP_CONCAT(p.nome_produto SEPARATOR ', ') AS produtos_fornecidos
FROM Fornecedor f
LEFT JOIN FornecedorProduto fp ON f.fornecedor_id = fp.fornecedor_id
LEFT JOIN Produto p ON fp.produto_id = p.produto_id
GROUP BY f.nome_fornecedor;
