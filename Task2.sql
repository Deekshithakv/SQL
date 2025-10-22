CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    salary DECIMAL(10,2) DEFAULT 30000,
    department VARCHAR(50) DEFAULT 'General',
    joining_date DATE
);

-- Step 2: Insert rows into the table
INSERT INTO employees (emp_id, first_name, last_name, email, phone, salary, department, joining_date)
VALUES 
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', '1234567890', 50000, 'HR', '2025-01-10'),
(2, 'Bob', 'Smith', 'bob.smith@example.com', NULL, 40000, 'IT', '2025-02-15'),
(3, 'Charlie', 'Brown', NULL, '0987654321', NULL, NULL, '2025-03-20'),
(4, 'David', 'Lee', 'david.lee@example.com', NULL, 45000, 'Finance', NULL);

-- Step 3: Insert partial values (some columns left NULL)
INSERT INTO employees (emp_id, first_name, last_name)
VALUES (5, 'Eva', 'Green');

-- Step 4: Update rows
-- Update salary for all IT employees
UPDATE employees
SET salary = 42000
WHERE department = 'IT';

-- Update phone number for a specific employee
UPDATE employees
SET phone = '5555555555'
WHERE emp_id = 2;

-- Step 5: Delete rows
-- Delete an employee who left the company
DELETE FROM employees
WHERE emp_id = 4;

-- Step 6: Query data to verify inserts/updates/deletes
SELECT * FROM employees;

-- Step 7: Handling NULLs
-- Find employees with missing email
SELECT * FROM employees
WHERE email IS NULL;

-- Update NULL department to default
UPDATE employees
SET department = 'General'
WHERE department IS NULL;

-- Step 8: Rollback example (optional in DB Fiddle)
-- BEGIN TRANSACTION;
-- DELETE FROM employees WHERE emp_id = 5;
-- ROLLBACK; -- Undo the deletion

-- Step 9: Insert using SELECT
INSERT INTO employees (emp_id, first_name, last_name, email, phone, salary, department, joining_date)
SELECT emp_id + 10, first_name, last_name, email, phone, salary, department, joining_date
FROM employees
WHERE department = 'HR';

-- 1. Add new customers
INSERT INTO customers (first_name, last_name, email, phone)
VALUES 
  ('Ananya', 'Verma', 'ananya@example.com', '9000000044'),
  ('Rohit', 'Patel', 'rohit@example.com', '9000000055')
ON CONFLICT (email) DO NOTHING;

-- 2. Add addresses for new customers
INSERT INTO addresses (customer_id, address_line1, address_line2, city, state, postal_code, country, is_default)
VALUES 
  ((SELECT customer_id FROM customers WHERE email = 'ananya@example.com'),
   '303 Sunset Blvd', NULL, 'Delhi', 'DL', '110001', 'India', TRUE),

  ((SELECT customer_id FROM customers WHERE email = 'rohit@example.com'),
   '101 Ocean Drive', 'Near Beach', 'Goa', 'GA', '403001', 'India', TRUE);

-- 3. Add new products
INSERT INTO products (name, description, price, stock_quantity, category_id, supplier_id)
VALUES 
  ('Wireless Mouse', 'Ergonomic 2.4GHz mouse', 79.00, 50,
    (SELECT category_id FROM categories WHERE name = 'Electronics'),
    (SELECT supplier_id FROM suppliers WHERE name = 'TechWorld')),

  ('Science Textbook', 'Physics for Class 12', 149.00, 20,
    (SELECT category_id FROM categories WHERE name = 'Books'),
    (SELECT supplier_id FROM suppliers WHERE name = 'BookBarn'))
ON CONFLICT DO NOTHING;

-- 4. Add orders
-- Order for Ananya
INSERT INTO orders (customer_id, shipping_address_id, billing_address_id, status, total_amount)
VALUES (
  (SELECT customer_id FROM customers WHERE email = 'ananya@example.com'),
  (SELECT address_id FROM addresses 
   WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'ananya@example.com') 
     AND is_default = TRUE),
  (SELECT address_id FROM addresses 
   WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'ananya@example.com') 
     AND is_default = TRUE),
  'Confirmed', 79.00
);

-- Order for Rohit
INSERT INTO orders (customer_id, shipping_address_id, billing_address_id, status, total_amount)
VALUES (
  (SELECT customer_id FROM customers WHERE email = 'rohit@example.com'),
  (SELECT address_id FROM addresses 
   WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'rohit@example.com') 
     AND is_default = TRUE),
  (SELECT address_id FROM addresses 
   WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'rohit@example.com') 
     AND is_default = TRUE),
  'Confirmed', 149.00
);

-- 5. Add order items
-- Ananya's order (Wireless Mouse)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
  ((SELECT order_id FROM orders 
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'ananya@example.com') 
      AND total_amount = 79.00),
   (SELECT product_id FROM products WHERE name = 'Wireless Mouse'), 1, 79.00);

-- Rohit's order (Science Textbook)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
  ((SELECT order_id FROM orders 
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'rohit@example.com') 
      AND total_amount = 149.00),
   (SELECT product_id FROM products WHERE name = 'Science Textbook'), 1, 149.00);

-- 6. Add payments
INSERT INTO payments (order_id, amount, method, transaction_ref)
VALUES 
  ((SELECT order_id FROM orders 
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'ananya@example.com') 
      AND total_amount = 79.00),
   79.00, 'UPI', 'TXN555XYZ'),

  ((SELECT order_id FROM orders 
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email = 'rohit@example.com') 
      AND total_amount = 149.00),
   149.00, 'Credit Card', 'TXN777LMN');

-- 7. Add product reviews
INSERT INTO product_reviews (product_id, customer_id, rating, title, comment)
VALUES 
  ((SELECT product_id FROM products WHERE name = 'Wireless Mouse'),
   (SELECT customer_id FROM customers WHERE email = 'ananya@example.com'),
   5, 'Great Value', 'Really good mouse at this price.'),

  ((SELECT product_id FROM products WHERE name = 'Science Textbook'),
   (SELECT customer_id FROM customers WHERE email = 'rohit@example.com'),
   4, 'Very Helpful', 'Covered all syllabus topics.');

-- 8. Add product images
INSERT INTO product_images (product_id, image_url, alt_text, seq)
VALUES 
  ((SELECT product_id FROM products WHERE name = 'Wireless Mouse'),
   'https://example.com/images/mouse.jpg', 'Wireless Mouse Image', 1),

  ((SELECT product_id FROM products WHERE name = 'Science Textbook'),
   'https://example.com/images/science.jpg', 'Science Textbook Cover', 1);


