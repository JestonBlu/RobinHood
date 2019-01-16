#' Get Current Quote from RobinHood
#'
#' For a string of ticker symbols, return latest quote data.
#'
#' @param RH object class RobinHood
#' @param ticker (string) of ticker symbols
#' @import curl jsonlite magrittr lubridate
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # get_quote(RH, c("CAT", "GE"))
get_quote <- function(RH, ticker) {

  # Get latest quote
  quote <- paste(ticker, collapse = ",")

  # Quotes URL
  quote_url <- paste(api_endpoints(endpoint = "quotes"), quote, sep = "")

  # Get last price
  quotes <- api_quote(RH, quote_url)

  # Trim output
  quotes <- subset(quotes, select = -c(instrument))
  quotes$updated_at <- ymd_hms(quotes$updated_at)

  return(quotes)

}
