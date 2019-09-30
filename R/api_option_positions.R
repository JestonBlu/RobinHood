#' RobinHood API: Option Contract Positions
#'
#' Backend function called by get_contract_positions(). Returns a data frame of owned options contracts.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr

api_option_positions <- function(RH) {

  # URL and token
  url <- api_endpoints("option_positions")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results)

  dta <- dta %>%
    dplyr::mutate_at(c("intraday_average_open_price", "intraday_quantity", "average_price", "trade_value_multiplier",
                       "pending_expired_quantity", "pending_buy_quantity", "pending_sell_quantity", "quantity"),
                     as.numeric) %>%
    dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  option_positions <- option_positions[option_positions$quantity > 0, ]

  return(option_positions)
}
