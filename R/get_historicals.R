#' Get historical price history from RobinHood
#'
#' Returns a data frame of historical price history for a given symbol.
#'
#' @param RH object of class RobinHood
#' @param symbol (string) Stock symbol to query, single symbol only
#' @param interval (string) Interval of time to aggregate to (examples: hour, day, week, month)
#' @param span (string) Period of time you are interested in (examples: day, week, month, year)
#' @param tz (string) timezone returned by OlsonNames() (eg: "America/Chicago")
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_historicals (RH = RH, symbol = "CAT", interval = "day", span = "month")
#'
#'}
get_historicals <- function(RH, symbol, interval, span, tz = Sys.timezone()) {

    # Check if RH is valid
    check_rh(RH)

    # Call the historical price position endpoint
    historicals_url <- api_endpoints("historicals")

    # Create the api url
    body <- paste("symbols=", symbol,
                  "&interval=", interval,
                  "&span=", span,
                  sep = "")

    # Call the historical api for price history
    historicals <- api_historicals(RH, historicals_url, body)

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
