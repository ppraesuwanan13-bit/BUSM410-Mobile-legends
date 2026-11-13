-- Build one regression-ready row per stable station ID.
-- Outcome: change in distinct ride records, Jan–Oct 2015 minus Jan–Oct 2014.
-- Predictors are measured in the 2014 baseline period.

WITH source_rows AS (
  SELECT DISTINCT t.*
  FROM `bigquery-public-data.new_york_citibike.citibike_trips` AS t
  WHERE (
      (starttime >= TIMESTAMP('2014-01-01') AND starttime < TIMESTAMP('2014-11-01'))
      OR
      (starttime >= TIMESTAMP('2015-01-01') AND starttime < TIMESTAMP('2015-11-01'))
    )
    AND start_station_id IS NOT NULL
    AND start_station_name IS NOT NULL
    AND TRIM(start_station_name) != ''
    AND start_station_latitude IS NOT NULL
    AND start_station_longitude IS NOT NULL
),
station_location_counts AS (
  SELECT
    start_station_id,
    COUNT(DISTINCT FORMAT(
      '%.4f,%.4f',
      ROUND(start_station_latitude, 4),
      ROUND(start_station_longitude, 4)
    )) AS coordinate_versions
  FROM source_rows
  GROUP BY start_station_id
),
stable_station_ids AS (
  SELECT start_station_id
  FROM station_location_counts
  WHERE coordinate_versions = 1
),
station_year_features AS (
  SELECT
    start_station_id,
    EXTRACT(YEAR FROM starttime) AS trip_year,
    ROUND(AVG(start_station_latitude), 4) AS latitude,
    ROUND(AVG(start_station_longitude), 4) AS longitude,
    COUNT(*) AS ride_count,
    SAFE_DIVIDE(COUNTIF(usertype = 'Subscriber'), COUNT(*)) AS subscriber_share,
    SAFE_DIVIDE(
      COUNTIF(usertype = 'Subscriber' AND LOWER(gender) = 'female'),
      COUNTIF(usertype = 'Subscriber' AND LOWER(gender) IN ('female', 'male'))
    ) AS female_share_of_known_gender_subscribers,
    SAFE_DIVIDE(
      COUNTIF(
        EXTRACT(DAYOFWEEK FROM starttime) BETWEEN 2 AND 6
        AND (EXTRACT(HOUR FROM starttime) BETWEEN 7 AND 9
          OR EXTRACT(HOUR FROM starttime) BETWEEN 16 AND 18)
      ),
      COUNT(*)
    ) AS weekday_peak_share
  FROM source_rows
  WHERE start_station_id IN (SELECT start_station_id FROM stable_station_ids)
  GROUP BY start_station_id, trip_year
),
matched AS (
  SELECT
    y2014.start_station_id,
    y2014.latitude,
    y2014.longitude,
    y2014.ride_count AS rides_2014,
    y2015.ride_count AS rides_2015,
    y2015.ride_count - y2014.ride_count AS ride_change,
    y2014.subscriber_share AS subscriber_share_2014,
    y2014.female_share_of_known_gender_subscribers
      AS female_share_of_known_gender_subscribers_2014,
    y2014.weekday_peak_share AS weekday_peak_share_2014
  FROM station_year_features AS y2014
  JOIN station_year_features AS y2015
    USING (start_station_id)
  WHERE y2014.trip_year = 2014
    AND y2015.trip_year = 2015
)
SELECT *
FROM matched
ORDER BY start_station_id;
