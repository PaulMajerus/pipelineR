#' Title
#'
#' @returns
#' @export
#'
#' @examples
build_summary_table<-function(){

  summaryTable <- tibble::tibble(id=integer(0),
                 userLogin = character(0),
                 batch_id = integer(0),
                 symbol = character(0),
                 status = character(0),
                 n_rows = integer(0),
                 message = character(0),
                 timestamp = as.POSIXct(0,
                                        format = "%Y-%m-%d %H:%M:%S",
                                        tz = "Europe/Paris"))

  return(summaryTable)

}
