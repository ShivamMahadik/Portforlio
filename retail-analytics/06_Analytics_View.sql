CREATE OR REPLACE VIEW customer_360 AS
with order_metrics as
(select 
	customer_id,
	min(date_trunc('month', invoice_date)) over ( partition by customer_id) as cohort_month,
	sum(total_price) as total_lifetime_spend,
	avg(total_price) as avg_order_value,
	max(invoice_date) as last_purchase_date,
	count(distinct invoice_no) as num_distinct_orders
from clean_retail
group by customer_id, invoice_date, total_price, invoice_no
),
customer_summary as (
	select
		customer_id,
		min(cohort_month) as cohort_month,
		sum(total_lifetime_spend) as total_lifetime_spend,
		avg(avg_order_value) as avg_order_value,
		max(last_purchase_date) as last_purchase_date,
		sum(num_distinct_orders) as num_distinct_orders
	from order_metrics
	group by customer_id
),

rfc_calculations AS(
SELECT
        customer_id,
        cohort_month,
        total_lifetime_spend,
        avg_order_value,
        num_distinct_orders,
        (SELECT MAX(last_purchase_date) FROM customer_summary) - last_purchase_date AS recency_days,
        NTILE(5) OVER (ORDER BY (SELECT MAX(last_purchase_date) FROM customer_summary) - last_purchase_date DESC) as r_score,
        NTILE(5) OVER (ORDER BY num_distinct_orders ASC) as f_score,
        NTILE(5) OVER (ORDER BY total_lifetime_spend ASC) as m_score
    FROM customer_summary
)


-- 4. Final selection with segment labeling
SELECT
    customer_id,
    cohort_month,
    total_lifetime_spend,
    avg_order_value,
    num_distinct_orders,
    recency_days,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal'
        WHEN r_score >= 3 AND f_score < 3 THEN 'Recent Customers'
        WHEN r_score < 3 AND f_score >= 3 THEN 'At Risk'
        ELSE 'Inactive'
    END AS rfm_segment
FROM rfc_calculations;





SELECT * FROM customer_360 ORDER BY total_lifetime_spend DESC LIMIT 20;