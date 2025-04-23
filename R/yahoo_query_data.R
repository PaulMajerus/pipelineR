#' Query Yahoo Finance Data for a List of Symbol Batches
#'
#' Retrieves stock price data for each batch of symbols using `tq_get()` from the `tidyquant` package.
#'
#' @param symbolsBatches A list of character vectors, each representing a batch of stock symbols.
#' @param from A `Date` or `POSIXct` object specifying the start date for data retrieval. Defaults to 5 days ago.
#'
#' @return A list of `tibble`s with stock price data for each batch.
#' @export
#'
#' @examples
#' symbols <- c("AAPL", "GOOG", "MSFT")
#' batches <- split_batch(symbols, batch_size = 2)
#' data <- yahoo_query_data(batches)
yahoo_query_data <- function(symbolsBatches,
                             from = lubridate::now() - lubridate::days(5)) {

  table <- lapply(symbolsBatches, function(x) {
    tidyquant::tq_get(
      x,
      from = from,
      get = "stock.prices",
      complete_cases = TRUE
    )
  })

  return(table)
}
