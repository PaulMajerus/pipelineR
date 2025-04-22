insert_new_data<-function(){

  new_data <- formattedTable %>%
    left_join(info %>%
                select(symbol,index_ts),
              by="symbol")

  new_data %>%
    anti_join(holc,
              by = c("index_ts","date","metric"))

}
