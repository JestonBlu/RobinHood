#' RobinHood API: watchlist
#'
#' Backend function called by watchlist(). Adds or remove instruments from the default watchlist. The create
#' and delete watchlist features are disabled as it appears that the functionality is not currently available
#' on the plateform.
#'
#' @param RH object of class RobinHood
#' @param watchlist_url (string) a single watchlist url
#' @param detail (logical) if null use header api only, otherwise pass options
#' @param delete (logical) send delete call
#' @import curl magrittr
#' @export
api_watchlist <- function(RH, watchlist_url, detail = FALSE, delete = FALSE) {

  # URL and token
  url <- watchlist_url
  token <- paste("Bearer", RH$tokens.access_token)

  # Send a command to delete a watchlist or instrument from a watchlist
  if (delete == TRUE) {

    # GET call
    dta <- httr::GET(url,
        httr::add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token),
        httr::config(customrequest = "DELETE"))

    dta <- rawToChar(dta$content)

  }

  # Send a command to create a watchlist
  if (delete == FALSE & detail == FALSE) {

    # GET call
    dta <- httr::GET(url,
        httr::add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token))

    dta <- mod_json(dta, "fromJSON")

  }

  # Send a command to add an instrument to an existing watchlist
  if (delete == FALSE & detail != FALSE) {

    # POST call
    dta <- httr::POST(url,
        httr::add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token),
        body = mod_json(detail, "toJSON"))

    dta <- mod_json(dta, "fromJSON")

  }

  return(dta)
}
