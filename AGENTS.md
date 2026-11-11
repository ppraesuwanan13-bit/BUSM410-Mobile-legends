# AGENTS.md

Read this before helping on our project.

* Team: Mobile Legends. Partners: Suwanan Yamma and Thipwigorn Khamjan.
* Dataset: `bigquery-public-data.new_york_citibike.citibike_trips`.
* Keep answers short and plain.
* Draft one step at a time, as a short query for us to approve. Never draft one long query that does everything.
* Don't save or change files until we say so.
* Back every claim about our data with a source, and say when something is your own conclusion.
* Ask us to confirm a table or column exists before you use it.
* Use our project audit skill (.agents/skills/project-audit/SKILL.md) to keep `Other/audit_log.md` up to date.
* Assume we're new to Git and GitHub. When we work together on our own computer, teach us how Git works as we go.
* When providing me with a git command, please provide the filepath command `cd` with it so I run the git command in the right place.
* Walk me through setting username and email for first time in git if needed.
* Never run commits or pushes yourself. Give us the commands, and we'll run them.
* Remind me to commit my changes before pushing my branch to GitHub.
* We each work on our own branch, named after the person (for example, alex). At the start of each session, remind us to run git pull on main, then merge main into our branch, before we change anything.
* At the end of each session, remind us to push our branch and open a pull request. Our partner reviews it before we merge it into main.
* If our work conflicts with our partner's, explain the conflict in plain words and help us decide what to keep.
* Remind us to merge finished work into main before each due date. Our instructor grades main.

## Project facts

* Dataset: `bigquery-public-data.new_york_citibike`; the confirmed tables are `citibike_trips` and `citibike_stations`. The dataset did not list `one_bike_ride`.
* Verified trip fields used here include `starttime`, `start_station_id`, `start_station_name`, station latitude/longitude, `bikeid`, and end-station fields.
* The required start-field check counted 58,937,715 total rows; 5,828,994 lacked all three required start fields; zero future start dates were found in the November 11, 2026 check. See `sql/03_cleaning_missing_future.sql` and `sql/04_cleaning_missing_overlap.sql`.
* For this station/time analysis, exclude rows missing start time, station ID, or a nonblank station name from the calculation, while retaining source rows.
* The duplicate screen found 9 repeated signatures: one pair identical across the full row and eight pairs different in other fields. The gap query counts distinct full rows; do not remove the nonidentical pairs.
* Project question: How did recorded ride starts at station ID 318 change from Jan–Oct 2014 to Jan–Oct 2015?
* BigQuery results supplied by the team: 46,934 distinct full-row ride records in Jan–Oct 2014 and 40,861 in Jan–Oct 2015, a decrease of 6,073 or 12.94%. Benchmark: station 318 in the same months one year earlier.
* Team review showed station 318's reported name and coordinates stable in the observed matched months; no station 318 rows appeared in Nov–Dec 2015. Do not infer why.
* Station 540 was set aside because its monthly output showed a changed name/coordinate and months with no observed rides in the proposed comparison window. This is not proof the station closed or relocated.
* The finding is descriptive, not causal. Do not call 6,073 rides lost revenue. The trip table lacks fare-per-trip/payment information; the State Comptroller notes trip counts do not directly correspond to revenue: https://www.osc.ny.gov/files/state-agencies/audits/pdf/sga-2026-23n5.pdf
