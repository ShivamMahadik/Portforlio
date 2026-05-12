-- Rank products and customers based on revenue and quantity sold
WITH product_revenue AS (
    SELECT
        stock_code,
        MIN(description) AS product_name,
        round(SUM(total_price)::NUMERIC, 2) AS total_revenue,
        SUM(quantity) AS total_qty_sold
    FROM clean_retail
    GROUP BY stock_code
)
SELECT
    stock_code,
    product_name,
    total_revenue,
    total_qty_sold,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank
LIMIT 10;



--Top 3 products by revenue for each country

WITH product_country_revenue AS (
    SELECT
		country,
        stock_code,
        MIN(description) AS product_name,
        round(SUM(total_price)::NUMERIC, 2) AS total_revenue,
        SUM(quantity) AS total_qty_sold
    FROM clean_retail
    GROUP BY country, stock_code
),
ranked as (
	select
		country,
		stock_code,
		product_name,
		total_revenue,
		row_number() over (
			partition by country
			order by total_revenue desc
		) as rn
	from product_country_revenue
)

select 
country,
stock_code,
product_name,
total_revenue
from ranked
where rn<=3
order by country, rn;


-- Finding the top 20 customer by the amount spent
with customer_spend as
(
	select
		customer_id,
		round(sum(total_price)::numeric, 2) as total_spend,
		count(distinct invoice_no) as num_orders,
		min(invoice_date) as first_purchase,
		max(invoice_date) as last_purchase
	from clean_retail
	group by customer_id
)

select 
	customer_id,
	total_spend,
	num_orders,
	rank() over (order by total_spend desc) as spend_rank,
	ntile(4) over (order by total_spend) as spend_quartile
from customer_spend
order by spend_rank	
limit 20;