# Lab 07 – Transform Data Using Dataflows (Gen2) in Microsoft Fabric

**Course:** DATA 034 · Assignment 7 &nbsp;|&nbsp; **Tools:** Dataflow Gen2, Power Query editor, Power Query M, Lakehouse

## Overview

In this lab I used **Dataflow Gen2** to clean and prepare sales data **without writing Spark or T-SQL code**. A dataflow uses the **Power Query editor**, the same tool many people already know from Excel and Power BI Desktop, so it's a good fit for teams that want a low-code way to prepare data.

I built a dataflow that:

1. Connects to a sample `orders.csv` file
2. Chooses columns, filters rows and sets data types
3. Renames columns and adds a calculated **Unit Price** column
4. Loads the result into a **lakehouse table**
5. Gets a fix (a **Round** step) after I checked the loaded table

The full query is in [`scripts/orders_dataflow.pq`](scripts/orders_dataflow.pq).

## What I built

| Item | Name | Role |
|------|------|------|
| Workspace | `lab7_ws` | |
| Lakehouse | `lab7_lakehouse` (with schemas, `dbo`) | **Destination** for the dataflow output |
| Dataflow Gen2 | `dataflow 1` (query `orders`) | **Transforms** the CSV with Power Query |
| Lakehouse table | `dbo.orders` | **Stores** the cleaned data (542 rows) |

```mermaid
flowchart LR
    CSV[orders.csv<br/>GitHub, anonymous] --> PQ[Dataflow Gen2<br/>dataflow 1]
    subgraph PQ_STEPS[Power Query steps]
        direction TB
        A[Choose columns] --> B[Filter rows<br/>OrderDate not empty<br/>OrderQty > 0]
        B --> C[Set data types] --> D[Rename columns]
        D --> E[Add Unit Price] --> F[Round to 2 decimals]
    end
    PQ --- PQ_STEPS
    PQ -->|Save and run<br/>Replace| LH[(lab7_lakehouse<br/>dbo.orders)]
```

## Steps

### 1. Create a workspace
I created a new workspace called `lab7_ws` with the default licensing mode. It opened empty, as expected.

| Create a workspace | Empty workspace |
|---|---|
| ![](screenshots/01-create-workspace.png) | ![](screenshots/02-empty-workspace.png) |

### 2. Create a lakehouse
From **New item → Store data → Lakehouse** I created `lab7_lakehouse`. **Lakehouse schemas** was checked, so the lakehouse has a `dbo` schema under **Tables**.

| New lakehouse | Empty lakehouse |
|---|---|
| ![](screenshots/03-new-lakehouse.png) | ![](screenshots/04-lakehouse-home.png) |

### 3. Create a Dataflow Gen2 and connect to the CSV file
From the lakehouse I selected **Get data → New Dataflow Gen2** and kept the name `dataflow 1`. Because I started from the lakehouse, the Power Query editor already had it set as the **default destination**.

| Get data → New Dataflow Gen2 | Power Query editor |
|---|---|
| ![](screenshots/05-get-data-new-dataflow.png) | ![](screenshots/06-power-query-editor.png) |

I chose **Import from a Text/CSV file**, used **Link to file** with `orders.csv` from the Microsoft Learning GitHub repo, and created a new connection with **Anonymous** authentication and no gateway. Fabric warned that the connection name was too long and would be truncated, but that didn't cause any problem.

The preview showed seven columns: `SalesOrderID`, `OrderDate`, `CustomerID`, `LineItem`, `ProductID`, `OrderQty` and `LineItemTotal`. After **Create**, the query opened with the first steps already added.

| Connection settings | Preview file data | Query in the editor |
|---|---|---|
| ![](screenshots/07-csv-connection-settings.png) | ![](screenshots/08-preview-file-data.png) | ![](screenshots/09-initial-query.png) |

### 4. Choose columns
With **Home → Choose columns** I unchecked `SalesOrderID` and `ProductID` and kept the other five. Keeping only the columns I need means later steps process less data.

| Choose columns | Five columns left |
|---|---|
| ![](screenshots/10-choose-columns.png) | ![](screenshots/11-five-columns.png) |

### 5. Filter rows
I added two filters:

- `OrderDate` → **Remove empty**, which keeps rows where the date isn't null or empty text
- `OrderQty` → **Number filters → Greater than** `0`, which removes zero and negative quantities

```m
Table.SelectRows(#"Filtered rows", each [OrderQty] > 0)
```

| Remove empty dates | Quantity greater than 0 |
|---|---|
| ![](screenshots/12-remove-empty-orderdate.png) | ![](screenshots/13-orderqty-greater-than-0.png) |

