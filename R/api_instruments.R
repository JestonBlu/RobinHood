#' RobinHood API: Instruments
#'
#' Backend function called by get_tag(), get_position(), watchlist(). Returns a list of instrument data.
#'
#' @param RH object of class RobinHood
#' @param symbol (string) a single symbol
#' @param instrument_url (string) instrument url
#' @import httr magrittr
#' @export
api_instruments <- function(RH, symbol = NULL, instrument_url = NULL) {

  if (is.null(instrument_url) == TRUE) {
    url <- paste(api_endpoints("instruments"), "?symbol=", symbol, sep = "")
  } else {
    url <- instrument_url
  }

  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta)

  dta$margin_initial_ratio <- as.numeric(dta$margin_initial_ratio)
  dta$maintenance_ratio <- as.numeric(dta$maintenance_ratio)
  dta$day_trade_ratio <- as.numeric(dta$day_trade_ratio)

  return(dta)

}
