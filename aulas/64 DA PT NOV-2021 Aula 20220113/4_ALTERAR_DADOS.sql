INSERT INTO ironhack.db_ecom.cliente
VALUES (DEFAULT, 'Pedro Teche de Lima', 'Al. dos Flamboyants 1637', 33836252813);

SELECT * FROM ironhack.db_ecom.cliente WHERE cd_documento = 33836252813;

DELETE FROM ironhack.db_ecom.cliente WHERE cd_cliente = 6;

SELECT * FROM ironhack.db_ecom.cliente;

DELETE FROM ironhack.db_ecom.produto WHERE nm_marca = 'Sony';

SELECT * FROM ironhack.db_ecom.produto;

UPDATE ironhack.db_ecom.pedido SET cd_status_pedido = 0 WHERE cd_pedido = 3;

SELECT * FROM ironhack.db_ecom.pedido;

UPDATE ironhack.db_ecom.produto SET nm_marca = 'LG Ind.' WHERE nm_marca = 'LG';

SELECT * FROM ironhack.db_ecom.produto;

DROP TABLE ironhack.db_ecom.linha_pedido;

SELECT * FROM ironhack.db_ecom.linha_pedido;

DROP TABLE ironhack.db_ecom.cliente CASCADE;

SELECT * FROM ironhack.db_ecom.cliente;

DROP SCHEMA ironhack.db_ecom CASCADE;