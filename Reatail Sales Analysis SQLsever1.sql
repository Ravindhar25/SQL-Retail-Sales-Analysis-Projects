
-- Create Database SQL_Projects --

CREATE DATABASE SQL_PROJECTS;

USE SQL_PROJECTS;

-- Create Table tblsales ---

CREATE TABLE TBLSALES
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME(0),
	customer_id	INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(40),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,	
	total_sale FLOAT
);


-- TO Bulk Insert Data into TblSales --

BULK INSERT Tblsales
FROM  'C:\path\to\yourfile.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2 -- If the file has headers
);

select * from TBLSALES;




-- ----------------------------- Data Exploration & Cleaning --------------------------------------------

--Record Count: Determine the total number of records in the dataset.
--Customer Count: Find out how many unique customers are in the dataset.
--Category Count: Identify all unique product categories in the dataset.
--Null Value Check: Check for any null values in the dataset and delete records with missing data.


-- ----------------------------- DATA EXPLORATION & CLEANING --------------------------------------------

-- Find out the Total number of records in the dataset:

SELECT
	count(*) total_cnt
FROM TBLSALES;


-- Find out how many unique customers are in the dataset:

SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS UNQ_CUS
FROM TBLSALES;

-- Identify all unique product categories in the dataset:

SELECT
	DISTINCT CATEGORY AS UNQ_CAT
FROM TBLSALES;

-- Check for any null values in the dataset and delete records with missing data:

-- --------------------------- TO CHECK NULL --------------------------------------------------------

SELECT
	*
FROM TBLSALES
WHERE transactions_id IS NULL;

SELECT
	*
FROM TBLSALES
WHERE sale_date IS NULL;

SELECT
	*
FROM TBLSALES
WHERE sale_time IS NULL;

SELECT
	*
FROM TBLSALES
WHERE customer_id IS NULL;

SELECT
	*
FROM TBLSALES
WHERE gender IS NULL;

SELECT
	*
FROM TBLSALES -- NULL
WHERE age IS NULL;

SELECT
	*
FROM TBLSALES
WHERE category IS NULL;

SELECT 
	*
FROM TBLSALES --NULL
WHERE quantity IS NULL;

SELECT
	*
FROM TBLSALES  -- null
WHERE price_per_unit IS NULL;

SELECT
	*
FROM TBLSALES -- null
WHERE cogs IS NULL;

SELECT
	*
FROM TBLSALES -- null
WHERE total_sale IS NULL;

-- TO CHECK NULL VALUES USING OR ----
SELECT
	*
FROM TBLSALES
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


-- -------------------------------- TO DELETE RECORDS WITH MISSING DATA -------------------------------

DELETE FROM TBLSALES
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


-- ---------------------------------- Data Analysis & Findings --------------------------------------

-- The following SQL queries were developed to answer specific business questions: 

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05':

SELECT
	*
FROM TBLSALES
WHERE SALE_DATE ='2022-11-05';


-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and
-- the quantity sold is more than 4 in the month of Nov-2022:

SELECT
	*
FROM TBLSALES
WHERE category ='Clothing'
	AND quantity >=4
	AND FORMAT(sale_date,'yyyy-MM') = '2022-11';

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category:

SELECT
	category,
	SUM(TOTAL_SALE) AS SALES
FROM TBLSALES
GROUP BY category
ORDER BY SALES DESC;


-- 4.Write an SQL query to calculate the total sales and the number of orders for each category:


SELECT
	category,
	SUM(TOTAL_SALE) AS SALES,
	COUNT(*) AS ORDERS
FROM TBLSALES
GROUP BY category
ORDER BY ORDERS DESC;

-- 5.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:

SELECT
	AVG(AGE) AVG_AGE
FROM TBLSALES
WHERE category = 'BEAUTY';

-- 6.Write a SQL query to find all transactions where the total_sale is greater than 1000:

SELECT
	*
FROM TBLSALES
WHERE TOTAL_SALE >1000;

-- 7.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:

SELECT
	GENDER,
	CATEGORY,
	COUNT(*) CNT
FROM TBLSALES
GROUP BY GENDER,CATEGORY
ORDER BY CNT DESC;

-- 8.Write a SQL query to calculate the average sale for each month
-- Find out best selling month in each year
SELECT
	*
FROM
	(
	SELECT
		MONTH(SALE_DATE) MONTH,
		YEAR(SALE_DATE) YEAR,
		AVG(TOTAL_SALE) AVG_SALES,
		RANK() OVER(PARTITION BY YEAR(SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) RNK
	FROM TBLSALES
	GROUP BY MONTH(SALE_DATE),
			 YEAR(SALE_DATE) 
		 )T
		 WHERE T.RNK =1;

-- 9.Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT TOP 5
	CUSTOMER_ID,
	SUM(TOTAL_SALE) SALES
FROM TBLSALES
GROUP BY CUSTOMER_ID
ORDER BY SUM(TOTAL_SALE) DESC;


-- 10.Write a SQL query to find the number of unique customers who purchased items from each category:

SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) CNT
FROM TBLSALES
GROUP BY CATEGORY
ORDER BY CNT DESC;


-- 11.Write a SQL query to create each shift and number of orders(Example Morning <=12, Afternoon Between 12 & 17, Evening >17):

WITH HOURS_SALES
AS
(
	SELECT
		*,
		CASE 
			WHEN DATEPART(HOUR,SALE_TIME)>12 THEN 'MORNING'
			WHEN DATEPART(HOUR,SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			ELSE 'EVENING'
			END AS SHIFT
	FROM TBLSALES
)
SELECT
	SHIFT,
	COUNT(*) CNT
FROM HOURS_SALES
GROUP BY SHIFT
ORDER BY CNT DESC;
	

