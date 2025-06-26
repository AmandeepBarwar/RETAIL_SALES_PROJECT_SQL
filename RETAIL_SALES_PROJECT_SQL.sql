-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as customers FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

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

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM RETAIL_SALES
WHERE 
	CATEGORY = 'Clothing' 
	 AND QUANTITY >= 4 
	-- AND SALE_DATE BETWEEN '2022-11-01' AND '2022-11-30'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11' -- MAINLY USED IN ORACLE DATABASE

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALE,
	COUNT(*) AS TOTAL_ORDER
FROM RETAIL_SALES
GROUP BY CATEGORY

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(AGE)),
	CATEGORY
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
GROUP BY CATEGORY

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT
	COUNT(*) TOTAL_TRANSACTION,
	TOTAL_SALE
FROM RETAIL_SALES
WHERE TOTAL_SALE > 1000
GROUP BY TOTAL_SALE

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	COUNT(*) TOTAL_TRANSACTION,
	GENDER,
	CATEGORY
FROM RETAIL_SALES
GROUP BY GENDER, CATEGORY
ORDER BY TOTAL_TRANSACTION

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM (
SELECT 
	EXTRACT (YEAR FROM SALE_DATE) AS YEAR,
	EXTRACT (MONTH FROM SALE_DATE) AS MONTH,
	ROUND(AVG(TOTAL_SALE)) AS AVG_SALE,
	RANK() OVER (PARTITION BY EXTRACT (YEAR FROM SALE_DATE) ORDER BY ROUND(AVG(TOTAL_SALE))) AS RANK
FROM RETAIL_SALES
GROUP BY YEAR, MONTH
) A
WHERE RANK = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_SALES DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	COUNT(DISTINCT CUSTOMER_ID) UNIQUE_CUSTOMERS,
	CATEGORY
FROM RETAIL_SALES
GROUP BY CATEGORY

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_SALE
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
        WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS SHIFT
FROM RETAIL_SALES
)
SELECT 
	SHIFT,
	COUNT(*) AS TOTAL_SALES
FROM HOURLY_SALE
GROUP BY SHIFT

-- END OF PROJECT