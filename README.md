# Mobile Legends

## BUSM 410 Semester Project — CP0

| **Item** | **Value** |
|---|---|
| Team members | Suwanan Yamma; Thipwigorn Khamjan |
| Canvas team | Team Mobile Legends |
| BigQuery dataset and table | `bigquery-public-data.new_york_citibike.citibike_trips` |
| Google Cloud project ID | `striking-canyon-509700-b8` |

## Problem framing

At Citi Bike station 318 (E 43 St & Vanderbilt Ave), recorded ride starts fell from 46,934 in January–October 2014 to 40,861 in the same months of 2015, a decrease of 6,073 trips or 12.94%. We compare the same station and calendar months to control for seasonal timing; the gap is worth 6,073 fewer recorded trips by the dataset's count. The available trip table does not support a reliable dollar estimate because it lacks fare-per-trip/payment data, and the State Comptroller notes trip totals do not directly correspond to revenue. See the [analysis SQL](sql/07_station_318_matched_period.sql), [findings](findings.md), and [source audit](https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf).

## Explore the work

| File or folder | What it contains |
|---|---|
| [charter.md](charter.md) | Question, decision, scope, and success criteria |
| [findings.md](findings.md) | Measured gap, benchmark, value, limits, and chart |
| [sql/README.md](sql/README.md) | Query results, cleaning choices, and interpretation |
| [sql/](sql/) | Numbered BigQuery queries |
| [visuals/gap_chart.png](visuals/gap_chart.png) | Matched-period ride-count chart |
| [Other/DATASET.md](Other/DATASET.md) | Dataset documentation links |
| [Other/citibike_erd.dbml](Other/citibike_erd.dbml) | Table diagram in DBML |
| [Other/audit_protocol.md](Other/audit_protocol.md) | How the team directs and checks the agent |
| [Other/audit_log.md](Other/audit_log.md) | Logged data checks and analysis changes |
| [AGENTS.md](AGENTS.md) | Project facts and working instructions |

## Dataset documentation

The [Citi Bike system data page](https://citibikenyc.com/system-data) explains the trip-history data and provides public downloads. The [NYC Open Data record](https://data.cityofnewyork.us/dataset/Citi-Bike-System-Data/vsnr-94wk) identifies the dataset provider and points to the source.

## Who did the work

Suwanan Yamma and Thipwigorn Khamjan, working with OpenAI Codex. Our team is responsible for checking the analysis, sources, and conclusions.
