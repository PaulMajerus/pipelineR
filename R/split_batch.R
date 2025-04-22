split_batch <- function(){

  make_batches <- function(vec, batch_size) {
    vec <- sample(vec)  # permutation aléatoire
    split(vec, ceiling(seq_along(vec) / batch_size))
  }

  symbolsBatches <- make_batches(symbols,10)

}
