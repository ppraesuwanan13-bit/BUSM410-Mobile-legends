-- Count missing start fields and future start dates; see sql/README.md.
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(starttime IS NULL) AS missing_starttime,
  COUNTIF(start_station_id IS NULL) AS missing_station_id,
  COUNTIF(start_station_name IS NULL OR TRIM(start_station_name) = '') AS blank_station_name,
  COUNTIF(DATE(starttime) > CURRENT_DATE('America/New_York')) AS future_start_dates
FROM `bigquery-public-data.new_york_citibike.citibike_trips`;
