#' RobinHood API: Instruments
#'
#' Backend function called by get_tag(), get_position(), watchlist(). Returns a list of instrument data.
#'
#' @param RH object of class RobinHood
#' @param symbol (string) a single symbol
#' @export
#' @import curl jsonlite magrittr
api_instruments <- function(RH, symbol) {

  symbol_url = paste(api_endpoints("instruments"), "?symbol=", symbol, sep = "")

  instrument <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = symbol_url)

  instrument <- fromJSON(rawToChar(instrument$content))
  instrument <- instrument$results

  instrument$margin_initial_ratio <- as.numeric(instrument$margin_initial_ratio)
  instrument$maintenance_ratio <- as.numeric(instrument$maintenance_ratio)
  instrument$day_trade_ratio <- as.numeric(instrument$day_trade_ratio)

  return(instrument)
}
