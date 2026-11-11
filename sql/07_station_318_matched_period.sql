-- Compare station 318 in matching Jan–Oct windows; see sql/README.md.
SELECT
  EXTRACT(YEAR FROM t.starttime) AS trip_year,
  COUNT(DISTINCT TO_JSON_STRING(t)) AS ride_records
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
GROUP BY trip_year
ORDER BY trip_year;
