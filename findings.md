# Findings: Citi Bike station ride changes

## All-station comparison

The BigQuery export contains 311 station IDs with one start-coordinate pair after rounding latitude and longitude to four decimals and at least one recorded ride in both matched periods. This is a stable-location subset, not every station that operated in either year.

| Measure | Jan–Oct 2014 | Jan–Oct 2015 | Change |
|---|---:|---:|---:|
| Distinct ride records across included stations | 6,647,007 | 7,307,992 | +660,985 (+9.94%) |

Of the 311 stations, 246 had more recorded rides in 2015 and 65 had fewer.

| Station ID | 2014 rides | 2015 rides | Change | Percent |
|---:|---:|---:|---:|---:|
| 529 | 25,989 | 54,217 | +28,228 | +108.62% |
| 528 | 44,512 | 29,996 | −14,516 | −32.61% |
| 318 | 46,934 | 40,861 | −6,073 | −12.94% |

Station 529 had the largest increase by ride count, and station 528 had the largest decrease. The 42,744-trip spread between those changes shows activity varied by location. Station 407 had the largest percentage decrease (−46.45%), from 5,864 to 3,140 rides. Percentages can look large when the starting count is small.

Station IDs with multiple rounded coordinate pairs, including 540 and 319, were excluded so different locations were not combined under one ID. This does not prove a station closed or moved.

## CP2 regression data

The regression-ready query creates one row per included station. The outcome is `ride_change` (2015 minus 2014). Candidate predictors use 2014 values: coordinates, subscriber share, female share among subscribers with a known gender, and weekday peak-hour share. The 2014 ride count is available as a starting-volume control.

The peak-hour measure covers weekday trips starting 7:00–9:59 a.m. or 4:00–6:59 p.m. Birth year is omitted because the field profile showed substantial missingness and implausibly early values. The query prepares the data; no regression has been fitted yet. Any later model results should be described as associations, not causes.

## Limits

These are recorded trip starts, not an explanation of why usage changed. The totals cover only the 311 included station IDs and are not systemwide. The trip table lacks fare-per-trip or payment amounts, so no revenue value is assigned.

- [All-station comparison query](sql/10_all_station_stable_change.sql)
- [Regression-ready query](sql/11_all_station_regression_features.sql)
- [Query log and cleaning choices](sql/README.md)
- [Original station 318 chart](visuals/gap_chart.png)
