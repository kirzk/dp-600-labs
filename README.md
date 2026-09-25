# DP-600: Microsoft Fabric Analytics Engineer – Hands-on Labs

![Microsoft Fabric](https://img.shields.io/badge/Microsoft%20Fabric-117865?logo=microsoft&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=black)
![Delta Lake](https://img.shields.io/badge/Delta%20Lake-00ADD4)

This repository holds my completed hands-on labs for **DATA 034**, a course at SAIT (Southern Alberta Institute of Technology) in Calgary. The course follows the **DP-600: Microsoft Certified Fabric Analytics Engineer Associate** learning path.

The labs document my practical experience with **Microsoft Fabric**:

- building lakehouses and data warehouses
- loading and querying data with T-SQL
- discovering and sharing data through OneLake
- preparing semantic models for Power BI reporting

---

## 📂 Labs

| # | Lab | Key skills |
|---|-----|-----------|
| 1 | [Get started with a lakehouse in Microsoft Fabric](./Lab-01-Lakehouse) | Workspaces, lakehouses, uploading files, loading CSV data into Delta tables, SQL analytics endpoint, no-code visual queries |
| 2 | [Analyze data in a data warehouse](./Lab-02-Data-Warehouse) | Creating a warehouse, building a star schema with T-SQL, analytical joins and aggregations, views, visual queries, semantic model relationships |
| 3 | [Discover and connect to data in OneLake](./Lab-03-OneLake-Discovery) | OneLake catalog, OneLake shortcuts (no data copied), querying shortcut tables with T-SQL, Direct Lake semantic models, Explore this data |

Each lab folder contains:
- a **README** walking through each step with screenshots
- a **`scripts/`** folder with the SQL I wrote and ran
- a **`screenshots/`** folder with captures from my Fabric workspace

---

## 🛠️ Tools & Technologies

- **Microsoft Fabric:** Lakehouse, Data Warehouse, SQL analytics endpoint, OneLake catalog, shortcuts
- **T-SQL:** DDL/DML, joins, aggregations, views
- **Delta Lake / Parquet** table storage
- **Power Query**-based visual queries
- **Power BI semantic models** (Direct Lake), relationships, Explore this data

---

## 📁 Repository Structure

```
dp-600-labs/
├── Lab-01-Lakehouse/
│   ├── screenshots/
│   ├── scripts/
│   └── README.md
├── Lab-02-Data-Warehouse/
│   ├── screenshots/
│   ├── scripts/
│   └── README.md
├── Lab-03-OneLake-Discovery/
│   ├── screenshots/
│   ├── scripts/
│   └── README.md
└── README.md
```

---

## 💡 Key Takeaways

- The **lakehouse** and **data warehouse** approaches in Microsoft Fabric differ, and each suits different cases:

  | | Lakehouse | Warehouse |
  |---|---|---|
  | Storage | Files and Delta tables | Relational tables |
  | SQL access | Read-only SQL endpoint | Full read/write T-SQL |

- Raw files become queryable **Delta tables**, and the `_delta_log` tracks every change.
- A **star schema** separates facts from dimensions, and **views** make that model easier to reuse.
- **OneLake shortcuts** let teams share data across lakehouses and workspaces without duplicating it.
- **Semantic models** turn tables into a model ready for reporting, with relationships and a single cross-filter direction.

---

## 📌 About the Labs

The labs are based on the official Microsoft Learn exercises for Microsoft Fabric. I completed them in a Fabric trial and lab environment provided through my course. The course materials and assignment instructions belong to their respective owners. This repository contains only my own work: the steps I performed, my screenshots, my SQL and my notes.

---

## 👤 Author

**Kyrylo Tsyrulik**
Data Analytics student | Calgary, Alberta
[GitHub](https://github.com/kirzk)
