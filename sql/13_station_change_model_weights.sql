-- Inspect unstandardized regression coefficients, standard errors, and p-values.
-- A coefficient is an association conditional on the model predictors, not a cause.
SELECT
  processed_input,
  weight,
  standard_error,
  p_value
FROM ML.ADVANCED_WEIGHTS(
  MODEL `striking-canyon-509700-b8.BUSM410_CP2.station_change_linear_reg`,
  STRUCT(FALSE AS standardize)
)
ORDER BY p_value;
