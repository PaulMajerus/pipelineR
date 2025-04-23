#' Split a Vector into Random Batches
#'
#' Randomly splits a vector into a list of smaller batches of a specified size.
#'
#' @param vec A vector to be split into batches (e.g., character, numeric).
#' @param batch_size An integer indicating the size of each batch.
#'
#' @return A named list of vectors, each representing a batch.
#' @export
#'
#' @examples
#' symbols <- c("AAPL", "GOOG", "MSFT", "AMZN", "TSLA")
#' split_batch(symbols, batch_size = 2)
split_batch <- function(vec = symbols,
                        batch_size = 10) {

  vec <- sample(vec)
  symbolsBatches <- split(vec, ceiling(seq_along(vec) / batch_size))

  return(symbolsBatches)
}
