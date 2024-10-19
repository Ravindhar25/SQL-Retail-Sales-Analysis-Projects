-- CREATE DATABASE RETAIL_SALES_DB

CREATE DATABASE Retail_sales_db;

-- CREATE TABLE TBL_SALES

CREATE TABLE TBL_SALES
(

	transactions_id   	INT PRIMARY KEY,
	sale_date			DATE,
	sale_time 			TIME,
	customer_id 		INT,
	gender				VARCHAR(10),
	age	 				INT,
	category			VARCHAR(35),
	quantity 			INT,
	price_per_unit 		FLOAT,
	cogs 				FLOAT,
	total_sale 			FLOAT

);

SELECT * FROM TBL_SALES;


-- DATA EXPLORATION & CLEANING
-- ---------------------------------------------------------------------------------------------

-- Find out the Total number of records in the dataset. 

SELECT
	COUNT(*) AS TOTAL_CNT
FROM TBL_SALES;

-- Find out how many unique customers are in the dataset.

SELECT
	COUNT(DISTINCT(CUSTOMER_ID)) AS UNQ_CUS_CNT
FROM TBL_SALES;

-- Identify all unique product categories in the dataset.

SELECT
	DISTINCT CATEGORY AS UNQ_CAT
FROM TBL_SALES;

-- Check for any null values in the dataset and delete records with missing data.

-- TO CHECK NULL --
SELECT
	*
FROM TBL_SALES
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- TO DELETE RECORDS WITH MISSING DATA --

DELETE FROM TBL_SALES
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


-- --------------------------------------------------------------------------------------------------

-- Data Analysis & Findings

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT 
	*
FROM TBL_SALES
WHERE SALE_DATE = '2022-11-05';
	


-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022:


SELECT
	*
FROM tbl_sales
WHERE category = 'Clothing' 
	  AND
	  quantity >=4
	  AND 
	  TO_CHAR(sale_date,  'YYYY-MM') = '2022-11';


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	CATEGORY,
	SUM(TOTAL_SALE) TOTAL_SALES
FROM TBL_SALES
GROUP BY CATEGORY;

-- 4. Write an SQL query to calculate the total sales and the number of orders for each category.


SELECT
	CATEGORY,
	SUM(TOTAL_SALE) TOTAL_SALES,
	COUNT(*) TOTAL_ORDERS
FROM TBL_SALES
GROUP BY CATEGORY
ORDER BY TOTAL_ORDERS DESC;

-- 5. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	 AVG(age) AVG_AGE
FROM tbl_sales
WHERE category ='Beauty';


SELECT
    ROUND(AVG(age), 2) as avg_age
FROM tbl_sales
WHERE category = 'Beauty';

-- 6. Write a SQL query to find all transactions where the total_sale is greater than 1000


SELECT
	*
FROM TBL_SALES
WHERE TOTAL_SALE >1000;

-- 7.  Write a SQL query to find the total number of transactions (transaction_id) made by
-- each gender in each category.


SELECT 
	GENDER,
	CATEGORY,
	COUNT(*) CNT_TRANS
FROM TBL_SALES
GROUP BY GENDER, CATEGORY
ORDER BY COUNT(*) DESC;


-- 8. Write a SQL query to calculate the average sale for each month.
-- Find out best selling month in each year
SELECT
	*
FROM
	(
	SELECT
		EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
		EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
		AVG(TOTAL_SALE)	AVG_SALES,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) RNK
	FROM TBL_SALES
	GROUP BY 1,2
	)T
WHERE T.RNK =1;


-- 9. Write a SQL query to find the top 5 customers based on the highest total sales 


SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) TOTAL_SALES
FROM TBL_SALES
GROUP BY CUSTOMER_ID
ORDER BY SUM(TOTAL_SALE) DESC
LIMIT 5;


-- 10. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS CNT_UNQ_CUS
FROM TBL_SALES
GROUP BY CATEGORY
ORDER BY CNT_UNQ_CUS DESC;


-- 11. Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH HOUR_SALES
AS
(
SELECT
	*,
	CASE
		WHEN EXTRACT(HOUR FROM SALE_TIME) >12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
		END SHIFT
FROM TBL_SALES
) 
SELECT
	SHIFT,
	COUNT(*) TOTAL_ORDERS
FROM HOUR_SALES
GROUP BY SHIFT;

-- -------------------------------------- End -------------------------------------------------

