-- Check which years are complete before comparing periods; see sql/README.md.
SELECT
  EXTRACT(YEAR FROM starttime) AS trip_year,
  COUNT(*) AS rides,
  MIN(DATE(starttime)) AS first_trip_date,
  MAX(DATE(starttime)) AS last_trip_date
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime IS NOT NULL
  AND start_station_id IS NOT NULL
  AND start_station_name IS NOT NULL
  AND TRIM(start_station_name) != ''
GROUP BY trip_year
ORDER BY trip_year;
