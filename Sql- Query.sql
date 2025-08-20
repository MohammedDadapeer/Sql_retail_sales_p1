-- SQL Retail sales analysis

--create table
create table retail_sales_tb
            (
             transactions_id int primary key,
             sale_date	date,
			 sale_time	time,
			 customer_id int,
			 gender	varchar(15),
			 age int,
			 category varchar(15),
			 quantiy int,	
			 price_per_unit	float,
			 cogs float,	
			 total_sale float
            )
-- we have uploaded the file in the data base 

select * from retail_sales_tb
limit 10

-- Data Cleaning
select count (*) from retail_sales_tb

select * from retail_sales_tb
where 
    transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
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
	total_sale is null;

-- deleted null values from the table
delete from retail_sales_tb
where 
    transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null


select count (*) from retail_sales_tb

-- Data Exploration

-- How many sales we have?
select count (*) from retail_sales_tb

-- How many unique customers we have?
select count (Distinct customer_id) from retail_sales_tb


-- How many unique category we have?
select count (Distinct category) from retail_sales_tb

-- Show the category name we have?
select distinct category from retail_sales_tb

-- Data Analysis & key problems & answers

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

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
	select * from retail_sales_tb
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT 
  *
FROM retail_sales_tb
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as net_sale
from retail_sales_tb
group by 1


select category, sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales_tb
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(Age),2) as avg_age
 from retail_sales_tb
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales_tb
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) as total_trans from retail_sales_tb
group by  category,gender
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from
(
select
     extract(year from sale_date) as year,
	 extract(month from sale_date) as month,
	 avg(total_sale) as avg_total_sales,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
from retail_sales_tb
group by 1,2
)as t1
where rank =1 
--order by 1,3 desc

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,
 sum(total_sale) as total_sales
from retail_sales_tb
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


select category, count(distinct customer_id) as unique_customer
from retail_sales_tb
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales_tb
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

