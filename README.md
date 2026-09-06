# dx-aws-rearchitecture

This project demonstrates a simple end-to-end data pipeline for ingesting, transforming, storing and visualising sales data.

## Architecture

```text
Sales CSV
   ↓
Python ingestion
   ↓
PostgreSQL
   ↓
SQL transformation
   ↓
Sales reporting table
   ↓
Grafana dashboards
```

The solution is intentionally lightweight for the technical exercise, while keeping the structure easy to extend into a production AWS architecture.

## Tech Stack

* Python
* PostgreSQL 16
* Docker / Docker Compose
* SQL
* Grafana

## Running the Project

### 1. Start the environment

```bash
docker compose up -d
```

This starts PostgreSQL and Grafana.

### 2. Set up Python

```bash
python3 -m venv .venv
source .venv/bin/activate

pip install pandas sqlalchemy psycopg2-binary python-dotenv
```

### 3. Run the ingestion pipeline

Run the Python ingestion script to load the source sales CSV into PostgreSQL.

```bash
python3 etl/load_sales.py
```

### 4. Transform the data

The SQL transformation layer cleans and prepares the source data for reporting, including standardising fields and calculating metrics such as:

* Revenue
* Cost
* Profit
* Returns
* Customer satisfaction

### 5. View the dashboard

Open Grafana at:

```text
http://localhost:3000
```

The dashboard provides visualisations of the processed sales data.

## Production Considerations

A production implementation could replace the local components with AWS services such as:

```text
S3 → Glue/Lambda → Redshift → Grafana / BI Layer
```

Additional improvements could include automated orchestration, data-quality checks, CI/CD, monitoring and incremental data processing.
