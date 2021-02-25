#' Get historical crypto price history from RobinHood
#'
#' Returns a data frame of historical crypto price history for a given symbol.
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
#' get_historicals_crypto(RH = RH, symbol = "ETC", interval = "day", bounds = "extended",
#'                        span = "month")
#'
#'}
get_historicals_crypto <- function(RH, symbol, interval, span, bounds, tz = Sys.timezone()) {

  # Check if RH is valid
  check_rh(RH)

  # Get Crypto ID for historicals
  currency_id <- api_currency_pairs(RH)
  currency_id <- currency_id[currency_id$asset_code == symbol, "id"]

  body <- paste("/?symbol", symbol,
                "&interval=", interval,
                "&span=", span,
                "&bounds=", bounds,
                sep = "")

  # url to get historical data
  url <- paste(api_endpoints("historicals_crypto"), currency_id, body, sep = "")

  historicals <- api_historicals_crypto(RH, url)

  # If interval is hour or minute, then adjust timezone to local or user override
  if (length(grep("hour|minute", x = interval)) == 1) {

    historicals <- historicals %>%
      dplyr::mutate_at("begins_at", function(x) lubridate::with_tz(lubridate::ymd_hms(x), tzone = tz))

  } else {

    historicals <- historicals %>%
      dplyr::mutate_at("begins_at", lubridate::ymd)

  }

  return(historicals)

  }
