#' Start the Data Pipeline
#'
#' This function runs the entire data pipeline. It connects to the database, fetches data, processes it in batches,
#' formats it, inserts new data, generates a summary, and pushes the summary to the database.
#'
#' @param batch_size The size of each batch when splitting the symbols for querying Yahoo Finance.
#' @returns NULL
#' @export
#'
#' @examples
#' \dontrun{
#' start_pipeline(batch_size = 10)
#' }
start_pipeline <- function(batch_size = 10){


  # connect_db()
  con <- connect_db()

  # fetch_symbols()
  symbols <- fetch_symbols(con)

  # build_summary_table()
  summaryTable <- build_summary_table()

  # split_batch()
  symbolsBatches <- split_batch(vec = symbols,
                                batch_size = batch_size)

  # yahoo_query_data()
  table <- yahoo_query_data(symbolsBatches = symbolsBatches)

  # format_table()
  formattedTable <- format_data(table = table)

  #insert_new_data()
  newObservations <- insert_new_data(con = con,
                                    formattedTable = formattedTable)

  #log_summary()
  summaryTable <- log_summary(newObservations = newObservations)

  # push_summary_table()
  push_summary_table(con=con,
                     summaryTable = summaryTable)
  #dbDisconnect
  DBI::dbDisconnect(con)
}
