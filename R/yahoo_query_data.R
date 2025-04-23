#' Title
#'
#' @param symbolsBatches
#' @param from
#'
#' @returns
#' @export
#'
#' @examples
yahoo_query_data<-function(symbolsBatches = symbolsBatches){

  table <- lapply(symbolsBatches,
                  function(x){
                    tidyquant::tq_get(x,
                                      from = lubridate::now()-lubridate::days(5),
                                      get = "stock.prices",
                                      complete_cases = TRUE)
                  }
  )

  return(table)
}
