-- First step of cohort analysis is to find the cohort month of each customer ( first month of purchase)

with customer_cohort as (
	select
		customer_id,
		invoice_date,
		date_trunc('month',invoice_date) as order_month,
		min(date_trunc('month',invoice_date)) over (
			partition by customer_id
		) as cohort_month
	from clean_retail
);