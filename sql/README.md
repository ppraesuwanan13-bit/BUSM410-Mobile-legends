# SQL Query Log

This log explains the BigQuery queries used for the Citi Bike station-and-time analysis. Each numbered SQL file starts with a short note pointing here. BigQuery results below were run and supplied by the team.

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
- Station 540 was not selected: the team’s monthly output showed a changed name/coordinate and gaps in observed months during the comparison window. That makes its full-year change hard to interpret as demand at one unchanged location. This is an analysis choice, not proof the station closed or relocated.
- Station 318 was selected because its reported name and coordinates were stable in the matched Jan–Oct months. No station 318 rows appeared in November or December 2015, so the project uses matched Jan–Oct periods rather than comparing a full 2014 year with only ten observed months in 2015.

## Interpreting the result

The comparison is a descriptive change in recorded trips, not evidence of cause. The BigQuery table does not supply fare revenue per trip or payment records. The New York State Comptroller explains that Citi Bike trip totals do not directly correspond to ridership revenue, because revenue includes memberships and only some fares are directly tied to individual trips. We therefore report the impact as 6,073 fewer recorded trips, not as a dollar loss. Source: [State Comptroller audit](https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf).
