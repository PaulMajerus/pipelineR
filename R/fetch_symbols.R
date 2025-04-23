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

  req <- glue::glue_sql("SELECT DISTINCT symbol
                  FROM sp500.info",
                  .con = con)

  symbols <- DBI::dbGetQuery(con,req) %>% dplyr::pull(symbol)

  return(symbols)
}


