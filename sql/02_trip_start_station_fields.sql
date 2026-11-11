-- Confirm the trip start and station fields; see sql/README.md.
SELECT
  column_name,
  data_type
FROM `bigquery-public-data.new_york_citibike.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'citibike_trips'
  AND REGEXP_CONTAINS(LOWER(column_name), r'(start|station)')
ORDER BY ordinal_position;
