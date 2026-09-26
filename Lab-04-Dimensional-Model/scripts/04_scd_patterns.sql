-- Lab 04 – Slowly changing dimensions on d_Product

------------------------------------------------------------------
-- SCD Type 2: UnitCost of Mountain Bike Pro rises 1200 -> 1350
-- (history is kept so margin analysis stays correct)
------------------------------------------------------------------

-- Step 1: Expire the current version of Mountain Bike Pro
UPDATE d_Product
SET ValidTo = '2026-03-01',
    IsCurrent = 0
WHERE ProductNaturalKey = 'MB-PRO'
  AND IsCurrent = 1;

-- Step 2: Insert the new version with updated cost (new surrogate key = 6)
INSERT INTO d_Product VALUES
(6, 'MB-PRO', 'Mountain Bike Pro', 'AdventureWorks', 'Mountain Bikes', 'Bikes',
 1350.00, '2026-03-01', '9999-12-31', 1);

-- Step 3: A sale after the cost change references the new product version
INSERT INTO f_Sales VALUES
(20260504, 1, 6, 5, 1, 1500.00, 1500.00, 0.00);

-- Check: each sale keeps the cost that was in effect when it happened
SELECT
    d.FullDate,
    p.ProductName,
    p.UnitCost  AS ProductCostVersion,
    p.ValidFrom AS CostEffectiveDate,
    f.Quantity,
    f.SalesAmount
FROM f_Sales f
JOIN d_Date d    ON f.DateKey = d.DateKey
JOIN d_Product p ON f.ProductKey = p.ProductKey
WHERE p.ProductNaturalKey = 'MB-PRO'
ORDER BY d.FullDate;

------------------------------------------------------------------
-- SCD Type 1: name correction overwrites all history
------------------------------------------------------------------
UPDATE d_Product
SET ProductName = 'Insulated Water Bottle'
WHERE ProductNaturalKey = 'WB-STD';

-- Verify both changes
SELECT ProductKey, ProductNaturalKey, ProductName, UnitCost, ValidFrom, ValidTo, IsCurrent
FROM d_Product
ORDER BY ProductNaturalKey, ValidFrom;
