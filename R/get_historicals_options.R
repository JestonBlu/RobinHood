#' Get historical options from RobinHood
#'
#' Returns a data frame of historical options for a given symbol, strike price, and expiration date.
#'
#' @param RH object of class RobinHood
#' @param chain_symbol (string) stock symbol
#' @param type (string) one of ("put", "call")
#' @param strike_price (numeric) strike price
#' @param expiration_date (string) expiration date (YYYY-MM-DD)
#' @param interval (string) one of ("5minute", "10minute", "hour", "day", "week")
#' @param span (string) one of ("day", "week", "month")
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_historicals_options(RH = RH, chain_symbol = "AAPL", interval = "10minute", type = "call",
#'                         expiration_date = "2021-03-12", strike_price = 122)
#'
#'}
get_historicals_options <- function(RH, chain_symbol, type, strike_price, expiration_date,
                                    interval = NULL, span = NULL) {

  # Check if RH is valid
  RobinHood::check_rh(RH)

  historicals <- api_historicals_options(RH, chain_symbol = chain_symbol,
                                         type = type,
                                         strike_price = strike_price,
                                         expiration_date = expiration_date,
                                         interval = interval,
                                         span = span)

  # Add columns for strike + symbol + expiration + type
  historicals$strike_price <- strike_price
  historicals$expiration_date <- expiration_date
  historicals$type <- type
  historicals$chain_symbol <- chain_symbol

  # Reorder columns
  historicals <- historicals %>%
    dplyr::select("chain_symbol", "type", "expiration_date", "strike_price", "open_price", "close_price",
                  "low_price", "high_price", "volume", "begins_at", "session", "interpolated")

  return(historicals)

  }
