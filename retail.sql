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
-- 1. What is the total number of orders over time (daily, monthly, quarterly)?
-- Daily
select FORMAT(Order_Date, 'dd/MM/yyyy') Daily, 
COUNT(DISTINCT Order_ID) AS TotalOrders,
STRING_AGG(Product_Name, ',') ProductName
from [Retail.OrderHistory.2.csv]
group by FORMAT(Order_Date, 'dd/MM/yyyy')
order by COUNT(DISTINCT Order_ID) desc;

-- Monthly
select format(Order_Date, 'MM/yyyy') OrderDate,  
count(distinct Order_ID) AS TotalOrders, 
STRING_AGG(Product_Name, ', ') AllProductNames
from [Retail.OrderHistory.2.csv]
Group by format(Order_Date, 'MM/yyyy')
order by count(distinct Order_ID) desc

-- Yearly 
select format(Order_Date, 'yyyy') OrderYear,  
count(distinct Order_ID) AS TotalOrders
from [Retail.OrderHistory.2.csv]
Group by format(Order_Date, 'yyyy')
order by count(distinct Order_ID) desc

-- 2. What is the overall date range of my data (first order vs last order)?
select min([Order_Date]) minDate, max([Order_Date]) MaxDate
from [Retail.OrderHistory.2.csv];

















