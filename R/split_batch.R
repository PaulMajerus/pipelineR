#' Title
#'
#' @param vec
#' @param batch_size
#'
#' @returns
#' @export
#'
#' @examples
split_batch <- function(vec = symbols,
                        batch_size = 10){

    vec <- sample(vec)
    symbolsBatches <- split(vec, ceiling(seq_along(vec) / batch_size))

    return(symbolsBatches)

}
