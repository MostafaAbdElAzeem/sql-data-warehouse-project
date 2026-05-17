# 🏗️ Sales Data Warehouse — ERP & CRM ETL Pipeline

A end-to-end data engineering project that extracts raw ERP and CRM data from CSV files, processes it through a **Medallion Architecture** (Bronze → Silver → Gold) hosted on **Microsoft SQL Server**, and delivers a clean **Star Schema** ready for BI & analytics consumption.

---

## 📌 Project Overview

This project implements a full ETL pipeline that integrates data from two source systems:

- **ERP** — Orders, product info, and sales historical data
- **CRM** — Customer info, product categories, and customer location data

The pipeline processes data through three progressive layers before exposing it as analytical views for tools like **Power BI** and **Machine Learning** workloads.

---

## 🏛️ Architecture

![High Level Architecture](docs/data_architecture.png)

| Layer | Object Type | Description |
|---|---|---|
| **Bronze** | Tables | Raw data ingested as-is from CSV source files |
| **Silver** | Tables | Cleaned, standardized, and validated data |
| **Gold** | Views | Business-ready data modeled as a Star Schema |

---

## 🔄 Data Flow (Lineage)

![Data Flow](docs/data_flow.png)

Six source tables flow through the pipeline:

**From CRM:** `crm_sales_details` · `crm_cust_info` · `crm_prd_info`

**From ERP:** `erp_cust_az12` · `erp_loc_a101` · `erp_px_cat_g1v2`

These are cleaned in the Silver layer and ultimately merged into three Gold objects: `fact_sales`, `dim_customers`, and `dim_products`.

---

## 🔗 Data Integration

![Data Integration](docs/data_integration.png)

The ERP and CRM datasets are joined through shared keys:

- `sales_details` links to `prd_info` via `sls_prd_key → prd_key`
- `sales_details` links to `cust_info` via `sls_cust_id → cst_id`
- CRM's `CUST_AZ12` and `LOC_A101` enrich customer records via `cid`
- CRM's `PX_CAT_G1V2` enriches product records via `id → prd_cat`

---

## ⭐ Star Schema (Gold Layer)

![Star Schema](docs/data_model.png)

### `gold.fact_sales`
| Column | Description |
|---|---|
| order_number | Unique order identifier |
| product_key (FK) | Links to `dim_products` |
| customer_key (FK) | Links to `dim_customers` |
| order_date | Date the order was placed |
| shipping_date | Date the order was shipped |
| due_date | Expected delivery date |
| sales_amount | Total sale value |
| quantity | Units sold |
| price | Unit price |

### `gold.dim_customers`
| Column | Description |
|---|---|
| customer_key (PK) | Surrogate key |
| customer_id | Source system ID |
| customer_numer | Customer number |
| first_name | First name |
| last_name | Last name |
| martial_status | Marital status |
| gender | Gender |
| birth_date | Date of birth |

### `gold.dim_products`
| Column | Description |
|---|---|
| product_key (PK) | Surrogate key |
| product_id | Source system ID |
| product_numer | Product number |
| product_name | Product name |
| category_id | Category identifier |
| product_category | Category name |
| product_subcategory | Subcategory name |
| product_line | Product line |
| product_cost | Cost of product |
| maintainance | Maintenance flag |
| product_start_date | Product launch date |

---

## 📁 Repository Structure

```
├── datasets/                   # Raw source CSV files (ERP and CRM data)
│
├── docs/                       # Project documentation & diagrams
│   ├── data_architecture.png   # High-level architecture overview
│   ├── data_flow.png           # Data lineage across layers
│   ├── data_integration.png    # Source table relationships
│   └── data_model.png          # Final Star Schema diagram
│
├── scripts/                    # SQL scripts for ETL and transformations
│   ├── bronze/                 # Extract & load raw data into Bronze tables
│   ├── silver/                 # Clean, standardize, and validate data
│   └── gold/                   # Build analytical views (Star Schema)
│
└── tests/                      # Data quality and validation test scripts
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Microsoft SQL Server** | Data warehouse engine |
| **SQL** | ETL scripting and transformations |
| **CSV Files** | Source data format (ERP & CRM) |
| **Data Modeling** |  

---

## 🚀 Getting Started

### Prerequisites
- Microsoft SQL Server (2019+ recommended)
- SQL Server Management Studio (SSMS) or Azure Data Studio

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Load raw data into Bronze layer**
   - Place source CSV files in the `datasets/` folder
   - Run all scripts under `scripts/bronze/` to ingest raw data

3. **Transform data into Silver layer**
   - Run all scripts under `scripts/silver/` to clean and standardize the data

4. **Build the Gold layer (Star Schema)**
   - Run all scripts under `scripts/gold/` to create analytical views

5. **Run data quality tests**
   - Execute scripts in `tests/` to validate data integrity

---

## 📊 Use Cases

Once the Gold layer is ready, the Star Schema can be consumed directly by:

- **BI Tools** (e.g., Power BI) for dashboards and reporting
- **Machine Learning** pipelines for predictive analytics
- **Ad-hoc SQL queries** for business analysis
