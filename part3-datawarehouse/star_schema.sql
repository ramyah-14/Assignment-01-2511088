-- ============================================================
-- star_schema.sql
-- Data Warehouse Star Schema for retail_transactions.csv
-- ETL decisions documented in etl_notes.md
-- ============================================================

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- ------------------------------------------------------------
-- Dimension: dim_date
-- ------------------------------------------------------------
CREATE TABLE dim_date (
    date_key      INT          NOT NULL,
    full_date     DATE         NOT NULL,
    day           INT          NOT NULL,
    month         INT          NOT NULL,
    month_name    VARCHAR(15)  NOT NULL,
    quarter       INT          NOT NULL,
    year          INT          NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_key)
);

-- ------------------------------------------------------------
-- Dimension: dim_store
-- ------------------------------------------------------------
CREATE TABLE dim_store (
    store_key   INT          NOT NULL,
    store_name  VARCHAR(100) NOT NULL,
    store_city  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_dim_store PRIMARY KEY (store_key)
);

-- ------------------------------------------------------------
-- Dimension: dim_product
-- ------------------------------------------------------------
CREATE TABLE dim_product (
    product_key   INT           NOT NULL,
    product_name  VARCHAR(100)  NOT NULL,
    category      VARCHAR(50)   NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_key)
);

-- ------------------------------------------------------------
-- Fact Table: fact_sales
-- Grain: one row per transaction
-- ------------------------------------------------------------
CREATE TABLE fact_sales (
    sales_key       INT           NOT NULL,
    transaction_id  VARCHAR(15)   NOT NULL,
    date_key        INT           NOT NULL,
    store_key       INT           NOT NULL,
    product_key     INT           NOT NULL,
    customer_id     VARCHAR(15)   NOT NULL,
    units_sold      INT           NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    total_revenue   DECIMAL(14,2) NOT NULL,
    CONSTRAINT pk_fact_sales  PRIMARY KEY (sales_key),
    CONSTRAINT fk_fact_date   FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_store  FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    CONSTRAINT fk_fact_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

-- ============================================================
-- INSERT: dim_store (all 5 stores)
-- ============================================================
INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Chennai Anna',   'Chennai'),
(2, 'Delhi South',    'Delhi'),
(3, 'Bangalore MG',   'Bangalore'),
(4, 'Pune FC Road',   'Pune'),
(5, 'Mumbai Central', 'Mumbai');

-- ============================================================
-- INSERT: dim_product (all 16 products)
-- Category cleaned: 'electronics' -> 'Electronics', 'Grocery' -> 'Groceries'
-- ============================================================
INSERT INTO dim_product (product_key, product_name, category, unit_price) VALUES
(1,  'Speaker',    'Electronics', 49262.78),
(2,  'Tablet',     'Electronics', 23226.12),
(3,  'Phone',      'Electronics', 48703.39),
(4,  'Smartwatch', 'Electronics', 58851.01),
(5,  'Atta 10kg',  'Groceries',   52464.00),
(6,  'Jeans',      'Clothing',     2317.47),
(7,  'Biscuits',   'Groceries',   27469.99),
(8,  'Jacket',     'Clothing',    30187.24),
(9,  'Laptop',     'Electronics', 42343.15),
(10, 'Headphones', 'Electronics', 39854.96),
(11, 'Saree',      'Clothing',    35451.81),
(12, 'Milk 1L',    'Groceries',   43374.39),
(13, 'T-Shirt',    'Clothing',    29770.19),
(14, 'Rice 5kg',   'Groceries',   52195.05),
(15, 'Oil 1L',     'Groceries',   26474.34),
(16, 'Pulses 1kg', 'Groceries',   31604.47);

-- ============================================================
-- INSERT: dim_date (47 unique dates covering all 50 fact rows)
-- All 3 raw date formats normalized to ISO 8601 (YYYY-MM-DD)
-- ============================================================
INSERT INTO dim_date (date_key, full_date, day, month, month_name, quarter, year) VALUES
(20230102, '2023-01-02',  2,  1, 'January',   1, 2023),
(20230111, '2023-01-11', 11,  1, 'January',   1, 2023),
(20230113, '2023-01-13', 13,  1, 'January',   1, 2023),
(20230115, '2023-01-15', 15,  1, 'January',   1, 2023),
(20230117, '2023-01-17', 17,  1, 'January',   1, 2023),
(20230118, '2023-01-18', 18,  1, 'January',   1, 2023),
(20230124, '2023-01-24', 24,  1, 'January',   1, 2023),
(20230204, '2023-02-04',  4,  2, 'February',  1, 2023),
(20230205, '2023-02-05',  5,  2, 'February',  1, 2023),
(20230208, '2023-02-08',  8,  2, 'February',  1, 2023),
(20230220, '2023-02-20', 20,  2, 'February',  1, 2023),
(20230226, '2023-02-26', 26,  2, 'February',  1, 2023),
(20230308, '2023-03-08',  8,  3, 'March',     1, 2023),
(20230321, '2023-03-21', 21,  3, 'March',     1, 2023),
(20230331, '2023-03-31', 31,  3, 'March',     1, 2023),
(20230428, '2023-04-28', 28,  4, 'April',     2, 2023),
(20230512, '2023-05-12', 12,  5, 'May',       2, 2023),
(20230521, '2023-05-21', 21,  5, 'May',       2, 2023),
(20230522, '2023-05-22', 22,  5, 'May',       2, 2023),
(20230523, '2023-05-23', 23,  5, 'May',       2, 2023),
(20230604, '2023-06-04',  4,  6, 'June',      2, 2023),
(20230610, '2023-06-10', 10,  6, 'June',      2, 2023),
(20230614, '2023-06-14', 14,  6, 'June',      2, 2023),
(20230722, '2023-07-22', 22,  7, 'July',      3, 2023),
(20230730, '2023-07-30', 30,  7, 'July',      3, 2023),
(20230801, '2023-08-01',  1,  8, 'August',    3, 2023),
(20230807, '2023-08-07',  7,  8, 'August',    3, 2023),
(20230809, '2023-08-09',  9,  8, 'August',    3, 2023),
(20230815, '2023-08-15', 15,  8, 'August',    3, 2023),
(20230820, '2023-08-20', 20,  8, 'August',    3, 2023),
(20230829, '2023-08-29', 29,  8, 'August',    3, 2023),
(20230927, '2023-09-27', 27,  9, 'September', 3, 2023),
(20231003, '2023-10-03',  3, 10, 'October',   4, 2023),
(20231011, '2023-10-11', 11, 10, 'October',   4, 2023),
(20231020, '2023-10-20', 20, 10, 'October',   4, 2023),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023),
(20231027, '2023-10-27', 27, 10, 'October',   4, 2023),
(20231029, '2023-10-29', 29, 10, 'October',   4, 2023),
(20231031, '2023-10-31', 31, 10, 'October',   4, 2023),
(20231102, '2023-11-02',  2, 11, 'November',  4, 2023),
(20231104, '2023-11-04',  4, 11, 'November',  4, 2023),
(20231118, '2023-11-18', 18, 11, 'November',  4, 2023),
(20231122, '2023-11-22', 22, 11, 'November',  4, 2023),
(20231203, '2023-12-03',  3, 12, 'December',  4, 2023),
(20231208, '2023-12-08',  8, 12, 'December',  4, 2023),
(20231212, '2023-12-12', 12, 12, 'December',  4, 2023),
(20231226, '2023-12-26', 26, 12, 'December',  4, 2023);

