# dbt Modern Warehouse

A modern ELT data warehouse built with dbt Core and PostgreSQL, using the Jaffle Shop dataset.

## Overview

This project implements a modern data warehouse demonstrating ELT pipeline design, dimensional modeling, data quality testing, and SCD2 historical tracking using dbt Core and PostgreSQL.

## Tech Stack

- **dbt Core** 1.8.2
- **PostgreSQL** 18
- **Python** 3.11

## Project Structure

```
jaffle_shop/
├── seeds/                        # Raw CSV source data
│   ├── raw_customers.csv
│   ├── raw_orders.csv
│   └── raw_payments.csv
├── models/
│   ├── staging/                  # Cleaned and renamed source data
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_payments.sql
│   │   └── schema.yml
│   └── marts/                    # Business-ready analytical models
│       ├── mart_customers.sql
│       └── mart_orders.sql
└── snapshots/                    # SCD2 historical tracking
    └── customers_snapshot.sql
```

## Data Lineage

```
raw_customers ──► stg_customers ──┐
raw_orders ────► stg_orders ──────┼──► mart_customers
raw_payments ──► stg_payments ────┤
                                  └──► mart_orders
```

## Models

**Staging** — raw data cleaned and renamed for consistency:
- `stg_customers` — customer IDs and names normalized
- `stg_orders` — orders with customer references and status
- `stg_payments` — payments with amounts converted to decimal

**Marts** — business-ready analytical tables:
- `mart_customers` — customers enriched with lifetime value, first order date, and total orders
- `mart_orders` — orders with payment breakdown by method (credit card, bank transfer, gift card)

**Snapshots** — SCD2 historical tracking:
- `customers_snapshot` — tracks customer changes over time using dbt snapshots

## Data Quality Tests

8 automated tests covering uniqueness, not-null constraints, and accepted values across all staging models.

```bash
dbt test
# Done. PASS=8 WARN=0 ERROR=0 SKIP=0 TOTAL=8
```

## Quick Start

```bash
# Clone the repository
git clone https://github.com/CarlosHenriqueCMoriera/dbt-modern-warehouse.git
cd dbt-modern-warehouse/jaffle_shop

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install dbt-core==1.8.2 dbt-postgres==1.8.2

# Configure your database credentials in ~/.dbt/profiles.yml

# Run the pipeline
dbt seed        # Load raw data
dbt run         # Build models
dbt test        # Run quality tests
dbt snapshot    # Run SCD2 snapshot
