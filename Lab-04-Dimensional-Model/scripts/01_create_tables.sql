-- Lab 04 – Star schema tables for Contoso Retail (Fabric Warehouse: ContosoDW)

-- Fact table: grain = one row per sales transaction line item.
-- No primary key on purpose – it adds storage without helping analysis.
CREATE TABLE f_Sales
(
    DateKey        INT            NOT NULL,
    StoreKey       INT            NOT NULL,
    ProductKey     INT            NOT NULL,
    CustomerKey    INT            NOT NULL,
    Quantity       INT            NOT NULL,
    UnitPrice      DECIMAL(10,2)  NOT NULL,
    SalesAmount    DECIMAL(10,2)  NOT NULL,
    DiscountAmount DECIMAL(10,2)  NOT NULL
);

-- Date dimension: uses YYYYMMDD integer format as surrogate key
CREATE TABLE d_Date
(
    DateKey       INT          NOT NULL,
    FullDate      DATE         NOT NULL,
    [Year]        INT          NOT NULL,
    [Quarter]     INT          NOT NULL,
    [Month]       INT          NOT NULL,
    MonthName     VARCHAR(10)  NOT NULL,
    [Day]         INT          NOT NULL,
    [DayOfWeek]   VARCHAR(10)  NOT NULL,
    FiscalYear    INT          NOT NULL,
    FiscalQuarter INT          NOT NULL,
    IsHoliday     BIT          NOT NULL,
    IsWeekday     BIT          NOT NULL
);

-- d_Store, d_Product and d_Customer were created in the same script.
-- d_Store and d_Product carry a natural key plus SCD Type 2 tracking columns
-- (ValidFrom, ValidTo, IsCurrent); d_Customer only needs Type 1 corrections.
-- d_Product columns: ProductKey, ProductNaturalKey, ProductName, Brand,
--                    Subcategory, Category, UnitCost, ValidFrom, ValidTo, IsCurrent
