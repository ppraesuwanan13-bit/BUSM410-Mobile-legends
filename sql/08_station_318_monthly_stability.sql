-- Review station 318's monthly names and coordinates; see sql/README.md.
SELECT
  DATE_TRUNC(DATE(t.starttime), MONTH) AS trip_month,
  COUNT(DISTINCT TO_JSON_STRING(t)) AS ride_records,
  ARRAY_AGG(DISTINCT t.start_station_name IGNORE NULLS) AS station_names,
  ARRAY_AGG(DISTINCT t.start_station_latitude IGNORE NULLS) AS latitudes,
  ARRAY_AGG(DISTINCT t.start_station_longitude IGNORE NULLS) AS longitudes
FROM `bigquery-public-data.new_york_citibike.citibike_trips` AS t
WHERE t.starttime IS NOT NULL
  AND t.start_station_id = 318
  AND t.start_station_name IS NOT NULL
  AND TRIM(t.start_station_name) != ''
  AND (
    (DATE(t.starttime) >= DATE '2014-01-01'
      AND DATE(t.starttime) < DATE '2014-11-01')
    OR
    (DATE(t.starttime) >= DATE '2015-01-01'
      AND DATE(t.starttime) < DATE '2015-11-01')
  )
GROUP BY trip_month
ORDER BY trip_month;
