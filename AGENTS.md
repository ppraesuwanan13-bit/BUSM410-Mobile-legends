# AGENTS.md

Read this before helping on our project.

* Team: Mobile Legends. Partners: Suwanan Yamma and Thipwigorn Khamjan.
* Dataset: `bigquery-public-data.new_york_citibike.citibike_trips`.
* Keep answers short and plain.
* Draft one step at a time, as a short query for us to approve. Never draft one long query that does everything.
* Don't save or change files until we say so.
* Back every claim about our data with a source, and say when something is your own conclusion.
* Ask us to confirm a table or column exists before you use it.
* Use our project audit skill (.agents/skills/project-audit/SKILL.md) to keep Other/audit_log.md up to date.
* Assume we're new to Git and GitHub. When we work together on our own computer, teach us how Git works as we go.
* When providing me with a git command, please provide the filepath command "cd" with it so I run the git command in the right place.
* Walk me through setting username and email for first time in git if needed.
* Never run commits or pushes yourself. Give us the commands, and we'll run them.
* Remind me to commit my changes before pushing my branch to GitHub.
* We each work on our own branch, named after the person (for example, alex). At the start of each session, remind us to run git pull on main, then merge main into our branch, before we change anything.
* At the end of each session, remind us to push our branch and open a pull request. Our partner reviews it before we merge it into main.
* If our work conflicts with our partner's, explain the conflict in plain words and help us decide what to keep.
* Remind us to merge finished work into main before each due date. Our instructor grades main.

## Project facts

* The dataset `bigquery-public-data.new_york_citibike` contains `citibike_trips` and `citibike_stations`; BigQuery did not list `one_bike_ride`. See [sql/01_table_inventory.sql](sql/01_table_inventory.sql).
* In `citibike_trips`, verified fields used so far are `starttime`, `start_station_id`, `start_station_name`, `end_station_id`, `end_station_name`, and `bikeid`. See [sql/02_trip_start_station_fields.sql](sql/02_trip_start_station_fields.sql) and [sql/05_duplicate_signature_counts.sql](sql/05_duplicate_signature_counts.sql).
* The start-field check counted 58,937,715 total rows; 5,828,994 lack all three start fields; 0 future start dates were found on November 11, 2026. See [sql/03_cleaning_missing_future.sql](sql/03_cleaning_missing_future.sql) and [sql/04_cleaning_missing_overlap.sql](sql/04_cleaning_missing_overlap.sql).
* For an analysis that needs start time and starting station, the working recommendation is to omit rows missing these fields from that calculation, while retaining the source rows. This is the agent's recommendation; the team has not confirmed it.
* The duplicate signature uses `starttime`, `bikeid`, `start_station_id`, and `end_station_id`. It found 9 repeated signatures; full-row review found one identical pair and eight pairs that differ in other fields. No rows have been removed. See [sql/05_duplicate_signature_counts.sql](sql/05_duplicate_signature_counts.sql) and [sql/06_duplicate_full_row_review.sql](sql/06_duplicate_full_row_review.sql).
* The project gap, benchmark, and value are not selected or measured yet. Do not invent figures. Record the question and evidence after the team approves them.
