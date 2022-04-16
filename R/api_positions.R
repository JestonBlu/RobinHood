#' RobinHood API: Positions
#'
#' Backend function called by get_positions(). Returns a data frame of instrument position data.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_positions <- function(RH) {

  # URL and token
  url <- api_endpoints("positions")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(df)
  
  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results)

  # Stop if data.frame is empty (no positions)
  if (nrow(dta) == 0) {
    stop("No positions found")
  }

  dta <- dta %>%
    dplyr::mutate_at(c("shares_held_for_stock_grants", "pending_average_buy_price",
                       "shares_held_for_options_events", "intraday_average_buy_price",
                       "shares_held_for_options_collateral", "shares_held_for_buys",
                       "average_buy_price", "intraday_quantity", "shares_held_for_sells",
                       "shares_pending_from_options_events", "quantity"), as.numeric) %>%
    dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  # Dont return records for 0 positions
  dta <- dta[dta$quantity > 0, ]

  return(dta)
}
