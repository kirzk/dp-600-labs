# Lab 06 – Get Started with Real-Time Intelligence in Microsoft Fabric

**Course:** DATA 034 · Assignment 6 &nbsp;|&nbsp; **Tools:** Real-Time hub, Eventstream, Eventhouse, KQL database, KQL (Kusto Query Language), Real-Time Dashboard, Activator

## Overview

My earlier labs used data that was already stored in a lakehouse or a warehouse. In this lab the data **keeps arriving**: a live stream of stock market events. I had to capture it, store it, query it, show it on a dashboard and react to it while it's still fresh.

I built the whole flow end to end:

1. An **eventstream** that ingests the *Stock market* sample source
2. An **eventhouse** with a **KQL database** that stores the stream in a table
3. **KQL queries** on the live data
4. A **Real-Time Dashboard** with a column chart
5. An **Activator** alert that fires when prices rise

The KQL queries are in [`scripts/stock_queries.kql`](scripts/stock_queries.kql).

## What I built

| Item | Name | Role |
|------|------|------|
| Workspace | `Kyrylo's WS` | |
| Eventstream | `stock-data` (source `stock`, stream `stock-data-stream`) | **Ingests** live stock events |
| Eventhouse / KQL database | `stock-store-eventhouse` | **Stores** events in the `stock` table |
| KQL queryset | `stock-store-eventhouse_queryset` | **Queries** the table |
| Real-Time Dashboard | `Stock Dashboard` | **Shows** average price per symbol |
| Activator | `test_activator` (rule `test_rule`) | **Reacts** by sending an email when the price rises |

```mermaid
flowchart LR
    SRC[Stock market<br/>sample source] --> ES[Eventstream<br/>stock-data]
    ES -->|stock-data-stream| KQL[(Eventhouse / KQL DB<br/>stock-store-eventhouse<br/>table: stock)]
    KQL --> QS[KQL queryset<br/>avg bidPrice by symbol]
    QS --> DB[Real-Time Dashboard<br/>Stock Dashboard]
    DB --> ACT{{Activator<br/>test_rule}}
    ACT -->|avgPrice increases by 100| MAIL[Email alert]
```

## Steps

### 1. Create an eventstream
I started in the **Real-Time hub**, the central place in Fabric for streaming data. I selected **Add data**, which lists sources such as Azure Event Hubs, Azure SQL DB (CDC) and Real-time weather. I picked the **Stock market** sample, which streams bid prices, volumes and event times.

| Real-Time hub | Add data sources |
|---|---|
| ![](screenshots/01-real-time-hub.png) | ![](screenshots/02-add-data-sources.png) |

I set these names:

- source: `stock`
- eventstream: `stock-data`
- stream: `stock-data-stream` (the default)

After I connected, the eventstream canvas showed the source linked to the stream. The data preview already had live events with `time`, `symbol`, `sector`, `securityType`, `bidPrice` and `bidSize` for three symbols: **HOOJ**, **NSFT** and **BMZM**. At this point, the data was only being ingested, not stored.

| Configure the source | Review + connect | Eventstream with live preview |
|---|---|---|
| ![](screenshots/03-configure-stock-source.png) | ![](screenshots/04-review-and-connect.png) | ![](screenshots/05-eventstream-live-preview.png) |

### 2. Create an eventhouse and load the stream into a table
I created the eventhouse `stock-store-eventhouse`, which automatically contains a KQL database with the same name. The database started empty, so I used **Get data → Eventstream → Existing eventstream** and configured it:

- new table: `stock`
- source: the `stock-data-stream` stream
- data connection: `stock-data`

On the **Inspect** step, Fabric read 50 sample events in JSON format and mapped them to columns.

| Eventhouse overview | Empty KQL database |
|---|---|
| ![](screenshots/06-eventhouse-overview.png) | ![](screenshots/07-empty-kql-database.png) |

| Destination table and source | Inspect the data |
|---|---|
| ![](screenshots/08-destination-table-config.png) | ![](screenshots/09-inspect-stream-data.png) |

Back in the Real-Time hub, the eventstream canvas now showed a **destination**: the KQL table. The stream was now being captured, not just ingested.

![Eventstream with destination](screenshots/10-eventstream-with-destination.png)

