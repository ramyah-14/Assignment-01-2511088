## ETL Decisions

### Decision 1 — Inconsistent Date Formats

**Problem:**  
The `date` column in `retail_transactions.csv` contains dates in at least three different formats across rows: `DD/MM/YYYY` (e.g., `29/08/2023`), `DD-MM-YYYY` (e.g., `12-12-2023`), and `YYYY-MM-DD` (e.g., `2023-02-05`). Loading these directly into a DATE column would either fail or silently misparse dates (e.g., `12-12-2023` could be read as December 12 or the 12th of the 12th depending on locale), producing incorrect time-based aggregations.

**Resolution:**  
During the ETL transformation stage, a multi-format date parser was applied to each row. Each date string was tested against all three known format patterns in order; the first successful parse was used and the result was standardized to ISO 8601 format (`YYYY-MM-DD`) before loading. This standardized value was then used to derive the `date_key` (integer `YYYYMMDD`), `day`, `month`, `month_name`, `quarter`, and `year` fields in `dim_date`.

---

### Decision 2 — Inconsistent Category Casing

**Problem:**  
The `category` column contains mixed-case values for the same logical category: `Electronics`, `electronics`, `Groceries`, and `Grocery` all appear in the raw data. If loaded as-is, GROUP BY queries on category would treat these as four distinct categories, fragmenting aggregations and producing incorrect totals (e.g., Electronics revenue split across two category buckets).

**Resolution:**  
A two-step normalization was applied: (1) all category strings were converted to Title Case using a string transformation, consolidating `electronics` → `Electronics`; (2) the legacy value `Grocery` was explicitly remapped to `Groceries` to align with the canonical category name used by the majority of rows. The cleaned category value was stored in `dim_product.category`. No raw category value was loaded into the warehouse without passing through this transformation.

---

### Decision 3 — NULL and Missing Store City Values

**Problem:**  
Inspection of the raw data revealed that `Delhi South` store rows had a blank/empty `store_city` field in several records — the city was not populated consistently. Loading these nulls into `dim_store.store_city` (a NOT NULL column) would cause load failures, and leaving them as NULLs would break city-level reporting queries.

**Resolution:**  
A lookup-based default fill was applied: since `store_name` values are unique and their cities are known from other rows in the same file, a store-to-city mapping was derived from non-null rows first, then used to back-fill any rows where `store_city` was blank. `Delhi South` was correctly assigned `store_city = 'Delhi'`. This ensured all dimension rows were complete before loading, and `dim_store.store_city` was declared NOT NULL to enforce this constraint going forward.
