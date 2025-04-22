#' Title
#'
#' @returns
#' @export
#'
#' @examples
connect_db <- function(tableName = "sp500.info"){
  con <- luxJob::connect_db()
  query <- paste0("'SELECT * FROM ",
                  tableName,"'")
  table <- DBI::dbGetQuery(con,query)
  return(table)
}
