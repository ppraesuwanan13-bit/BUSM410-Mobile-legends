-- Count repeated trip signatures; see sql/README.md.
WITH event_counts AS (
  SELECT
    starttime,
    bikeid,
    start_station_id,
    end_station_id,
    COUNT(*) AS copies
  FROM `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE starttime IS NOT NULL
    AND bikeid IS NOT NULL
    AND start_station_id IS NOT NULL
  GROUP BY starttime, bikeid, start_station_id, end_station_id
)
SELECT
  COUNTIF(copies > 1) AS repeated_signatures,
  SUM(IF(copies > 1, copies - 1, 0)) AS extra_rows,
  MAX(copies) AS most_copies
FROM event_counts;
