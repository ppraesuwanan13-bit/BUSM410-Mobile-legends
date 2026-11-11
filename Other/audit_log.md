# Audit Log

This log records the team's checks, corrections, and analysis choices. The team ran the BigQuery queries and supplied the results; the agent documented them here.

| Category | What it means | Entries |
|---|---|---:|
| [Verified a claim](#verified-a-claim) | The team checked a claim against BigQuery or documentation. | 5 |
| [Caught an error](#caught-an-error) | The team found an incorrect statement or calculation. | 2 |
| [Separated fact from opinion](#separated-fact-from-opinion) | A conclusion was marked as an inference or limit. | 1 |
| [Changed the analysis](#changed-the-analysis) | Evidence changed the project approach. | 1 |
| [Improved the agent's instructions](#improved-the-agents-instructions) | Project facts or directions were clarified. | 1 |

## Verified a claim

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 1 | 2026-11-11 | Station 318 had 46,934 Jan–Oct 2014 trips and 40,861 Jan–Oct 2015 trips after exact full-row duplicates were counted once. | Ran the matched-period query in BigQuery. | Confirmed both counts; the difference is 6,073 rides (12.94%). See [query 07](../sql/07_station_318_matched_period.sql). |
| 2 | 2026-11-11 | Station 318's reported name and coordinates were stable in observed Jan–Oct months, with no Nov–Dec 2015 rows. | Reviewed the monthly station query results. | Confirmed the returned values; the data does not establish why no late-2015 trips appear. See [query 08](../sql/08_station_318_monthly_stability.sql). |
| 3 | 2026-11-11 | 2014 and 2015 had complete calendar-year coverage; other years shown had partial-year coverage. | Ran the yearly coverage query. | Confirmed the dates and counts in [sql/README.md](../sql/README.md). |
| 4 | 2026-11-11 | The start-field check found 58,937,715 rows, 5,828,994 missing all three required start fields, and zero future dates. | Ran the cleaning and overlap queries. | Confirmed the results. |
| 5 | 2026-11-11 | Nine repeated signatures included one exact full-row pair and eight nonidentical pairs. | Ran the signature and full-row comparison queries. | Confirmed; no source rows were deleted. |

## Caught an error

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 6 | 2026-11-11 | An early station 318 query compared all of 2014 with only Jan–Oct 2015. | Compared the SQL date filters with the monthly results, then reran both years for Jan–Oct. | Corrected the benchmark to matched Jan–Oct windows. |
| 7 | 2026-11-11 | The repository initially named `one_bike_ride` as the trip table. | Ran the table inventory query. | Corrected: BigQuery listed `citibike_trips` and `citibike_stations`. |

## Separated fact from opinion

| # | Date | Data fact | Interpretation or limit |
|---|---|---|---|
| 8 | 2026-11-11 | Matched-period ride records decreased by 6,073 (12.94%). | This does not identify a cause or establish a revenue loss. We rely on the State Comptroller's [audit](https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf) for the revenue limitation. |

## Changed the analysis

| # | Date | Evidence | Change |
|---|---|---|---|
| 9 | 2026-11-11 | Station 540's monthly output showed a name/coordinate change and gaps in observed months; station 318 had stable reported location for the matched months. | Set aside station 540 and use station 318 for the matched Jan–Oct comparison. |

## Improved the agent's instructions

| # | Date | Instruction changed | Reason |
|---|---|---|---|
| 10 | 2026-11-11 | Added the selected question, measured station 318 gap, benchmark, and revenue limitation to `AGENTS.md`. | Keep future analysis consistent with checked results and avoid unsupported revenue or causal claims. |
