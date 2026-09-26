-- Lab 04 – Keys are added with ALTER TABLE (not inside CREATE TABLE) and are
-- NOT ENFORCED: they document relationships as metadata and let Power BI
-- detect them automatically, but the warehouse does not validate the data.

-- Primary keys on dimension tables
ALTER TABLE d_Date
    ADD CONSTRAINT PK_d_Date PRIMARY KEY NONCLUSTERED (DateKey) NOT ENFORCED;

ALTER TABLE d_Store
    ADD CONSTRAINT PK_d_Store PRIMARY KEY NONCLUSTERED (StoreKey) NOT ENFORCED;

ALTER TABLE d_Product
    ADD CONSTRAINT PK_d_Product PRIMARY KEY NONCLUSTERED (ProductKey) NOT ENFORCED;

ALTER TABLE d_Customer
    ADD CONSTRAINT PK_d_Customer PRIMARY KEY NONCLUSTERED (CustomerKey) NOT ENFORCED;

-- Foreign keys on the fact table (same pattern for StoreKey, ProductKey, CustomerKey)
ALTER TABLE f_Sales
    ADD CONSTRAINT FK_Sales_Date FOREIGN KEY (DateKey)
    REFERENCES d_Date(DateKey) NOT ENFORCED;
