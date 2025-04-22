library(readr)
library(dplyr)
# info <- read_csv("//home01/ms/YLF486/Formation/R/data/info.csv")
#
# holc <- read_csv("//home01/ms/YLF486/Formation/R/data/holc.csv")
#
# logs <- read_csv("//home01/ms/YLF486/Formation/R/data/logs.csv")

library(glue)
# connect_db()
con <- luxJob::connect_db()

# fetch_symbols()
req <- glue_sql("SELECT DISTINCT symbol
                  FROM sp500.info",
                .con = con)

symbols <- DBI::dbGetQuery(con,req) %>% pull(symbol)

# build_summary_table()

# split_batch()
make_batches <- function(vec, batch_size) {
  vec <- sample(vec)  # permutation aléatoire
  split(vec, ceiling(seq_along(vec) / batch_size))
}

symbolsBatches <- make_batches(symbols,10)

# yahoo_query_data()
library(tidyquant)
table <- lapply(symbolsBatches,
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
req <- glue_sql("SELECT symbol,
                  index_ts
                  FROM sp500.info",
                .con = con)

tableInfo <- DBI::dbGetQuery(con,req)

new_data <- formattedTable %>%
  left_join(tableInfo %>%
              select(symbol,index_ts),
            by="symbol")

req <- glue_sql("SELECT id,
                  index_ts,
                  date,
                  metric,
                  value
                  FROM student_paul.data_sp500",
                .con = con)

tableHolc <- DBI::dbGetQuery(con,req)

finalTable <- new_data %>%
  anti_join(tableHolc,
            by = c("index_ts","date","metric"))

#log_summary()


# push_summary_table()
#dbDisconnect
DBI::dbDisconnect(con)
