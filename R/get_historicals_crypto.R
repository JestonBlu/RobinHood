#' Get historical crypto price history from RobinHood
#'
#' Returns a data frame of historical crypto price history for a given symbol. Note that not all combinations of interval/span and bounds will return results. Spans that go beyond day (week, month, year) will not return results for certain bounds values (trading, extended). The function should return a message if you specify a combination of inputs that returns no results.
#'
#' @param RH object of class RobinHood
#' @param symbol (string) ticker symbol of crypto (BTC, ETH, ETC)
#' @param interval (string) Interval of time to aggregate to (examples: hour, day, week, month)
#' @param span (string) Period of time you are interested in (examples: day, week, month, year)
#' @param bounds (string) One of regular (6 hours), trading (9 hours), extended (16 hours), 24_7
#' @param tz (string) timezone returned by OlsonNames() (eg: "America/Chicago")
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_historicals_crypto(RH, symbol = "ETC", interval = "5minute", span = "day", bounds = 'regular')
#' get_historicals_crypto(RH, symbol = "ETC", interval = "5minute", span = "day", bounds = 'trading')
#' get_historicals_crypto(RH, symbol = "ETC", interval = "5minute", span = "day", bounds = 'extended')
#' get_historicals_crypto(RH, symbol = "ETC", interval = "5minute", span = "day", bounds = '24_7')
#'
#'}
get_historicals_crypto <- function(RH, symbol, interval, span, bounds, tz = Sys.timezone()) {

  # Check if RH is valid
  RobinHood::check_rh(RH)

  # Get Crypto ID for historicals
  currency_id <- RobinHood::api_currency_pairs(RH)
  currency_id <- currency_id[currency_id$asset_code == symbol, "id"]

  body <- paste("/?symbol", symbol,
                "&interval=", interval,
                "&span=", span,
                "&bounds=", bounds,
                sep = "")

  # url to get historical data
  url <- paste(RobinHood::api_endpoints("historicals_crypto"), currency_id, body, sep = "")

  historicals <- RobinHood::api_historicals_crypto(RH, url)

  # Certain combinations of interval/span and bounds do not always return results
  # Return a message if the data frame returned is empty
  if (nrow(historicals) == 0) return(cat("You may have used a bounds value that didnt return results"))

  # Adjust timezone to local or user override
  historicals <- historicals %>%
      dplyr::mutate_at("begins_at", function(x) lubridate::with_tz(lubridate::ymd_hms(x), tzone = tz))

  return(historicals)

  }
