#' Insert New Observations into PostgreSQL Table
#'
#' This function identifies and inserts new data points from a formatted list of `tibble`s into a
#' PostgreSQL table. It compares with existing records based on `index_ts`, `date`, and `metric`.
#'
#' @param con A PostgreSQL DBI connection object.
#' @param formattedTable A list of `tibble`s containing cleaned and reshaped data.
#'
#' @return A list of `tibble`s containing only the new observations inserted into the database.
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' new_data <- insert_new_data(con, formattedTable)
#' }
insert_new_data <- function(con,
                            formattedTable = list()) {

  # Charger la table info
  req_info <- glue::glue_sql("
    SELECT symbol, index_ts
    FROM sp500.info", .con = con)

  tableInfo <- DBI::dbGetQuery(con, req_info)

  # Joindre l'index_ts à chaque table
  new_data <- lapply(formattedTable, function(x) {
    x %>%
      dplyr::left_join(tableInfo %>% dplyr::select(symbol, index_ts),
                       by = "symbol")
  })

  # Charger la table principale d'observation
  req_data <- glue::glue_sql(paste0("
    SELECT id, index_ts, date, metric, value
    FROM student_", Sys.getenv("PG_USER"), ".data_sp500"),
                             .con = con)

  tableHolc <- DBI::dbGetQuery(con, req_data)

  # Détecter uniquement les nouvelles observations
  newObservations <- lapply(new_data, function(x) {
    dplyr::anti_join(
      x,
      tableHolc,
      by = c("index_ts", "date", "metric")
    )
  })

  # Insérer les nouvelles observations
  invisible(lapply(newObservations, function(x) {
    if (nrow(x) > 0) {
      DBI::dbAppendTable(
        conn = con,
        name = DBI::SQL(paste0("student_", Sys.getenv("PG_USER"), ".data_sp500")),
        value = x
      )
    }
  }))

  return(newObservations)
}
