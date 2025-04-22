library(readr)
library(dplyr)
info <- read_csv("//home01/ms/YLF486/Formation/R/data/info.csv")

holc <- read_csv("//home01/ms/YLF486/Formation/R/data/holc.csv")

logs <- read_csv("//home01/ms/YLF486/Formation/R/data/logs.csv")


# connect_db()


# fetch_symbols()
symbols <- sort(unique(info$symbol))

# build_summary_table()

# split_batch()
make_batches <- function(vec, batch_size) {
  vec <- sample(vec)  # permutation aléatoire
  split(vec, ceiling(seq_along(vec) / batch_size))
}

symbolsBatches <- make_batches(symbols,10)

# yahoo_query_data()
table <- lapply(symbol,
       function(x){
         tq_get(x,
                from = "2025-01-01",
                get = "stock.prices",
                complete_cases = TRUE)
       }
)  %>%
  bind_rows()

# format_table()
formattedTable <- table %>%
  tidyr::pivot_longer(names_to = "metric",
               values_to = "value",
               cols = c("open","high","low","close"))
#insert_new_data()
new_data <- formattedTable %>%
  left_join(info %>%
              select(symbol,index_ts),
            by="symbol")

new_data %>%
  anti_join(holc,
            by = c("index_ts","date","metric"))

#log_summary()
