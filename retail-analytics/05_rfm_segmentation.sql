-- Calculate RFM metrics per customers
with rfm_metrics as (
	select 
		customer_id,
		(select max(invoice_date) from clean_retail) - max(invoice_date)
			as recency_interval,
		extract(day from
					(select max(invoice_date) from clean_retail) - 
					max(invoice_date)
				) as recency_days,
				count(distinct invoice_no) as frequency,
				round(sum(total_price):: numeric, 2) as monetary
	from clean_retail
	group by customer_id
),

--Score each metric into quartile (1-4, where 4 is best)
rfm_scores as (
	select
		customer_id,
		recency_days,
		frequency,
		monetary,
		ntile(4) over (order by recency_days desc) r_score,
		ntile(4) over (order by frequency asc) as f_score,
		ntile(4) over (order by monetary asc) as m_score
	from rfm_metrics
	where recency_days is not null
),

--Assign customer segments based on combined score
rfm_segments as
(
	select 
		customer_id,
		recency_days,
		frequency,
		monetary,
		r_score,
		f_score,
		m_score,
		(r_score + f_score + m_score) as rfm_total,
		case
			when r_score >=4 and f_score >=4 and m_score >= 4 then
			'Champions'
			when r_score >=3 and f_score >=3 and m_score >= 3 then 
			'Loyal Customers'
			when r_score >=4 and f_score <=2 then
			'New Customers'
			when r_score >=3 and f_score >=2 and m_score >= 2 then
			'Potential Loyalists'
			when r_score <=2 and f_score >=3 and m_score >= 3 then
			'At Risk'
			when r_score <=2 and f_score >=4 then 'Cannot Lost Them'
			when r_score <-2 and f_score <=2 then 'Lost'
			else 'Others'
		end as segment	
	from rfm_scores
)

-- Final Summary by segment
select
	segment,
	count(*) as num_customers,
	round(avg(recency_days):: numeric, 0) as avg_recency_days,
	round(avg(frequency)::numeric,1 ) as avg_frequency,
	round(avg(monetary)::numeric, 2) as avg_monetary,
	round(sum(monetary)::numeric, 2) as total_revenue
from rfm_segments
group by segment
order by total_revenue desc;