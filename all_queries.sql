-- Query 1
select gender,sum(purchase_amount) as total_revenue
from cleaned_df
group by gender

-- Query 2
select customer_id ,purchase_amount
from cleaned_df
where discount_applied='Yes' and purchase_amount > (select avg(purchase_amount) from cleaned_df)

-- Query 3
select customer_id,item_purchased, avg(review_rating) as "highest rating"
from cleaned_df
group by item_purchased
order by avg(review_rating) desc
limit 5

-- Query 4
SELECT
  (SELECT AVG(purchase_amount) FROM cleaned_df WHERE shipping_type='Standard') AS avg_standard_shipping,
  (SELECT AVG(purchase_amount) FROM cleaned_df WHERE shipping_type='Express') AS avg_express_shipping

-- Query 5
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as purchase_sum
from cleaned_df
group by subscription_status
order by avg_spend,purchase_sum desc

-- Query 6
select item_purchased ,
round(cast(sum(case when discount_applied='Yes' then 1 else 0 END) as REAL)/count(*)*100,2) as discount_rate
from cleaned_df
group by item_purchased
order by discount_rate desc
limit 5;

-- Query 7
with customer_purchase as (
  select customer_id, previous_purchases,
  case
  when previous_purchases = 1 then 'New'
  when previous_purchases between 2 and 10 then 'Returning'
  else 'Loyal'
  end as customer_segment
  from cleaned_df
  )
  select customer_segment, count(*) as "number of customers"
  from customer_purchase
  group by customer_segment

-- Query 8
with item_counts as (
  select category, item_purchased, count( customer_id ) as total_orders,
  row_number() over (partition by category order by count( customer_id ) desc) as item_rank
  from cleaned_df
  group by category, item_purchased
) select item_rank,category, item_purchased, total_orders
  from item_counts
  where item_rank <= 3

-- Query 9
select subscription_status, count(customer_id) as repeat_buyers
from cleaned_df
where previous_purchases > 5
group by subscription_status

-- Query 10
select age_group,sum(purchase_amount) as total_revenue
from cleaned_df
group by age_group
order by total_revenue desc;

