# SQL Query Log

This log records the schema and data-quality checks run in BigQuery for the Citi Bike project. Each numbered SQL file includes a short note; this README explains the purpose, results, and cleaning decisions.

## Dataset and confirmed table

The dataset is `bigquery-public-data.new_york_citibike`. BigQuery showed two tables: `citibike_stations` and `citibike_trips`. The repository previously listed `one_bike_ride`, which was not in the table list. The trip table used for these checks is `citibike_trips`.

The schema check confirmed `starttime` (DATETIME), `start_station_id` (INT64), `start_station_name` (STRING), `end_station_id` (INT64), `end_station_name` (STRING), and `bikeid` (INT64). These are the fields used in the checks below.

## Queries and results

| File | Purpose | Result |
|---|---|---|
| [01_table_inventory.sql](01_table_inventory.sql) | List tables in the dataset. | `citibike_stations`, `citibike_trips` |
| [02_trip_start_station_fields.sql](02_trip_start_station_fields.sql) | Confirm start-time and station field names and types. | Confirmed fields listed above. |
| [03_cleaning_missing_future.sql](03_cleaning_missing_future.sql) | Count total rows, missing start fields, and future start dates. | 58,937,715 total rows; 5,828,994 rows missing each of the three start fields; 0 future start dates. BigQuery estimated 1.85 GB processed. |
| [04_cleaning_missing_overlap.sql](04_cleaning_missing_overlap.sql) | Check whether the missing fields occur together. | 5,828,994 rows missing all three and 5,828,994 missing any; the missing fields occur together in these rows. |
| [05_duplicate_signature_counts.sql](05_duplicate_signature_counts.sql) | Screen for repeated signatures using start time, bike ID, and start/end station IDs. | 9 repeated signatures, 9 extra rows, at most 2 copies per signature. |
| [06_duplicate_full_row_review.sql](06_duplicate_full_row_review.sql) | Compare all columns for each repeated signature. | Each of the 9 signatures had 2 rows. One pair was an exact full-row match; the other 8 pairs differed in at least one field. |

These results came from BigQuery runs on November 11, 2026. The missing-field checks show that 53,108,721 rows had all three start fields available (58,937,715 total minus 5,828,994 missing). The missing rows are about 9.89% of the table.

## Cleaning decisions and limits

For analyses that require ride start time and starting station, rows missing any of `starttime`, `start_station_id`, or `start_station_name` cannot be assigned to the needed time-and-station groups. A reasonable working rule is to exclude those rows from those calculations while retaining the original source data. This is a project recommendation, not a confirmed team decision.

The future-date check found no start dates after the query run date. Repeat this check if the public table is updated.

The signature screen found 9 repeated combinations, but only one pair was identical across the full row. The other 8 pairs are not exact duplicate rows. No records have been removed. Do not remove the 8 nonidentical pairs without inspecting why their other fields differ.

## Project status

The project gap, benchmark, and value have not been measured yet. The counts above are data-quality checks, not the project gap. Do not present them as rides lost, revenue lost, or service failures.
