

# connect_db()
con <- connect_db()

# fetch_symbols()
symbols <- fetch_symbols(con)

# build_summary_table()
summaryTable <- build_summary_table()

# split_batch()
symbolsBatches <- split_batch(vec = symbols,
                              batch_size = 10)

# yahoo_query_data()
table <- yahoo_query_data(symbolsBatches = symbolsBatches,
                                    from = "2025-01-01")

# format_table()
formattedTable <- format_data(table = table)

#insert_new_data()
newObservation <- insert_new_data(con = con,
                formattedTable = formattedTable)

#log_summary()
summaryTable <- log_summary(newObservation = newObservation)

# push_summary_table()
push_summary_table()
#dbDisconnect
DBI::dbDisconnect(con)
