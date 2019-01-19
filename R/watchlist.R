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
watchlist <- function(RH, action, watchlist = "", ticker = "") {

  # get starting watchlist url
  base_watchlist_url <- api_endpoints("watchlist")

  # get watchlist urls
  current_watchlist <- api_watchlist(RH, base_watchlist_url)

  if (action == "get" & watchlist == "") {
    # Return a list of watchlist
    wl <- current_watchlist$results$name
  }

  if (action == "get" & watchlist != "") {
    # Return instruments the watchlist
    watchlist_url <- paste(base_watchlist_url,
                           watchlist,
                           "/?cursor=$cursor",
                           sep = "", collapse = "")

    instruments <- api_watchlist(RH, watchlist_url, detail = FALSE)
    instrument_id <- instruments$results$instrument

    wl <- c()

    for (i in 1:length(instrument_id)) {
      x <- api_instruments(RH, instrument_id[i])
      x <- x$symbol
      wl <- c(wl, x)
    }

  }

  if (action == "add" & watchlist == "") {
    stop("Watchlist cant be null, maybe you wanted Default?")
  }

  if (action == "add" & watchlist != "" & ticker == "") {
    # Create a new watchlist
    # detail <- paste("name=", watchlist, sep = "")
    # wl <- api_watchlist(RH, base_watchlist_url, detail = detail)
    stop("Creating a watchlist is currently disabled, use the Default watchlist")
  }

  if (action == "add" & watchlist != "" & ticker != "") {
    # Add ticker to the named watchlist
    watchlist_url <- paste(base_watchlist_url,
                           watchlist,
                           "/bulk_add/",
                           sep = "", collapse = "")

    detail <- paste("symbols=", ticker, sep = "", collapse = "")

    wl <- api_watchlist(RH, watchlist_url, detail)

    if (length(wl)  > 0) wl <- "Instrument added to watchlist"
    if (length(wl) == 0) wl <- "Instrument is already in your watchlist"

  }

  if (action == "delete" & watchlist == "") {
    stop("Watchlist cant be null.")
  }

  if (action == "delete" & watchlist != "" & ticker == "") {
    # delete the named watchlist
    # watchlist_url <- paste(base_watchlist_url, watchlist, "/", sep = "", collapse = "")
    # wl <- api_watchlist(RH, watchlist_url, delete = TRUE)
    stop("Deleting a watchlist is currently disabled")
  }

  if (action == "delete" & watchlist != "" & ticker != "") {
    # delete the instruments from the named watchlist
    fundamentals <- api_fundamentals(RH, ticker)

    # get instrument and strip out everything before the id
    instrument_id <- fundamentals$instrument
    instrument_id <- gsub("https://api.robinhood.com/instruments/",
                          "",
                          instrument_id)

    watchlist_url <- paste(base_watchlist_url,
                           watchlist,
                           "/",
                           instrument_id,
                           sep = "", collapse = "")

    wl <- api_watchlist(RH, watchlist_url, delete = TRUE)

    if (wl == "") wl <- "Instrument removed from watchlist"

  }

  return(wl)

}
