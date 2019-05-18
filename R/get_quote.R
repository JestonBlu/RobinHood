#' Get a quote from RobinHood
#'
#' @param RH object class RobinHood
#' @param symbol (string) of ticker symbols
#' @param limit_output (logical) if TRUE (default) return less quote detail
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_quote(RH, "IR")
#'}
get_quote <- function(RH, symbol, limit_output = TRUE) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # Get latest quote
  quote <- paste(symbol, collapse = ",")

  # Quotes URL
  quote_url <- paste(api_endpoints(endpoint = "quotes"), quote, sep = "")

  # Get last price
  quotes <- api_quote(RH, quote_url)

  # Trim output
  quotes <- quotes[, !names(quotes) %in% c("instrument")]
  quotes$updated_at <-  lubridate::ymd_hms(quotes$updated_at)

  if (limit_output == TRUE) {
    quotes <- quotes[, c("symbol", "last_trade_price")]
  } else {
    quotes <- quotes[, c("symbol",
                         "last_trade_price",
                         "last_trade_price_source",
                         "ask_price",
                         "ask_size",
                         "bid_price",
                         "bid_size",
                         "previous_close",
                         "adjusted_previous_close",
                         "previous_close_date",
                         "last_extended_hours_trade_price",
                         "trading_halted",
                         "has_traded",
                         "updated_at")]
                     }

  return(quotes)

}
