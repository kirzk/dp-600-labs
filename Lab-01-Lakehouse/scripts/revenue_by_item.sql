-- Lab 01 – Total revenue per item
-- Run against the lakehouse's SQL analytics endpoint (read-only T-SQL).

SELECT Item, SUM(Quantity * UnitPrice) AS Revenue
FROM sales
GROUP BY Item
ORDER BY Revenue DESC;
