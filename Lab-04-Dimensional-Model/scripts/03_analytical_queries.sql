-- Lab 04 – Querying the star schema from different angles

-- Sales by month and product category
-- (grouping by d.[Month] too keeps months in calendar order)
SELECT
    d.MonthName,
    p.Category,
    SUM(f.SalesAmount)    AS TotalSales,
    SUM(f.Quantity)       AS TotalQuantity,
    SUM(f.DiscountAmount) AS TotalDiscounts
FROM f_Sales f
JOIN d_Date d    ON f.DateKey = d.DateKey
JOIN d_Product p ON f.ProductKey = p.ProductKey
GROUP BY d.MonthName, d.[Month], p.Category
ORDER BY d.[Month], p.Category;

-- Sales by store region and customer segment
SELECT
    s.Region,
    c.Segment,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(*)           AS TransactionCount
FROM f_Sales f
JOIN d_Store s    ON f.StoreKey = s.StoreKey
JOIN d_Customer c ON f.CustomerKey = c.CustomerKey
GROUP BY s.Region, c.Segment
ORDER BY s.Region, c.Segment;
