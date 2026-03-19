## Storage Systems

The hospital network's four goals each map to a different storage technology, chosen to match the data's structure, access pattern, and consistency requirements.

**Goal 1 — Predict patient readmission risk (ML on historical treatment data):**  
A Data Lakehouse (Delta Lake on cloud object storage) is the right choice. Historical treatment records, lab results, and discharge summaries need to be stored at scale in a format that data scientists can query with Python and Spark for feature engineering and model training. The Lakehouse provides ACID guarantees for data reliability while supporting the flexible, schema-evolving nature of clinical data accumulated over years.

**Goal 2 — Doctors querying patient history in plain English:**  
A Vector Database (such as Pinecone or pgvector) serves this goal. Patient notes, discharge summaries, and clinical reports are embedded as vectors at ingestion. When a doctor asks "Has this patient had a cardiac event before?", the question is converted to an embedding and the nearest matching records are retrieved semantically — catching "myocardial infarction," "cardiac arrest," and "heart attack" even when exact keywords differ. The vector store sits alongside a Relational Database (PostgreSQL) that holds the authoritative structured patient record.

**Goal 3 — Monthly management reports (bed occupancy, department-wise costs):**  
A Data Warehouse (such as Snowflake or BigQuery) with a star schema powers this goal. Fact tables for admissions, discharges, and costs, joined to dimension tables for departments, dates, and wards, enable fast aggregation queries for BI dashboards and scheduled monthly reports.

**Goal 4 — Real-time ICU vitals streaming:**  
A Time-Series Database (such as InfluxDB or Amazon Timestream) is optimized for high-frequency append-only writes and windowed queries over time. ICU monitoring devices emit hundreds of data points per second; a relational database would buckle under this write load, while a time-series store handles it natively and supports threshold-based alerting.

---

## OLTP vs OLAP Boundary

The OLTP system ends at the point of data capture and immediate clinical use. The PostgreSQL relational database handling patient registrations, appointments, prescriptions, and ICU vitals ingestion is the OLTP layer — it is optimized for high-frequency, low-latency reads and writes, with ACID guarantees ensuring that a medication record written by one nurse is immediately visible to another.

The OLAP boundary begins at the ETL/ELT pipeline that extracts from the OLTP system and loads into the Data Warehouse. The Warehouse never receives direct writes from clinical applications; it receives cleaned, transformed, and aggregated data on a scheduled basis (nightly or hourly). Analytical queries — monthly occupancy reports, department cost trends, readmission rate calculations — run against the Warehouse, insulating the OLTP system from the resource demands of long-running aggregations.

---

## Trade-offs

**Trade-off: Data duplication and synchronization lag across multiple storage systems.**  
The architecture uses four specialized systems — a relational database, a data lakehouse, a vector database, and a data warehouse — which means the same patient record may exist in multiple stores simultaneously. A discharge summary lives in PostgreSQL (source of truth), is embedded and indexed in the vector database, and is also loaded into the Lakehouse for ML training. This creates a synchronization challenge: if the original record is amended, all downstream copies must be updated, or clinicians may query stale embeddings.

**Mitigation:** Implement an event-driven data pipeline using a message broker (such as Apache Kafka). Every time a record is created or updated in PostgreSQL, a change event is published to a Kafka topic. Downstream consumers — the Lakehouse ETL, the vector database embedding pipeline, and the Warehouse loader — each subscribe to the relevant topics and apply updates in near-real-time. This decouples the systems while ensuring consistency propagates automatically, and the Kafka log provides an auditable record of all data changes — critical for healthcare compliance.
