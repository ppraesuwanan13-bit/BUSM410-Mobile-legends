-- Compare the CP2 outcome with three 2014 station predictors.
-- Query 1 groups by each observed numeric value, as requested in CP2 Part A.
-- Query 2 summarizes the terciles used in the station-group chart.
-- Run both in BigQuery and compare Query 2 with the previously recorded means.
WITH station_values AS (
  SELECT
    'Subscriber share' AS predictor,
    subscriber_share_2014 AS x_value,
    ride_change,
    station_id
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`

  UNION ALL

  SELECT
    'Weekday peak-hour share' AS predictor,
    weekday_peak_share_2014 AS x_value,
    ride_change,
    station_id
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`

  UNION ALL

  SELECT
    'Latitude' AS predictor,
    latitude AS x_value,
    ride_change,
    station_id
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`
)
SELECT
  predictor,
  x_value,
  COUNT(*) AS station_count,
  ROUND(AVG(ride_change), 1) AS mean_ride_change
FROM station_values
GROUP BY predictor, x_value
ORDER BY predictor, x_value;

-- Tertile summary used by the chart; station_id makes tied values deterministic.
WITH station_values AS (
  SELECT
    station_id,
    'Subscriber share' AS predictor,
    subscriber_share_2014 AS x_value,
    ride_change
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`

  UNION ALL

  SELECT
    station_id,
    'Weekday peak-hour share' AS predictor,
    weekday_peak_share_2014 AS x_value,
    ride_change
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`

  UNION ALL

  SELECT
    station_id,
    'Latitude' AS predictor,
    latitude AS x_value,
    ride_change
  FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`
),
ranked AS (
  SELECT
    *,
    NTILE(3) OVER (
      PARTITION BY predictor
      ORDER BY x_value, station_id
    ) AS tercile
  FROM station_values
)
SELECT
  predictor,
  CASE tercile
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Middle'
    WHEN 3 THEN 'High'
  END AS group_name,
  COUNT(*) AS station_count,
  ROUND(AVG(ride_change), 1) AS mean_ride_change
FROM ranked
GROUP BY predictor, tercile
ORDER BY predictor, tercile;
