#' Get a current instrument quote from RobinHood
#'
#' For a string of ticker symbols, return quote data.
#'
#' @param RH object class RobinHood
#' @param ticker (string) of ticker symbols
#' @param simple (logical) if TRUE (default) return less quote detail
#' @import curl jsonlite magrittr lubridate
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # get_quote(RH, c("CAT", "GE"))
get_quote <- function(RH, ticker, simple = TRUE) {

  # Get latest quote
  quote <- paste(ticker, collapse = ",")

  # Quotes URL
  quote_url <- paste(api_endpoints(endpoint = "quotes"), quote, sep = "")

  # Get last price
  quotes <- api_quote(RH, quote_url)

  # Trim output
  quotes <- subset(quotes, select = -c(instrument))
  quotes$updated_at <- ymd_hms(quotes$updated_at)

  if (simple == TRUE) {
    quotes <- quotes[, c("symbol",
                        "last_trade_price",
                        "last_trade_price_source")]
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
