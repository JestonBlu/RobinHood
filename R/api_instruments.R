#' RobinHood API: Instruments
#'
#' Backend function called by get_tag(), get_position(), watchlist(). Returns a list of instrument data.
#'
#' @param RH object of class RobinHood
#' @param instrument_id (string) a single instrument_id
#' @import curl jsonlite magrittr
#' @examples
#' # data returned by api call
#' #  $ margin_initial_ratio
#' #  $ rhs_tradability
#' #  $ id
#' #  $ market
#' #  $ simple_name
#' #  $ min_tick_size
#' #  $ maintenance_ratio
#' #  $ tradability
#' #  $ state
#' #  $ type
#' #  $ tradeable
#' #  $ fundamentals
#' #  $ quote
#' #  $ symbol
#' #  $ day_trade_ratio
#' #  $ name
#' #  $ tradable_chain_id
#' #  $ splits
#' #  $ url
#' #  $ country
#' #  $ bloomberg_unique
#' #  $ list_date
api_instruments <- function(RH, instrument_id) {

  instrument <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = instrument_id) %$% content %>%
    rawToChar %>% fromJSON

  return(instrument)
}
