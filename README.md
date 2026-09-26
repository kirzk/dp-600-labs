# DP-600: Microsoft Fabric Analytics Engineer – Hands-on Labs

This repository contains my completed hands-on labs for the **DP-600 (Microsoft Certified: Fabric Analytics Engineer Associate)** learning path, which I worked through as part of my data analytics studies at SAIT (Southern Alberta Institute of Technology), Calgary.

The goal of this repository is to document my practical experience with **Microsoft Fabric** — building lakehouses and data warehouses, discovering and connecting to data in OneLake, designing dimensional models, loading and querying data with SQL, and preparing semantic models for reporting in Power BI.

---

## 📂 Labs

| # | Lab | Key skills |
|---|-----|-----------|
| 1 | [Get started with a lakehouse in Microsoft Fabric](./Lab-01-Lakehouse) | Workspaces, lakehouses, uploading files, loading data into Delta tables, querying with the SQL analytics endpoint |
| 2 | [Analyze data in a data warehouse](./Lab-02-Data-Warehouse) | Creating a warehouse, creating tables and inserting data with T-SQL, querying tables, creating views, visual queries, defining a data model |
| 3 | [Discover and connect to data in OneLake](./Lab-03-OneLake-Discovery) | OneLake catalog, Delta Lake file structure, OneLake shortcuts, T-SQL aggregation queries, Direct Lake semantic models, Explore this data |
| 4 | [Design and implement a dimensional model](./Lab-04-Dimensional-Model) | Star schema design, fact and dimension tables, grain and measures, surrogate and natural keys, NOT ENFORCED primary/foreign keys, SCD Type 1 and Type 2 |
| … | *More labs will be added as the course continues* | |

Each lab folder contains:
- **Screenshots** of each completed step
- **SQL scripts / notebooks** used in the lab (where applicable)
- A short **reflection** on what I learned

---

## 🛠️ Tools & Technologies

- Microsoft Fabric (Lakehouse, Data Warehouse, SQL analytics endpoint)
- OneLake (catalog, shortcuts)
- T-SQL (DDL, DML, table constraints, analytical queries)
- Delta Lake tables (Parquet + transaction log)
- Dimensional modeling (star schema, slowly changing dimensions)
- Power BI (semantic models, Direct Lake, visual queries, Explore this data)

---

## 📁 Repository Structure

```
DP-600-Labs/
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
├── Lab-04-Dimensional-Model/
│   ├── screenshots/
│   ├── scripts/
│   └── README.md
└── README.md
```

---

## 💡 Key Takeaways

- How the **lakehouse** and **data warehouse** approaches differ in Microsoft Fabric, and when to use each
- How to organize work in Fabric **workspaces**
- How to find data across an organization with the **OneLake catalog**
- How **shortcuts** let teams share one copy of data instead of duplicating it
- How to create tables, load data and write analytical queries with **T-SQL**
- How to design a **star schema**: choosing the grain, separating facts from dimensions, and knowing which measures are additive
- How **slowly changing dimensions** keep history accurate (Type 2) or apply corrections to all history (Type 1)
- How to build **views**, **data models** and **semantic models** that make data ready for reporting

---

## 📌 About the Labs

The labs are based on the official Microsoft Learn exercises for Microsoft Fabric and were completed in a lab environment provided through my course. The course materials and assignment instructions belong to their respective owners; this repository only contains my own work.

---

## 👤 Author

**Kyrylo Tsyrulik**
Data Analytics student | Calgary, Alberta
[LinkedIn](https://www.linkedin.com/in/kll-zk) · [GitHub](https://github.com/kirzk)
