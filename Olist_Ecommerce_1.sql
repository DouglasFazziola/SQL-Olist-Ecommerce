<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="C:/Users/Douglas/Downloads/olist_ecommerce.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="3724"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,12:mainSELLER_STATS"/><default_encoding codec=""/><browse_table_settings/></tab_browse><tab_sql><sql name="SQL 1">/*
Retorne a quantidade de itens vendidos em cada categoria por estado em que o 
cliente se encontra, mostrando somente categorias que tenham vendido uma quantidade de items acima de 1000.
*/

SELECT
	count(pd.product_id) as quantidade,
	coalesce(pd.product_category_name,'indefinida') as categoria,
	cd.customer_state as estado
FROM olist_products_dataset as pd
INNER JOIN olist_order_items_dataset as id on pd.product_id = id.product_id
INNER JOIN olist_orders_dataset as od on id.order_id = od.order_id
INNER JOIN olist_customers_dataset as cd on od.customer_id = cd.customer_id
GROUP BY categoria, estado
HAVING quantidade &gt; 1000


/*
Mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras, 
qual foi o valor total de todas as compras deles, quantidade de compras, e valor médio gasto por compras. 
Ordene os mesmos por ordem decrescente pela média do valor de compra.
*/

SELECT
	clientes,
	total_compras,
	quantidade_compras,
	media
FROM(
	SELECT
		OD.customer_id AS clientes,
		SUM(PD.payment_value) AS total_compras,
		count(customer_id) AS quantidade_compras,
		AVG(PD.payment_value) AS Media
	FROM
		olist_orders_dataset AS OD
	INNER JOIN
		olist_order_payments_dataset AS PD ON OD.order_id = PD.order_id
	GROUP BY Clientes)
ORDER BY Media DESC
LIMIT 5

/*
Mostre o valor vendido total de cada vendedor (seller_id) em cada uma das categorias de produtos, 
somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000. 
Desejamos ver a categoria do produto e os vendedores. Para cada uma dessas categorias, 
mostre seus valores de venda de forma decrescente.
*/

SELECT
	SD.seller_id AS Vendedor,
	SUM(ID.price) AS 'Valor vendido',
	coalesce(PD.product_category_name,'indefinida') AS Categoria
FROM olist_sellers_dataset AS SD
INNER JOIN olist_order_items_dataset AS ID ON SD.seller_id = ID.seller_id
INNER JOIN olist_products_dataset AS PD ON ID.product_id = PD.product_id
GROUP BY categoria, vendedor
HAVING SUM(ID.price) &gt; 1000
ORDER by categoria ASC, SUM(ID.price) DESC</sql><current_tab id="0"/></tab_sql></sqlb_project>
