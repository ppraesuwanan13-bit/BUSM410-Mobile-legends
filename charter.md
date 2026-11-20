# Project Charter

## The question

Across Citi Bike stations with a consistent recorded location and rides in both periods, how did ride starts change from January–October 2014 to January–October 2015? Which station characteristics from 2014 are associated with those changes?

## The decision this supports

The comparison can help Citi Bike operations staff identify stations for a closer review. The regression describes how station location, rider mix, and weekday peak-hour activity relate to the change in recorded rides. The analysis cannot show that any characteristic caused a change or explain what happened at an individual station.

## Scope

We use the public BigQuery table `bigquery-public-data.new_york_citibike.citibike_trips`. The comparison uses January 1 through October 31 in 2014 and the same dates in 2015. The findings currently cover 311 station IDs that have one start-coordinate pair after rounding latitude and longitude to four decimal places and at least one recorded ride in both periods. This is a stable-location subset, not every station that operated in either year.

The outcome for the station-level comparison is the change in recorded ride starts (2015 count minus 2014 count). Candidate regression inputs are measured in 2014: coordinates, subscriber share, female share among subscribers with known gender, weekday peak-hour share, and starting ride count. The linear regression has been fitted to all 311 stations, without a held-out test set. We describe the model as exploratory and its results as associations, not causes.

## What success looks like

- Compare the same ten calendar months in both years.
- Explain which stations are included and why other station IDs are excluded.
- Show the overall change and the range of station-level changes.
- Prepare one row per included station for the CP2 regression, with the outcome and clearly defined candidate predictors.
- Report model fit, coefficients, p-values, and the limit that training and evaluation used the same stations.
- State the limits of the trip data and avoid unsupported claims about causes or revenue.

## Expected ending

We expect to identify which stable-location stations merit a closer operational review and which measured 2014 characteristics are associated with ride changes. The data taught us that a citywide increase can happen at the same time that some individual stations lose rides; the 311-station comparison rose overall while station 318 declined.
