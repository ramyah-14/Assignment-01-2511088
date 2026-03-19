# Assignment 2 — Business Analytics: Gen and Agentic AI

## Structure

```
assignment/
├── datasets/                    ← Source data files (do not modify)
│   ├── orders_flat.csv
│   ├── retail_transactions.csv
│   ├── customers.csv
│   ├── orders.json
│   └── products.parquet
├── part1-rdbms/
│   ├── schema_design.sql        ← 3NF schema + INSERT statements
│   ├── queries.sql              ← 5 SQL queries (Q1–Q5)
│   └── normalization.md        ← Anomaly analysis + justification
├── part2-nosql/
│   ├── sample_documents.json   ← 3 MongoDB documents (Electronics, Clothing, Groceries)
│   ├── mongo_queries.js        ← 5 MongoDB operations (OP1–OP5)
│   └── rdbms_vs_nosql.md       ← ACID vs BASE, CAP theorem recommendation
├── part3-datawarehouse/
│   ├── star_schema.sql         ← Fact + 3 dimension tables + 10 fact rows
│   ├── dw_queries.sql          ← 3 analytical queries (Q1–Q3)
│   └── etl_notes.md            ← 3 ETL transformation decisions
├── part4-vector-db/
│   ├── embeddings_demo.ipynb   ← Colab notebook: embeddings + heatmap + similarity search
│   └── vector_db_reflection.md ← Law firm vector DB use case
├── part5-datalake/
│   ├── duckdb_queries.sql      ← 4 cross-format DuckDB queries
│   └── architecture_choice.md  ← Data Lakehouse recommendation
└── part6-capstone/
    ├── architecture_diagram.png ← Hospital AI data architecture diagram
    └── design_justification.md ← Storage systems, OLTP/OLAP boundary, trade-offs
```
