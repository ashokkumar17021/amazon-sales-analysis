--Amazon_SQL_questions

-- 1) what are the total sales made by each customer?

SELECT
		customer_id,
		sum(sale) as total_sales
FROM orders
GROUP BY 1
ORDER BY 1;

--2). How many orders were placed in each state?

SELECT
		state,
		count(1) as total_orders
FROM orders
WHERE state IS NOT NULL
GROUP BY 1;

-- 3) How many unique prodcuts were sold?

SELECT
		COUNT(DISTINCT product_id) AS total_unique_product
FROM orders;

-- 4) How many returns were made for each product category?

select 
		o.category,
		count(r.return_id) as no_of_returns
FROM orders o
LEFT JOIN
returns r
ON o.order_id = r.order_id
WHERE o.category IS NOT NULL
GROUP BY 1;

-- 5) How many orders were placed each month(2022)?

SELECT
		EXTRACT(MONTH FROM order_date) as month,
		COUNT(order_id) as total_orders
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2022
GROUP BY 1;


--Q6.Determine the top 5 products whose revenue has decreased compared to the previous year.
select * from orders

WITH cte AS
( 
	SELECT
			product_id,
			sum(sale) AS last_year
	FROM orders
	where EXTRACT(YEAR FROM order_date) = 2022
GROUP BY 1
),
cte2 AS
(
	SELECT
			product_id,
			sum(sale) AS curr_year
	FROM orders
	where EXTRACT(YEAR FROM order_date) = 2023
GROUP BY 1
)
SELECT
	c1.product_id,
	c1.last_year,
	c2.curr_year,
	 abs(((c1.last_year - c2.curr_year) / c1.last_year) * 100) AS rev_decrease
	FROM cte c1 
JOIN
cte2 c2 
ON C1.product_id = c2.product_id
WHERE c2.curr_year<c1.last_year
ORDER BY rev_decrease DESC
LIMIT 5;

--7). List all orders where the quantity sold is greater than the average quantity sold across all orders.

SELECT
		*
FROM orders
where quantity >(select avg(quantity) from orders)
ORDER BY quantity;

--8).  Find out the top 5 customers who made the highest profits.

SELECT 
    o.customer_id, 
    SUM((o.price_per_unit - p.cogs) * o.quantity) AS total_profit
FROM 
    orders AS o
LEFT JOIN 
    products AS p ON o.product_id = p.product_id
GROUP BY 
    o.customer_id
ORDER BY 
    total_profit DESC
LIMIT 5;

--9). Find the details of the top 5 products with the highest total sales, where the total sale for each product is greater than the average sale across all products.
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(o.sale) AS total_sales
FROM 
    orders o
JOIN 
    products p ON o.product_id = p.product_id
GROUP BY 
    p.product_id, 
    p.product_name
HAVING 
    SUM(o.sale) > (SELECT SUM(sale) / COUNT(DISTINCT product_id) FROM orders)
ORDER BY 
    total_sales DESC
LIMIT 5;

--10). Calculate the profit margin percentage for each sale
SELECT 
    order_id,
   ABS(((SUM(o.price_per_unit - p.cogs) * o.quantity) / SUM(o.sale))) * 100 AS profit_margin_percentage
FROM 
    orders AS o
LEFT JOIN 
    products AS p ON o.product_id = p.product_id
GROUP BY 
    order_id;



		