### 3. Query the captured data with KQL
In the eventhouse's queryset, I first previewed the table:

```kql
stock
| take 100
```

It returned 100 records with columns such as `bidPrice`, `askPrice`, `lastSalePrice`, `volume` and `marketPercent`.

![take 100](screenshots/11-kql-take-100.png)

Then I calculated the **average bid price per symbol over the last five minutes**. In this query:

- `ago(5m)` keeps only the latest data.
- `todecimal()` converts the bid price to a number before averaging.

```kql
stock
| where ["time"] > ago(5m)
| summarize avgPrice = avg(todecimal(bidPrice)) by symbol
| project symbol, avgPrice
```

The first run returned about **1,320 for HOOJ**, **341 for NSFT** and **2,287 for BMZM**. When I ran it again a few seconds later, the averages had shifted slightly; NSFT went from about 340.79 to about 341.00. That shows new events are still flowing into the table.

| First run | Second run a few seconds later |
|---|---|
| ![](screenshots/12-avg-price-first-run.png) | ![](screenshots/13-avg-price-second-run.png) |

### 4. Build a Real-Time Dashboard
I used **Save to Dashboard → To a new Dashboard** to pin the average-price query as a tile on **Stock Dashboard**. In editing mode I renamed the tile and changed its visual type from **Table** to **Column chart**. The final chart shows BMZM with the highest average price, HOOJ in the middle and NSFT the lowest, and it updates live.

| Pinned as a table | Changing the visual type | Live column chart |
|---|---|---|
| ![](screenshots/14-dashboard-table-tile.png) | ![](screenshots/15-change-to-column-chart.png) | ![](screenshots/16-dashboard-column-chart.png) |

### 5. Create an alert with Activator
From the dashboard I selected **Add alert** and created the rule `test_rule` on the tile:

| Setting | Value |
|---|---|
| Source | Stock Dashboard tile (query runs every 5 minutes) |
| Check | On each event when |
| Grouping field | `symbol` |
| Condition | `avgPrice` **increases by 100** |
| Occurrence | Every time the condition is met |
| Action | Email |
| Saved in | New activator item `test_activator` |

The rule was saved with the status **Running**.

| Rule configuration | Rule running |
|---|---|
| ![](screenshots/17-activator-rule-config.png) | ![](screenshots/18-rule-running.png) |

The workspace then held every item from the lab. The rule's **History** tab showed **0 activations**. That's expected, because the average price never rose by 100 during the lab.

| Workspace items | Rule history |
|---|---|
| ![](screenshots/19-workspace-items.png) | ![](screenshots/20-rule-history.png) |

### 6. Clean up
At the end I removed the workspace from **Workspace settings → General → Remove this workspace**. Fabric keeps a deleted workspace for a 7-day retention period.

## Reflection

This lab showed me how **Real-Time Intelligence** differs from the batch-style work in my earlier labs. There, I loaded data once and then queried it. Here, an eventstream brings in events continuously, and each item has its own job:

- the **eventstream** ingests
- the **eventhouse** stores
- the **KQL database** holds the table
- the **dashboard** shows
- **Activator** reacts

Checking that a destination really appeared on the eventstream canvas helped me see how the pieces connect.

The most interesting part for me was **KQL**. Unlike T-SQL, the data flows through a pipeline with the `|` (pipe) symbol, one step after another. `where ["time"] > ago(5m)` made it easy to look only at the latest data, and `summarize … by symbol` gave an average per stock. Running the same query twice and getting slightly different results was simple but clear proof that the table was being filled by a live stream. Needing `todecimal()` before averaging reminded me to always check data types.

The **Real-Time Dashboard** turned the query into a live chart with just a few clicks. **Activator** showed how to move from watching data to acting on it. The empty alert history taught me that an alert needs a sensible threshold and check interval. In a real project, I would also add transformations in the eventstream to aggregate the data over time windows.

The main lesson is that real-time analytics doesn't need a complicated setup: a few connected items can take data from a stream to a table, a chart and an alert. It also matters to clean up afterwards, because a running eventstream and eventhouse use capacity. Next, I'd like to try this with a real business stream, such as sales or sensor events, and add transformations before the data is stored.
