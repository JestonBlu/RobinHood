#' RobinHood API: Option Orders
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_orders_options <- function(RH) {

  # URL and token
  url <- api_endpoints("option_orders")
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

  # Only return options you current own
  dta <- dta[dta$quantity > 0, ]

  return(dta)
}
