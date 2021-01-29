#' Manage your RobinHood watchlist
#'
#' Add and delete instruments from your RobinHood watchlist.
#'
#' @param RH object class RobinHood
#' @param action (string) one of: get, add, delete
#' @param watchlist (string) name of watchlist to add, delete, or get instruments, null will return a list of watchlist
#' @param ticker (string) list of tickers to add or delete, null will add or delete watchlist
#' @import httr magrittr
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

    # Check if RH is valid
    check_rh(RH)

    # Get starting watchlist url
    base_watchlist_url <- api_endpoints("watchlist")

    # Get watchlist urls
    current_watchlist <- api_watchlist(RH, paste(base_watchlist_url, "default/", sep = "", collapse = ""))

    # Checks for invalid inputs
    if (action == "add" & watchlist == "") cat("Watchlist can't be null, maybe you wanted Default?")
    #if (action == "add" & watchlist != "" & ticker == "") cat("Creating a watchlist is currently disabled, use the Default watchlist")
    if (action == "delete" & watchlist == "") cat("Watchlist cant be null")
    #if (action == "delete" & watchlist != "" & ticker == "") cat("Deleting a watchlist is currently disabled")


    # If no watchlist submitted, return a vector of watchlists
    if (action == "get" & watchlist == "") {
      wl <- current_watchlist$results$display_name
      return(wl)
    }

    # If watchlist is not null, return instruments in the watchlist
    if (action == "get" & watchlist != "") {

      # Get watchlist ids
      current_watchlist <- current_watchlist$results
      watchlist_id <- current_watchlist[current_watchlist$display_name == watchlist, "id"]

      watchlist_url <- paste(base_watchlist_url, "items/?list_id=", watchlist_id, sep = "", collapse = "")
      instruments <- api_watchlist(RH, watchlist_url, detail = FALSE)

      wl <- instruments$results$symbol

      return(wl)
    }

    # Add a ticker to the named watchlist
    if (action == "add" & watchlist != "" & ticker != "") {
      watchlist_url <- paste(base_watchlist_url, watchlist, "/bulk_add/", sep = "", collapse = "")
      detail = data.frame(symbols = ticker)
      wl <- api_watchlist(RH, watchlist_url, detail)
      if (length(wl)  > 0) cat("Instrument added to watchlist")
      if (length(wl) == 0) cat("Instrument is already in your watchlist")
    }

    # Delete tickers from a watchlist
    if (action == "delete" & watchlist != "" & ticker != "") {
      fundamentals <- api_fundamentals(RH, ticker)
      # get instrument and strip out everything before the id
      instrument_id <- fundamentals$instrument
      instrument_id <- gsub("https://api.robinhood.com/instruments/", "", instrument_id)
      watchlist_url <- paste(base_watchlist_url, watchlist, "/", instrument_id, sep = "", collapse = "")
      wl <- api_watchlist(RH, watchlist_url, delete = TRUE)
      if (wl == "") cat("Instrument removed from watchlist")
    }
  }
