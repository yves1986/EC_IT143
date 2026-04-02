/**********************************************************************
NAME: EC_IT143_W3.4_JD.sql
PURPOSE: AdventureWorks Questions and Answers

MODIFICATION LOG:
Ver    Date        Author        Description
---    ----------  -----------    ----------------------------------------
1.0    04/02/2026  John Doe       1. Built this script for EC IT143

RUNTIME:
< 5 seconds

NOTES:
This script contains 8 questions and their SQL answers.
Questions come from myself and other students in the course.
Sources: Bobby Deayee Kaye, Joseph Nesly, Victor Ogbonna, and my own questions.
**********************************************************************/

-- ============================================================
-- SECTION 1: Business User Questions - Marginal Complexity
-- ============================================================

-- ------------------------------------------------------------------
-- Q1: What are the top five most expensive products by list price?
-- Author: Bobby Deayee Kaye
-- Source: AdventureWorks, Production.Product table only
-- ------------------------------------------------------------------

SELECT TOP 5
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
WHERE ListPrice > 0
ORDER BY ListPrice DESC;

-- Expected result: Top 5 products with highest list price
-- Example: Touring-2000 Blue (ListPrice: 3399.99)


-- ------------------------------------------------------------------
-- Q2: How many customers are listed in the Sales.Customer table?
-- Author: Joseph Nesly
-- Source: AdventureWorks, Sales.Customer table
-- ------------------------------------------------------------------

SELECT COUNT(*) AS TotalCustomers
FROM Sales.Customer;

-- Expected result: A single number (e.g., 847 customers)


-- ============================================================
-- SECTION 2: Business User Questions - Moderate Complexity
-- ============================================================

-- ------------------------------------------------------------------
-- Q3: Show the category name and total sales amount for each category
-- Author: Bobby Deayee Kaye
-- Source: Tables: SalesOrderDetail, Product, ProductSubcategory, ProductCategory
-- ------------------------------------------------------------------

SELECT 
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalSalesAmount DESC;

-- Expected result: Categories like Bikes, Components, Clothing, Accessories
-- with their total sales amounts


-- ------------------------------------------------------------------
-- Q4: List employees and their managers with email addresses
-- Author: Joseph Nesly
-- Source: Tables: HumanResources.Employee, Person.Person, Person.EmailAddress
-- ------------------------------------------------------------------

SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    ea.EmailAddress,
    m.BusinessEntityID AS ManagerID,
    mp.FirstName + ' ' + mp.LastName AS ManagerName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress ea ON e.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
LEFT JOIN Person.Person mp ON m.BusinessEntityID = mp.BusinessEntityID
WHERE e.OrganizationLevel IS NOT NULL
ORDER BY e.BusinessEntityID;

-- Expected result: List of employees with their manager names and email addresses


-- ============================================================
-- SECTION 3: Business User Questions - Increased Complexity
-- ============================================================

-- ------------------------------------------------------------------
-- Q5: Monthly sales report for road bikes in 2012 showing quantity sold,
--     list price, standard cost, and estimated net revenue
-- Author: Bobby Deayee Kaye (my answer to their question)
-- Source: Tables: SalesOrderHeader, SalesOrderDetail, Product, 
--         ProductSubcategory
-- ------------------------------------------------------------------

SELECT 
    YEAR(soh.OrderDate) AS OrderYear,
    MONTH(soh.OrderDate) AS OrderMonth,
    DATENAME(month, soh.OrderDate) AS MonthName,
    SUM(sod.OrderQty) AS QuantitySold,
    AVG(p.ListPrice) AS AvgListPrice,
    AVG(p.StandardCost) AS AvgStandardCost,
    SUM(sod.LineTotal) AS TotalRevenue,
    SUM(sod.OrderQty * (p.ListPrice - p.StandardCost)) AS EstimatedNetRevenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.Name = 'Road Bikes'
    AND YEAR(soh.OrderDate) = 2012
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate), DATENAME(month, soh.OrderDate)
ORDER BY OrderYear, OrderMonth;

-- Expected result: 12 rows (one for each month of 2012) with sales metrics


-- ------------------------------------------------------------------
-- Q6: Top 10 salespeople with full name, territory, total sales, and bonus
-- Author: Victor Ogbonna
-- Source: Tables: Sales.SalesPerson, Sales.SalesOrderHeader, 
--         Person.Person, Sales.SalesTerritory
-- ------------------------------------------------------------------

SELECT TOP 10
    p.FirstName + ' ' + p.LastName AS SalesPersonName,
    st.Name AS TerritoryName,
    sp.SalesYTD AS YearToDateSales,
    sp.Bonus
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY sp.SalesYTD DESC;

-- Expected result: Top 10 salespeople ranked by Year-to-Date sales


-- ============================================================
-- SECTION 4: Metadata Questions (INFORMATION_SCHEMA Views)
-- ============================================================

-- ------------------------------------------------------------------
-- Q7: List all tables in AdventureWorks that contain a column named 
--     "ProductID" using INFORMATION_SCHEMA views
-- Author: Bobby Deayee Kaye
-- Source: INFORMATION_SCHEMA.COLUMNS
-- ------------------------------------------------------------------

SELECT DISTINCT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Expected result: Tables like Production.Product, Sales.SalesOrderDetail,
--                  Purchasing.PurchaseOrderDetail, etc.


-- ------------------------------------------------------------------
-- Q8: How many columns does each table in the Sales schema have?
--     Sorted from most columns to fewest.
-- Author: Victor Ogbonna
-- Source: INFORMATION_SCHEMA.COLUMNS
-- ------------------------------------------------------------------

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COUNT(*) AS ColumnCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
GROUP BY TABLE_SCHEMA, TABLE_NAME
ORDER BY ColumnCount DESC;

-- Expected result: Tables in Sales schema with column counts
-- Example: SalesOrderHeader (30+ columns), Customer (10+ columns), etc.


-- ============================================================
-- END OF SCRIPT
-- ============================================================
