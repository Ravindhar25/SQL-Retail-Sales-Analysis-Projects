# Retail Sales Analysis Project - SQL

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_db`.
- **Table Creation**: A table named `tblsales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.


-- **Create Database SQL_Projects** --

CREATE DATABASE SQL_PROJECTS;

USE SQL_PROJECTS;

-- **Create Table tblsales** ---
```sql
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
```

-- **TO Bulk Insert Data into TblSales** --

```sql
BULK INSERT TableName
FROM 'C:\path\to\yourfile.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2 -- If the file has headers
);
```



-- ----------------------------- Data Exploration & Cleaning --------------------------------------------

--**Record Count**: Determine the total number of records in the dataset.

--**Customer Count**: Find out how many unique customers are in the dataset.

--**Category Count**: Identify all unique product categories in the dataset.

--**Null Value Check**: Check for any null values in the dataset and delete records with missing data.


-- ----------------------------- DATA EXPLORATION & CLEANING --------------------------------------------

-- **Find out the Total number of records in the dataset:**
```sql

SELECT
	count(*) total_cnt
FROM TBLSALES;
```

-- **Find out how many unique customers are in the dataset:**
```sql

SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS UNQ_CUS
FROM TBLSALES;
````

-- **Identify all unique product categories in the dataset:**
```sql

SELECT
	DISTINCT CATEGORY AS UNQ_CAT
FROM TBLSALES;
```
-- **Check for any null values in the dataset and delete records with missing data:**

-- --------------------------- TO CHECK NULL --------------------------------------------------------
```sql

SELECT
	*
FROM TBLSALES
WHERE transactions_id IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES
WHERE sale_date IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES
WHERE sale_time IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES
WHERE customer_id IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES
WHERE gender IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES -- NULL
WHERE age IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES
WHERE category IS NULL;
```
```sql

SELECT 
	*
FROM TBLSALES --NULL
WHERE quantity IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES  -- null
WHERE price_per_unit IS NULL;
```
```sql

SELECT
	*
FROM TBLSALES -- null
WHERE cogs IS NULL;
```
```sql
SELECT
	*
FROM TBLSALES -- null
WHERE total_sale IS NULL;
```

-- **TO CHECK NULL VALUES USING OR OPERATOR** ---

```sql

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
```

-- -------------------------------- TO DELETE RECORDS WITH MISSING DATA -------------------------------
```sql

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
```

-- ---------------------------------- Data Analysis & Findings --------------------------------------

-- The following SQL queries were developed to answer specific business questions:

-- **1.Write a SQL query to retrieve all columns for sales made on '2022-11-05':**

```sql
SELECT
	*
FROM TBLSALES
WHERE SALE_DATE ='2022-11-05';
```

-- **2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:**

```sql
SELECT
	*
FROM TBLSALES
WHERE category ='Clothing'
	AND quantity >=4
	AND FORMAT(sale_date,'yyyy-MM') = '2022-11';
```

-- **3.Write a SQL query to calculate the total sales (total_sale) for each category:**

```sql

SELECT
	category,
	SUM(TOTAL_SALE) AS SALES
FROM TBLSALES
GROUP BY category
ORDER BY SALES DESC;
```

-- **4.Write an SQL query to calculate the total sales and the number of orders for each category:**

```sql
SELECT
	category,
	SUM(TOTAL_SALE) AS SALES,
	COUNT(*) AS ORDERS
FROM TBLSALES
GROUP BY category
ORDER BY ORDERS DESC;
```

-- **5.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:**

```sql
SELECT
	AVG(AGE) AVG_AGE
FROM TBLSALES
WHERE category = 'BEAUTY';
```

-- **6.Write a SQL query to find all transactions where the total_sale is greater than 1000:**

```sql
SELECT
	*
FROM TBLSALES
WHERE TOTAL_SALE >1000;
```

-- **7.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:**

```sql
SELECT
	GENDER,
	CATEGORY,
	COUNT(*) CNT
FROM TBLSALES
GROUP BY GENDER,CATEGORY
ORDER BY CNT DESC;
```

-- **8.Write a SQL query to calculate the average sale for each month Find out best selling month in each year:**

```sql
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
```

-- **9.Write a SQL query to find the top 5 customers based on the highest total sales:**

```sql
SELECT TOP 5
	CUSTOMER_ID,
	SUM(TOTAL_SALE) SALES
FROM TBLSALES
GROUP BY CUSTOMER_ID
ORDER BY SUM(TOTAL_SALE) DESC;
```

-- **10.Write a SQL query to find the number of unique customers who purchased items from each category:**
```sql
SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) CNT
FROM TBLSALES
GROUP BY CATEGORY
ORDER BY CNT DESC;
```

-- **11.Write a SQL query to create each shift and number of orders(Example Morning <=12, Afternoon Between 12 & 17, Evening >17):**

```sql
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
```


## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Ravi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. 


