#' Get historical price history from RobinHood
#'
#' Returns a data frame of historical price history for a given symbol.
#'
#' @param RH object of class RobinHood
#' @param symbol (string) Stock symbol to query, single symbol only
#' @param interval (string) Interval of time to aggregate to (examples: hour, day, week, month)
#' @param span (string) Period of time you are interested in (examples: day, week, month, year)
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_historicals (RH = RH, symbol = "CAT", interval = "day", span = "month")
#'
#'}
get_historicals <- function(RH, symbol, interval, span) {

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

    return(historicals)
  }
