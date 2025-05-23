% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/start_pipeline.R
\name{start_pipeline}
\alias{start_pipeline}
\title{Start the Data Pipeline}
\usage{
start_pipeline(batch_size = 10)
}
\arguments{
\item{batch_size}{The size of each batch when splitting the symbols for querying Yahoo Finance.}
}
\description{
This function runs the entire data pipeline. It connects to the database, fetches data, processes it in batches,
formats it, inserts new data, generates a summary, and pushes the summary to the database.
}
\examples{
\dontrun{
start_pipeline(batch_size = 10)
}
}
