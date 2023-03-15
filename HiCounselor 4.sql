USE hicounselor3;
-- 1.What percentage of total orders were shipped on the same date? --
SELECT CONCAT(COUNT(*) * 100 / (SELECT COUNT(*) FROM superstore), '%') AS percentage 
FROM superstore 
WHERE Order_Date = Ship_Date;

-- 2.Name top 3 customers with highest total value of orders. --

SELECT Customer_Name, SUM(Sales) AS Total_Order_Value
FROM superstore
GROUP BY Customer_Name
ORDER BY Total_Order_Value DESC
LIMIT 3;

-- 3.Find the top 5 items with the highest average sales per day. --
SELECT Product_Name, AVG(Sales) AS Avg_Sales_Per_Day
FROM superstore
GROUP BY Product_Name
ORDER BY Avg_Sales_Per_Day DESC
LIMIT 5;

-- 4.Write a query to find the average order value for each customer, and rank the customers by their average order value.--
SELECT Customer_Name, AVG(Sales) AS Avg_Order_Value
FROM superstore
GROUP BY Customer_Name
ORDER BY Avg_Order_Value DESC;

-- 5.Give the name of customers who ordered highest and lowest orders from each city.--
SELECT City,
MAX(Customer_Name) AS Customer_With_Highest_Order,
MIN(Customer_Name) AS Customer_With_Lowest_Order
FROM superstore
GROUP BY City;

-- 6.What is the most demanded sub-category in the west region? --
SELECT Sub_Category, SUM(Sales) AS Total_Sales
FROM superstore
WHERE Region = 'West'
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 1;

-- 7.Which order has the highest number of items? And which order has the highest cumulative value? --
SELECT Order_ID, COUNT(*) AS Item_Count
FROM superstore
GROUP BY Order_ID
ORDER BY Item_Count DESC
LIMIT 1;

SELECT Order_ID, SUM(Sales) AS Cumulative_Value
FROM superstore
GROUP BY Order_ID
ORDER BY Cumulative_Value DESC
LIMIT 1;

-- 8.Which order has the highest cumulative value? --
SELECT Order_ID, SUM(Sales) AS Cumulative_Value
FROM superstore
GROUP BY Order_ID
ORDER BY Cumulative_Value DESC
LIMIT 1;

-- 9.Which segment’s order is more likely to be shipped via first class? --
SELECT Segment, COUNT(*) AS First_Class_Count
FROM superstore
WHERE Ship_Mode = 'First Class'
GROUP BY Segment
ORDER BY First_Class_Count DESC
LIMIT 1;

-- 10.Which city is least contributing to total revenue? --
SELECT City, SUM(Sales) AS Total_Revenue
FROM superstore
GROUP BY City
ORDER BY Total_Revenue
LIMIT 1;

-- 11.What is the average time for orders to get shipped after order is placed? --
SELECT AVG(DATEDIFF(Ship_Date, Order_Date)) AS Avg_Shipping_Time
FROM superstore;

-- 12.Which segment places the highest number of orders from each state and which segment places the largest individual orders from each state?
SELECT State, Segment, MAX(Sales) AS Largest_Individual_Order 
FROM superstore 
GROUP BY State, Segment 
HAVING Largest_Individual_Order = (
    SELECT MAX(Largest_Individual_Order) 
    FROM (
        SELECT State, Segment, MAX(Sales) AS Largest_Individual_Order 
        FROM superstore 
        GROUP BY State, Segment
    ) AS Subquery
);


SELECT State, Segment, COUNT(*) AS Order_Count
FROM superstore
GROUP BY State, Segment
HAVING Order_Count = (
SELECT MAX(Order_Count)
FROM (
SELECT State, Segment, COUNT(*) AS Order_Count
FROM superstore
GROUP BY State, Segment
) AS tmp
WHERE tmp.State = superstore.State
)
ORDER BY State ASC;



-- 13.Find all the customers who individually ordered on 3 consecutive days where each day’s total order was more than 50 in value. ** --
SELECT Customer_Name
FROM superstore
WHERE Order_Date IN (
  SELECT Order_Date
  FROM superstore
  WHERE Sales > 50
  GROUP BY Order_Date
  HAVING COUNT(DISTINCT Customer_Name) >= 3
)
AND Sales > 50
GROUP BY Customer_Name
HAVING COUNT(DISTINCT Order_Date) >= 3;

-- 14.Find the maximum number of days for which total sales on each day kept rising.** --
SELECT COUNT(*) as num_days
FROM (
  SELECT Order_Date, SUM(Sales) as total_sales
  FROM superstore
  GROUP BY Order_Date
  HAVING SUM(Sales) > (
    SELECT SUM(Sales)
    FROM superstore
    WHERE Order_Date = (
      SELECT MIN(Order_Date)
      FROM superstore
    )
  )
) as subquery;



