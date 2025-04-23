#' Connect to the PostgreSQL Database
#'
#' This function wraps the internal `luxJob::connect_db()` function and returns a DBI connection object.
#'
#' @return A [DBI::DBIConnection-class] object to the PostgreSQL database.
#' @export
#'
#' @examples
#' con <- connect_db()
#' DBI::dbListTables(con)
connect_db <- function(){
  con <- luxJob::connect_db()
  return(con)
}
