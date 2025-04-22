yahoo_query_data<-function(){
  table <- lapply(symbol,
                  function(x){
                    tq_get(x,
                           from = "2025-01-01",
                           get = "stock.prices",
                           complete_cases = TRUE)
                  }
  )  %>%
    bind_rows()

  return(table)
}
