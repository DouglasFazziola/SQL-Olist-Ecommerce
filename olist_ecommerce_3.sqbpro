<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="C:/Users/Douglas/Downloads/olist_ecommerce.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="1715"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,12:mainSELLER_STATS"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="olist_customers_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="188"/><column index="4" value="153"/><column index="5" value="121"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_geolocation_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="202"/><column index="2" value="121"/><column index="3" value="121"/><column index="4" value="124"/><column index="5" value="135"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_items_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="1" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="108"/><column index="3" value="231"/><column index="4" value="231"/><column index="5" value="142"/><column index="6" value="53"/><column index="7" value="104"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_payments_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="1" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="149"/><column index="3" value="112"/><column index="4" value="160"/><column index="5" value="117"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_order_reviews_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="105"/><column index="4" value="162"/><column index="5" value="300"/><column index="6" value="161"/><column index="7" value="193"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_orders_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort><column index="4" mode="0"/></sort><column_widths><column index="1" value="231"/><column index="2" value="231"/><column index="3" value="103"/><column index="4" value="197"/><column index="5" value="145"/><column index="6" value="211"/><column index="7" value="228"/><column index="8" value="224"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_products_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="297"/><column index="3" value="160"/><column index="4" value="197"/><column index="5" value="151"/><column index="6" value="136"/><column index="7" value="143"/><column index="8" value="143"/><column index="9" value="138"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="olist_sellers_dataset" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="231"/><column index="2" value="162"/><column index="3" value="240"/><column index="4" value="95"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="product_category_name_translation" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="297"/><column index="2" value="247"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1">/*EXERCICIO 1
Crie uma view (SELLER_STATS) para mostrar por fornecedor, a quantidade de itens enviados, 
o tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor.
*/
CREATE VIEW SELLER_STATS AS 
SELECT
	ID.seller_id Fornecedor,
	count(*) Pedidos_enviados,
	count(DISTINCT id.order_id) Total_Pedidos,
	coalesce(
		Round(
			avg(
				julianday (OD.order_delivered_carrier_date) - julianday (OD.order_approved_at)),1),'indeterminado') Tempo_Medio
FROM
	olist_order_items_dataset AS ID
INNER JOIN
	olist_orders_dataset AS OD ON ID.order_id = OD.order_id
GROUP BY Fornecedor

/* Queremos dar um cupom de 10% do valor da última compra do cliente. 
Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última 
(a partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última compra. 
Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis.*/

SELECT
	CLIENTE,
	sum(case when APROV=1 then COMPRA else 0 end) as ultimo,
	sum(case when APROV=2 then COMPRA else 0 end) as penultimo,
	(sum(case when APROV=1 then COMPRA else 0 end) * 0.10) AS DESCONTO
FROM(
	SELECT
		CD.customer_unique_id AS CLIENTE,
		ROW_NUMBER() OVER(PARTITION BY CD.customer_unique_id ORDER BY OD.order_approved_at) AS APROV,
		PD.payment_value AS COMPRA
	FROM olist_customers_dataset AS CD
	INNER JOIN olist_orders_dataset AS OD ON CD.customer_id = OD.customer_id
	INNER JOIN olist_order_payments_dataset as PD ON OD.order_id = PD.order_id
	WHERE order_approved_at IS NOT NULL)
GROUP BY CLIENTE
HAVING PENULTIMO &gt;= ULTIMO
</sql><current_tab id="0"/></tab_sql></sqlb_project>
