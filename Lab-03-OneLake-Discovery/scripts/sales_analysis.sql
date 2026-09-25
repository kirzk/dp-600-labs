-- Lab 03 – Queries run through the SQL analytics endpoint of the lakehouse
-- that holds the `sales` shortcut (no data copied from the source lakehouse).

-- Total revenue and quantity sold per item
SELECT
    Item,
    SUM(Quantity * UnitPrice) AS TotalRevenue,
    SUM(Quantity) AS TotalQuantity
FROM sales
GROUP BY Item
ORDER BY TotalRevenue DESC;

-- Top 5 customers by revenue
SELECT TOP 5
    CustomerName,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM sales
GROUP BY CustomerName
ORDER BY TotalRevenue DESC;
