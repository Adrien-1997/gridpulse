# GridPulse

**European Power Grid Stress — Early Warning System (ML + MLOps)**

GridPulse is a production‑oriented **Machine Learning + MLOps** project that detects **early signs of stress in the European power grid** using official ENTSO‑E data.

The system combines **robust statistics**, **multivariate anomaly detection**, and a **full MLOps pipeline** (ingestion, data quality, feature engineering, model training, scoring, monitoring, replay) to produce an **interpretable stress score per country**, with clear explanations.

> **One‑line pitch**  
> Detect when a European country is entering a power‑grid stress situation — and explain *why* — before it becomes obvious in aggregated reports.

---

## Why this project

- **Real critical system**: electricity grids (energy, industry, geopolitics)
- **Official data**: ENTSO‑E Transparency Platform
- **True ML problem**: multivariate anomaly detection on system‑level signals
- **True MLOps problem**: orchestration, backfill, model registry, monitoring
- **Rare in portfolios**: not a toy forecast, not a Kaggle dataset

This project is designed to be **credible for ML Engineer / MLOps Engineer roles**, while remaining **deeply data‑science driven**.

---

## What GridPulse does

For each European country (bidding zone), GridPulse:

1. Ingests official ENTSO‑E data (hourly)
   - Electricity **load (consumption)**
   - **Generation by energy source** (nuclear, wind, solar, gas, hydro, …)
   - **Cross‑border power flows** (imports / exports)

2. Builds robust, stationarised **system features**
   - Demand spikes vs seasonal baseline
   - Supply shocks by generation type
   - Import dependency and sudden flow changes
   - Volatility and instability indicators
   - Data quality confidence signals

3. Trains a **multivariate anomaly detection model** (Isolation Forest)
   - Time‑aware training (no leakage)
   - Country‑level or global modelling
   - Versioned with MLflow

4. Produces a **Stress Score (0–100)** per country
   - ML anomaly score (central)
   - Interpretable components (demand / supply / imports)
   - Penalty for low data confidence

5. Detects and tracks **grid stress incidents**
   - Demand spikes
   - Supply shocks (e.g. wind drop, nuclear outage)
   - Import dependency stress
   - Data quality incidents

6. Exposes results via a **clear dashboard**
   - Europe‑level overview
   - Country‑level explanation
   - Incident timelines
   - Historical replay

---

## High‑level architecture

```
ENTSO‑E API
    ↓
Ingestion (Bronze / Raw)
    ↓
Normalization (Silver)
    ↓
Data Quality & Confidence
    ↓
Feature Engineering (Gold)
    ↓
ML Anomaly Detection (MLflow)
    ↓
Stress Score & Attribution
    ↓
Incidents & Alerts
    ↓
Dashboard + Replay
```

**Key principles**:
- Bronze data is immutable and replayable
- All transformations are deterministic
- ML models are versioned and auditable
- Data confidence is never hidden

---

## Tech stack

| Layer | Technology |
|---|---|
| Language | Python |
| Orchestration | Apache Airflow |
| Streaming / events | Kafka / Redpanda |
| Storage | Parquet (bronze/silver/gold) |
| Metadata & incidents | PostgreSQL |
| ML lifecycle | MLflow |
| Visualization | Streamlit |
| Packaging | Docker / Docker Compose |

---

## Data sources

### ENTSO‑E Transparency Platform
Official European electricity system data.

Used datasets:
- **Load** (electricity consumption per country)
- **Generation per type** (nuclear, wind, solar, gas, hydro, …)
- **Cross‑border flows** (imports / exports)

Access requires a free API token.

Documentation:
https://transparency.entsoe.eu/

---

## Machine Learning approach

### Problem formulation

- **Type**: Unsupervised / semi‑supervised anomaly detection
- **Target**: System‑level stress situations (regime changes)
- **Input**: Multivariate time‑series features (gold layer)

No naive forecasting. No single KPI threshold.

The model learns what a *normal operating regime* looks like and detects **deviations across multiple signals simultaneously**.

### Model
- Isolation Forest (robust, interpretable, production‑friendly)
- Time‑aware training / validation
- Dynamic thresholds

### Evaluation
- Detection delay
- False positive rate
- Stability of alerts
- Consistency across countries

---

## Stress Score

The **Stress Score** (0–100) combines:

- ML anomaly score (core signal)
- Demand pressure component
- Supply shock component (by generation type)
- Import dependency component
- Data confidence penalty

Each score is accompanied by **clear drivers**, e.g.:
> “65% of stress due to wind generation drop, 25% due to demand spike.”

---

## Project structure

```
.
├── infra/              # Docker, Airflow, infrastructure
├── ingestion/          # ENTSO‑E API client, raw ingestion
├── bronze/             # Raw immutable data
├── silver/             # Normalized time series
├── gold/               # Features and stress scores
├── dq/                 # Data quality & confidence
├── ml/                 # Training, scoring, MLflow
├── incidents/          # Incident detection & attribution
├── dashboard/          # Streamlit app
├── contracts/          # Data schemas & contracts
├── docs/               # Architecture, ML, runbooks
└── README.md
```

---

## Getting started

### Prerequisites
- Docker & Docker Compose
- ENTSO‑E API token

### Environment variables
Create a `.env` file:

```
ENTSOE_API_KEY=your_token_here
```

### Run locally

```
docker compose up --build
```

Once running:
- Airflow UI: http://localhost:8080
- Dashboard: http://localhost:8501

---

## Example use cases

- Detect early stress during extreme weather
- Identify supply shocks (wind / nuclear outages)
- Monitor increasing dependency on imports
- Replay historical events and analyze drivers

---

## Design philosophy

- **ML is not decoration** — it is central and justified
- **Data quality is first‑class** — bad data never hides
- **Explainability beats raw accuracy**
- **Everything is replayable**

---

## Status

🚧 Actively developed — flagship portfolio project

Planned extensions:
- More countries
- Graph‑based flow modelling
- Advanced attribution (SHAP on system features)

---

## License

MIT

---

## Contact

Built as a professional MLOps / ML Engineering portfolio project.

If you are a recruiter or engineer and want to discuss the design choices, feel free to reach out.
