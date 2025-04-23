#' Reshape Stock Price Data to Long Format
#'
#' Transforms each `tibble` in a list from wide format (with columns `open`, `high`, `low`, `close`)
#' to long format using `pivot_longer()`, resulting in a metric/value structure.
#'
#' @param table A list of `tibble`s containing stock price data (typically from `tq_get()`).
#'
#' @return A list of reshaped `tibble`s with columns including `metric` and `value`.
#' @export
#'
#' @examples
#' \dontrun{
#' data <- yahoo_query_data(symbolsBatches)
#' formatted <- format_data(data)
#' }
format_data <- function(table = list()) {
  formattedTable <- lapply(table, function(x) {
    x |>
      tidyr::pivot_longer(
        names_to = "metric",
        values_to = "value",
        cols = c("open", "high", "low", "close")
      )
  })

  return(formattedTable)
}
