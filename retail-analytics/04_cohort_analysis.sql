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
),

-- Calculate the number of months between the cohort month and the order month for each transaction
cohort_age as (
    select 
    customer_id,
    cohort_month,
    order_month,
    (date_part('year', order_month) - date_part('year', cohort_month)) * 12 + (date_part('month', order_month) - date_part('month', cohort_month)) as cohort_age
    from customer_cohort
),

--Count distinct customers per cohort per age

cohort_count as (
    select 
    cohort_month,
    cohort_age,
    count(distinct customer_id) as num_customers
    from cohort_age
    group by cohort_month, cohort_age
),

-- Get cohort starting size (age = 0)

cohort_size as (
    select 
        cohort_month,
        num_customers as cohort_size
    from cohort_count
    where cohort_age = 0
)

--calculate the retention percentage

select 
    c.cohort_month,
    s.cohort_size,
    c.cohort_age,
    c.num_customers,
    round(c.num_customers::numeric/ s.cohort_size * 100, 2) as retention_pct
from cohort_count c 
join cohort_size s ON c.cohort_month = s.cohort_month
where c.cohort_age <=12
order by c.cohort_month, c.cohort_age;