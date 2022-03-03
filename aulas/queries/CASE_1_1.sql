DROP TABLE IF EXISTS ironhack.olist_db.case_1;
CREATE TABLE ironhack.olist_db.case_1 AS
(
SELECT
	ooid.order_id,
	ooid.product_id,
	ooid.seller_id,
	ooid.price,
	ooid.freight_value,
	ood.order_purchase_timestamp,
	date_part('YEAR', ood.order_approved_at) * 100 + date_part('MONTH', ood.order_approved_at) AS anomes_faturado,
	opd.product_category_name,
	opd.product_weight_g,
	ocd.customer_city,
	ocd.customer_state,
	osd.seller_city,
	osd.seller_state,
	tb_review.review_score,
	tb_atraso.status_atraso
FROM
	ironhack.olist_db.olist_order_items_dataset ooid JOIN
	ironhack.olist_db.olist_orders_dataset ood ON (ooid.order_id = ood.order_id) JOIN 
	ironhack.olist_db.olist_products_dataset opd ON (ooid.product_id = opd.product_id) JOIN 
	ironhack.olist_db.olist_customers_dataset ocd ON (ood.customer_id = ocd.customer_id) JOIN 
	ironhack.olist_db.olist_sellers_dataset osd ON (osd.seller_id = ooid.seller_id) LEFT JOIN 
	(
	SELECT
		T1.order_id,
		AVG(T1.review_score) AS review_score
	FROM
		ironhack.olist_db.olist_order_reviews_dataset T1
	GROUP BY
		T1.order_id
	) AS tb_review ON (tb_review.order_id = ood.order_id) JOIN 
	(
	SELECT
		ood.order_id,
		ood.order_estimated_delivery_date AS data_estimada,
		ood.order_delivered_customer_date AS data_entregue,
		date_part('DAYS', ood.order_delivered_customer_date - ood.order_estimated_delivery_date) AS dias_atraso,
		CASE
			WHEN date_part('DAYS', ood.order_delivered_customer_date - ood.order_estimated_delivery_date) > 0 THEN 'ATRASADO'
			WHEN date_part('DAYS', ood.order_delivered_customer_date - ood.order_estimated_delivery_date) <= 0 THEN 'ONTIME'
			ELSE 'NAO ENTREGUE' END AS status_atraso
	FROM
		ironhack.olist_db.olist_orders_dataset ood
	) AS tb_atraso ON (tb_atraso.order_id = ood.order_id)
WHERE 
	ood.order_status = 'delivered'
);