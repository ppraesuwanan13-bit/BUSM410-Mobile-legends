# SQL Query Log

This log explains the BigQuery queries used for the Citi Bike station-and-time analysis. Each numbered SQL file starts with a short note pointing here. Results are from team checks and BigQuery work completed with AI assistance; the team should review them before submission.

## Dataset and fields

The dataset is `bigquery-public-data.new_york_citibike`. BigQuery listed `citibike_stations` and `citibike_trips`; the table used here is `citibike_trips`. Verified fields include `starttime` (DATETIME), `start_station_id` (INT64), `start_station_name` (STRING), station latitude/longitude, `bikeid`, and end-station fields. Citi Bike's [system data page](https://citibikenyc.com/system-data) describes the public trip-history data and its prior field definitions.

## Query inventory and results

| File | Purpose | Result |
|---|---|---|
| [01_table_inventory.sql](01_table_inventory.sql) | List tables in the dataset. | `citibike_stations`, `citibike_trips`. |
| [02_trip_start_station_fields.sql](02_trip_start_station_fields.sql) | Confirm start and station field names and types. | Confirmed fields listed above. |
| [03_cleaning_missing_future.sql](03_cleaning_missing_future.sql) | Count total rows, missing start fields, and future dates. | 58,937,715 rows; 5,828,994 missing each start field; 0 future start dates (query run 2026-11-11). |
| [04_cleaning_missing_overlap.sql](04_cleaning_missing_overlap.sql) | Check whether required fields are missing together. | 5,828,994 missing all three; 5,828,994 missing any. |
| [05_duplicate_signature_counts.sql](05_duplicate_signature_counts.sql) | Screen repeated signatures using start time, bike ID, and start/end station IDs. | 9 repeated signatures, 9 extra rows, maximum 2 copies. |
| [06_duplicate_full_row_review.sql](06_duplicate_full_row_review.sql) | Compare every column for repeated signatures. | One pair identical across the full row; eight pairs differed in other fields. |
| [07_station_318_matched_period.sql](07_station_318_matched_period.sql) | Count distinct full-row trips for station 318 in matched Jan–Oct periods. | 2014: 46,934; 2015: 40,861. |
| [08_station_318_monthly_stability.sql](08_station_318_monthly_stability.sql) | Review monthly station names and coordinates for the chosen comparison. | Team results show station 318 as E 43 St & Vanderbilt Ave at the same coordinates in all observed Jan–Oct months in both years. No Nov–Dec 2015 station 318 rows were returned. |
| [09_yearly_coverage.sql](09_yearly_coverage.sql) | Check the date coverage before choosing comparison years. | 2014 and 2015 were complete calendar years; other listed years had partial-year coverage. See the rows below. |
| [10_station_analysis_table.sql](10_station_analysis_table.sql) | Build the CP2 station-level outcome and 2014 predictors in the team's dataset. | BigQuery created `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`; preview showed 311 rows (run 2026-11-19). |
| [11_analysis_table_quality_check.sql](11_analysis_table_quality_check.sql) | Check the station table for missing/impossible values and verify `ride_change`. | 311 rows and 311 unique stations; 0 rows with missing values, 0 with impossible values, and 0 outcome mismatches. Ride totals: 6,647,007 in 2014 and 7,307,992 in 2015 (run 2026-11-19). |
| [12_station_change_linear_regression.sql](12_station_change_linear_regression.sql) | Fit the CP2 linear regression to the station analysis table. | Model `station_change_linear_reg` created with p-values, dummy encoding, 50 maximum iterations, and early stopping disabled; split option omitted as instructed (run 2026-11-19). |
| [13_station_change_model_weights.sql](13_station_change_model_weights.sql) | Retrieve unstandardized regression weights, standard errors, and p-values. | Latitude was the only predictor with p < 0.05 (run 2026-11-19); see [model card](../model/model_card.md). |

## CP2 analysis table

The unit is one station ID. `ride_change` is the 2015 Jan–Oct ride count minus the 2014 Jan–Oct count. Candidate predictors use 2014 rides: latitude, longitude, subscriber share, female share among subscribers with known gender, weekday peak-hour share, and starting ride count (`rides_2014`). Weekday peak hours are Monday–Friday, 7:00–9:59 a.m. and 4:00–6:59 p.m. A source-category check returned 2014 subscriber rows with gender values `male` (5,635,912), `female` (1,650,252), and `unknown` (1,557); the female-share denominator therefore includes only known male/female subscribers.

