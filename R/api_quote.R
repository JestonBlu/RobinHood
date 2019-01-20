#' RobinHood API: Quote
#'
#' Backend function called by get_positions(), get_quote(), place_order(). Returns a data frame of quote data
#'
#' @param RH object of class RobinHood
#' @param symbols_url (string) url of query with ticker symbols
#' @import curl jsonlite magrittr
#' @examples
#' # data returned by api call
#' #  $ symbol
#' #  $ last_trade_price
#' #  $ last_trade_price_source
#' #  $ ask_price
#' #  $ ask_size
#' #  $ bid_price
#' #  $ bid_size
#' #  $ previous_close
#' #  $ adjusted_previous_close
#' #  $ previous_close_date
#' #  $ last_extended_hours_trade_price
#' #  $ trading_halted
#' #  $ has_traded
#' #  $ updated_at
api_quote <- function(RH, symbols_url) {

  quotes <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = symbols_url) %$% content %>%
    rawToChar %>%
    fromJSON %$% results %>% data.frame

  return(quotes)
}
