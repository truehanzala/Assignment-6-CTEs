



-- Question    1   



WITH store_counts AS
(
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;






-- Question    2





WITH cte_high_value_products AS
(
    SELECT
        product_id,
        product_name,
        category_id,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT
    p.product_id,
    p.product_name,
    p.list_price,
    c.category_name
FROM cte_high_value_products AS p
JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';





-- Question  3





WITH order_counts AS
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM order_counts AS oc
JOIN customer_revenue AS cr
    ON oc.customer_id = cr.customer_id;







-- Question   4







WITH numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT
    n,
    n * n AS square
FROM numbers
OPTION (MAXRECURSION 10);








--  Question    5







WITH org_chart AS
(
    SELECT
        staff_id,
        first_name,
        manager_id,
        first_name AS manager_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        o.first_name AS manager_name,
        o.level + 1
    FROM sales.staffs AS s
    JOIN org_chart AS o
        ON s.manager_id = o.staff_id
)
SELECT
    staff_id,
    first_name,
    manager_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);







--  Question    6






SELECT
    customer_id,
    COUNT(*) AS order_count
INTO #CustomerOrders
FROM sales.orders
GROUP BY customer_id;

SELECT *
FROM #CustomerOrders;

SELECT *
FROM #CustomerOrders
WHERE order_count > 5;

DROP TABLE #CustomerOrders;