The table keeps station IDs with exactly one start-coordinate pair after rounding both coordinates to four decimal places and with recorded rides in both periods. Exact duplicate full rows are counted once. The first BigQuery attempt failed because the location check nested an aggregate alias. The query was corrected by checking distinct location pairs in a separate CTE; the corrected query completed and the table preview showed 311 rows. The quality check found no missing or impossible values and no `ride_change` arithmetic mismatches. The source gender check confirmed three categories; unknown gender is excluded from the female-share denominator.

## Exploratory group comparisons and model

Across the 311 included stations, total rides increased by 660,985 (+9.94%); 246 stations increased and 65 decreased. In tercile comparisons, average ride change was positive in every group: subscriber-share groups averaged +2,260.1 (low), +1,746.3 (middle), and +2,372.0 (high) rides; weekday peak-share groups averaged +2,412.8, +1,869.8, and +2,093.1; latitude bands averaged +841.1 (southern), +2,611.0 (middle), and +2,931.7 (northern). These are descriptive group averages, not causal effects. The three group comparison results and regression output were run in BigQuery on 2026-11-19.

The [CP2 station-group chart](../visuals/cp2_station_group_comparisons.svg) displays these mean changes for the full stable-location sample. The earlier [Station 318 chart](../visuals/gap_chart.png) is retained as a single-station example from CP1.

The linear regression predicts `ride_change` from 2014 latitude, longitude, ride count, subscriber share, female share, and weekday peak-hour share. It used all 311 stations; with fewer than 500 rows there was no held-out test set. The `r2_score` was 0.0792, meaning the model explains only a small part of variation in station ride changes, and mean absolute error was about 2,595 rides. Latitude was the only predictor with p < 0.05 (coefficient +51,542.5 rides per degree, p = 0.00062). Longitude had the next-lowest predictor p-value (0.0926), above 0.05. These are conditional associations, not causes. The subscriber-share comparisons were positive in all three groups but non-monotonic (middle lowest); weekday peak-share comparisons were also positive and non-monotonic (middle lowest); average gains were larger in the middle and northern latitude bands than the south. See [model card](../model/model_card.md) for each predictor, p-value, and limits.

The yearly coverage result was:

| Year | Ride rows | First date | Last date |
|---|---:|---|---|
| 2013 | 5,037,185 | 2013-07-01 | 2013-12-31 |
| 2014 | 8,081,216 | 2014-01-01 | 2014-12-31 |
| 2015 | 9,937,969 | 2015-01-01 | 2015-12-31 |
| 2016 | 10,262,649 | 2016-01-01 | 2016-09-30 |
| 2017 | 14,118,669 | 2017-04-01 | 2017-12-31 |
| 2018 | 5,671,033 | 2018-01-01 | 2018-05-31 |

## Cleaning choices

- For a station-by-time analysis, rows missing `starttime`, `start_station_id`, or a nonblank `start_station_name` cannot be assigned to the required groups. Exclude them from this analysis while retaining the original source rows. The initial check found 5,828,994 rows missing all three required start fields (about 9.89% of all rows).
- The future-date screen returned zero rows after the query date, 2026-11-11. Repeat the check if the public table changes.
- The duplicate screen found nine repeated signatures, but only one pair matched across all columns. Queries 07 and 08 count distinct serialized full rows, so the exact full-row duplicate is counted once; the eight nonidentical signature pairs remain. No source records are deleted.
- The CP1 station 318 comparison used matched Jan–Oct periods because no station 318 rows appeared in November or December 2015. For CP2, the station-level table uses those same matched periods for every included station.
- Station IDs with more than one rounded coordinate pair are excluded from the CP2 stable-location subset. This is an analysis choice, not proof that a station closed or relocated.

## Interpreting the result

The comparison is a descriptive change in recorded trips, not evidence of cause. The BigQuery table does not supply fare revenue per trip or payment records. The New York State Comptroller explains that Citi Bike trip totals do not directly correspond to ridership revenue, because revenue includes memberships and only some fares are directly tied to individual trips. We therefore report ride counts rather than a dollar loss. Source: [State Comptroller audit](https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf).
