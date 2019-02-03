#' RobinHood API: Fundamentals
#'
#' Backend function called by get_fundamentals(), watchlist(). Returns a data frame of descriptive data for a
#' given ticker symbol.
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @import curl jsonlite magrittr
api_fundamentals <- function(RH, ticker) {

  ticker_symbols <- paste(api_endpoints("fundamentals"), ticker, collapse = ",", sep = "")

  fundamentals <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = ticker_symbols)

  fundamentals <- fromJSON(rawToChar(fundamentals$content))
  fundamentals <- data.frame(fundamentals$results)

  fundamentals$open <- as.numeric(fundamentals$open)
  fundamentals$high <- as.numeric(fundamentals$high)
  fundamentals$low <- as.numeric(fundamentals$low)
  fundamentals$volume <- as.numeric(fundamentals$volume)
  fundamentals$average_volume_2_weeks <- as.numeric(fundamentals$average_volume_2_weeks)
  fundamentals$average_volume <- as.numeric(fundamentals$average_volume)
  fundamentals$high_52_weeks <- as.numeric(fundamentals$high_52_weeks)
  fundamentals$dividend_yield <- as.numeric(fundamentals$dividend_yield)
  fundamentals$low_52_weeks <- as.numeric(fundamentals$low_52_weeks)
  fundamentals$market_cap <- as.numeric(fundamentals$market_cap)
  fundamentals$pe_ratio <- as.numeric(fundamentals$pe_ratio)
  fundamentals$shares_outstanding <- as.numeric(fundamentals$shares_outstanding)


  return(fundamentals)
}
