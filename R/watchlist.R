#' Manage your RobinHood watchlist
#'
#' Add and delete instruments from your RobinHood watchlist. 
#'
#' @param RH object class RobinHood
#' @param action (string) one of: get, add, delete
#' @param watchlist (string) name of watchlist to add, delete, or get instruments, null will return a list of watchlist
#' @param ticker (string) list of tickers to add or delete, null will add or delete watchlist
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Get a vector of your watchlist names
#' watchlist(RH, action = "get")
#'
#' # Get a vectors of symbols on your watchlist
#' watchlist(RH, action = "get", watchlist = "Default")
#'
#' # Add a symbol to your watchlist
#' watchlist(RH, action = "add", watchlist = "Default", ticker = "CAT")
#'
#' # Delete a symbol from your watchlist
#' watchlist(RH, action = "delete", watchlist = "Default", ticker = "CAT")
#'}
watchlist <- function(RH, action, watchlist = "", ticker = "") {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # get starting watchlist url
  base_watchlist_url <- api_endpoints("watchlist")

  # get watchlist urls
  current_watchlist <- api_watchlist(RH, base_watchlist_url)

  if (action == "get" & watchlist == "") {
    # Return a list of watchlist
    wl <- current_watchlist$results$name
    return(wl)
  }

  if (action == "get" & watchlist != "") {
    # Return instruments the watchlist
    watchlist_url <- paste(base_watchlist_url, watchlist, "/?cursor=$cursor", sep = "", collapse = "")

    instruments <- api_watchlist(RH, watchlist_url, detail = FALSE)
    instrument_id <- instruments$results$instrument

    wl <- c()

    for (i in 1:length(instrument_id)) {
      x <- api_instruments(RH, instrument_id[i])
      x <- x$symbol
      wl <- c(wl, x)
    }

    return(wl)

  }

  if (action == "add" & watchlist == "") {
    cat("Watchlist cant be null, maybe you wanted Default?")
  }

  if (action == "add" & watchlist != "" & ticker == "") {
    cat("Creating a watchlist is currently disabled, use the Default watchlist")
  }

  if (action == "add" & watchlist != "" & ticker != "") {
    # Add ticker to the named watchlist
    watchlist_url <- paste(base_watchlist_url, watchlist, "/bulk_add/", sep = "", collapse = "")

    detail <- paste("symbols=", ticker, sep = "", collapse = "")

    wl <- api_watchlist(RH, watchlist_url, detail)

    if (length(wl)  > 0) cat("Instrument added to watchlist")
    if (length(wl) == 0) cat("Instrument is already in your watchlist")

  }

  if (action == "delete" & watchlist == "") {
    cat("Watchlist cant be null")
  }

  if (action == "delete" & watchlist != "" & ticker == "") {
    cat("Deleting a watchlist is currently disabled")
  }

  if (action == "delete" & watchlist != "" & ticker != "") {
    # delete the instruments from the named watchlist
    fundamentals <- api_fundamentals(RH, ticker)

    # get instrument and strip out everything before the id
    instrument_id <- fundamentals$instrument
    instrument_id <- gsub("https://api.robinhood.com/instruments/", "", instrument_id)

    watchlist_url <- paste(base_watchlist_url, watchlist, "/", instrument_id, sep = "", collapse = "")

    wl <- api_watchlist(RH, watchlist_url, delete = TRUE)

    if (wl == "") cat("Instrument removed from watchlist")

  }

}
