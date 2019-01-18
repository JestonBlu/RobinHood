#' RobinHood API: Fundamentals
#'
#' Get a list of trading data for a particular ticker symbol
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @import curl jsonlite magrittr
api_fundamentals <- function(RH, ticker) {

  ticker_symbols <- paste(api_endpoints("fundamentals"), ticker, collapse = ",", sep = "")

  # Log in, get access token
  fundamentals <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = ticker_symbols) %$% content %>%
    rawToChar %>%
    fromJSON %$% results %>% data.frame

  return(fundamentals)
}
