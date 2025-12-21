Create Database retaildb;

Select * From retail_orders

--Total Orders, Total Revenue,Total Selling Quantity, Average Order Value
Select 
COUNT([Order-Id]) as total_order,
SUM(Sales) as total_revenue,
SUM(Quantity) as total_Quantity,
AVG(Sales) as avg_order_value
from retail_orders


--Monthwise sales data 
Select
YEAR([Order-Date]) as yr,
MONTH([Order-Date]) as mn,
SUM([Sales]) as monthlysales
from retail_orders
group by YEAR([Order-Date]),Month([Order-Date])
order by yr,mn



---Top 10 highest selling products
select top 10 [Product-Id],sum(Sales) as sales
from retail_orders
group by [Product-Id]
order by sales desc


--find top 5 highest selling products in each region
with cte as (
select Region,[Product-Id],sum(Sales) as sales
from retail_orders
group by Region,[Product-Id])
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select year([Order-Date]) as order_year,month([Order-Date]) as order_month,
sum(Sales) as sales
from retail_orders
group by year([Order-Date]),month([Order-Date])
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month