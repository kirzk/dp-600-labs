-- Lab 02 – Wrap the regional aggregation in a reusable view.
-- (ORDER BY is not allowed inside a view, so sorting happens when it is queried.)

CREATE VIEW vSalesByRegion
AS
SELECT  d.[Year]        AS CalendarYear,
        d.[Month]       AS MonthOfYear,
        d.MonthName     AS MonthName,
        c.CountryRegion AS SalesRegion,
        SUM(so.SalesTotal) AS SalesRevenue
FROM FactSalesOrder AS so
JOIN DimDate     AS d ON so.SalesOrderDateKey = d.DateKey
JOIN DimCustomer AS c ON so.CustomerKey = c.CustomerKey
GROUP BY d.[Year], d.[Month], d.MonthName, c.CountryRegion;
GO

SELECT CalendarYear, MonthName, SalesRegion, SalesRevenue
FROM vSalesByRegion
ORDER BY CalendarYear, MonthOfYear, SalesRegion;
