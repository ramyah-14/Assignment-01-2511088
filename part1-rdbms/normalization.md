## Anomaly Analysis

The file `orders_flat.csv` stores all order, customer, product, and sales representative data in a single denormalized table. This structure introduces the following anomalies.

### Insert Anomaly

**Definition:** A new entity cannot be added to the database without also adding unrelated data.

**Example from dataset:**  
Suppose a new sales representative joins — say, SR04 with the name "Meera Nair" and email `meera@corp.com`. There is no way to record this representative in the table until they are assigned to at least one order. The `sales_rep_id`, `sales_rep_name`, and `sales_rep_email` columns exist only within order rows, so a sales rep who has not yet handled any orders simply cannot be inserted.

Similarly, a new product (e.g., P009 — Whiteboard) cannot be recorded in the system until a customer actually orders it.

---

### Update Anomaly

**Definition:** Updating a single logical fact requires changing multiple rows, creating a risk of inconsistency.

**Example from dataset:**  
`SR01 Deepak Joshi` appears in dozens of rows (e.g., ORD1027 through ORD1184). If Deepak moves from the Mumbai HQ office to a new address, every single row where `sales_rep_id = SR01` must be updated. If even one row is missed, the table will contain contradictory `office_address` values for the same sales rep.

A concrete inconsistency already exists in the data: rows for SR01 show the address as both `"Mumbai HQ, Nariman Point, Mumbai - 400021"` (most rows) and `"Mumbai HQ, Nariman Pt, Mumbai - 400021"` (e.g., ORD1172, ORD1176, ORD1177) — a classic update anomaly where partial edits have left inconsistent values.

---

### Delete Anomaly

**Definition:** Deleting a row to remove one piece of information inadvertently destroys other unrelated information.

**Example from dataset:**  
Customer `C003 Amit Verma` from Bangalore is associated with product `P008 Webcam` only through the single order row `ORD1185`. If this order is deleted (e.g., the customer returns the item and the record is purged), all knowledge that product P008 (Webcam, Electronics, unit price ₹2,100) exists in the catalog is also permanently lost from the database, since no other order references it.

---

## Normalization Justification

A manager arguing that a single flat table is "simpler" than a normalized schema is making a short-term convenience argument that breaks down quickly under real-world conditions. The `orders_flat.csv` dataset itself demonstrates why.

**Redundancy creates maintenance risk.** Every sales representative's name, email, and office address is repeated in every order they handle. Deepak Joshi (`SR01`) appears in over 60 rows. The data already has two slightly different spellings of his office address ("Nariman Point" vs "Nariman Pt"), showing that the moment anyone edits even a handful of rows, inconsistency creeps in. In a normalized schema, the sales rep's address lives in exactly one place — one update, always consistent.

**The flat table cannot represent incomplete facts.** If the business onboards a new product or recruits a new sales rep before they are linked to an order, there is nowhere to record them. This is not just a theoretical concern — it means the product catalog is always lagging actual inventory, and HR records cannot be pre-loaded before first use. Normalization eliminates this by giving each entity its own table.

**Deletion destroys knowledge.** The entire record of product P008 (Webcam) hangs on a single order row. Cancel that order, and the product disappears from the system. A separate `products` table prevents this.

**Query performance and storage.** Storing "Standing Desk, Furniture, 22000" in 40+ rows wastes space and forces the query engine to scan and aggregate redundant strings. A normalized schema stores the fact once and joins on a compact integer key.

Normalization is not over-engineering — it is the difference between a database that stays correct as data grows and one that degrades into inconsistency. The flat file approach trades short-term setup simplicity for long-term maintenance cost, data quality risk, and structural limitations that affect every future operation on the data.