### 6. Set data types
On the **Transform** tab I checked the types that matter for sorting, filtering and calculations:

| Column | Type |
|---|---|
| `OrderDate` | Date |
| `OrderQty` | Whole number |
| `LineItemTotal` | Decimal number |

| OrderDate | OrderQty | LineItemTotal |
|---|---|---|
| ![](screenshots/14-type-orderdate-date.png) | ![](screenshots/15-type-orderqty-whole-number.png) | ![](screenshots/16-type-linetotal-decimal.png) |

### 7. Rename columns
I renamed `OrderQty` → **Quantity**, `LineItemTotal` → **Line Total** and `LineItem` → **Item**. Renaming usually breaks **query folding**, so it's better to do it after the steps that can be folded.

![Renamed columns](screenshots/17-renamed-columns.png)

### 8. Add a calculated column
With **Add column → Custom column** I added **Unit Price** (Decimal number):

```m
[Line Total] / [Quantity]
```

The values were correct, but some had many decimal places. For example, 406.79 / 6 = 67.79833333.

| Custom column | Unit Price in the preview |
|---|---|
| ![](screenshots/18-custom-column-unit-price.png) | ![](screenshots/19-unit-price-preview.png) |

### 9. Review the applied steps and the data destination
The **Applied steps** list showed every transformation in order: Source, Promoted headers, Changed column type, Choose columns, two Filtered rows steps, Renamed columns and Added custom. The icons next to some steps show whether a step can be **folded** to the source. A CSV file doesn't support folding, so none were green, but the icons matter when the source is a database.

The data destination was already **Lakehouse**: workspace `lab7_ws`, lakehouse `lab7_lakehouse`, update method **Replace**, and automatic column mapping that allows schema changes.

| Applied steps | Data destination |
|---|---|
| ![](screenshots/20-applied-steps.png) | ![](screenshots/21-data-destination.png) |

### 10. Publish and verify the results
**Save and run** publishes the dataflow and starts the first refresh. When it finished, `dataflow 1` had a green check mark in the workspace.

The `dbo.orders` table had **542 rows** with only my selected columns plus **Unit Price**. As I expected, Unit Price had inconsistent decimals, such as `67.79833333333333` and `5.394`.

| Workspace after refresh | Loaded table (not rounded) |
|---|---|
| ![](screenshots/22-workspace-after-refresh.png) | ![](screenshots/23-orders-table-unrounded.png) |

To fix it, I went back to the dataflow, selected **Unit Price** and used **Transform → Rounding → Round** with **2** decimal places. This added a **Rounded off** step at the end:

```m
Table.TransformColumns(#"Added custom", {{"Unit Price", each Number.Round(_, 2), type number}})
```

In the preview, 218.455 became 218.46 and 67.79833333 became 67.8.

| Round dialog | Rounded preview | Rounded off step |
|---|---|---|
| ![](screenshots/24-round-dialog.png) | ![](screenshots/25-rounded-preview.png) | ![](screenshots/26-rounded-off-step.png) |

After another **Save and run**, the lakehouse table showed Unit Price with at most two decimals, such as 32.39, 41.99 and 5.39.

![Rounded orders table](screenshots/27-orders-table-rounded.png)

### 11. Clean up
To clean up, I would go to **Workspace settings → General → Remove this workspace → Delete**. This removes `lab7_ws` together with the dataflow and the lakehouse.

## Reflection

This lab showed me how **Dataflow Gen2** lets me prepare data with Power Query and load it into a lakehouse without writing code. I liked that every action became a visible step in **Applied steps**. That makes the logic easy to review, change and explain to other people on a team. Creating the dataflow from the lakehouse also set the destination for me, which saved some work.

**The order of steps matters.** With query folding, Power Query sends operations back to the source. Choosing columns, filtering rows and changing types can usually be folded, so they should come first. Renaming and custom columns should come later. My CSV source doesn't support folding, so I couldn't see the effect, but I now understand what the icons mean and why order matters with a database source.

The **Unit Price** column showed why I must **verify the output after loading**. The calculation was right, but values like `67.79833333333333` aren't good for reporting. One small Round step fixed it. I also noticed that the row order in the lakehouse table was different from the Power Query preview, so I shouldn't depend on row order in a table.

Dataflows are useful for teams that already know Power Query, because the same skills work at a larger scale. Next, I'd like to use a source that supports query folding, schedule a refresh, and try Copilot to create steps from natural language. The lab gave me a clear process: clean the data, calculate new columns, load to a lakehouse, and always check the result.
