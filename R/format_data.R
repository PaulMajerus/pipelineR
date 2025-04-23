#' Title
#'
#' @param table
#'
#' @returns
#' @export
#'
#' @examples
format_data<-function(table = list()){


  formattedTable <- lapply(table,
                           function(x){
                             x %>%
    tidyr::pivot_longer(names_to = "metric",
                        values_to = "value",
                        cols = c("open","high","low","close"))})

  return(formattedTable)

}
