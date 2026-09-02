-- ============================================================
-- ITEC105 Laboratory No. 2
-- Design and Implement a Relational Database Using MySQL Workbench
-- Organization: DEEPSCENT (Fragrance / Perfume Store)
-- ============================================================

-- ============================================================
-- PART 3: CREATE YOUR DATABASE
-- ============================================================
DROP DATABASE IF EXISTS deepscent_db;
CREATE DATABASE deepscent_db;
USE deepscent_db;

-- ============================================================
-- PART 4: CREATE YOUR TABLES (5+ related tables)
-- ============================================================

-- 1. BRANDS -----------------------------------------------------
CREATE TABLE brands (
    brand_id      INT PRIMARY KEY AUTO_INCREMENT,
    brand_name    VARCHAR(100) NOT NULL UNIQUE,
    country       VARCHAR(50),
    founded_year  INT
);

-- 2. CUSTOMERS ----------------------------------------------------
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    address       VARCHAR(150),
    created_at    DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- 3. PRODUCTS -----------------------------------------------------
CREATE TABLE products (
    product_id     INT PRIMARY KEY AUTO_INCREMENT,
    product_name   VARCHAR(100) NOT NULL,
    brand_id       INT NOT NULL,
    category       ENUM('Eau de Parfum','Eau de Toilette','Cologne','Extrait de Parfum') NOT NULL,
    size_ml        INT NOT NULL,
    price          DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

-- 4. ORDERS -----------------------------------------------------
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATE NOT NULL,
    status        ENUM('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. ORDER_DETAILS -----------------------------------------------------
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      DECIMAL(10,2) NOT NULL,
    subtotal        DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 6. PAYMENTS -----------------------------------------------------
CREATE TABLE payments (
    payment_id      INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT NOT NULL,
    payment_date    DATE NOT NULL,
    amount          DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_method  ENUM('Cash','Credit Card','GCash','Bank Transfer') NOT NULL,
    payment_status  ENUM('Pending','Paid','Refunded') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ============================================================
-- PART 6: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO brands (brand_name, country, founded_year) VALUES
('Maison Margiela', 'France', 1988),
('Le Labo', 'USA', 2006),
('Creed', 'France', 1760),
('Byredo', 'Sweden', 2006),
('Tom Ford', 'USA', 2005);

INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Juan', 'Dela Cruz', 'juan.delacruz@email.com', '09171234567', 'Sta. Cruz, Laguna'),
('Maria', 'Santos', 'maria.santos@email.com', '09182345678', 'San Pablo, Laguna'),
('Pedro', 'Reyes', 'pedro.reyes@email.com', '09193456789', 'Calamba, Laguna'),
('Ana', 'Garcia', 'ana.garcia@email.com', '09204567890', 'Los Baños, Laguna'),
('Liza', 'Ramos', 'liza.ramos@email.com', '09215678901', 'Biñan, Laguna');

INSERT INTO products (product_name, brand_id, category, size_ml, price, stock_quantity) VALUES
('Replica Jazz Club', 1, 'Eau de Toilette', 100, 3200.00, 25),
('Santal 33', 2, 'Eau de Parfum', 50, 5800.00, 15),
('Aventus', 3, 'Eau de Parfum', 100, 12500.00, 10),
('Gypsy Water', 4, 'Eau de Parfum', 100, 6200.00, 20),
('Tobacco Vanille', 5, 'Eau de Parfum', 50, 8900.00, 12),
('Replica Beach Walk', 1, 'Eau de Toilette', 100, 3200.00, 18);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-08-10', 'Delivered'),
(2, '2026-08-15', 'Shipped'),
(3, '2026-08-20', 'Processing'),
(1, '2026-08-25', 'Pending'),
(4, '2026-08-28', 'Delivered');

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 3200.00),
(1, 3, 1, 12500.00),
(2, 2, 2, 5800.00),
(3, 4, 1, 6200.00),
(4, 5, 1, 8900.00),
(5, 6, 3, 3200.00);

INSERT INTO payments (order_id, payment_date, amount, payment_method, payment_status) VALUES
(1, '2026-08-10', 15700.00, 'GCash', 'Paid'),
(2, '2026-08-15', 11600.00, 'Credit Card', 'Paid'),
(3, '2026-08-20', 6200.00, 'Cash', 'Pending'),
(4, '2026-08-25', 8900.00, 'Bank Transfer', 'Pending'),
(5, '2026-08-28', 9600.00, 'GCash', 'Paid');

-- ============================================================
-- PART 7: BASIC SQL QUERIES (SELECT)
-- ============================================================

-- Query 1: Display all records from one table
SELECT * FROM products;

-- Query 2: Display only one column
SELECT product_name FROM products;

-- Query 3: Display two or more columns
SELECT product_name, price FROM products;

-- Query 4: Use WHERE
SELECT * FROM products
WHERE category = 'Eau de Parfum';

-- Query 5: Use ORDER BY
SELECT * FROM products
ORDER BY price DESC;

-- ============================================================
-- PART 8: JOIN QUERIES (3+)
-- ============================================================

-- Join 1: Customer name with their order dates
SELECT
    c.first_name,
    c.last_name,
    o.order_date,
    o.status
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;

-- Join 2: Products with their brand names
SELECT
    p.product_name,
    b.brand_name,
    p.price
FROM products p
JOIN brands b
    ON p.brand_id = b.brand_id;

-- Join 3: Order details with product and order info (3-table join)
SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    p.product_name,
    od.quantity,
    od.subtotal
FROM order_details od
JOIN orders o     ON od.order_id = o.order_id
JOIN customers c  ON o.customer_id = c.customer_id
JOIN products p   ON od.product_id = p.product_id;

-- ============================================================
-- PART 10: DATA ABSTRACTION USING VIEWS (2+)
-- ============================================================

-- View 1: Customer-facing view - order summary
CREATE VIEW customer_order_view AS
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date,
    p.product_name AS product,
    od.quantity,
    od.subtotal AS total
FROM customers c
JOIN orders o        ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p       ON od.product_id = p.product_id;

-- View 2: Employee/staff view - order fulfillment & payment status
CREATE VIEW employee_order_view AS
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    p.product_name AS product,
    od.quantity,
    pay.payment_status
FROM orders o
JOIN customers c       ON o.customer_id = c.customer_id
JOIN order_details od  ON o.order_id = od.order_id
JOIN products p        ON od.product_id = p.product_id
JOIN payments pay      ON o.order_id = pay.order_id;

-- Test the views:
SELECT * FROM customer_order_view;
SELECT * FROM employee_order_view;
