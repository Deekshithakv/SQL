
-- 1. categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- 2. suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(150),
    phone VARCHAR(30),
    address TEXT
);

-- 3. products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    category_id INT REFERENCES categories(category_id) ON DELETE SET NULL,
    supplier_id INT REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 4. customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 5. addresses
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(40),
    country VARCHAR(100),
    is_default BOOLEAN DEFAULT FALSE
);

-- 6. orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT NOW(),
    shipping_address_id INT REFERENCES addresses(address_id) ON DELETE SET NULL,
    billing_address_id INT REFERENCES addresses(address_id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    total_amount NUMERIC(12,2) DEFAULT 0
);

-- 7. order_items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- 8. payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT NOW(),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'Completed',
    transaction_ref VARCHAR(200)
);

-- 9. product_reviews
CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    customer_id INT REFERENCES customers(customer_id) ON DELETE SET NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(200),
    comment TEXT,
    review_date TIMESTAMP DEFAULT NOW()
);

-- 10. product_images
CREATE TABLE product_images (
    image_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    seq INT DEFAULT 0
);

