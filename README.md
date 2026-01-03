# GridPulse

European Power Grid Stress — Early Warning System (ML + MLOps)

GridPulse is a production-grade Machine Learning and MLOps project designed to detect early signs of stress in the European power grid using official ENTSO-E data.

The system combines robust statistical signals, multivariate anomaly detection, and a fully reproducible MLOps pipeline (ingestion, backfill, data quality, feature engineering, model training, scoring, monitoring, replay) to compute an interpretable stress score per country, together with explicit drivers.

One-line pitch:
Detect when a European country is entering a power-grid stress situation — and explain why — before it becomes obvious in aggregated reports.

---

WHY THIS PROJECT EXISTS

Most energy-related data projects focus on forecasting a single signal or visualising historical trends.
GridPulse targets a different, harder problem.

- Critical real-world system: national electricity grids (energy security, industry, geopolitics)
- Official, regulated data: ENTSO-E Transparency Platform
- True ML problem: unsupervised detection of system-level regime changes
- True MLOps problem: backfill, data contracts, reproducibility, monitoring
- Rare in portfolios: not a toy dataset, not a Kaggle competition, not a simple forecast

The project is intentionally designed to be credible for ML Engineer and MLOps Engineer roles, while remaining deeply data-science driven.

---

WHAT GRIDPULSE DOES

For each European country (bidding zone), GridPulse:

1. Ingests official ENTSO-E data (hourly)
- Electricity load (consumption)
- Generation by energy source (nuclear, wind, solar, gas, hydro, etc.)
- Cross-border power flows (imports / exports)

All ingestion supports full historical backfill and deterministic replay.

2. Builds robust system-level features
- Demand spikes relative to seasonal baselines
- Supply shocks by generation type
- Import dependency and sudden flow changes
- Volatility and instability indicators
- Explicit data quality and coverage metrics

3. Trains a multivariate anomaly detection model
- Model: Isolation Forest
- Time-aware training and validation
- MLflow versioning

4. Produces an interpretable Stress Score (0–100)
- ML anomaly score
- Demand pressure component
- Supply shock component
- Import dependency component
- Data confidence penalty

5. Detects and tracks grid stress incidents
- Demand-driven stress events
- Supply shocks
- Import dependency stress
- Data quality incidents

6. Exposes results through a clear dashboard
- Europe-level overview
- Country-level drill-down
- Stress score evolution
- Incident timelines
- Historical replay

---

HIGH-LEVEL ARCHITECTURE

ENTSO-E API
→ Ingestion (Bronze / Raw)
→ Normalization (Silver)
→ Data Quality & Confidence
→ Feature Engineering (Gold)
→ ML Anomaly Detection (MLflow)
→ Stress Score & Attribution
→ Incidents & Alerts
→ Dashboard + Replay

Core principles:
- Raw data is immutable and replayable
- Transformations are deterministic
- ML models are versioned and auditable
- Data confidence is explicit

---

TECH STACK

- Language: Python
- Orchestration: Apache Airflow
- Streaming: Kafka / Redpanda
- Storage: Parquet (bronze / silver / gold)
- Metadata: PostgreSQL
- ML lifecycle: MLflow
- Visualization: Streamlit
- Packaging: Docker / Docker Compose

---

DATA SOURCES

ENTSO-E Transparency Platform
Official European electricity system data.

Datasets:
- Load
- Generation per type
- Cross-border flows

Documentation:
https://transparency.entsoe.eu/

---

MACHINE LEARNING APPROACH

Type: Unsupervised anomaly detection
Objective: Detect system-level stress regimes
Inputs: Multivariate time-indexed features

Model:
Isolation Forest

Evaluation:
- Detection delay
- False positive stability
- Alert persistence
- Cross-country consistency

---

PROJECT STRUCTURE

infra/
ingestion/
bronze/
silver/
gold/
dq/
ml/
incidents/
dashboard/
contracts/
docs/
README.md

---

GETTING STARTED

Prerequisites:
- Docker
- Docker Compose
- ENTSO-E API token

Environment variables:
ENTSOE_API_KEY=your_token_here

Run:
docker compose up --build

---

DESIGN PHILOSOPHY

- ML is not decorative
- Data quality is first-class
- Explainability beats raw accuracy
- Everything is replayable

---

LICENSE

MIT
