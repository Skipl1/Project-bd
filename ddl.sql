CREATE TABLE IF NOT EXISTS Users (
    user_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone VARCHAR(20) CHECK (phone ~ '^[0-9]{3,15}$'),
    address VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS ProductCategories (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Warehouses (
    warehouse_id INTEGER PRIMARY KEY,
    location VARCHAR(255) NOT NULL
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INTEGER REFERENCES ProductCategories(category_id),
    stock_quantity INTEGER NOT NULL,
    warehouse_id INTEGER REFERENCES Warehouses(warehouse_id)
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount > 0)
);

CREATE TABLE OrderItems (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES Orders(order_id),
    product_id INTEGER REFERENCES Products(product_id),
    quantity INTEGER NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL CHECK (price_at_purchase > 0)
);

CREATE TABLE Shipping (
    shipping_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES Orders(order_id),
    shipping_date TIMESTAMP,
    shipping_status VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(100) UNIQUE
);

CREATE TABLE OrderHistory (
    history_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES Orders(order_id),
    status VARCHAR(50) NOT NULL,
    change_date TIMESTAMP NOT NULL,
    changed_by VARCHAR(255) NOT NULL
);

CREATE TABLE Payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES Orders(order_id),
    payment_date TIMESTAMP NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'Cash'))
);
