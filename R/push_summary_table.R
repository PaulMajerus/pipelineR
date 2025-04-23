#' Push Summary Table to PostgreSQL
#'
#' This function appends the summary table (containing batch processing details) to a PostgreSQL table.
#' The table is stored under a schema named with the current user's environment variable `PG_USER`.
#'
#' @param summaryTable A `tibble` containing the summary of new observations that were processed.
#' The table must have the same structure as the `pipeline_logs` table in the PostgreSQL database.
#' @param con A connection to the database.
#'
#' @return NULL This function does not return anything. It performs an append operation to the database.
#' @export
#'
#' @examples
#' \dontrun{
#' push_summary_table(summaryTable)
#' }
push_summary_table <- function(summaryTable = tibble(),
                               con=con) {

  # Append the summary table to the "pipeline_logs" table in the user's schema
  DBI::dbAppendTable(
    conn = con,
    name = DBI::Id(
      schema = paste0("student_", Sys.getenv("PG_USER")),
      table = "pipeline_logs"
    ),
    value = summaryTable
  )


}
