# Retail Sales Analysis SQL Project

## Project Overview
**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `project1`  


This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives
1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.


## Project Structure

### 1. Database Setup
1. **Database Creation**: The project starts by creating a database named p1_retail_db.
2. **Table Creation**: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE project1;

CREATE TABLE sale (

	transactions_id	INT,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR (15),	
	quantity	INT,
	price_per_unit INT,	
	cogs FLOAT,
	total_sale INT
);
```

### 2. Data Exploration & Cleaning
-**Record Count**: Determine the total number of records in the dataset.
-**Customer Count**: Find out how many unique customers are in the dataset.
-**Category Count**: Identify all unique product categories in the dataset.
-**Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM sale
WHERE 
	transactions_id	IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL	
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL
	;

DELETE FROM sale
WHERE 
	transactions_id	IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL	
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL
	;
```
## DATA EXPLORATION

-**HOW MANY SALES WE HAVE?**
```sql
SELECT COUNT(transactions_id) AS total_sale
FROM sale;
```
-**HOW MANY CUSTOMERS WE HAVE?**
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sale;
```
-**HOW MANY CATEGORIES WE HAVE?**
```sql
SELECT DISTINCT(category)
FROM sale;
```
-**HOW MANY CATEGORY WISE SALE DO WE HAVE?**
```sql
SELECT 
	category, 
	COUNT(category) AS total
FROM sale
GROUP BY category;
```
### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**.
```sql
SELECT * FROM sale
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**.
```sql
SELECT 
	sale_date, 
	transactions_id 
	FROM
	(SELECT * FROM sale
		WHERE 
			category = 'Clothing'
			AND quantity >= 4)
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```
***Alternatively***
```sql
SELECT 
	EXTRACT (MONTH FROM sale_date) AS months,
	transactions_id
FROM sale
WHERE category = 'Clothing'
	AND quantity >= 4
	AND EXTRACT (MONTH FROM sale_date) = 11
	AND EXTRACT (YEAR FROM sale_date) = 2022
	;
```
***Alternatively***
```sql
SELECT 
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11' AS months,
	transactions_id
FROM sale
WHERE category = 'Clothing'
	AND quantity >= 4
	AND EXTRACT (MONTH FROM sale_date) = 11
	AND EXTRACT (YEAR FROM sale_date) = 2022
ORDER BY transactions_id DESC;
```
3. **Write a SQL query to calculate the total sales (total_sale) for each category**.
```sql
SELECT category,
	SUM(total_sale) AS total_sale
FROM SALE
GROUP BY category
ORDER BY total_sale DESC;
```
4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**.
```sql
SELECT 
	category,
	ROUND(AVG(age),2) AS avg_age
FROM sale
WHERE category = 'Beauty'
GROUP BY category
ORDER BY AVG(age);
```
5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**.
```sql
SELECT *
FROM sale
WHERE total_sale > 1000;
```
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**.
```sql
SELECT 
	category,
	gender,
	COUNT(transactions_id) AS total_transactions
FROM sale
GROUP BY category, gender
ORDER BY category;
```
7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**
```sql
SELECT
	years,
	months,
	average_sale
FROM (
	SELECT 
		-- sale_date, 
		EXTRACT(YEAR FROM sale_date) AS years,
		TO_CHAR(sale_date,'FMMonth') AS months,
		ROUND(AVG(total_sale),2) AS average_sale,
		RANK () OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS ranks
	FROM sale
	GROUP BY months, years) AS table_1
WHERE ranks = 1;
```
8. **Write a SQL query to find the top 5 customers based on the highest total sales**.
```sql
SELECT
	customer_id,
	SUM(total_sale)
FROM sale
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;
```
9. **Write a SQL query to find the number of unique customers who purchased items from each category**.
```sql
SELECT
	category,
	COUNT (DISTINCT customer_id) AS unique_customers	
FROM sale
GROUP BY category;
```
10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**.
```sql
WITH hourly_sale AS
	(SELECT *,
		CASE 
			WHEN sale_time < '12:00:00' THEN 'Morning'
			WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
			WHEN sale_time > '17:00:00' THEN 'Evening'
		END AS shift
	FROM sale)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

## Findings
- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports
**Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
**Trend Analysis**: Insights into sales trends across different months and shifts.
**Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use
- **Clone the Repository**: Clone this project repository from GitHub.
- **Set Up the Database**: Run the SQL scripts provided in the database_setup.sql file to create and populate the database.
- **Run the Queries**: Use the SQL queries provided in the analysis_queries.sql file to perform your analysis.
- **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Zero Analyst
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

## Stay Updated and Join the Community
For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

## About Me
- **Name**: Koushik Das
- **Education**: B.Sc. Physics (Hons.)
- **LinkedIn**: Connect with me professionally
- **Contact**: 9911568488

Thank you for your support, and I look forward to connecting with you!

***END OF THE PROJECT***
