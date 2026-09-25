-- Lab 02 – Create the DimProduct dimension table and insert sample rows.

CREATE TABLE dbo.DimProduct
(
    ProductKey    INTEGER      NOT NULL,
    ProductAltKey VARCHAR(25)  NULL,
    ProductName   VARCHAR(50)  NOT NULL,
    Category      VARCHAR(50)  NULL,
    ListPrice     DECIMAL(5,2) NULL
);
GO

INSERT INTO dbo.DimProduct
VALUES
(1, 'RING1',  'Bicycle bell', 'Accessories', 5.99),
(2, 'BRITE1', 'Front light',  'Accessories', 15.49),
(3, 'BRITE2', 'Rear light',   'Accessories', 15.49);
GO

-- The remaining tables (DimCustomer, DimDate, FactSalesOrder) were created and
-- populated with Microsoft's sample script:
-- https://raw.githubusercontent.com/MicrosoftLearning/dp-data/main/create-dw.txt