-- ============================================================
-- INSERT: fact_sales — 50 cleaned rows from retail_transactions.csv
-- total_revenue = units_sold * unit_price (pre-computed)
-- ============================================================
INSERT INTO fact_sales (sales_key, transaction_id, date_key, store_key, product_key, customer_id, units_sold, unit_price, total_revenue) VALUES
(1,  'TXN5000', 20230829, 1,  1,  'CUST045',  3, 49262.78,  147788.34),
(2,  'TXN5001', 20231212, 1,  2,  'CUST021', 11, 23226.12,  255487.32),
(3,  'TXN5002', 20230205, 1,  3,  'CUST019', 20, 48703.39,  974067.80),
(4,  'TXN5003', 20230220, 2,  2,  'CUST007', 14, 23226.12,  325165.68),
(5,  'TXN5004', 20230115, 1,  4,  'CUST004', 10, 58851.01,  588510.10),
(6,  'TXN5005', 20230809, 3,  5,  'CUST027', 12, 52464.00,  629568.00),
(7,  'TXN5006', 20230331, 4,  4,  'CUST025',  6, 58851.01,  353106.06),
(8,  'TXN5007', 20231026, 4,  6,  'CUST041', 16,  2317.47,   37079.52),
(9,  'TXN5008', 20231208, 3,  7,  'CUST030',  9, 27469.99,  247229.91),
(10, 'TXN5009', 20230815, 3,  4,  'CUST020',  3, 58851.01,  176553.03),
(11, 'TXN5010', 20230604, 1,  8,  'CUST031', 15, 30187.24,  452808.60),
(12, 'TXN5011', 20231020, 5,  6,  'CUST045', 13,  2317.47,   30127.11),
(13, 'TXN5012', 20230521, 3,  9,  'CUST044', 13, 42343.15,  550460.95),
(14, 'TXN5013', 20230428, 5,  12, 'CUST015', 10, 43374.39,  433743.90),
(15, 'TXN5014', 20231118, 2,  8,  'CUST042',  5, 30187.24,  150936.20),
(16, 'TXN5015', 20230118, 5,  11, 'CUST009', 15, 35451.81,  531777.15),
(17, 'TXN5016', 20230801, 5,  11, 'CUST035', 11, 35451.81,  389969.91),
(18, 'TXN5017', 20230512, 3,  8,  'CUST019',  6, 30187.24,  181123.44),
(19, 'TXN5018', 20230208, 3,  10, 'CUST015', 15, 39854.96,  597824.40),
(20, 'TXN5019', 20230722, 1,  5,  'CUST008',  3, 52464.00,  157392.00),
(21, 'TXN5020', 20231027, 1,  5,  'CUST024',  9, 52464.00,  472176.00),
(22, 'TXN5021', 20230113, 5,  6,  'CUST036', 16,  2317.47,   37079.52),
(23, 'TXN5022', 20231122, 3,  6,  'CUST020',  3,  2317.47,    6952.41),
(24, 'TXN5023', 20230124, 1,  10, 'CUST032',  5, 39854.96,  199274.80),
(25, 'TXN5024', 20231003, 5,  10, 'CUST024',  8, 39854.96,  318839.68),
(26, 'TXN5025', 20230321, 4,  16, 'CUST032', 19, 31604.47,  600484.93),
(27, 'TXN5026', 20230117, 4,  16, 'CUST029',  9, 31604.47,  284440.23),
(28, 'TXN5027', 20230220, 1,  6,  'CUST042', 12,  2317.47,   27809.64),
(29, 'TXN5028', 20230522, 3,  3,  'CUST030', 13, 48703.39,  633144.07),
(30, 'TXN5029', 20230111, 5,  13, 'CUST016', 20, 29770.19,  595403.80),
(31, 'TXN5030', 20231011, 2,  13, 'CUST015',  3, 29770.19,   89310.57),
(32, 'TXN5031', 20230102, 3,  1,  'CUST010', 20, 49262.78,  985255.60),
(33, 'TXN5032', 20230226, 2,  8,  'CUST009',  6, 30187.24,  181123.44),
(34, 'TXN5033', 20231029, 5,  5,  'CUST017',  8, 52464.00,  419712.00),
(35, 'TXN5034', 20230927, 5,  1,  'CUST031', 14, 49262.78,  689678.92),
(36, 'TXN5035', 20231031, 1,  5,  'CUST015', 17, 52464.00,  891888.00),
(37, 'TXN5036', 20230604, 4,  3,  'CUST002', 17, 48703.39,  827957.63),
(38, 'TXN5037', 20230807, 5,  12, 'CUST046', 13, 43374.39,  563867.07),
(39, 'TXN5038', 20230614, 1,  2,  'CUST009',  3, 23226.12,   69678.36),
(40, 'TXN5039', 20231102, 3,  14, 'CUST033', 13, 52195.05,  678535.65),
(41, 'TXN5040', 20231226, 4,  16, 'CUST042',  4, 31604.47,  126417.88),
(42, 'TXN5041', 20230820, 4,  13, 'CUST030', 14, 29770.19,  416782.66),
(43, 'TXN5042', 20230610, 1,  16, 'CUST017',  4, 31604.47,  126417.88),
(44, 'TXN5043', 20230204, 3,  1,  'CUST006', 16, 49262.78,  788204.48),
(45, 'TXN5044', 20230308, 1,  10, 'CUST036', 12, 39854.96,  478259.52),
(46, 'TXN5045', 20230730, 4,  14, 'CUST049',  4, 52195.05,  208780.20),
(47, 'TXN5046', 20231104, 1,  3,  'CUST037', 10, 48703.39,  487033.90),
(48, 'TXN5047', 20231203, 4,  13, 'CUST007',  5, 29770.19,  148850.95),
(49, 'TXN5048', 20230523, 3,  5,  'CUST028',  4, 52464.00,  209856.00),
(50, 'TXN5049', 20231203, 4,  9,  'CUST012', 20, 42343.15,  846863.00);
