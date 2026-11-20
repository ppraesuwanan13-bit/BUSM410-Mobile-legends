-- Check the CP2 station-level table for missing/impossible values and arithmetic errors.
-- See sql/README.md for the result recorded on 2026-11-19.
SELECT
  COUNT(*) AS station_rows,
  COUNT(DISTINCT station_id) AS unique_stations,
  COUNTIF(
    station_id IS NULL
    OR latitude IS NULL
    OR longitude IS NULL
    OR rides_2014 IS NULL
    OR rides_2015 IS NULL
    OR ride_change IS NULL
    OR subscriber_share_2014 IS NULL
    OR female_share_2014 IS NULL
    OR weekday_peak_share_2014 IS NULL
  ) AS rows_with_missing_values,
  COUNTIF(
    rides_2014 <= 0
    OR rides_2015 <= 0
    OR latitude NOT BETWEEN -90 AND 90
    OR longitude NOT BETWEEN -180 AND 180
    OR subscriber_share_2014 NOT BETWEEN 0 AND 1
    OR female_share_2014 NOT BETWEEN 0 AND 1
    OR weekday_peak_share_2014 NOT BETWEEN 0 AND 1
  ) AS rows_with_impossible_values,
  COUNTIF(ride_change != rides_2015 - rides_2014) AS outcome_mismatches,
  SUM(rides_2014) AS total_rides_2014,
  SUM(rides_2015) AS total_rides_2015
FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`;
