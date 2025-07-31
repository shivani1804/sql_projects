-- Retail Database--
CREATE DATABASE sql_project_p1;

--Make Table--
DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);

SELECT * FROM retail_sales;

--Data cleaning--
SELECT
	COUNT(*) 
FROM retail_sales;


SELECT * FROM retail_sales
WHERE transactions_id IS NULL;


SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
	(
	transactions_id IS NULL
	OR
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
	);

--
delete from retail_sales
WHERE 
	(
	transactions_id IS NULL
	OR
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
	);

-- Date exploration--

--How many sales we have?--
SELECT COUNT(*) AS total_sales
FROM retail_sales;

--How many customers we have?--
SELECT COUNT(DISTINCT(customer_id)) as total_customers
FROM retail_sales;

--Number of categories--
SELECT DISTINCT(category)
FROM retail_sales;


--Data Analysis & Businees problems--

--Sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date ='2022-11-05';

--Trasactions for category clothing and quantity more than or 2 in month of nov-2022
SELECT *
FROM retail_sales
WHERE
	category = 'Clothing'
	AND
	quantiy >=2
	AND
	FORMAT(sale_date, 'yyyy-MM') = '2022-11';

--total sales for each category--
SELECT category, sum(total_sale) as total_sale
FROM retail_sales
GROUP BY category;

--Average age of customers who purchased items from 'Beauty' category--
SELECT Round(AVG(age),2) as Average_age
FROM retail_sales
WHERE category = 'Beauty';

--Transactions where total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000;

--Total number of transactions made by each gender in each category
SELECT category, gender,COUNT(*)
FROM retail_sales
GROUP BY category, gender;

--avg sale for each month and best selling month in year
SELECT *
FROM(
	SELECT year(sale_date) as [year] ,month(sale_date) as [month],avg(total_sale) as avg_sale, rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
	FROM retail_sales
	GROUP BY YEAR(sale_date), MONTH(sale_date)
	) AS t1
WHERE ranking =1;


--Top 5 customers based on highest total_sales
SELECT top 5 customer_id, sum(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales desc;


-- unique customers who purchased items from each category
SELECT category, count(distinct(customer_id)) as unique_customers
FROM retail_sales
GROUP BY category;

--create each shift and number of orders(example morning <12, afternoon between 12,17, evening >17)
with hourly_sales as(
SELECT *,
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shifts
FROM retail_sales
)

SELECT shifts,count(*) as total_orders
FROM hourly_sales
GROUP BY shifts;

