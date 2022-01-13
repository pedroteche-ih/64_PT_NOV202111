-- Povoar tabela clientes

INSERT INTO ironhack.db_ecom.cliente
VALUES (DEFAULT, 'Pedro Teche de Lima', 'Al. dos Flamboyants 1637', 33836252813);

INSERT INTO ironhack.db_ecom.cliente
VALUES (DEFAULT, 'Adriano', '???', 1111111);

INSERT INTO ironhack.db_ecom.produto 
VALUES (331, 'Monitor LG 15', 'LG', 983.99);

INSERT INTO ironhack.db_ecom.pedido 
VALUES (DEFAULT, '20220111 19:27:12 +3', '20220113 19:27:12 +3', 1, 1);

INSERT INTO ironhack.db_ecom.linha_pedido
VALUES (99.99, 'Al. dos Jequitibas, 1384', 1, 1, 331);


INSERT INTO ironhack.db_ecom.cliente
VALUES 
	(DEFAULT, 'João', '???', 1111111),
	(DEFAULT, 'Maria', '???', 1111111),
	(DEFAULT, 'José', '???', 1111111);

INSERT INTO ironhack.db_ecom.produto
VALUES 
	(332, 'Monitor LG 17', 'LG', 983.99),
	(15543, 'Teclado Logitech K400+', 'Logitech', 149.99),
	(1863, 'Cabo HDMI 4m', 'Generic', 39.99),
	(333, 'Monitor Sony 15', 'Sony', 1483.99),
	(334, 'Monitor Sony 17', 'Sony', 1983.99);

INSERT INTO ironhack.db_ecom.pedido 
VALUES 
	(DEFAULT, '20220110 19:27:12 +3', '20220110 19:27:12 +3', 1, 1),
	(DEFAULT, '20220106 19:27:12 +3', '20220106 19:27:12 +3', 1, 2),
	(DEFAULT, '20220103 19:27:12 +3', '20220103 19:27:12 +3', 1, 4);

INSERT INTO ironhack.db_ecom.linha_pedido
VALUES
	(0, '????', 2, 2, 1863),
	(0, '????', 1, 2, 332),
	(0, '????', 1, 3, 15543),
	(0, '????', 3, 3, 1863),
	(0, '????', 1, 3, 332),
	(0, '????', 1, 4, 331);
	
