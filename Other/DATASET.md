# Dataset documentation

The project uses BigQuery's `bigquery-public-data.new_york_citibike.citibike_trips` table. Dataset documentation and source context:

- [Citi Bike system data](https://citibikenyc.com/system-data): operator's public trip-history page; describes trip fields and how the data is processed.
- [NYC Open Data: Citi Bike System Data](https://data.cityofnewyork.us/dataset/Citi-Bike-System-Data/vsnr-94wk): city dataset catalog entry identifying Citi Bike as the data provider.

We query the BigQuery public table named `citibike_trips`; the operator's page may use updated field names for newer downloadable files.
