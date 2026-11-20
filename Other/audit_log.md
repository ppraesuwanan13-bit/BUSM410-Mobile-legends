# Audit Log

This log records checks, corrections, and analysis choices made by the team with AI assistance. The team should review the saved queries and results before submission.

| Category | What it means | Entries |
|---|---|---:|
| [Verified a claim](#verified-a-claim) | A claim was checked against BigQuery or documentation. | 12 |
| [Caught an error](#caught-an-error) | An incorrect statement, query, or calculation was found. | 4 |
| [Separated fact from opinion](#separated-fact-from-opinion) | A conclusion was marked as an inference or limit. | 1 |
| [Changed the analysis](#changed-the-analysis) | Evidence changed the project approach. | 2 |
| [Improved the agent's instructions](#improved-the-agents-instructions) | Project facts or directions were clarified. | 1 |

## Verified a claim

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 1 | 2026-11-11 | Station 318 had 46,934 Jan–Oct 2014 trips and 40,861 Jan–Oct 2015 trips after exact full-row duplicates were counted once. | Ran the matched-period query in BigQuery. | Confirmed both counts; the difference is 6,073 rides (12.94%). See [query 07](../sql/07_station_318_matched_period.sql). |
| 2 | 2026-11-11 | Station 318's reported name and coordinates were stable in observed Jan–Oct months, with no Nov–Dec 2015 rows. | Reviewed the monthly station query results. | Confirmed the returned values; the data does not establish why no late-2015 trips appear. See [query 08](../sql/08_station_318_monthly_stability.sql). |
| 3 | 2026-11-11 | 2014 and 2015 had complete calendar-year coverage; other years shown had partial-year coverage. | Ran the yearly coverage query. | Confirmed the dates and counts in [sql/README.md](../sql/README.md). |
| 4 | 2026-11-11 | The start-field check found 58,937,715 rows, 5,828,994 missing all three required start fields, and zero future dates. | Ran the cleaning and overlap queries. | Confirmed the results. |
| 5 | 2026-11-11 | Nine repeated signatures included one exact full-row pair and eight nonidentical pairs. | Ran the signature and full-row comparison queries. | Confirmed; no source rows were deleted. |
| 12 | 2026-11-19 | Codex created the CP2 station analysis table after the team requested help. | Checked the BigQuery completion message and opened the table Preview. | Confirmed the table exists and Preview shows 311 rows. The follow-up quality check is recorded in entry 14. |
| 14 | 2026-11-19 | Codex ran the CP2 station-table quality check. | Reviewed the BigQuery JSON result for [query 11](../sql/11_analysis_table_quality_check.sql), then checked the totals by subtraction. | Confirmed five checks: 311 total rows; 311 unique station IDs; 0 rows with missing values; 0 rows with impossible values; and 0 `ride_change` mismatches. The result also showed 6,647,007 rides in 2014 and 7,307,992 in 2015. As a second-way arithmetic check, 7,307,992 − 6,647,007 = 660,985, matching the documented net increase. This arithmetic reconciliation uses the query 11 totals; it is not an independent source-table query. |
| 15 | 2026-11-19 | The 2014 subscriber gender check returned `male`, `female`, and `unknown`. | Reviewed the BigQuery result grouped by `gender` for subscriber rides. | Counts were 5,635,912 male, 1,650,252 female, and 1,557 unknown. The station table's female share uses known male/female records in its denominator. The team should confirm this definition matches the assignment. |
| 16 | 2026-11-19 | An earlier regression run reported latitude as the only predictor with p < 0.05. | Reviewed the BigQuery `ML.ADVANCED_WEIGHTS` output and model details; see [model card](../model/model_card.md). | Latitude coefficient was +51,542.5 rides per degree (p = 0.000619). That run's metrics used the same 311 stations for fitting and evaluation. The corrected final model options are described in entry 17. This is an association, not a cause. |
| 17 | 2026-11-19 | The corrected model run followed the assignment options and produced an evaluation result. | Reviewed BigQuery's successful query status, `ML.EVALUATE` result, and `ML.ADVANCED_WEIGHTS` output. | Confirmed `r2_score` 0.079209, MAE 2,595.0 rides, and latitude as the only predictor with p < 0.05. There is no holdout because the analysis table has 311 rows. AI helped prepare the query and summarize output; the team should review the SQL and results. |
| 19 | 2026-11-19 | The exact-value statement in query 14 ran in the team's BigQuery project. | Checked the completed job and result count in BigQuery. | Confirmed that the query completed and returned 886 predictor-value rows. The team should review the observed-value patterns before presenting them. |
| 20 | 2026-11-19 | The second statement in query 14 checked the tercile means used in the chart. | Reviewed the completed BigQuery result table with 9 predictor-group rows. | Confirmed each predictor had group sizes 104, 104, and 103. The nine means matched the chart and query log: subscriber share +2,260.1/+1,746.3/+2,372.0; weekday peak share +2,412.8/+1,869.8/+2,093.1; latitude +841.1/+2,611.0/+2,931.7. |

## Caught an error

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 6 | 2026-11-11 | An early station 318 query compared all of 2014 with only Jan–Oct 2015. | Compared the SQL date filters with the monthly results, then reran both years for Jan–Oct. | Corrected the benchmark to matched Jan–Oct windows. |
| 7 | 2026-11-11 | The repository initially named `one_bike_ride` as the trip table. | Ran the table inventory query. | Corrected: BigQuery listed `citibike_trips` and `citibike_stations`. |
| 13 | 2026-11-19 | The first CP2 table query failed with “Aggregations of aggregations are not allowed” while checking station locations. | Separated distinct coordinate pairs into their own CTE and reran the corrected query. | BigQuery created `BUSM410_CP2.station_analysis`; its Preview showed 311 rows. |
| 18 | 2026-11-19 | The first saved model documentation described `NO_SPLIT` as a model option, although the assignment requires omitting the split option. | Compared the saved model SQL with the assignment options and checked the corrected BigQuery run. | Updated the SQL description and model card: split option omitted; p-values and dummy encoding enabled; 50 iterations; early stopping disabled. With 311 rows, evaluation uses the same observations. |

## Separated fact from opinion

| # | Date | Data fact | Interpretation or limit |
|---|---|---|---|
| 8 | 2026-11-11 | Matched-period ride records decreased by 6,073 (12.94%). | This does not identify a cause or establish a revenue loss. We rely on the State Comptroller's [audit](https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf) for the revenue limitation. |

## Changed the analysis

| # | Date | Evidence | Change |
|---|---|---|---|
| 9 | 2026-11-11 | Station 540's monthly output showed a name/coordinate change and gaps in observed months; station 318 had stable reported location for the matched months. | Set aside station 540 and use station 318 for the matched Jan–Oct comparison. |
| 11 | 2026-11-19 | The instructor's feedback asked us to compare stations broadly; the project homepage reports the 311-station stable-location comparison. | Updated the charter and project homepage to frame station 318 as an example within a broader station-level analysis. |

## Improved the agent's instructions

| # | Date | Instruction changed | Reason |
|---|---|---|---|
| 10 | 2026-11-11 | Added the selected question, measured station 318 gap, benchmark, and revenue limitation to `AGENTS.md`. | Keep future analysis consistent with checked results and avoid unsupported revenue or causal claims. |
