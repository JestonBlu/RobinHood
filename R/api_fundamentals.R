#' RobinHood API: Fundamentals
#'
#' Backend function called by get_fundamentals(), watchlist(). Returns a data frame of descriptive data for a
#' given ticker symbol.
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @import curl magrittr
#' @export
api_fundamentals <- function(RH, ticker) {

  ticker_symbols <- paste(api_endpoints("fundamentals"), ticker, collapse = ",", sep = "")

  fundamentals <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = ticker_symbols)

  fundamentals <- jsonlite::fromJSON(rawToChar(fundamentals$content))
  fundamentals <- data.frame(fundamentals$results)

  fundamentals <- fundamentals %>%
    dplyr::mutate_at(c("open", "high", "low", "volume", "average_volume_2_weeks", "average_volume", "high_52_weeks",
                       "dividend_yield", "low_52_weeks", "market_cap", "pe_ratio", "shares_outstanding"),
                     as.numeric)

  return(fundamentals)
}
