push_summary_table <- function(summaryTable=tibble()){

  dbAppendTable(
    conn = con,
    name = paste0("student_",
                  Sys.getenv("PG_USER"),
                  ".pipeline_logs"),
    value = summaryTable
  )

}
