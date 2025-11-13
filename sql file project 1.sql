
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

-- DATA CLEANING

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

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?

SELECT COUNT(transactions_id) AS total_sale
FROM sale;

-- HOW MANY CUSTOMERS WE HAVE ?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sale;

-- HOW MANY CATEGORIES WE HAVE?

SELECT DISTINCT(category)
FROM sale;

-- HOW MANY CATEGORY WISE SALE DO WE HAVE?
SELECT 
	category, 
	COUNT(category) AS total
FROM sale
GROUP BY category;

-- 	DATA ANALYSIS AND BUSINESS KEY PROBLEMS

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM sale
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 4 in the month of Nov-2022.

SELECT 
	sale_date, 
	transactions_id 
	FROM
	(SELECT * FROM sale
		WHERE 
			category = 'Clothing'
			AND quantity >= 4)
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- ALTERNATIVELY

SELECT 
	EXTRACT (MONTH FROM sale_date) AS months,
	transactions_id
FROM sale
WHERE category = 'Clothing'
	AND quantity >= 4
	AND EXTRACT (MONTH FROM sale_date) = 11
	AND EXTRACT (YEAR FROM sale_date) = 2022
	;

-- ALTERNATIVELY

SELECT 
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11' AS months,
	transactions_id
FROM sale
WHERE category = 'Clothing'
	AND quantity >= 4
	AND EXTRACT (MONTH FROM sale_date) = 11
	AND EXTRACT (YEAR FROM sale_date) = 2022
ORDER BY transactions_id DESC;


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
	SUM(total_sale) AS total_sale
FROM SALE
GROUP BY category
ORDER BY total_sale DESC;


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	category,
	ROUND(AVG(age),2) AS avg_age
FROM sale
WHERE category = 'Beauty'
GROUP BY category
ORDER BY AVG(age);

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM sale
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) 
-- made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id) AS total_transactions
FROM sale
GROUP BY category, gender
ORDER BY category;

-- 7. Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year.

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

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT
	customer_id,
	SUM(total_sale)
FROM sale
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	category,
	COUNT (DISTINCT customer_id) AS unique_customers	
FROM sale
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

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

-- END OF THE PROJECT.
