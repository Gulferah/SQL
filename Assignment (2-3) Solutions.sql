


---Session 9 

----Assignment-2       39:00


/* 1. Product Sales

You need to create a report on whether customers who purchased 
the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

Birinci ürünü almislar ama 2 ci ürün satin almislarmi diye rapor hazirliycaz.

Трябва да създадете отчет за това дали клиентите, които са закупили 
продукт с име „2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD“, са закупили друг продукта по-долу или не.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

*/


--1. Product sales

 CREATE VIEW V_PRODUCT_1 AS									 -- view hazirlik tablo 1
 SELECT DISTINCT d.customer_id, d.first_name, d.last_name    --id ler üzerinden yapmaya bak, diger sütünlar unique net olmayabilir
 FROM	product.product AS A
		INNER JOIN 
		sale.order_item AS B
		ON A.product_id = B.product_id
		INNER JOIN
		sale.orders AS C
		ON B.order_id = C.order_id
		INNER JOIN
		sale.customer AS D
		ON C.customer_id = D.customer_id
WHERE	A.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 



																	-- view hazirlik tablo 2
 CREATE VIEW V_PRODUCT_2 AS											--yukarikisinden farkli müsteriler
 SELECT DISTINCT d.customer_id, d.first_name, d.last_name
 FROM	product.product AS A
		INNER JOIN 
		sale.order_item AS B
		ON A.product_id = B.product_id
		INNER JOIN
		sale.orders AS C
		ON B.order_id = C.order_id
		INNER JOIN
		sale.customer AS D
		ON C.customer_id = D.customer_id
WHERE	product_name = 'Polk Audio - 50 W Woofer - Black'



SELECT	A.*, CASE WHEN B.customer_id IS NULL THEN 'NO' ELSE 'YES' END other_product_is_purchased    --ana tablomuz, result veren
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id
ORDER BY other_product_is_purchased

---------------------------------------------------------------------------------------------

SELECT	A.*, 
		B.first_name,
		ISNULL(B.first_name, 'NO'),
		NULLIF(ISNULL(B.first_name, 'NO'), A.first_name),
		ISNULL(NULLIF(ISNULL(B.first_name, 'NO'), A.first_name), 'YES') other_product
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id

------------------------------------------------------------------------------------------

SELECT	A.*, 
		ISNULL(NULLIF(ISNULL(B.first_name, 'NO'), A.first_name), 'YES') other_product
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id




--------------------------------------------------------------------------------------------------------


SELECT	A.*, CASE WHEN B.customer_id IS NULL THEN 'NO' ELSE 'YES' END other_product_is_purchased
FROM	( 
			SELECT DISTINCT d.customer_id, d.first_name, d.last_name
			 FROM	product.product AS A
					INNER JOIN 
					sale.order_item AS B
					ON A.product_id = B.product_id
					INNER JOIN
					sale.orders AS C
					ON B.order_id = C.order_id
					INNER JOIN
					sale.customer AS D
					ON C.customer_id = D.customer_id
			WHERE	A.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 
		) AS A
		LEFT JOIN
		(
		 SELECT DISTINCT d.customer_id, d.first_name, d.last_name
		 FROM	product.product AS A
				INNER JOIN 
				sale.order_item AS B
				ON A.product_id = B.product_id
				INNER JOIN
				sale.orders AS C
				ON B.order_id = C.order_id
				INNER JOIN
				sale.customer AS D
				ON C.customer_id = D.customer_id
		WHERE	product_name = 'Polk Audio - 50 W Woofer - Black'
		) AS B
		ON	A.customer_id = B.customer_id
ORDER BY other_product_is_purchased


------------------------------------------

  CASE                                      --damla
        WHEN EXISTS (
            SELECT 1
            FROM sale.orders AS Ord
            INNER JOIN sale.order_item AS It 
                ON It.order_id = Ord.order_id
            INNER JOIN product.product AS Prod 
                ON Prod.product_id = It.product_id
            WHERE Ord.customer_id = Cu.customer_id
            AND Prod.product_name = 'Polk Audio - 50 W Woofer - Black'
        )
        THEN 'Yes'
        ELSE 'No'
    END AS Other_Product


	-- 9/1,15
/*2. Conversion Rate  dönüsüm orani, attigimiz tas, ürküttügümüz kurbaga degiyor mu?
-- firmalar farkli sekillerde reklam yapiyorlar, ve bir kar bekliyorlar. Harcadiklari ve bekledikleri karin arasindaki farktir aslinda
-- Herhangi bir reklam türünden gelen müsteriler nasil hareket etmis?

Below you see a table of the actions of customers 
visiting the website by clicking on two different types of advertisements given by an E-Commerce company.

Write a query to return the conversion rate for each Advertisement type.
*/

CREATE TABLE advertisement --reklama
(
visitor_id INT ,
adv_type CHAR(1),
action_type varchar(15)

)

INSERT advertisement 
VALUES			(1,'A', 'Left'),
				(2,'A', 'Order'),   -- siparis vermis
				(3,'B', 'Left'),    --cikmis
				(4,'A', 'Order'),
				(5,'A', 'Review'),
				(6,'A', 'Left'),
				(7,'B', 'Left'),
				(8,'B', 'Order'),
				(9,'B', 'Review'),   --sadece bakmis
				(10,'A', 'Review')






SELECT	adv_type, 
		COUNT(visitor_id) total_visitor,
		SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) cnt_order,
		CAST (1.0* SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) / COUNT(visitor_id) AS decimal(3,2)) AS conversion_rate
FROM	advertisement
GROUP BY adv_type




WITH T1 AS (
			SELECT	adv_type, 
					COUNT(visitor_id) total_visitor,
					SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) cnt_order
			FROM	advertisement
			GROUP BY adv_type
			)
SELECT adv_type, CAST (1.0* cnt_order / total_visitor AS decimal(3,2)) AS conversion_rate
FROM T1











