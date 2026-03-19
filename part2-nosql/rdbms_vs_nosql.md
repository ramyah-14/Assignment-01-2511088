## Database Recommendation

For a healthcare patient management system, I would recommend **MySQL** (or any ACID-compliant relational database) as the primary data store — and the reasoning centers on the fundamental guarantees that patient data demands.

Healthcare data is mission-critical. A patient's medication history, allergies, lab results, and treatment records must be correct at all times. MySQL's ACID compliance ensures that every transaction is Atomic (a prescription update either fully commits or fully rolls back), Consistent (the database never moves into a state that violates its rules), Isolated (concurrent updates by two nurses do not interfere), and Durable (once committed, a record survives a system crash). MongoDB, operating on BASE principles (Basically Available, Soft-state, Eventually consistent), trades some of these guarantees for flexibility and horizontal scale — a trade-off that is acceptable for a product catalog, but dangerous for a patient record.

The CAP theorem tells us that in the presence of a network partition, a system must choose between Consistency and Availability. MySQL prioritizes Consistency; MongoDB, in its default configurations, prioritizes Availability. For patient data, showing a doctor a slightly stale medication record because the system chose availability over consistency could be life-threatening. Consistency must win.

Relational schemas also enforce data integrity through foreign keys and constraints, ensuring referential integrity between patients, appointments, prescriptions, and doctors. This structured integrity is naturally suited to patient management workflows where relationships between entities are well-defined and stable.

**Would the answer change for fraud detection?**

Yes, significantly. Fraud detection requires analyzing large volumes of behavioral data in near-real-time — transaction patterns, login locations, device fingerprints — often across semi-structured or unstructured data sources. This workload is a poor fit for a normalized relational schema and an excellent fit for a document store or a graph database. I would recommend a **hybrid architecture**: MySQL remains the authoritative system of record for patient records, while a MongoDB collection (or a graph database like Neo4j) powers the fraud detection module by storing behavioral event logs and enabling fast pattern matching. This hybrid approach preserves ACID guarantees where they matter most while giving the fraud module the schema flexibility and horizontal scalability it needs.
