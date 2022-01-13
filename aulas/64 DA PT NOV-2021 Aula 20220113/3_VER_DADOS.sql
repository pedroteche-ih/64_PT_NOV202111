SELECT * FROM cliente;

SELECT * FROM produto;

SELECT * FROM pedido;

SELECT * FROM linha_pedido;

SELECT
	t1.cd_sku,
	t1.nm_produto,
	SUM(t2.qt_item) AS qt_itens_vendidos,
	SUM(t2.qt_item * t1.vl_produto) AS vl_produto_total,
	SUM(t2.vl_desconto) AS vl_desconto
FROM
	ironhack.db_ecom.produto AS t1 JOIN
	ironhack.db_ecom.linha_pedido AS t2 ON (t1.cd_sku = t2.cd_sku)
GROUP BY 
	t1.cd_sku,
	t1.nm_produto;