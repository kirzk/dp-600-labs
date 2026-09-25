-- Lab 02 – Aggregate the fact table using the dimension tables.

-- Sales revenue by year and month
SELECT  d.[Year]    AS CalendarYear,
        d.[Month]   AS MonthOfYear,
        d.MonthName AS MonthName,
        SUM(so.SalesTotal) AS SalesRevenue
FROM FactSalesOrder AS so
JOIN DimDate AS d ON so.SalesOrderDateKey = d.DateKey
GROUP BY d.[Year], d.[Month], d.MonthName
ORDER BY CalendarYear, MonthOfYear;

-- Sales revenue by year, month and sales region
SELECT  d.[Year]        AS CalendarYear,
        d.[Month]       AS MonthOfYear,
        d.MonthName     AS MonthName,
        c.CountryRegion AS SalesRegion,
        SUM(so.SalesTotal) AS SalesRevenue
FROM FactSalesOrder AS so
JOIN DimDate     AS d ON so.SalesOrderDateKey = d.DateKey
JOIN DimCustomer AS c ON so.CustomerKey = c.CustomerKey
GROUP BY d.[Year], d.[Month], d.MonthName, c.CountryRegion
ORDER BY CalendarYear, MonthOfYear, SalesRegion;
