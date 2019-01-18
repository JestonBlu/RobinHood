#' Get a current instrument quote from RobinHood
#'
#' For a string of ticker symbols, return quote data.
#'
#' @param RH object class RobinHood
#' @param action (string) one of: get, add, delete
#' @param watchlist (string) name of watchlist to add, delete, or get instruments, null will return a list of watchlist
#' @param ticker (string) list of tickers to add or delete, null will add or delete watchlist
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # get_quote(RH, c("CAT", "GE"))
watchlist <- function(RH, action, watchlist = NULL, ticker = NULL) {

  # get watchlist urls
  current_watchlist <- api_watchlist(RH, api_endpoints("watchlist"))

  # get starting watchlist url
  base_watchlist_url <- api_endpoints("watchlist")

  if (action == 'get') {
    if (is.null(watchlist)) {
      # Return a list of watchlist
      wl <- current_watchlist$name
    } else {
      # Return instruments the watchlist
      watchlist_url <- paste(base_watchlist_url, watchlist, "/?cursor=$cursor", sep = "", collapse = "")
      wl <- api_watchlist(RH, watchlist_url)
    }
  }

  if (action == 'add') {
    if (is.null(watchlist)) stop("Watchlist cant be null, maybe you wanted Default?")
  } else {
    if (is.null(ticker)) {
      # Create a new watchlist
      wl <- api_watchlist(RH, base_watchlist_url, detail = watchlist)
    } else {
      # Add ticker to the named watchlist
      watchlist_url <- paste(base_watchlist_url, watchlist, "/", sep = "", collapse = "")
      wl <- api_watchlist(RH, watchlist_url, ticker)
    }
  }

  if (action == 'delete') {
    if (is.null(watchlist)) {
      stop("Watchlist cant be null.")
    } else {
      if(is.null(ticker)) {
        # delete the named watchlist
        watchlist_url <- paste(base_watchlist_url, watchlist, "/", sep = "", collapse = "")
        wl <- api_watchlist(RH, watchlist_url, delete = TRUE)
      } else {
        # delete the instruments from the named watchlist
        fundamentals <- api_fundamentals(RH, ticker)
        instrument_id <- fundamentals$instrument
        watchlist_url <- paste(base_watchlist_url, watchlist, "/", instrument_id, "/", sep = "", collapse = "")
        wl = api_watchlist(RH, watchlist_url, delete = TRUE)
      }
    }
  }

  return(wl)

}
