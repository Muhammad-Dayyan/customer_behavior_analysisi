select * from customer
-- q1 total revenue by male or female customer?

select gender, sum(purchase_amount) as revenue from customer
group by gender

-- q2 which coutomer used a discount but still spent more than the average purchase amount?

select customer_id, purchase_amount from customer
where promo_code_used = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer)

-- q3 top 5 product with highest average review rating

select item_purchased,round(avg(review_rating::numeric),2) as average from customer
group by item_purchased
order by avg(review_rating) desc
limit 5

--q4 average purchased amount between standar and express shipping

select shipping_type , round(avg(purchase_amount),2) from customer 
where shipping_type in ('Express','Standard')
group by shipping_type

-- q5 compare average spent and total revenue between subscriber and non-subscriber

select subscription_status, count(customer_id) as total_customer,
round(avg(purchase_amount),2) as amount,
round(sum(purchase_amount),2) as revenue from customer
group by subscription_status
order by amount, revenue desc

-- q6 which 5 product have the highest percentage of purchases with discount applied
select item_purchased,
round(100 * sum(case when  promo_code_used = 'Yes' then 1 else 0 end)/count(*),2) as discount from customer
group by item_purchased
order by discount desc 
limit 5

--Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id, previous_purchases,
CASE
   WHEN previous_purchases = 1 THEN 'New'
   WHEN previous_purchases between 2 and 10 then 'Returning'
   ELSE 'Loyal'	
   END AS customer_segment
from customer   
)
SELECT customer_segment, count(*) as "Number of customer"
from customer_type
group by customer_segment
--Q8. What are the top 3 most purchased products within each category? 

with item_count as (
select item_purchased, category,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) DESC) AS item_rank from customer
group by item_purchased, category
)
select item_rank,item_purchased, category,total_orders from item_count
where item_rank <= 3 
--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status ,count(customer_id) as sub from customer
where previous_purchases > 5
group by  subscription_status


--Q10. What is the revenue contribution of each age group? 

select age_group,sum(purchase_amount) from customer
group by age_group 
order by age_group desc


show statement_timeout

select count(*) from customer