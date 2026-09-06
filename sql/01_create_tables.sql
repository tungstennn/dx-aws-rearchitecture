-- create staging table for sales data

CREATE TABLE IF NOT EXISTS sales_staging (
    order_id VARCHAR(20),
    order_line_id VARCHAR(20),
    order_date VARCHAR(20),
    region VARCHAR(20),
    sales_channel VARCHAR(20),
    sales_rep VARCHAR(100),
    category VARCHAR(50),
    product VARCHAR(100),
    units_sold VARCHAR(20),
    unit_price VARCHAR(20),
    discount_pct VARCHAR(20),
    revenue VARCHAR(20),
    cost VARCHAR(20),
    profit VARCHAR(20),
    customer_satisfaction VARCHAR(20),
    returned VARCHAR(20)
);

-- create final table for sales data

CREATE TABLE IF NOT EXISTS sales (
    order_id VARCHAR(20) NOT NULL,
    order_line_id VARCHAR(30) PRIMARY KEY,
    order_date DATE NOT NULL,
    region VARCHAR(20),
    sales_channel VARCHAR(20),
    sales_rep VARCHAR(100),
    category VARCHAR(50),
    product VARCHAR(100),
    units_sold INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    discount_pct NUMERIC(5,2) NOT NULL,
    revenue NUMERIC(12,2) NOT NULL,
    cost NUMERIC(12,2) NOT NULL,
    profit NUMERIC(12,2) NOT NULL,
    customer_satisfaction SMALLINT,
    returned BOOLEAN
);

