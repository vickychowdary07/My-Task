use  walmartsales;
select * from
walmartsalesdata.csv;
-------------------------------------------------------------------------
-- 1.	How many unique cities does the data have?
select distinct city
from walmartsalesdata;
 -- 2. In which city is each branch?
 select City,count(Branch)
 from walmartsalesdata
 group by city
 order by count(Branch);
 ------------------------------------------------------------------
 ----------------- PRODUCT -------------------------
-- 1.	How many unique product lines does the data have?
SELECT count(DISTINCT `product line`) AS unique_produt_line
FROM walmartsalesdata;
-- 2.	What is the most common payment method?
SELECT Payment
FROM walmartsalesdata
GROUP BY Payment
ORDER BY count(Payment) desc
LIMIT 1;
-- 3.What is the most selling product line?
SELECT `Product line`, COUNT(`Product line`) AS most_selling_product_line
FROM walmartsalesdata
group by `Product line`
ORDER BY most_selling_product_line desc
LIMIT 1;
-- 4.What is the total revenue by month?
select Month(Date) AS Month,
sum(`Unit price` * Quantity) AS Revenue
from walmartsalesdata
group by Month(Date)
order by Month;
-- 5.What month had the largest COGS?
SELECT month(Date) AS month, sum(cogs)
FROM walmartsalesdata
group by month(Date)
order by sum(cogs) desc;
-- 6.What product line had the largest revenue?
select  (`Product line`),SUM(`Unit price` * Quantity) as Revenue
from walmartsalesdata
group by `Product line`
order by Revenue DESC;
-- 7.What is the city with the largest revenue?
SELECT City,sum(`Unit price` * Quantity) AS revenue
FROM walmartsalesdata
group by City
order by revenue;
-- 8.What product line had the largest VAT?
SELECT `Product line`, MAX(`Tax 5%`)
FROM walmartsalesdata
group by `Product line`
order by MAX(`Tax 5%`) desc;
-- 9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
    `Product line`,
    AVG(`Unit price` * Quantity) AS `Average sales`,
    CASE 
        WHEN AVG(`Unit price` * Quantity) > (SELECT AVG(`Unit price` * Quantity) FROM walmartsalesdata) THEN 'Good'
        ELSE 'Bad'
    END AS Category
FROM walmartsalesdata
GROUP BY 
    `Product line`;
	-- AVERAGE
SELECT AVG(Unit_price * Quantity) AS SALES_AVG
from walmartsalesdata;
-- 10.Which branch sold more products than average product sold?
SELECT Branch,AVG(`Unit price` * Quantity) AS Product_sold
FROM walmartsalesdata
group by Branch
order by AVG(`Unit price` * Quantity)  desc
LIMIT 1;
-- 11.What is the most common product line by gender?
SELECT Gender, MAX(`Product line`) AS gender
FROM walmartsalesdata
group by gender
order by MAX(`Product line`) desc;
-- 12.What is the average rating of each product line?
SELECT `Product line`, AVG(Rating) AS Rating
FROM walmartsalesdata
group by `product line`
order by AVG(Rating) desc;
----------------------------------------------------------
----------- SALES ----------------
-- 1.Number of sales made in each time of the day per weekday
SELECT `Day name`, 
       SUM(`Unit price` * Quantity) AS sales 
FROM walmartsalesdata 
GROUP BY `Day name`;

    -- 2.Which of the customer types brings the most revenue?
    SELECT `Customer type`,SUM(`Unit price` * Quantity) AS revenue
    FROM walmartsalesdata
    group by `Customer type`
    order by revenue desc
    LIMIT 1;
    -- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
    SELECT City,max(`Tax 5%` * cogs) AS VAT
    FROM walmartsalesdata
    GROUP BY  City
    ORDER BY max(`Tax 5%`) desc;
    -- 4.Which customer type pays the most in VAT?
    SELECT (`Customer type`), SUM(`Unit price` * Quantity) AS VAT
    FROM walmartsalesdata
    GROUP BY `Customer type` 
    ORDER BY VAT desc
    LIMIT 1;
    ----------------------------------------------------------
    -------------- CUSTOMER ----------------
    -- 1.How many unique customer types does the data have?
    SELECT COUNT(distinct `Customer type`) AS unique_customer_type
    FROM walmartsalesdata;
    -- 2.How many unique payment methods does the data have?
    SELECT distinct Payment 
    FROM walmartsalesdata;
    -- 3.What is the most common customer type?
SELECT `Customer type`,COUNT(*) AS type_count
FROM walmartsalesdata
GROUP BY `customer type`
ORDER BY type_count DESC
LIMIT 1;
-- 4.Which customer type buys the most?
SELECT `Customer type`,COUNT(Payment) AS buys
FROM walmartsalesdata
GROUP BY `Customer type`
ORDER BY COUNT(Payment) DESC;
-- 5.What is the gender of most of the customers?
SELECT Gender,COUNT(*) AS `most customers`
FROM walmartsalesdata
GROUP BY Gender
ORDER BY COUNT(*) DESC; 
-- 6.What is the gender distribution per branch?
 SELECT Gender,Branch,COUNT(Branch) AS distrubution
 FROM walmartsalesdata
 GROUP BY Gender,Branch
 ORDER by Gender;
 -- 7.Which time of the day do customers give most ratings?
 SELECT `Time of day`,Time,COUNT(Rating) AS most_rating
 FROM walmartsalesdata
 GROUP BY `Time of day`,Time
 ORDER BY most_rating DESC;
 -- 8.Which time of the day do customers give most ratings per branch?
 SELECT `Time of day`,Time,Branch,COUNT(Rating) AS most_rating
 FROM walmartsalesdata
 GROUP BY `Time of day`,Time,Branch
 ORDER BY most_rating DESC;
 -- 9.Which day of the week has the best avg ratings?
 SELECT `Day name`,AVG(Rating) AS best_rating
 FROM walmartsalesdata
 GROUP BY `Day name`
 ORDER BY best_rating DESC;
 -- 10.Which day of the week has the best average ratings per branch?
  SELECT `Day name`,Branch,AVG(Rating) AS best_rating
 FROM walmartsalesdata
 GROUP BY `Day name`,Branch
 ORDER BY best_rating DESC;
 
 
 
 
 
 
 

    
    
    


