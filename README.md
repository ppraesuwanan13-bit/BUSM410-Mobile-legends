# Mobile Legends

## BUSM 410 Semester Project — CP2: Drivers and Model

| **Item** | **Value** |
|---|---|
| Team members | Suwanan Yamma; Thipwigorn Khamjan |
| Canvas team | Team Mobile Legends |
| BigQuery dataset and table | `bigquery-public-data.new_york_citibike.citibike_trips` |
| Google Cloud project ID | `striking-canyon-509700-b8` |

## Problem framing

Across 311 station IDs with consistent recorded coordinates and rides in both matched periods, recorded ride starts rose from 6,647,007 in January–October 2014 to 7,307,992 in the same months of 2015: **660,985 more rides (+9.94%)**. This is a stable-location subset, not a systemwide total. Individual stations moved in different directions: 246 had more recorded rides and 65 had fewer. The comparison is descriptive and does not explain why activity changed. The trip table does not contain fare-per-trip or payment amounts, so we do not estimate revenue. See the [SQL query log](sql/README.md).

## CP2: station characteristics and ride change

We compared average ride change across three groups of stations for subscriber share, weekday peak-hour share, and latitude. Average change was positive in every group. The northern latitude third had the largest average increase (+2,931.7 rides); the southern third had the smallest (+841.1). In the linear regression, latitude was the only predictor with a p-value below 0.05 (coefficient +51,542.5 rides per degree, p = 0.00062). The model's R² was 0.0792, and its mean absolute error was about 2,595 rides. It was evaluated on the same 311 stations used for training, so it does not measure performance on new stations. These are associations, not causes. See the [model card](model/model_card.md) and [SQL query log](sql/README.md).

## Explore the work

| File or folder | What it contains |
|---|---|
| [charter.md](charter.md) | Question, decision, scope, and success criteria |
| [sql/README.md](sql/README.md) | Query results, cleaning choices, and interpretation |
| [sql/](sql/) | Numbered BigQuery queries |
| [sql/10_station_analysis_table.sql](sql/10_station_analysis_table.sql) | CP2 station-level outcome and predictor table |
| [sql/11_analysis_table_quality_check.sql](sql/11_analysis_table_quality_check.sql) | CP2 missing-value, range, and arithmetic check |
| [sql/12_station_change_linear_regression.sql](sql/12_station_change_linear_regression.sql) | CP2 regression model |
| [sql/13_station_change_model_weights.sql](sql/13_station_change_model_weights.sql) | Regression coefficients and p-values |
| [sql/14_station_predictor_group_means.sql](sql/14_station_predictor_group_means.sql) | Part A group means for observed predictor values and chart terciles |
| [model/model_card.md](model/model_card.md) | Regression metrics, coefficients, and limitations |
| [model/notes.md](model/notes.md) | Model work summary |
| [visuals/gap_chart.png](visuals/gap_chart.png) | Matched-period chart for station 318, included as an example station |
| [visuals/cp2_station_group_comparisons.svg](visuals/cp2_station_group_comparisons.svg) | CP2 comparison of mean ride change across all 311 stable-location stations, split by subscriber share, weekday peak share, and latitude |
| [Other/DATASET.md](Other/DATASET.md) | Dataset documentation links |
| [Other/citibike_erd.dbml](Other/citibike_erd.dbml) | Table diagram in DBML |
| [Other/audit_protocol.md](Other/audit_protocol.md) | How the team directs and checks the agent |
| [Other/audit_log.md](Other/audit_log.md) | Logged data checks and analysis changes |
| [AGENTS.md](AGENTS.md) | Project facts and working instructions |

## Dataset documentation

The [Citi Bike system data page](https://citibikenyc.com/system-data) explains the trip-history data and provides public downloads. The [NYC Open Data record](https://data.cityofnewyork.us/dataset/Citi-Bike-System-Data/vsnr-94wk) identifies the dataset provider and points to the source.

## Who did the work

Suwanan Yamma and Thipwigorn Khamjan, working with OpenAI Codex. Our team is responsible for checking the analysis, sources, and conclusions.
