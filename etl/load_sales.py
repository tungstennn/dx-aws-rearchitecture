import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text


load_dotenv()

CSV_PATH = "data/sales.csv"

DB_URL = (
    f"postgresql+psycopg2://"
    f"{os.getenv('POSTGRES_USER')}:"
    f"{os.getenv('POSTGRES_PASSWORD')}@"
    f"{os.getenv('POSTGRES_HOST')}:"
    f"{os.getenv('POSTGRES_PORT')}/"
    f"{os.getenv('POSTGRES_DB')}"
)


engine = create_engine(DB_URL)


def load_sales():
    try:
        # Read everything as strings so PostgreSQL staging receives raw values
        df = pd.read_csv(
            CSV_PATH,
            dtype=str,
            keep_default_na=False
        )

        # structural mapping only
        df.columns = [
            "order_id",
            "order_line_id",
            "order_date",
            "region",
            "sales_channel",
            "sales_rep",
            "category",
            "product",
            "units_sold",
            "unit_price",
            "discount_pct",
            "revenue",
            "cost",
            "profit",
            "customer_satisfaction",
            "returned",
        ]

        with engine.begin() as conn:
            conn.execute(text("TRUNCATE TABLE sales_staging"))

        df.to_sql(
            "sales_staging",
            engine,
            if_exists="append",
            index=False
        )

        print(f"Loaded {len(df)} rows into sales_staging")

    except Exception as e:
        print(f"Error loading sales data: {e}")
        return


    try:
        with engine.begin() as conn:
            conn.execute(text("CALL load_sales()"))

        print("Transformation complete: sales table loaded")

    except Exception as e:
        print(f"Error transforming sales data: {e}")
        return

if __name__ == "__main__":
    load_sales()