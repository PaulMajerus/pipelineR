format_data<-function(){


  formattedTable <- table %>%
    tidyr::pivot_longer(names_to = "metric",
                        values_to = "value",
                        cols = c("open","high","low","close"))

  return(formattedTable)

}
