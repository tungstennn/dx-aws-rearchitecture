
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
    profit NUMERIC(12, 2),
    customer_satisfaction VARCHAR(20),
    returned VARCHAR(20)
);


