## Architecture Recommendation

For a fast-growing food delivery startup collecting GPS location logs, customer text reviews, payment transactions, and restaurant menu images, I would recommend a **Data Lakehouse** architecture.

**Reason 1 — Heterogeneous data types that no single system handles well.**  
The startup's data spans four fundamentally different types: structured (payment transactions), semi-structured (GPS logs, text reviews), and unstructured (menu images). A traditional Data Warehouse is designed for structured, pre-modeled data and cannot natively store raw GPS streams or images. A pure Data Lake can store everything but provides no transactional guarantees or query performance for structured analytics. A Lakehouse combines both: raw files of any format land in the lake layer, while a structured, ACID-compliant table format (such as Delta Lake or Apache Iceberg) provides reliable analytics on top of the same storage. This means the startup does not need two separate systems maintained in parallel.

**Reason 2 — Diverse query patterns requiring both real-time and analytical access.**  
Payment fraud detection needs low-latency, transactional queries on recent data. Monthly business reviews need aggregated OLAP queries across months of history. GPS data powers real-time delivery tracking dashboards. A Lakehouse supports all three via a unified storage layer with tiered compute — streaming ingestion for live GPS feeds, batch ETL for historical analysis, and interactive SQL engines (like Spark SQL or DuckDB) for ad hoc queries.

**Reason 3 — Schema flexibility for a fast-growing startup.**  
A food delivery startup evolves quickly: new restaurant categories, new payment methods, new review formats. A rigid Data Warehouse schema requires schema migrations for every change. A Lakehouse with schema evolution support (Delta Lake's `MERGE` and schema evolution features, for example) allows new fields to be added without breaking existing pipelines or historical data.

A Data Warehouse alone would fail on images and semi-structured logs. A Data Lake alone would provide no governance, no ACID guarantees on payments, and poor query performance. The Lakehouse is the pragmatic choice that scales with the business.
