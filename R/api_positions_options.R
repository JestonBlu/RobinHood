#' RobinHood API: Option Contract Positions
#'
#' Backend function called by get_positions_options(). Returns a data frame of owned options contracts.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_positions_options <- function(RH) { # nolint

  # URL and token
  url <- RobinHood::api_endpoints("option_positions")
  token <- paste("Bearer", RH$api_response.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)

  # format return
  dta <- RobinHood::mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results)

  dta <- dta %>%
    dplyr::mutate_at(c("intraday_average_open_price", "intraday_quantity", "average_price", "trade_value_multiplier",
                       "pending_expired_quantity", "pending_buy_quantity", "pending_sell_quantity", "quantity"),
                     as.numeric) %>%
    dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  dta <- dta[dta$quantity > 0, ]

  return(dta)
}
