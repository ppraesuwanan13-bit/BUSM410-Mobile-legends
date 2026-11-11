-- List the tables available in the Citi Bike dataset; see sql/README.md.
SELECT table_name
FROM `bigquery-public-data.new_york_citibike.INFORMATION_SCHEMA.TABLES`
ORDER BY table_name;
