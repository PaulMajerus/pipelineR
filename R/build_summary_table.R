#' Create an Empty Summary Table Template
#'
#' Constructs an empty `tibble` with the expected structure for storing batch processing summaries.
#'
#' @return A `tibble` with predefined columns:
#' \itemize{
#'   \item \code{id} (integer)
#'   \item \code{userLogin} (character)
#'   \item \code{batch_id} (integer)
#'   \item \code{symbol} (character)
#'   \item \code{status} (character)
#'   \item \code{n_rows} (integer)
#'   \item \code{message} (character)
#'   \item \code{timestamp} (POSIXct, timezone = "Europe/Paris")
#' }
#'
#' @export
#'
#' @examples
#' summary_table <- build_summary_table()
#' print(summary_table)
build_summary_table <- function() {
  summaryTable <- tibble::tibble(
    id         = integer(0),
    userLogin  = character(0),
    batch_id   = integer(0),
    symbol     = character(0),
    status     = character(0),
    n_rows     = integer(0),
    message    = character(0),
    timestamp  = as.POSIXct(0, format = "%Y-%m-%d %H:%M:%S", tz = "Europe/Paris")
  )

  return(summaryTable)
}
