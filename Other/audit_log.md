# Audit Log

This log records the team's BigQuery checks, corrections, and analysis choices. The team ran the queries and supplied the results; the agent documented them here.

| Category | What it means | Entries |
|---|---|---:|
| [Caught an error](#caught-an-error) | The team found an incorrect statement or calculation. | 2 |
| [Verified a claim](#verified-a-claim) | The team checked a claim against BigQuery or a source. | 5 |
| [Separated fact from opinion](#separated-fact-from-opinion) | A conclusion was marked as an inference or limit. | 1 |
| [Changed the analysis](#changed-the-analysis) | Evidence changed the project approach. | 1 |
| [Improved the agent's instructions](#improved-the-agents-instructions) | Project facts or directions were clarified. | 1 |

## Caught an error

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 1 | 2026-11-11 | The repository listed `one_bike_ride` as the trip table. | Ran the table inventory query. | **Corrected.** BigQuery listed `citibike_trips` and `citibike_stations`. |
| 2 | 2026-11-11 | An early comparison counted all of 2014 but only January–October 2015 for station 318. | Compared the query's date filters with the monthly results, then reran both years for January–October. | **Corrected.** Use 46,934 rides in Jan–Oct 2014 and 40,861 in Jan–Oct 2015. |

## Verified a claim

| # | Date | What the AI said or did | How I checked it | Result |
|---|---|---|---|---|
| 1 | 2026-11-11 | The table has 58,937,715 rows; 5,828,994 lacked all three required start fields; no future dates were found. | Ran the cleaning and overlap queries in BigQuery. | Confirmed the results. |
| 2 | 2026-11-11 | The duplicate screen found nine repeated signatures, one exact full-row pair, and eight nonidentical pairs. | Ran the signature and full-row checks. | Confirmed; no source rows were deleted. |
| 3 | 2026-11-11 | 2014 and 2015 had complete calendar-year coverage; other listed years were partial. | Ran the yearly coverage query. | Confirmed the dates and counts recorded in `sql/README.md`. |
| 4 | 2026-11-11 | Station 318 had 46,934 Jan–Oct 2014 trips and 40,861 Jan–Oct 2015 trips after exact full-row duplicates were counted once. | Reran the matched-period query in BigQuery. | Confirmed the two counts. |
| 5 | 2026-11-11 | Station 318's reported name and coordinates remained stable in observed Jan–Oct months, and there were no station 318 rows in Nov–Dec 2015. | Reviewed the monthly station query results. | Confirmed the returned values; this does not establish why no late-2015 trips appear. |

## Separated fact from opinion

| # | Date | Data fact | Interpretation or limit |
|---|---|---|---|
| 1 | 2026-11-11 | The matched-period count decreased by 6,073 rides (12.94%). | The data does not explain why. We do not call this lost revenue or attribute it to a station closure or move. |

## Changed the analysis

| # | Date | Evidence | Change |
|---|---|---|---|
| 1 | 2026-11-11 | Station 540's monthly output showed a name/coordinate change and months with no observed rides; station 318 had stable reported location for the matched months. | Set aside station 540 and use station 318 for the matched Jan–Oct comparison. |

## Improved the agent's instructions

| # | Date | Instruction changed | Reason |
|---|---|---|---|
| 1 | 2026-11-11 | Added the measured station 318 gap, benchmark, and revenue limitation to `AGENTS.md`. | Preserve the approved analysis facts and prevent unsupported revenue or causal claims. |
