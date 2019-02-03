#' RobinHood API: Instruments
#'
#' Backend function called by get_tag(), get_position(), watchlist(). Returns a list of instrument data.
#'
#' @param RH object of class RobinHood
#' @param instrument_id (string) a single instrument_id
#' @import curl jsonlite magrittr
api_instruments <- function(RH, instrument_id) {

  instrument <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = instrument_id)

  instrument <- fromJSON(rawToChar(instrument$content))

  instrument$margin_initial_ratio <- as.numeric(instrument$margin_initial_ratio)
  instrument$maintenance_ratio <- as.numeric(instrument$maintenance_ratio)
  instrument$day_trade_ratio <- as.numeric(instrument$day_trade_ratio)

  return(instrument)
}
