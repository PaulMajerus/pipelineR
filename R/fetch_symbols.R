#' Fetch distinct symbols from the database
#'
#' Connects to the database and retrieves the distinct values of `symbol` from the `sp500.info` table.
#'
#' @param con A [DBI::DBIConnection-class] object to the PostgreSQL database.
#'
#' @return A character vector of unique symbols from the `sp500.info` table.
#' @export
#'
#' @examples
#' con <- connect_db()
#' symbols <- fetch_symbols(con)
#' head(symbols)
fetch_symbols <- function(con) {
  req <- glue::glue_sql(
    "SELECT DISTINCT symbol FROM sp500.info",
    .con = con
  )

  symbols <- DBI::dbGetQuery(con, req) %>%
    dplyr::pull(symbol)

  return(symbols)
}



