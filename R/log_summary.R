#' Log Summary of New Observations
#'
#' Generates a summary table for the new observations processed, including the number of rows,
#' the symbols involved, and a message indicating whether new rows were inserted or not.
#'
#' @param newObservations A list of `tibble`s containing the new observations for each batch.
#' @param symbolsBatches A list of character vector containing the symbols by batches
#'
#' @return A `tibble` summarizing the results of the batch processing with columns:
#' \itemize{
#'   \item \code{id} (integer): Unique identifier for each batch.
#'   \item \code{user_login} (character): User login from environment variable \code{PG_USER}.
#'   \item \code{batch_id} (integer): The batch identifier.
#'   \item \code{symbol} (character): A comma-separated list of unique symbols in the batch.
#'   \item \code{status} (character): Status of the batch (always "OK").
#'   \item \code{n_rows} (integer): Number of rows in the batch.
#'   \item \code{message} (character): A message indicating the result of the batch (e.g., "No new rows to insert" or "Batch processed").
#'   \item \code{timestamp} (POSIXct): Timestamp of when the summary was created.
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' summary_table <- log_summary(newObservation)
#' }
log_summary <- function(newObservations = list(),
                        symbolsBatches = list()) {

  # Create the summary table by processing each new observation batch
  summary_table <- lapply(1:length(newObservations), function(x) {
    n_rows <- nrow(newObservations[[x]])

    # Create a summary for each batch
    newObservations[[x]] |>
      dplyr::summarize(
        n_rows = n_rows,
        symbol = paste0(symbolsBatches[[x]], collapse = ",")
      ) |>
      dplyr::mutate(
        user_login = Sys.getenv("PG_USER"),
        message = if (n_rows == 0) "No new rows to insert" else
          "Batch processed"
      )
  }) |>
    dplyr::bind_rows(.id = "batch_id") |>
    dplyr::mutate(
      status = "OK",
      timestamp = Sys.time()
    ) |>
    dplyr::select(user_login, batch_id, symbol, status, n_rows, message, timestamp)

  return(summary_table)
}
