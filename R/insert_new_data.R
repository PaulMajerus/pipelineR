#' Title
#'
#' @param con
#' @param formattedTable
#'
#' @returns
#' @export
#'
#' @examples
insert_new_data<-function(con = con,
                          formattedTable = list()){

  req <- glue::glue_sql("SELECT symbol,
                  index_ts
                  FROM sp500.info",
                        .con = con)

  tableInfo <- DBI::dbGetQuery(con,req)

  new_data <- lapply(formattedTable,
         function(x){

           x %>%
             dplyr::left_join(tableInfo %>%
                                select(symbol,index_ts),
                              by="symbol")
         })

  req <- glue::glue_sql(paste0("SELECT id,
                  index_ts,
                  date,
                  metric,
                  value
                  FROM student_",Sys.getenv("PG_USER"),
                               ".data_sp500"),
                  .con = con)

  tableHolc <- DBI::dbGetQuery(con,req)

  newObservations <- lapply(new_data,
         function(x){
           dplyr::anti_join(
             x,
             tableHolc,
             by = c("index_ts", "date", "metric")
           )
         })

  lapply(newObservations,
         function(x){
           dbAppendTable(
             conn = con,
             name = paste0("student_",
                           Sys.getenv("PG_USER"),
                           ".data_sp500"),
             value = x
           )
         })


  return(newObservations)
}
