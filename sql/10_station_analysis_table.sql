-- Build one row per stable-location station for CP2; see sql/README.md.
CREATE OR REPLACE TABLE `striking-canyon-509700-b8.BUSM410_CP2.station_analysis` AS

WITH trips AS (
  SELECT
    t.starttime,
    t.start_station_id,
    ROUND(t.start_station_latitude, 4) AS latitude,
    ROUND(t.start_station_longitude, 4) AS longitude,
    t.usertype,
    t.gender
  FROM `bigquery-public-data.new_york_citibike.citibike_trips` AS t
  WHERE t.starttime IS NOT NULL
    AND t.start_station_id IS NOT NULL
    AND t.start_station_name IS NOT NULL
    AND TRIM(t.start_station_name) != ''
    AND t.start_station_latitude IS NOT NULL
    AND t.start_station_longitude IS NOT NULL
    AND (
      DATE(t.starttime) BETWEEN DATE '2014-01-01' AND DATE '2014-10-31'
      OR DATE(t.starttime) BETWEEN DATE '2015-01-01' AND DATE '2015-10-31'
    )
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY TO_JSON_STRING(t)
    ORDER BY t.starttime
  ) = 1
),

distinct_locations AS (
  SELECT DISTINCT start_station_id, latitude, longitude
  FROM trips
),

locations AS (
  SELECT
    start_station_id,
    ANY_VALUE(latitude) AS station_latitude,
    ANY_VALUE(longitude) AS station_longitude
  FROM distinct_locations
  GROUP BY start_station_id
  HAVING COUNT(*) = 1
),

station_totals AS (
  SELECT
    start_station_id,
    COUNTIF(EXTRACT(YEAR FROM starttime) = 2014) AS rides_2014,
    COUNTIF(EXTRACT(YEAR FROM starttime) = 2015) AS rides_2015,
    COUNTIF(
      EXTRACT(YEAR FROM starttime) = 2014
      AND LOWER(usertype) = 'subscriber'
    ) AS subscribers_2014,
    COUNTIF(
      EXTRACT(YEAR FROM starttime) = 2014
      AND LOWER(usertype) = 'subscriber'
      AND LOWER(gender) = 'female'
    ) AS female_subscribers_2014,
    COUNTIF(
      EXTRACT(YEAR FROM starttime) = 2014
      AND LOWER(usertype) = 'subscriber'
      AND LOWER(gender) IN ('female', 'male')
    ) AS known_gender_subscribers_2014,
    COUNTIF(
      EXTRACT(YEAR FROM starttime) = 2014
      AND EXTRACT(DAYOFWEEK FROM starttime) BETWEEN 2 AND 6
      AND (
        EXTRACT(HOUR FROM starttime) BETWEEN 7 AND 9
        OR EXTRACT(HOUR FROM starttime) BETWEEN 16 AND 18
      )
    ) AS weekday_peak_rides_2014
  FROM trips
  GROUP BY start_station_id
)

SELECT
  s.start_station_id AS station_id,
  l.station_latitude AS latitude,
  l.station_longitude AS longitude,
  s.rides_2014,
  s.rides_2015,
  s.rides_2015 - s.rides_2014 AS ride_change,
  SAFE_DIVIDE(s.subscribers_2014, s.rides_2014) AS subscriber_share_2014,
  COALESCE(
    SAFE_DIVIDE(
      s.female_subscribers_2014,
      s.known_gender_subscribers_2014
    ),
    0
  ) AS female_share_2014,
  SAFE_DIVIDE(s.weekday_peak_rides_2014, s.rides_2014)
    AS weekday_peak_share_2014
FROM station_totals AS s
JOIN locations AS l USING (start_station_id)
WHERE s.rides_2014 > 0
  AND s.rides_2015 > 0;
