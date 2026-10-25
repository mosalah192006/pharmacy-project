-- =========================================================
-- ASSIGNMENT III: SQL TABLE MANIPULATION
-- Student Name: Mohamed Salah
-- Student ID: 202511449
-- Business Idea: Pharmacy Management System[cite: 1]
-- Database Management System: MySQL[cite: 1]
-- =========================================================

-- ---------------------------------------------------------
-- SECTION 1: DATABASE CREATION
-- Naming format: mohamedsalah_202511449_pharmacy_system[cite: 2]
-- ---------------------------------------------------------
CREATE DATABASE IF NOT EXISTS mohamedsalah_202511449_pharmacy_system;

-- Select the database for use
USE mohamedsalah_202511449_pharmacy_system;

-- ---------------------------------------------------------
-- SECTION 2: TABLE CREATION AND CONSTRAINTS[cite: 2, 3]
-- ---------------------------------------------------------

-- Parent Table 1: Categories[cite: 2]
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Parent Table 2: Medicines (Child to Categories)[cite: 2, 3]
CREATE TABLE IF NOT EXISTS medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    CONSTRAINT fk_medicines_categories 
        FOREIGN KEY (category_id) 
        REFERENCES categories(category_id) 
        ON DELETE CASCADE
);

-- Child Table: Sales (Child to Medicines)[cite: 2, 3]
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sales_medicines 
        FOREIGN KEY (medicine_id) 
        REFERENCES medicines(medicine_id) 
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- SECTION 3: INITIAL DATA INSERTION (At least 5 records per table)[cite: 3]
-- ---------------------------------------------------------

-- 1. Insert into Categories (Parent)
INSERT INTO categories (category_name, description) VALUES
('Antibiotics', 'Medications used to treat bacterial infections'),
('Painkillers', 'Analgesics and fever reducers'),
('Vitamins', 'Dietary supplements and immune boosters'),
('Antihistamines', 'Allergy relief medications'),
('Cardiovascular', 'Heart and blood pressure management medications');

-- 2. Insert into Medicines
INSERT INTO medicines (medicine_name, category_id, unit_price, stock_quantity) VALUES
('Amoxicillin 500mg', 1, 12.50, 150),
('Paracetamol 500mg', 2, 3.00, 500),
('Ibuprofen 400mg', 2, 5.50, 300),
('Vitamin C 1000mg', 3, 8.00, 200),
('Loratadine 10mg', 4, 6.00, 80);

-- 3. Insert into Sales (Child)
INSERT INTO sales (medicine_id, quantity_sold, total_amount, sale_date) VALUES
(1, 2, 25.00, '2026-10-24 09:30:00'),
(2, 5, 15.00, '2026-10-24 10:15:00'),
(3, 1, 5.50, '2026-10-24 11:00:00'),
(4, 3, 24.00, '2026-10-25 14:20:00'),
(5, 2, 12.00, '2026-10-25 16:45:00');

-- ---------------------------------------------------------
-- SECTION 4: SELECT TASKS (Data Retrieval)[cite: 4]
-- ---------------------------------------------------------

-- Q1.1: Basic Data Retrieval[cite: 4]
SELECT medicine_name, stock_quantity 
FROM medicines;

-- Q1.2: Conditional Data Retrieval[cite: 4]
SELECT medicine_name, stock_quantity, unit_price 
FROM medicines 
WHERE stock_quantity < 200;

-- Q1.3: Sorted Data Retrieval[cite: 4]
SELECT medicine_name, unit_price 
FROM medicines 
ORDER BY unit_price DESC;

-- ---------------------------------------------------------
-- SECTION 5: JOIN TASKS (Retrieving Related Data)[cite: 4]
-- ---------------------------------------------------------

-- Q2.1: INNER JOIN[cite: 4]
SELECT m.medicine_name, c.category_name, m.unit_price
FROM medicines m
INNER JOIN categories c ON m.category_id = c.category_id;

-- Q2.2: LEFT JOIN[cite: 4]
SELECT c.category_name, m.medicine_name, m.stock_quantity
FROM categories c
LEFT JOIN medicines m ON c.category_id = m.category_id;

-- Q2.3: Multi-Table JOIN[cite: 4]
SELECT s.sale_id, m.medicine_name, c.category_name, s.quantity_sold, s.total_amount, s.sale_date
FROM sales s
INNER JOIN medicines m ON s.medicine_id = m.medicine_id
INNER JOIN categories c ON m.category_id = c.category_id;

-- ---------------------------------------------------------
-- SECTION 6: UPDATE TASKS (Modifying Existing Data)[cite: 4, 5]
-- ---------------------------------------------------------

-- Q3.1: Update One Record[cite: 4]
UPDATE medicines 
SET unit_price = 3.50 
WHERE medicine_id = 2;

SELECT medicine_name, unit_price FROM medicines WHERE medicine_id = 2;

-- Q3.2: Update Multiple Records[cite: 4]
UPDATE medicines 
SET stock_quantity = stock_quantity + 50 
WHERE stock_quantity < 250;

SELECT medicine_name, stock_quantity FROM medicines;

-- Q3.3: Conditional Update[cite: 4, 5]
UPDATE medicines 
SET unit_price = unit_price * 0.90 
WHERE category_id = 2;

SELECT m.medicine_name, c.category_name, m.unit_price 
FROM medicines m 
JOIN categories c ON m.category_id = c.category_id 
WHERE c.category_id = 2;

-- ---------------------------------------------------------
-- SECTION 7: ALTER TABLE TASKS (Modifying Table Structure)[cite: 5]
-- ---------------------------------------------------------

-- Q4.1: Rename a Column[cite: 5]
ALTER TABLE categories 
RENAME COLUMN description TO category_description;

SELECT category_name, category_description FROM categories LIMIT 1;

-- Q4.2: Change a Column's Data Type[cite: 5]
ALTER TABLE medicines 
MODIFY COLUMN medicine_name VARCHAR(200);

-- Q4.3: Add a New Column[cite: 5]
ALTER TABLE medicines 
ADD COLUMN expiry_date DATE;

SELECT medicine_name, expiry_date FROM medicines LIMIT 1;

-- ---------------------------------------------------------
-- SECTION 8: INSERT TASKS (Adding New Records)[cite: 5, 6]
-- ---------------------------------------------------------

-- Q5.1: Insert a Single Record[cite: 5]
INSERT INTO categories (category_name, category_description) 
VALUES ('Dermatology', 'Skincare and topical ointments');

SELECT * FROM categories WHERE category_name = 'Dermatology';

-- Q5.2: Insert Multiple Records[cite: 5]
INSERT INTO medicines (medicine_name, category_id, unit_price, stock_quantity, expiry_date) VALUES
('Aspirin 81mg', 2, 4.00, 400, '2027-12-31'),
('Cetirizine 10mg', 4, 5.00, 150, '2028-05-15');

SELECT * FROM medicines WHERE medicine_name IN ('Aspirin 81mg', 'Cetirizine 10mg');

-- Q5.3: Insert a Related Record[cite: 6]
INSERT INTO sales (medicine_id, quantity_sold, total_amount, sale_date) 
VALUES (6, 10, 40.00, CURRENT_TIMESTAMP);

SELECT s.sale_id, m.medicine_name, s.quantity_sold, s.total_amount 
FROM sales s 
JOIN medicines m ON s.medicine_id = m.medicine_id 
WHERE s.medicine_id = 6;