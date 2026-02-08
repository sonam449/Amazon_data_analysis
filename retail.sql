-- Database chreation
Create database Amazon
use Amazon;

-- Data Import
/*
for bulk import we need to first make table with matching columns and same datatypes instead Import via SQL Server Import & Export Wizard-
bulk insert RetailOrderHistory 
from "D:\N_downloads\myData\All Data Categories\Retail.OrderHistory.2\Retail.OrderHistory.2.csv"
with 
(FirstRow = 2,
  FieldTerminator = ',',
  Rowterminator = '\n',
  tablock
)
*/
-- In Object Explorer, right-click your Database → Tasks → Import Data…

-- Changing the datatype
alter table [Retail.OrderHistory.2.csv]
Alter column Order_Date date;

select top 10 * from [Retail.OrderHistory.2.csv];
'''A) Orders & Time (Overall Business Health)'''

-- 1. What is the total number of orders over time (daily, monthly, quarterly)?
-- Daily
select FORMAT(Order_Date, 'dd/MM/yyyy') Daily, 
COUNT(DISTINCT Order_ID) AS TotalOrders,
STRING_AGG(Product_Name, ',') ProductName
from [Retail.OrderHistory.2.csv]
WHERE Shipment_Status = 'Shipped'
group by FORMAT(Order_Date, 'dd/MM/yyyy')
order by COUNT(DISTINCT Order_ID) desc;

-- Monthly
select format(Order_Date, 'MM/yyyy') OrderDate,  
count(distinct Order_ID) AS TotalOrders, 
STRING_AGG(Product_Name, ', ') AllProductNames
from [Retail.OrderHistory.2.csv]
WHERE Shipment_Status = 'Shipped'
Group by format(Order_Date, 'MM/yyyy')
order by count(distinct Order_ID) desc

-- Yearly 
select format(Order_Date, 'yyyy') OrderYear,  
count(distinct Order_ID) AS TotalOrders
from [Retail.OrderHistory.2.csv]
WHERE Shipment_Status = 'Shipped'
Group by format(Order_Date, 'yyyy')
order by count(distinct Order_ID) desc

-- 2. What is the overall date range of my data (first order vs last order)?
select min([Order_Date]) minDate, max([Order_Date]) MaxDate
from [Retail.OrderHistory.2.csv];

-- 3. Are there any days/months with unusually high or low orders? (that is needs to compare with mean+-std or just mean!)
-- Daily
with dailyOrdersCTE as (
		select format(Order_Date, 'dd/MM/yyyy') OrderDate, 
		count(distinct Order_ID) AS TotalOrders
		from [Retail.OrderHistory.2.csv]
		where Shipment_Status = 'Shipped'
		group by format(Order_Date, 'dd/MM/yyyy')
), 
avg_orders as (
		select avg(TotalOrders) avgOrders
		from dailyOrdersCTE)

SELECT
    d.OrderDate,
    d.TotalOrders,
    CASE
        WHEN d.TotalOrders > a.avgOrders THEN 'Above Average'
        WHEN d.TotalOrders < a.avgOrders THEN 'Below Average'
        ELSE 'Average'
    END AS OrderTag
FROM dailyOrdersCTE d
CROSS JOIN avg_orders a
ORDER BY d.OrderDate;

-- Monthly
WITH monthOrderCTE AS (
SELECT FORMAT(Order_date, 'MM/yyyy') OrderMonth,
		count(distinct Order_ID) MonthOrd
		FROM [Retail.OrderHistory.2.csv]
		WHERE Shipment_Status = 'Shipped'
		GROUP BY FORMAT(Order_date, 'MM/yyyy')
		), 
monthAvgOrders as (
select avg(MonthOrd) MonthAvgOrd
from monthOrderCTE
)

select m.OrderMonth, 
m.MonthOrd,
CASE WHEN m.MonthOrd > ma.MonthAvgOrd then 'More than Avg'
		when m.MonthOrd < ma.MonthAvgOrd then 'Less than Avg'
		else 'Avg'
		end as MonthTag
from monthOrderCTE m CROSS JOIN monthAvgOrders ma
order by m.OrderMonth;

-- 4. How many unique orders exist vs total rows (to confirm that one order can have multiple items)?












