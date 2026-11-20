# Model Card: Station Ride Change

## Purpose

This exploratory model describes how recorded station activity and station characteristics in 2014 are associated with the change in recorded ride starts from January–October 2014 to the same months in 2015. It is intended to help identify stations for further review, not to make causal claims or operational predictions.

## Data and outcome

- **Source:** `bigquery-public-data.new_york_citibike.citibike_trips`
- **Analysis table:** `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`
- **Unit:** one station ID
- **Rows:** 311 stable-location stations with recorded rides in both periods
- **Outcome:** `ride_change = rides_2015 - rides_2014`
- **Predictors:** latitude, longitude, `rides_2014`, subscriber share, female share among subscribers with known male/female values, and weekday peak-hour share. Shares and ride count are measured in 2014.
- **Cleaning:** exact duplicate full rows were counted once; station IDs with more than one rounded coordinate pair were excluded; dates were matched to Jan–Oct in each year.

## Model and evaluation

BigQuery ML model: `station_change_linear_reg`, linear regression, with p-value calculation, dummy encoding, 50 maximum iterations, and early stopping disabled. The SQL omits a split option as required by the assignment. Because the analysis has only 311 rows, BigQuery used the same rows for fitting and evaluation; there is no held-out test set.

Final model evaluation metrics, checked in BigQuery on 2026-11-19:

| Metric | Value |
|---|---:|
| `r2_score` | 0.079209 |
| Mean absolute error | 2,595.0 rides |
| Mean squared error | 17,582,928.9 rides² |
| Mean squared log error | 1.4077 |
| Median absolute error | 1,477.0 rides |

Our `r2_score` is 0.0792, so the model explains only a small part of the variation in station ride changes. These are in-sample fit metrics and do not show how well the model predicts new stations.

## Coefficients

Unstandardized weights from BigQuery ML's `ML.ADVANCED_WEIGHTS`, ordered by p-value. At a 0.05 threshold, latitude is the only predictor with a statistically significant coefficient. The intercept is not a predictor and is omitted from this table.

| Predictor | Coefficient | p-value | Reading |
|---|---:|---:|---|
| Latitude | +51,542.472 | 0.000619 | Higher latitude is associated with a larger ride change, holding the other listed predictors constant; this is the only predictor with p < 0.05. |
| Longitude | −30,952.805 | 0.092585 | Negative conditional association; not statistically significant at 0.05. |
| Subscriber share | −4,887.949 | 0.145251 | Negative conditional association; not statistically significant at 0.05. |
| Weekday peak-hour share | −5,082.060 | 0.245770 | Negative conditional association; not statistically significant at 0.05. |
| 2014 ride count | −0.01097 | 0.644776 | Very small negative conditional association per additional 2014 ride; not statistically significant. |
| Female share | +2,227.678 | 0.719219 | Positive conditional association; not statistically significant at 0.05. |

Latitude has the strongest evidence of association because its p-value is 0.000619, below 0.05. Longitude has the next-lowest predictor p-value (0.092585), but it is above 0.05, so we do not have strong evidence that longitude is associated with ride change in this model. There is only one statistically significant predictor. The latitude coefficient is in rides per degree, a large unit relative to the small latitude range in this New York station sample. It should not be read as the expected effect of moving a station. The coefficient is a conditional association in this particular model, not evidence that latitude caused ridership to change.

## Driver interpretation

Latitude's coefficient is positive (p = 0.000619), so holding the other predictors steady, a higher latitude goes with a higher `ride_change`. It is the only predictor with p < 0.05. Longitude has the next-smallest p-value and a negative coefficient (p = 0.092585), so a higher longitude goes with a lower fitted `ride_change` while holding the other predictors steady; because its p-value is above 0.05, this pattern could be due to chance and is not a confirmed driver.

## Limits and responsible use

- The model uses only 311 stations from a stable-location subset, not every Citi Bike station.
- The model is exploratory, uses one before/after period, and has no held-out test data.
- Predictors may be correlated, and p-values do not establish causation.
- The linear form may not describe nonlinear or local patterns well.
- Trip records do not provide fare or payment amounts; ride changes are not revenue changes.
- The team should inspect the station-level residuals and decide whether the result is useful before submission. Do not use this model alone to make service decisions.

## Reproduction

The model SQL is saved in [12_station_change_linear_regression.sql](../sql/12_station_change_linear_regression.sql), and coefficient extraction is saved in [13_station_change_model_weights.sql](../sql/13_station_change_model_weights.sql). BigQuery model output was inspected on 2026-11-19. The team should review the job history and results before presenting them as verified team work.
