Audit Protocol
I use this process to check our Citi Bike analysis before relying on its results.
I state the question, date range, and what one output row represents before asking for SQL.
I check the table and field names in BigQuery metadata or project documentation before using them.
I review one focused query at a time. I confirm its filters, duplicate handling, coordinate rule, and expected output before running it.
I save the query and results, then compare important totals with a second calculation or a spot check.
I check station names and coordinates before treating an ID as the same location in both years. Here, an ID must have one start-coordinate pair rounded to four decimals across both periods.
I keep source data unchanged and record missing fields, exact duplicates, exclusions, and assumptions.
I separate observed counts from my explanation. A change in ride counts does not show why it happened, and ride counts are not revenue.
I record checks, corrections, and limits in audit_log.md, then review the report before committing.
