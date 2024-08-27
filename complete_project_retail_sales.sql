-- SQL Retail Sales Analysis - P1
create database sql_project_p2;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(6),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit float,
    cogs float,
    total_sale float
);
drop table retail_sales

select * from retail_sales
limit 10

select count(*) from retail_sales limit 10

-- check null values in any column
select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where customer_id is null

select * from retail_sales
where gender is null

select * from retail_sales
where age is null

---- multiple column check 
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- check the all rows after fixing, so i have to delete the null values row(Know as Data Cleaning Process).
delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

----
select count(*) from retail_sales
select * from retail_sales

----
--Data Exploration
--How Many sales we have?
select count(*) as total_sales from retail_sales

-- How many customer we have?
select count(customer_id) as total_sales from retail_sales

-- How many find unique customer we have?
select count(distinct(customer_id)) as total_sales from retail_sales

-- HOw many Unique category in the Retail_Shop?
select distinct(category) from retail_sales


-- Data Analysis & Bussiness
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

------------------------------------------------------------------------------------------------------------------------------------------------
								--Solution
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing' 
	and
	to_char(sale_date,'yyyy-mm') = '2022-11'
	and
	quantiy >=4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
category,
sum(total_sale) as total_sales,
count(*) as total_orders
from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
	count(*) as total_trans from retail_sales group by category,gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as average_sale,
		-- window function used in here
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
) as t1 
where rank = '1'
--order by 1,3 desc

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id)
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sales
group by shift
/*
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
*/

-----------------END OF PROJECT------------------