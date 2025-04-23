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
    x |>
      dplyr::left_join(tableInfo |> dplyr::select(symbol, index_ts),
                       by = "symbol")
  })

  # Charger la table principale d'observation
  req_data <- glue::glue_sql(paste0("
    SELECT *
    FROM student_", Sys.getenv("PG_USER"), ".data_sp500"),
                             .con = con)

  tableHolc <- DBI::dbGetQuery(con, req_data)


  # ID initial
  id_counter <- if (nrow(tableHolc) == 0) 0 else
    max(tableHolc$id, na.rm = TRUE)

  # Résultat : liste avec IDs incrémentés
  newObservations <- lapply(new_data, function(x) {
    # lignes nouvelles
    x_new <- dplyr::anti_join(x,
                              tableHolc,
                              by = c("index_ts", "date", "metric"))
    n_new <- nrow(x_new)

    if (n_new > 0) {
      x_new <- x_new |>
        dplyr::mutate(id = seq_len(n_new) + id_counter) |>
        dplyr::select(id, index_ts, date, metric, value,symbol)

      id_counter <<- id_counter + n_new
      return(x_new)
    } else {
      return(NULL)
    }
  })

  # Insérer les nouvelles observations
  lapply(newObservations, function(x) {
    if (nrow(x) > 0) {
      DBI::dbAppendTable(
        conn = con,
        name = DBI::SQL(paste0("student_",
                               Sys.getenv("PG_USER"),
                               ".data_sp500")),
        value = x |> dplyr::select(-symbol)
      )
    }
  })

  return(newObservations)
}
