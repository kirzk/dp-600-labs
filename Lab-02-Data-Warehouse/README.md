# Lab 02 – Analyze Data in a Data Warehouse

**Course:** DATA 034 · Assignment 2 &nbsp;|&nbsp; **Tools:** Microsoft Fabric Warehouse, T-SQL, Visual query, Semantic model (Direct Lake)

## Overview

In this lab I built a small **star schema** in a Fabric data warehouse. I:

- Created and loaded the tables with T-SQL
- Queried them with both T-SQL and the visual query designer
- Wrapped a query in a reusable view
- Defined a semantic model with relationships between the fact table and the dimension tables

## What I built

| Item | Name |
|------|------|
| Workspace | `Kyrylo's WS` |
| Warehouse | `KyrylosWarehouse` |
| Tables | `DimProduct`, `DimCustomer`, `DimDate`, `FactSalesOrder` |
| View | `vSalesByRegion` |
| Semantic model | `KLL_Test_SM` (Direct Lake on SQL) |

### Data model

```mermaid
erDiagram
    DimProduct  ||--o{ FactSalesOrder : "ProductKey"
    DimCustomer ||--o{ FactSalesOrder : "CustomerKey"
    DimDate     ||--o{ FactSalesOrder : "DateKey = SalesOrderDateKey"

    FactSalesOrder {
        int SalesOrderKey
        int SalesOrderDateKey
        int ProductKey
        int CustomerKey
        int Quantity
        decimal SalesTotal
    }
    DimProduct {
        int ProductKey
        string ProductAltKey
        string ProductName
        string Category
        decimal ListPrice
    }
    DimCustomer {
        int CustomerKey
        string FirstName
        string LastName
        string City
        string CountryRegion
    }
    DimDate {
        int DateKey
        int Year
        int Month
        string MonthName
    }
```

## Steps

### 1. Create the warehouse
In the workspace I selected **New item → Warehouse** and created `KyrylosWarehouse`.

| New warehouse | Warehouse home |
|---|---|
| ![](screenshots/01-new-warehouse.png) | ![](screenshots/02-warehouse-home.png) |

### 2. Create tables and insert data
In the T-SQL editor I created the `DimProduct` table and inserted three rows. I then ran Microsoft's sample script, which created and loaded `DimCustomer`, `DimDate` and `FactSalesOrder` to complete the star schema. The DimProduct code is in [`scripts/01_create_dim_product.sql`](scripts/01_create_dim_product.sql).

| CREATE TABLE | INSERT | Loading the full schema |
|---|---|---|
| ![](screenshots/03-create-dimproduct.png) | ![](screenshots/04-insert-dimproduct.png) | ![](screenshots/06-load-star-schema-script.png) |

### 3. Query the warehouse
I joined the fact table to `DimDate` and `DimCustomer` to total sales revenue:

- by year and month
- by year, month and sales region (Canada, United Kingdom, United States)

The queries are in [`scripts/02_analytical_queries.sql`](scripts/02_analytical_queries.sql).

| Revenue by month | Revenue by month and region |
|---|---|
| ![](screenshots/07-revenue-by-month.png) | ![](screenshots/08-revenue-by-region.png) |

### 4. Create a view
I saved the regional aggregation as the view `vSalesByRegion` and then queried it directly. A view can't contain `ORDER BY`, so the sorting moved into the query that reads from it. The code is in [`scripts/03_create_view.sql`](scripts/03_create_view.sql).

| CREATE VIEW | Querying the view |
|---|---|
| ![](screenshots/09-create-view.png) | ![](screenshots/10-query-view.png) |

### 5. Build a visual query (no code)
To simulate a manager asking for one product's sales, I built this in the visual query designer:

1. Merged `FactSalesOrder` with `DimProduct` on `ProductKey` (left outer join, 4,311 of 4,311 rows matched)
2. Expanded `ProductName`
3. Filtered to **Cable Lock**

I then used **Visualize results** to chart the data.

| Merge | Expand ProductName | Filtered to Cable Lock | Visualized |
|---|---|---|---|
| ![](screenshots/11-visual-query-merge.png) | ![](screenshots/12-expand-productname.png) | ![](screenshots/13-filter-cable-lock.png) | ![](screenshots/14-visualize-results.png) |

### 6. Define the data model
I created a new semantic model with all four tables and put `FactSalesOrder` in the center. I then added three **many-to-one** relationships, each with a **single** cross-filter direction:

| From (many) | To (one) |
|---|---|
| `FactSalesOrder.ProductKey` | `DimProduct.ProductKey` |
| `FactSalesOrder.CustomerKey` | `DimCustomer.CustomerKey` |
| `FactSalesOrder.SalesOrderDateKey` | `DimDate.DateKey` |

| New semantic model | New relationship | Final star schema |
|---|---|---|
| ![](screenshots/15-new-semantic-model.png) | ![](screenshots/16-new-relationship.png) | ![](screenshots/17-star-schema-model.png) |

### 7. Clean up
At the end I deleted the workspace from **Workspace settings**.

## What I learned

- How a Fabric **warehouse** differs from a lakehouse: it gives full read/write T-SQL (`CREATE`, `INSERT`) instead of a read-only SQL endpoint.
- How a **star schema** works: numeric measures sit in the fact table, and descriptive attributes sit in the dimension tables used for slicing and grouping.
- How **views** package complex joins and aggregations into something reusable, and why `ORDER BY` goes in the query that reads the view.
- How the **visual query** designer supports joins, column expansion and filters for non-SQL users.
- How to model **relationships** (cardinality and cross-filter direction) in a semantic model so it's ready for Power BI reporting.
