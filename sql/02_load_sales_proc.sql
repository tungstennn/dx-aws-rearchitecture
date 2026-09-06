-- Load sales data from staging table to final table - INCREMENTAL LOAD

CREATE OR REPLACE PROCEDURE load_sales()
LANGUAGE plpgsql
AS $$
BEGIN


-- Remove existing versions of records in this batch

    DELETE FROM sales
	USING sales_staging
	WHERE sales.order_line_id = UPPER(NULLIF(TRIM(sales_staging.order_line_id), ''));


-- reload the current batch

    INSERT INTO sales (
        order_id,
        order_line_id,
        order_date,
        region,
        sales_channel,
        sales_rep,
        category,
        product,
        units_sold,
        unit_price,
        discount_pct,
        revenue,
        cost,
        profit,
        customer_satisfaction,
        returned
    )
    WITH cleaned AS (
        SELECT
            UPPER(NULLIF(TRIM(order_id), '')) AS order_id,
            UPPER(NULLIF(TRIM(order_line_id), '')) AS order_line_id,
            CASE
                WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$'
                    THEN TO_DATE(order_date, 'YYYY-MM-DD')
                WHEN order_date ~ '^\d{4}/\d{2}/\d{2}$'
                    THEN TO_DATE(order_date, 'YYYY/MM/DD')
                WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$'
                    THEN TO_DATE(order_date, 'DD/MM/YYYY')
            END AS order_date,
            UPPER(COALESCE(NULLIF(TRIM(region), ''), 'unknown')) AS region,
            UPPER(TRIM(sales_channel)) AS sales_channel,
            UPPER(TRIM(sales_rep)) AS sales_rep,
            UPPER(TRIM(category)) AS category,
            UPPER(TRIM(product)) AS product,
            NULLIF(TRIM(units_sold), '')::INTEGER AS units_sold,
            NULLIF(TRIM(unit_price), '')::NUMERIC(10,2) AS unit_price,
            NULLIF(TRIM(discount_pct), '')::NUMERIC(5,2) AS discount_pct,
            NULLIF(TRIM(cost), '')::NUMERIC(12,2) AS cost,
            NULLIF(TRIM(customer_satisfaction), '')::SMALLINT AS customer_satisfaction,
            CASE
                WHEN LOWER(TRIM(returned)) = 'yes' THEN TRUE
                WHEN LOWER(TRIM(returned)) = 'no' THEN FALSE
            END AS returned,
            ROW_NUMBER() OVER (
                PARTITION BY UPPER(TRIM(order_line_id))
                ORDER BY UPPER(TRIM(order_line_id))
            ) AS rn
        FROM sales_staging
    )
    SELECT
        order_id,
        order_line_id,
        order_date,
        region,
        sales_channel,
        sales_rep,
        category,
        product,
        units_sold,
        unit_price,
        discount_pct,
        ROUND(units_sold * unit_price * (1 - discount_pct / 100),2) AS revenue,
        cost,
        ROUND((units_sold * unit_price * (1 - discount_pct / 100)) - cost,2) AS profit,
        customer_satisfaction,
        returned
    FROM cleaned
    WHERE rn = 1
      AND order_id IS NOT NULL
      AND order_line_id IS NOT NULL
      AND order_date IS NOT NULL
      AND units_sold IS NOT NULL
      AND unit_price IS NOT NULL
      AND discount_pct IS NOT NULL
      AND cost IS NOT NULL
      AND returned IS NOT NULL;
END;
$$;