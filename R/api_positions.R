#' RobinHood API: Positions
#'
#' Backend function called by get_positions(). Returns a data frame of instrument position data.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @examples
#' # data returned by api call
#' # $ shares_held_for_stock_grants
#' # $ account
#' # $ pending_average_buy_price
#' # $ shares_held_for_options_events
#' # $ intraday_average_buy_price
#' # $ url
#' # $ shares_held_for_options_collateral
#' # $ created_at
#' # $ updated_at
#' # $ shares_held_for_buys
#' # $ average_buy_price
#' # $ instrument
#' # $ intraday_quantity
#' # $ shares_held_for_sells
#' # $ shares_pending_from_options_events
#' # $ quantity
api_positions <- function(RH) {

  positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = RH$url.positions) %$% content %>%
    rawToChar %>%
    fromJSON %$% results %>% data.frame

  positions$created_at <- ymd_hms(positions$created_at)
  positions$updated_at <- ymd_hms(positions$updated_at)
  positions$shares_held_for_stock_grants <- as.numeric(positions$shares_held_for_stock_grants)
  positions$pending_average_buy_price <- as.numeric(positions$pending_average_buy_price)
  positions$shares_held_for_options_events <- as.numeric(positions$shares_held_for_options_events)
  positions$intraday_average_buy_price <- as.numeric(positions$intraday_average_buy_price)
  positions$shares_held_for_options_collateral <- as.numeric(positions$shares_held_for_options_collateral)
  positions$shares_held_for_buys <- as.numeric(positions$shares_held_for_buys)
  positions$average_buy_price <- as.numeric(positions$average_buy_price)
  positions$intraday_quantity <- as.numeric(positions$intraday_quantity)
  positions$shares_held_for_sells <- as.numeric(positions$shares_held_for_sells)
  positions$shares_pending_from_options_events <- as.numeric(positions$shares_pending_from_options_events)
  positions$quantity <- as.numeric(positions$quantity)

  return(positions)
}
