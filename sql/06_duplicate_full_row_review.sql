-- Compare repeated trip signatures across full rows; see sql/README.md.
SELECT
  t.starttime,
  t.bikeid,
  t.start_station_id,
  t.end_station_id,
  COUNT(*) AS copies,
  COUNT(DISTINCT TO_JSON_STRING(t)) AS distinct_full_rows
FROM `bigquery-public-data.new_york_citibike.citibike_trips` AS t
WHERE t.starttime IS NOT NULL
  AND t.bikeid IS NOT NULL
  AND t.start_station_id IS NOT NULL
GROUP BY
  t.starttime,
  t.bikeid,
  t.start_station_id,
  t.end_station_id
HAVING COUNT(*) > 1
ORDER BY t.starttime;
