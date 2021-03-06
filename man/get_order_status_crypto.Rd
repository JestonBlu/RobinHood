% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_order_status_crypto.R
\name{get_order_status_crypto}
\alias{get_order_status_crypto}
\title{Get a current status of an crypto currency order on RobinHood}
\usage{
get_order_status_crypto(RH, order_id)
}
\arguments{
\item{RH}{object of class RobinHood}

\item{order_id}{(string) id field of the object returned by place_order_crypto}
}
\description{
Returns a list of order information given a buy/sell order url returned from place_order().
}
\examples{
\dontrun{
# Login in to your RobinHood account
RH <- RobinHood("username", "password")

# Place an order, should generate an email confirmation
x <- place_order_crypto(RH = RH,
                       symbol = "GE",          # Ticker symbol you want to trade
                       type = "market",        # Type of market order
                       time_in_force = "gfd",  # Time period (gfd: good for day)
                       trigger = "immediate",  # Trigger or delay order
                       price = 8.96,           # The highest price you are willing to pay
                       quantity = 1,           # Number of shares you want
                       side = "buy")           # buy or sell

get_order_status_crypto(RH, order_id = x$id)
}
}
