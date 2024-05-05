

/* 1. Product Sales

You need to create a report on whether customers who purchased 
the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

*/


SELECT
    c.Customer_Id,
    c.First_Name,
    c.Last_Name,

    CASE
        WHEN EXISTS (
            SELECT 1
            FROM sale.orders o1
            JOIN sale.order_item oi1 ON o1.order_id = oi1.order_id
            JOIN product.product p1 ON oi1.product_id = p1.product_id
            WHERE c.Customer_Id = o1.customer_id
            AND p1.product_name = 'Polk Audio - 50 W Woofer - Black'
        ) THEN 'Yes'
        ELSE 'No'
    END AS Other_Product
FROM
    sale.orders o
    JOIN sale.order_item oi ON o.order_id = oi.order_id
    JOIN product.product p ON oi.product_id = p.product_id
    JOIN sale.customer c ON o.customer_id = c.customer_id
WHERE
    p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';






/*2. Conversion Rate

Below you see a table of the actions of customers 
visiting the website by clicking on two different types of advertisements given by an E-Commerce company.

Write a query to return the conversion rate for each Advertisement type.
*/




CREATE TABLE Actions (
    Visitor_ID INT,
    Adv_Type CHAR(1),
    Action VARCHAR(10)
);


INSERT INTO Actions (Visitor_ID, Adv_Type, Action)
VALUES
    (1, 'A', 'Left'),
    (2, 'A', 'Order'),
    (3, 'B', 'Left'),
    (4, 'A', 'Order'),
    (5, 'A', 'Review'),
    (6, 'A', 'Left'),
    (7, 'B', 'Left'),
    (8, 'B', 'Order'),
    (9, 'B', 'Review'),
    (10, 'A', 'Review');






	SELECT 
    Adv_Type,
    COUNT(*) AS Total_Actions,
    SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Total_Orders
FROM 
    Actions
GROUP BY 
    Adv_Type;






	SELECT 
    Adv_Type,
    CAST(SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS Conversion_Rate
FROM 
    Actions
GROUP BY 
    Adv_Type;
