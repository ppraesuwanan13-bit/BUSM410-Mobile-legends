# How Our Team Checks AI Work

We use an AI assistant to help with the Citi Bike project, but we are responsible for the work we submit. We use these steps to check the assistant and our analysis. We record examples in the [audit log](audit_log.md).

1. **Say what we are trying to answer.** Before asking for analysis, we explain the project question and what decision the results could help with.
2. **Check where facts came from.** If the assistant gives a fact about the dataset, we ask for the table, field, query, or source that supports it.
3. **Mark calculations and opinions clearly.** We check the math ourselves and label interpretations as interpretations, not as facts from the data.
4. **Agree on what a query should return.** Before running SQL, we decide what one result row means and which columns we need.
5. **Read the SQL before running it.** We check the dates, filters, grouping, and estimated data scanned in BigQuery.
6. **Follow up on unexpected results.** If a number or pattern surprises us, we ask why and check the query and source before using it.
7. **Keep a record of our checks.** When we confirm a result, catch a mistake, or change our approach, we add what we checked and what we learned to the audit log.

We do not have to accept an answer just because the assistant gave it. If something is unclear, we ask questions until we understand it. We review the final analysis and take responsibility for the conclusions.
