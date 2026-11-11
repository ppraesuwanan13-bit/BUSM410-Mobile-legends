# Project Charter

## The question

How did recorded ride starts at Citi Bike station 318 change from January–October 2014 to the same months in 2015?

## The decision this supports

This analysis can help a Citi Bike operations manager decide whether station 318 merits a closer operational review. The data describes ride starts; it does not identify why the count changed or prove that a service change caused it.

## Scope

We use the public BigQuery table `bigquery-public-data.new_york_citibike.citibike_trips`. The source table contains trips from 2013–2018, with partial-year coverage in several years. The comparison covers January 1 through October 31 in 2014 and 2015 at start station ID 318. One source row represents one recorded ride; the analysis counts distinct full-row records. A comparison-period aggregate row represents station 318 in one year.

## What success looks like

- The comparison uses the same ten calendar months in both years.
- Missing start time or station fields are excluded from the analysis, with source rows retained.
- Exact full-row duplicates are counted once; nonidentical repeated signatures are retained.
- The result and chart show the ride-count difference and percent change.
- The report states the limits on causal and revenue claims.
