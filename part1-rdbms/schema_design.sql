-- ============================================================
-- schema_design.sql
-- Normalized schema for orders_flat.csv — Third Normal Form (3NF)
-- ============================================================

-- Drop tables in reverse dependency order (for re-runability)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sales_reps;

-- ------------------------------------------------------------
-- Table: sales_reps
-- Holds sales representative data. Eliminates repeating SR info
-- across every order row.
-- ------------------------------------------------------------
CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  NOT NULL,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) NOT NULL,
    office_address  VARCHAR(300) NOT NULL,
    CONSTRAINT pk_sales_reps PRIMARY KEY (sales_rep_id)
);

-- ------------------------------------------------------------
-- Table: customers
-- Holds customer master data. Eliminates repeating customer
-- name, email, city across every order row.
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL,
    customer_city  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

-- ------------------------------------------------------------
-- Table: products
-- Holds product catalog. Eliminates repeating product name,
-- category, and unit price across every order row.
-- Also fixes the delete anomaly: products survive even if all
-- their orders are removed.
-- ------------------------------------------------------------
CREATE TABLE products (
    product_id   VARCHAR(10)   NOT NULL,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

-- ------------------------------------------------------------
-- Table: orders
-- Fact table. Each row records a single order transaction.
-- All repeated entity data is replaced by foreign keys.
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id       VARCHAR(10)   NOT NULL,
    customer_id    VARCHAR(10)   NOT NULL,
    product_id     VARCHAR(10)   NOT NULL,
    sales_rep_id   VARCHAR(10)   NOT NULL,
    quantity       INT           NOT NULL,
    order_date     DATE          NOT NULL,
    CONSTRAINT pk_orders         PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_product  FOREIGN KEY (product_id)   REFERENCES products(product_id),
    CONSTRAINT fk_orders_salesrep FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- ============================================================
-- INSERT STATEMENTS
-- ============================================================

-- Sales Reps
INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');

-- Customers
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');

-- Products
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00);

-- Orders (representative sample of 10 rows from the dataset)
INSERT INTO orders (order_id, customer_id, product_id, sales_rep_id, quantity, order_date) VALUES
('ORD1027', 'C002', 'P004', 'SR02', 4, '2023-11-02'),
('ORD1114', 'C001', 'P007', 'SR01', 2, '2023-08-06'),
('ORD1185', 'C003', 'P008', 'SR03', 1, '2023-06-15'),
('ORD1075', 'C005', 'P003', 'SR03', 3, '2023-04-18'),
('ORD1091', 'C001', 'P006', 'SR01', 3, '2023-07-24'),
('ORD1061', 'C006', 'P001', 'SR01', 4, '2023-10-27'),
('ORD1098', 'C007', 'P001', 'SR03', 2, '2023-10-03'),
('ORD1076', 'C004', 'P006', 'SR03', 5, '2023-05-16'),
('ORD1054', 'C002', 'P001', 'SR03', 1, '2023-10-04'),
('ORD1169', 'C003', 'P003', 'SR01', 5, '2023-01-28');
