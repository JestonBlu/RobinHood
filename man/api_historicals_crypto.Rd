% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api_historicals_crypto.R
\name{api_historicals_crypto}
\alias{api_historicals_crypto}
\title{RobinHood API: Historicals crypto}
\usage{
api_historicals_crypto(RH, url)
}
\arguments{
\item{RH}{object of class RobinHood}

\item{url}{(string) full url coming from get_historicals_crypto}
}
\description{
Backend function called by get_historicals_crypto(). Returns a data frame of historical price data.
}
