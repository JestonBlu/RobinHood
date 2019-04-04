#' RobinHood API: Option Contract Positions
#'
#' Backend function called by get_contract_positions(). Returns a data frame of owned options contracts.
#'
#' @param RH object of class RobinHood
#' @export
#' @import curl jsonlite magrittr lubridate
api_option_positions <- function(RH) {

  option_positions_url <- api_endpoints("option_positions")

  option_positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = option_positions_url)

  option_positions <- fromJSON(rawToChar(option_positions$content))
  option_positions <- data.frame(option_positions$results)

  option_positions$intraday_average_open_price <- as.numeric(option_positions$intraday_average_open_price)
  option_positions$intraday_quantity <- as.numeric(option_positions$intraday_quantity)
  option_positions$created_at <- lubridate::ymd_hms(option_positions$created_at)
  option_positions$updated_at <- lubridate::ymd_hms(option_positions$updated_at)
  option_positions$average_price <- as.numeric(option_positions$average_price)
  option_positions$trade_value_multiplier <- as.numeric(option_positions$trade_value_multiplier)
  option_positions$pending_expired_quantity <- as.numeric(option_positions$pending_expired_quantity)
  option_positions$pending_buy_quantity <- as.numeric(option_positions$pending_buy_quantity)
  option_positions$pending_sell_quantity <- as.numeric(option_positions$pending_sell_quantity)
  option_positions$quantity <- as.numeric(option_positions$quantity)

  option_positions <- option_positions[option_positions$quantity > 0, ]

  return(option_positions)
}
