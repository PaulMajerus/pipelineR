log_summary<-function(newObservation = list()){

  summary_table <- lapply(newObservation, function(x) {
    n_rows <- nrow(x)
    x %>%
      summarize(
        n_rows = n_rows,
        symbol = paste(unique(symbol), collapse = ",")
      ) %>%
      mutate(
        user_login = Sys.getenv("PG_USER"),
        message = if (n_rows == 0) "No new rows to insert" else
          "Batch processed"
      )
  }) %>%
    bind_rows(.id = "batch_id") %>%
    mutate(
      status = "OK",
      timestamp = Sys.time(),
      id = row_number()
    ) %>%
    select(id, user_login, batch_id, symbol,
           status, n_rows, message, timestamp)

  return(summary_table)

}
