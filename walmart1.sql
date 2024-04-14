CREATE DATABASE walmart;
CREATE TABLE IF NOT EXISTS SALES(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(10,2) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_percentage FLOAT(11,9) NOT NULL,
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1) NOT NULL
);


-- -----------------------------------------------------------------
-- Feature Engineering
-- adding column time_of_day
SELECT
    time,
    (CASE
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING" 
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENING"
     END   
    ) AS time_of_day
FROM sales;    
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day=(
     CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING" 
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENING"
     END
);
-- adding column day_name
SELECT
     date,
    dayname(date)
FROM sales ;   
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);  
UPDATE sales
SET day_name=DAYNAME(date);  

-- adding column month_name
SELECT 
     date,
     monthname(date)
 FROM sales;
 ALTER TABLE sales ADD COLUMN month_name VARCHAR(15); -- to add column
 UPDATE sales
 SET month_name=monthname(date); -- to add data to column
 -- ------------------------------------------------------------------
 -- EXPLORATORY DATA ANALYSIS------------------------------
 -- -------------------------------------------------------
 -- GENERIC QUESTIONS-------------------------
 
 -- How many unique cities does the data have?
 SELECT 
       DISTINCT city
FROM sales ;      
 
  SELECT 
       DISTINCT branch
FROM sales;
-- In which city is each branch?
SELECT
     DISTINCT city,
     branch
FROM sales;     

-- PRODUCT QUESTIONS-------------------------

-- How many unique product lines does the data have?
SELECT 
	 DISTINCT product_line -- TO COUNT WRITE COUNT(DISTINCT product_line)
FROM sales;     

-- What is the most common payment method?
SELECT  
      payment_method,
      COUNT(payment_method) as count
FROM sales
GROUP BY payment_method
ORDER BY count desc;

-- What is the most selling product line?
SELECT 
      product_line,
      COUNT(product_line) as count
FROM sales 
GROUP BY product_line
ORDER BY count desc;      

-- What is the total revenue by month?
SELECT 
      month_name as month,
      SUM(total) as total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue ;     
      
-- What month had the largest COGS?
SELECT 
      month_name as month,
      SUM(cogs) as total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs desc;      

-- What product line had the largest revenue?
SELECT 
      product_line as product_line,
      SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue desc;

-- What is the city with the largest revenue?
SELECT 
      city as city,
      SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue desc;      
      
-- What product line had the largest VAT?
SELECT 
      product_line as product_line,
      AVG(VAT) as AVG_TAX -- If you use SUM(), it will give you the total VAT amount for each product line.
FROM sales
GROUP BY product_line
ORDER BY AVG_TAX desc;-- This gives you the average amount of VAT paid for each transaction or item within a specific product line. 

-- Which branch sold more products than average product sold?
SELECT
      branch,
      SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);    

-- What is the most common product line by gender?
SELECT 
      gender,
      product_line,
      COUNT(gender) as total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt desc;      
     
-- What is the average rating of each product line?
SELECT 
     product_line,
     round(AVG(rating),2) as avg_rating
FROM sales     
GROUP BY product_line
ORDER BY avg_rating desc;  

-- ------------------------------------------------------------
-- Sales Questions------------------------------------------   

-- Number of sales made in each time of the day per weekday
SELECT 
      day_name,
      time_of_day,
      COUNT(*) as total_sales
FROM sales
GROUP BY day_name,time_of_day
ORDER BY total_sales;      

-- Which of the customer types brings the most revenue?
SELECT 
      customer_type,
      SUM(total) as total
FROM sales
GROUP BY customer_type
ORDER BY total desc;   

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
         city,
         AVG(VAT) as avg_vat
FROM sales
GROUP BY city
ORDER BY avg_vat desc;          

-- Which customer type pays the most in VAT?
SELECT 
	  customer_type,
      AVG(VAT) as avg_vat
FROM sales
GROUP BY customer_type
ORDER BY avg_vat desc;     

-- ------------------------------------------------------------------------
-- Customer QUESTIONS ------------------------------------ 
-- --------------------------------------------------------------------
-- How many unique customer types does the data have?
SELECT 
      count(distinct(customer_type)) as unique_customertype
FROM sales; 

-- How many unique payment methods does the data have?
 SELECT 
      count(distinct(payment_method)) as unique_paymentmethods
FROM sales;

-- What is the most common customer type?
SELECT
      customer_type,
      count(customer_type) as count
FROM sales      
GROUP BY customer_type
ORDER BY count desc;  

-- Which customer type buys the most?
SELECT 
      customer_type,
      COUNT(*) as total
FROM sales
GROUP BY customer_type
ORDER BY total desc;    

-- What is the gender of most of the customers?
SELECT 
      gender,
      COUNT(*) as count
FROM sales
GROUP BY gender
ORDER BY count desc;

-- What is the gender distribution per branch?
SELECT 
      branch,
      gender,
      COUNT(*) as count
FROM sales -- if we want for a particular branch we can add WHERE branch="c" after this line
GROUP BY branch,gender      
ORDER BY branch; 

-- Which time of the day do customers give most ratings?
SELECT 
      time_of_day,
      AVG(rating) as rating -- mistake : i had used count here
FROM sales
GROUP BY time_of_day
ORDER BY rating desc;

-- Which time of the day do customers give most ratings per branch?
SELECT 
      branch,
      time_of_day,
      AVG(rating) as rating
FROM sales
GROUP BY branch,time_of_day
ORDER BY branch,rating desc;

-- Which day fo the week has the best avg ratings?
SELECT 
      day_name,
      AVG(rating) as average_rating
FROM sales
GROUP BY day_name
ORDER BY average_rating desc;

-- Which day of the week has the best average ratings per branch?
SELECT 
	  branch,
      day_name,
      AVG(rating) as average_rating
FROM sales
GROUP BY branch,day_name
ORDER BY branch,average_rating desc;
      
            

      