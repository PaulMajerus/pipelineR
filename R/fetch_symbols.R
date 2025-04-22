#' Fetch join data
#'
#' @param tableInfo
#' @param tableHolc
#'
#' @returns
#' @export
#'
#' @examples
fetch_symbols <- function(con){

  req <- glue_sql("SELECT DISTINCT symbol
                  FROM info",
                  .con = con)

  listeSymbols <- DBI::dbGetQuery(con, req)

  return(table)
}


