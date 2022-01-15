-- Deleta tabelas caso elas já existam
DROP SCHEMA IF EXISTS db_ecom CASCADE;
CREATE SCHEMA db_ecom;

-- Cria tabelas com informações e relações presentes no RS
CREATE TABLE ironhack.db_ecom.CLIENTE
(
  CD_CLIENTE BIGSERIAL NOT NULL,
  nm_cliente VARCHAR(256) NOT NULL,
  nm_endereco TEXT NOT NULL,
  cd_documento BIGINT NOT NULL,
  PRIMARY KEY (CD_CLIENTE)
);

CREATE TABLE ironhack.db_ecom.PRODUTO
(
  CD_SKU BIGINT NOT NULL,
  nm_produto TEXT NOT NULL,
  nm_marca TEXT NOT NULL,
  vl_produto NUMERIC(7, 2) NOT NULL,
  PRIMARY KEY (CD_SKU)
);

CREATE TABLE ironhack.db_ecom.PEDIDO
(
  CD_PEDIDO BIGSERIAL NOT NULL,
  dt_pedido TIMESTAMP NOT NULL,
  dt_expedicao TIMESTAMP NOT NULL,
  cd_status_pedido INT NOT NULL,
  CD_CLIENTE BIGINT NOT NULL,
  PRIMARY KEY (CD_PEDIDO),
  FOREIGN KEY (CD_CLIENTE) REFERENCES ironhack.db_ecom.CLIENTE(CD_CLIENTE)
);

CREATE TABLE ironhack.db_ecom.LINHA_PEDIDO
(
  vl_desconto NUMERIC(7, 2) NOT NULL,
  nm_endereco_entrega TEXT NOT NULL,
  qt_item INT NOT NULL,
  CD_PEDIDO BIGINT NOT NULL,
  CD_SKU BIGINT NOT NULL,
  FOREIGN KEY (CD_PEDIDO) REFERENCES ironhack.db_ecom.PEDIDO(CD_PEDIDO),
  FOREIGN KEY (CD_SKU) REFERENCES ironhack.db_ecom.PRODUTO(CD_SKU)
);