# AGENTS.md

Read this before helping on our project.

* Team: Mobile Legends. Partners: Suwanan Yamma and Thipwigorn Khamjan.
* Dataset: `bigquery-public-data.new_york_citibike.citibike_trips`.
* Keep answers short and plain.
* Draft one step at a time, as a short query for us to approve. Never draft one long query that does everything.
* Back every claim about our data with a source, and say when something is your own conclusion.
* Ask us to confirm a table or column exists before you use it.
* Keep `Other/audit_log.md` current when the team checks, corrects, or changes the analysis.
* Assume we're new to Git and GitHub. When we work together on our own computer, teach us how Git works as we go.
* When providing me with a git command, please provide the filepath command `cd` with it so I run the git command in the right place.
* Walk me through setting username and email for first time in git if needed.
* We each work on our own branch, named after the person (for example, alex). At the start of each session, remind us to run git pull on main, then merge main into our branch, before we change anything.
* At the end of each session, remind us to push our branch and open a pull request. Our partner reviews it before we merge it into main.
* If our work conflicts with our partner's, explain the conflict in plain words and help us decide what to keep.
* Remind us to merge finished work into main before each due date. Instructor grades main.

## Project facts

* The table inventory showed `citibike_trips` and `citibike_stations`; it did not show `one_bike_ride`.
* Fields verified for this analysis include `starttime`, `start_station_id`, `start_station_name`, start latitude/longitude, `bikeid`, and end-station fields.
* The required start-field check counted 58,937,715 total rows; 5,828,994 rows lacked all three start fields; no future start dates were found in the November 11, 2026 query. See `sql/03_cleaning_missing_future.sql` and `sql/04_cleaning_missing_overlap.sql`.
* For this station/time analysis, exclude rows missing start time, start station ID, or a nonblank name from the calculation, while retaining source rows. This cleaning rule is scoped to the analysis.
* Nine repeated signatures were found using starttime, bikeid, and start/end station IDs. One pair was identical across the full row; eight pairs differed in other fields. Do not remove those eight pairs as duplicates. The gap query counts distinct full rows.
* Project question: how did ride starts at station ID 318 change between Jan–Oct 2014 and Jan–Oct 2015?
* Verified gap: 46,934 distinct full-row ride records in Jan–Oct 2014 and 40,861 in Jan–Oct 2015, a decrease of 6,073 or 12.94%. The benchmark is the same station in the same calendar months one year earlier.
* Team review found station 318's name and coordinates stable in observed Jan–Oct months; no Nov–Dec 2015 station 318 records were returned. Do not infer why.
* Station 540 was set aside because its monthly output had a name/coordinate change and months without observed rides in the proposed comparison window.
* This is a descriptive ride-count change, not a causal finding. The table does not support a defensible dollar estimate from trip counts alone; do not call the 6,073 rides lost revenue. The State Comptroller notes that trip totals do not directly correspond to revenue: https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf
