DROP SCHEMA IF EXISTS olist_db CASCADE;
CREATE SCHEMA olist_db;
-- CARREGAR TABELA PRODUCTS
DROP TABLE IF EXISTS ironhack.olist_db.olist_products_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_products_dataset (
	product_id VARCHAR PRIMARY KEY,
	product_category_name VARCHAR,
	product_name_length INTEGER,
	product_description_length VARCHAR,
	product_photos_qty INTEGER,
	product_weight_g NUMERIC,
	product_length_cm NUMERIC,
	product_height_cm NUMERIC,
	product_width_cm NUMERIC
);

COPY ironhack.olist_db.olist_products_dataset
FROM 'C:\olist_products_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA GEOLOCATION
DROP TABLE IF EXISTS ironhack.olist_db.temp_olist_geolocation_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.temp_olist_geolocation_dataset (
	geolocation_zip_code_prefix NUMERIC,
	geolocation_lat NUMERIC,
	geolocation_lng NUMERIC,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR
);

COPY ironhack.olist_db.temp_olist_geolocation_dataset
FROM 'C:\olist_geolocation_dataset.csv' 
HEADER DELIMITER ',' CSV;

DROP TABLE IF EXISTS ironhack.olist_db.olist_geolocation_dataset CASCADE; 
CREATE TABLE ironhack.olist_db.olist_geolocation_dataset AS
	(
		WITH non_dup AS (
		    SELECT 
		    	p.geolocation_zip_code_prefix, 
		        p.geolocation_lat, 
		        p.geolocation_lng,
		        p.geolocation_city,
		        p,geolocation_state,
		        ROW_NUMBER() OVER(PARTITION BY p.geolocation_zip_code_prefix
		        				  ORDER BY p.geolocation_zip_code_prefix DESC) AS rank
		      FROM ironhack.olist_db.temp_olist_geolocation_dataset AS p)
		SELECT 
			*
		FROM 
			non_dup
		WHERE 
			rank = 1
	);

ALTER TABLE ironhack.olist_db.olist_geolocation_dataset ADD PRIMARY KEY (geolocation_zip_code_prefix);
DROP TABLE IF EXISTS ironhack.olist_db.temp_olist_geolocation_dataset CASCADE; 
-- CARREGAR TABELA SELLERS
DROP TABLE IF EXISTS ironhack.olist_db.olist_sellers_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_sellers_dataset (
	seller_id VARCHAR PRIMARY KEY,
	seller_zip_code_prefix NUMERIC,
	seller_city VARCHAR,
	seller_state VARCHAR
);

COPY ironhack.olist_db.olist_sellers_dataset
FROM 'C:\olist_sellers_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA CUSTOMERS
DROP TABLE IF EXISTS ironhack.olist_db.olist_customers_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_customers_dataset (
	customer_id VARCHAR PRIMARY KEY,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix NUMERIC,
	customer_city VARCHAR,
	customer_state VARCHAR
);

COPY ironhack.olist_db.olist_customers_dataset
FROM 'C:\olist_customers_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA ORDERS
DROP TABLE IF EXISTS ironhack.olist_db.olist_orders_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_orders_dataset (
	order_id VARCHAR PRIMARY KEY,
	customer_id VARCHAR REFERENCES ironhack.olist_db.olist_customers_dataset(customer_id),
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP,
	UNIQUE(order_id, customer_id)
);

COPY ironhack.olist_db.olist_orders_dataset
FROM 'C:\olist_orders_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA ORDERS_ITEMS
DROP TABLE IF EXISTS ironhack.olist_db.olist_order_items_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_order_items_dataset (
	order_id VARCHAR REFERENCES ironhack.olist_db.olist_orders_dataset(order_id),
	order_item_id VARCHAR,
	product_id VARCHAR REFERENCES ironhack.olist_db.olist_products_dataset(product_id),
	seller_id VARCHAR  REFERENCES ironhack.olist_db.olist_sellers_dataset(seller_id),
	shipping_limit_date TIMESTAMP,
	price NUMERIC,
	freight_value NUMERIC,
	PRIMARY KEY(order_id, order_item_id, product_id, seller_id)
);

COPY ironhack.olist_db.olist_order_items_dataset
FROM 'C:\olist_order_items_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA ORDERS_PAYMENTS
DROP TABLE IF EXISTS ironhack.olist_db.olist_order_payments_dataset CASCADE; 

CREATE TABLE ironhack.olist_db.olist_order_payments_dataset (
	order_id VARCHAR REFERENCES ironhack.olist_db.olist_orders_dataset(order_id),
	payment_sequential NUMERIC,
	payment_type VARCHAR,
	payment_installments NUMERIC,
	payment_value NUMERIC,
	PRIMARY KEY(order_id, payment_sequential)
);

COPY ironhack.olist_db.olist_order_payments_dataset
FROM 'C:\olist_order_payments_dataset.csv' 
HEADER DELIMITER ',' CSV;

-- CARREGAR TABELA olist_order_reviews_dataset
DROP TABLE IF EXISTS ironhack.olist_db.olist_order_reviews_dataset CASCADE; 
	
CREATE TABLE ironhack.olist_db.olist_order_reviews_dataset (
	review_id VARCHAR,
	order_id VARCHAR REFERENCES ironhack.olist_db.olist_orders_dataset(order_id),
	review_score NUMERIC,
	review_comment_title VARCHAR,
	review_comment_message VARCHAR,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP,
	PRIMARY KEY(review_id, order_id)
);

COPY ironhack.olist_db.olist_order_reviews_dataset
FROM 'C:\olist_order_reviews_dataset.csv' 
HEADER DELIMITER ',' CSV;
