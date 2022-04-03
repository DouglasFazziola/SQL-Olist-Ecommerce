<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="C:/Users/Douglas/Downloads/olist_ecommerce.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="3724"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,12:mainSELLER_STATS"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="olist_customers_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="188"/><column index="4" value="153"/><column index="5" value="121"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_geolocation_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="202"/><column index="2" value="121"/><column index="3" value="121"/><column index="4" value="124"/><column index="5" value="135"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_items_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="1" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="108"/><column index="3" value="231"/><column index="4" value="231"/><column index="5" value="142"/><column index="6" value="53"/><column index="7" value="104"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_payments_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="1" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="149"/><column index="3" value="112"/><column index="4" value="160"/><column index="5" value="117"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_reviews_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="105"/><column index="4" value="162"/><column index="5" value="300"/><column index="6" value="161"/><column index="7" value="193"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_orders_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="4" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="103"/><column index="4" value="197"/><column index="5" value="145"/><column index="6" value="211"/><column index="7" value="228"/><column index="8" value="224"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_products_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="297"/><column index="3" value="160"/><column index="4" value="197"/><column index="5" value="151"/><column index="6" value="136"/><column index="7" value="143"/><column index="8" value="143"/><column index="9" value="138"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_sellers_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="162"/><column index="3" value="240"/><column index="4" value="95"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="product_category_name_translation" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="297"/><column index="2" value="247"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1">/* Retorne uma tabela analítica de todos os itens que foram vendidos, mostrando somente pedidos interestaduais. 
Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não no prazo.
*/

SELECT
	ID.product_id PRODUTO,
	SD.seller_state AS ORIGEM,
	CD.customer_state AS DESTINO,
	CASE
		WHEN od.order_estimated_delivery_date &gt;= od.order_delivered_customer_date THEN 'NO PRAZO'
		WHEN OD.order_estimated_delivery_date &lt; od.order_delivered_customer_date THEN 'ATRASADO'
		END 'SITUACAO DA ENTREGA',
	round(julianday(OD.order_delivered_carrier_date) - julianday(OD.order_purchase_timestamp),0) AS 'DIAS PARA POSTAGEM'
FROM olist_order_items_dataset AS ID
INNER JOIN olist_sellers_dataset AS SD ON ID.seller_id = SD.seller_id
INNER JOIN olist_orders_dataset AS OD ON ID.ORDER_ID = OD.order_id
INNER JOIN olist_customers_dataset AS CD ON OD.customer_id = CD.customer_id
WHERE ORIGEM &lt;&gt; DESTINO 
AND OD.order_status = 'delivered'

/*
Retorne todos os pagamentos do cliente, com suas datas de aprovação, 
valor da compra e o valor total que o cliente já gastou em todas as suas compras, 
mostrando somente os clientes onde o valor da compra é diferente do valor total já gasto
*/

SELECT
	CD.customer_id AS Cliente,
	OD.order_approved_at AS 'Aprovacao do pagamento',
	id.price AS 'Valor da compra',
	sum(id.price) AS 'Valor total'
FROM olist_customers_dataset AS CD
INNER JOIN olist_orders_dataset AS OD ON CD.customer_id = OD.customer_id
INNER JOIN olist_order_items_dataset AS ID ON OD.order_id = ID.order_id
GROUP BY Cliente
HAVING id.price &lt;&gt; sum(id.price)

/*
Retorne as categorias válidas, suas somas totais dos valores de vendas, 
um ranqueamento de maior valor para menor valor junto com o somatório 
acumulado dos valores pela mesma regra do ranqueamento.
*/

SELECT CATEGORIA
		, VENDA_TOTAL
		, SUM (VENDA_TOTAL) OVER ()AS ACUMULADO
		, RANK (*) OVER (ORDER BY VENDA_TOTAL DESC) AS POSICAO

 FROM 
 (
 SELECT P.product_category_name			AS CATEGORIA
		, PG.payment_value				AS VENDA
		, SUM(PG.payment_value)			AS VENDA_TOTAL
 FROM olist_products_dataset P
 INNER JOIN olist_order_items_dataset I ON I.product_id = P.product_id 
 INNER JOIN olist_order_payments_dataset PG ON PG.order_id = I.order_id
 INNER JOIN olist_orders_dataset O ON O.order_id = PG.order_id
 WHERE P.product_category_name is NOT NULL
 GROUP BY CATEGORIA
 
) AS VENDAS_ACUMULADAS</sql><current_tab id="0"/></tab_sql></sqlb_project>
