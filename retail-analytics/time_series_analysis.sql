-- Analyzes revenue trends using window functions
-- This query calculates monthly revenue, the number of customers, and the number of invoices for each month.

with monthly_revenue as (
   select
    date_trunc('month', invoice_date) as month,
    round(sum(total_price)::numeric, 2) as revenue,
    count(distinct customer_id) as number_of_customers,
    count(distinct invoice_no) as number_of_invoices
   from clean_retail
group by date_trunc('month', invoice_date)
)

select 
month,
revenue,
number_of_customers,
number_of_invoices,
sum(revenue) over (
    order by month
    rows between unbounded preceding and current row
) as running_total,
round(
    avg(revenue) over (
        order by month
        rows between 2 preceding and current row
    ),
) as moving_average_3m
from monthly_revenue
order by month;


-- Month-over-month revenue growth percentage

with monthly_revenue as (
   select
    date_trunc('month', invoice_date) as month,
    round(sum(total_price)::numeric, 2) as revenue
   from clean_retail
group by date_trunc('month', invoice_date)
)

select 
    month,
    revenue,
    LAG(revenue, 1) over (order by month) as prev_month_revenue,
    round((revenue - LAG(revenue,1) over (order by month))
    / LAG(revenue,1) over (order by month) * 100,
    2) as month_growth_percentage
from monthly_revenue
order by month;


-- Country contribution to total revenue (part-to-whole analysis)

with country_revenue as (
    select 
        country,
        round(sum(total_price)::numeric, 2) as revenue
    from clean_retail
    group by country
)

select 
     country,
     revenue,
     sum(revenue) over () as total_revenue,
     round(
        revenue / sum(revenue) over () * 100, 
        2) as percentage_of_total
from country_revenue
order by revenue desc
limit 15;


