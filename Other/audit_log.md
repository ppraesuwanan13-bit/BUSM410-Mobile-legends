# Audit Log

This log records checks made by the Mobile Legends team on the Citi Bike project. The first entries cover data-source and cleaning checks; the project gap has not yet been measured.

| Category | What it means | Entries |
|---|---|---|
| [Caught an error](#caught-an-error) | The team found an incorrect statement or project fact. | 1 |
| [Verified a claim](#verified-a-claim) | The team checked a claim against BigQuery or documentation. | 3 |
| [Separated fact from opinion](#separated-fact-from-opinion) | The team identified an inference as an inference. | 0 |
| [Changed the analysis](#changed-the-analysis) | The team's judgment changed the approach or framing. | 0 |
| [Improved the agent's instructions](#improved-the-agents-instructions) | The team changed how the agent is directed. | 0 |

## Caught an error

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 1 | 2026-11-11 | The repository listed `one_bike_ride` as the trip table. | Ran the table-list query in BigQuery. | **Corrected the project fact.** The dataset listed `citibike_trips` and `citibike_stations`; it did not list `one_bike_ride`. |

## Verified a claim

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 2 | 2026-11-11 | The cleaning check showed 58,937,715 total rows, 5,828,994 missing each start field, and 0 future start dates. | Ran the cleaning query in BigQuery and checked the result. | Confirmed the counts. The follow-up overlap query showed those 5,828,994 rows were missing all three start fields. |
| 3 | 2026-11-11 | The start-field missing counts referred to the same rows. | Compared the `missing_all_three` and `missing_any` results in BigQuery. | Confirmed both counts were 5,828,994. |
| 4 | 2026-11-11 | The repeated-signature check found nine candidate groups, and only one pair was identical across all fields. | Ran the signature count and full-row comparison queries in BigQuery. | Confirmed 9 signatures with 2 rows each; one pair had one distinct full row, and eight pairs had two distinct full rows. No records were removed. |

## Separated fact from opinion

No entries yet.

## Changed the analysis

No entries yet.

## Improved the agent's instructions

No entries yet.
