SELECT 
    count(*) as total_records,
    count(*) filter (where invoice_no like 'C%') as cancellations,
    count(*) filter (where customer_id is null) as null_customers,
    count(*) filter (where quantity <=0) as zero_or_negetive_qty,
    count(*) filter (where price <=0) as zero_or_negetive_price
FROM
raw_data;

create or replace view clean_retail as
with cleaned as (
    select 
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        price,
        customer_id,
        country,
        (quantity * price) as total_price
    from raw_data
    where invoice_no not like 'C%' 
    and customer_id is not null
    and quantity > 0
    and price > 0
)
select * from cleaned;


SELECT
    COUNT(*) AS clean_rows,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT invoice_no) AS unique_invoices,
    MIN(invoice_date) AS first_order,
    MAX(invoice_date) AS last_order,
    ROUND(SUM(total_price)::NUMERIC, 2) AS total_revenue
FROM clean_retail;

