-- Create the exploratory CP2 linear regression model.
-- With 311 rows, evaluation uses the same stations; see model/model_card.md.
CREATE OR REPLACE MODEL
  `striking-canyon-509700-b8.BUSM410_CP2.station_change_linear_reg`
OPTIONS (
  model_type = 'linear_reg',
  input_label_cols = ['ride_change'],
  calculate_p_values = TRUE,
  category_encoding_method = 'DUMMY_ENCODING',
  max_iterations = 50,
  early_stop = FALSE
) AS
SELECT
  ride_change,
  latitude,
  longitude,
  rides_2014,
  subscriber_share_2014,
  female_share_2014,
  weekday_peak_share_2014
FROM `striking-canyon-509700-b8.BUSM410_CP2.station_analysis`;
