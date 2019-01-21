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
#' @import curl jsonlite magrittr
api_watchlist <- function(RH, watchlist_url, detail = FALSE, delete = FALSE) {

  # Send a command to delete a watchlist or instrument from a watchlist
  if (delete == TRUE) {
    watchlist <- new_handle() %>%
      handle_setopt(customrequest = "DELETE") %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = watchlist_url)

    watchlist <- rawToChar(watchlist$content)
  }

  # Send a command to create a watchlist
  if (delete == FALSE & detail == FALSE) {
    watchlist <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = watchlist_url)

    watchlist <- fromJSON(rawToChar(watchlist$content))
  }

  # Send a command to add an instrument to an existing watchlist
  if (delete == FALSE & detail != FALSE) {
    watchlist <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = detail) %>%
      curl_fetch_memory(url = watchlist_url)

    watchlist <- fromJSON(rawToChar(watchlist$content))
  }

  return(watchlist)
}
