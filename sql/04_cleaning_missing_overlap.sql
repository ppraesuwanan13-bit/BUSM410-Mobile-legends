-- Check whether required start-field blanks occur in the same rows; see sql/README.md.
SELECT
  COUNTIF(
    starttime IS NULL
    AND start_station_id IS NULL
    AND (start_station_name IS NULL OR TRIM(start_station_name) = '')
  ) AS missing_all_three,
  COUNTIF(
    starttime IS NULL
    OR start_station_id IS NULL
    OR start_station_name IS NULL
    OR TRIM(start_station_name) = ''
  ) AS missing_any
FROM `bigquery-public-data.new_york_citibike.citibike_trips`;
