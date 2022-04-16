#' RobinHood API: Quote
#'
#' Backend function called by get_positions(), get_quote(), place_order(). Returns a data frame of quote data
#'
#' @param RH object of class RobinHood
#' @param symbols_url (string) url of query with ticker symbols
#' @import httr magrittr
#' @export
api_quote <- function(RH, symbols_url) {

  # URL and token
  url <- symbols_url
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(df)
  
  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results)

  # Check if api did not return any results
  if (nrow(dta) == 0) stop("Symbol not found")

  dta <- dta %>%
  dplyr::mutate_at(c("ask_price", "bid_price", "last_trade_price",
                     "last_extended_hours_trade_price",
                     "previous_close", "adjusted_previous_close"), as.numeric) %>%
  dplyr::mutate_at("previous_close_date", lubridate::ymd) %>%
  dplyr::mutate_at("updated_at", lubridate::ymd_hms)


  return(dta)
}
