// Lab 07 – Power Query (M) for the "orders" query in Dataflow Gen2 "dataflow 1".
// Reconstructed from the Applied steps built in the Power Query editor.
// Destination: lab7_lakehouse (dbo.orders), update method Replace, automatic column mapping.

let
    // Source: orders.csv from the Microsoft Learning GitHub repo (Anonymous connection, no gateway)
    Source = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/MicrosoftLearning/dp-data/main/orders.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.None]
    ),
    #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {
        {"SalesOrderID", Int64.Type}, {"OrderDate", type date}, {"CustomerID", Int64.Type},
        {"LineItem", Int64.Type}, {"ProductID", Int64.Type}, {"OrderQty", Int64.Type},
        {"LineItemTotal", type number}
    }),

    // Task 4: keep only the columns needed for analysis
    #"Choose columns" = Table.SelectColumns(#"Changed column type",
        {"OrderDate", "CustomerID", "LineItem", "OrderQty", "LineItemTotal"}),

    // Task 5: remove rows with an empty order date, then rows with zero/negative quantity
    #"Filtered rows" = Table.SelectRows(#"Choose columns", each [OrderDate] <> null and [OrderDate] <> ""),
    #"Filtered rows 1" = Table.SelectRows(#"Filtered rows", each [OrderQty] > 0),

    // Task 7: friendlier column names (done after the foldable steps)
    #"Renamed columns" = Table.RenameColumns(#"Filtered rows 1", {
        {"OrderQty", "Quantity"}, {"LineItemTotal", "Line Total"}, {"LineItem", "Item"}
    }),

    // Task 8: calculated column
    #"Added custom" = Table.TransformColumnTypes(
        Table.AddColumn(#"Renamed columns", "Unit Price", each [Line Total] / [Quantity]),
        {{"Unit Price", type number}}
    ),

    // Task 10 fix: round Unit Price to 2 decimal places
    #"Rounded off" = Table.TransformColumns(#"Added custom",
        {{"Unit Price", each Number.Round(_, 2), type number}})
in
    #"Rounded off"
