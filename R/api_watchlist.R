#' RobinHood API: watchlist
#'
#' @param RH object of class RobinHood
#' @param watchlist_url (string) url passed from watchlist.R
#' @param detail (string) if null use header api only, otherwise pass options
#' @param delete (logical) send delete call?
#' @import curl jsonlite magrittr
api_watchlist <- function(RH, watchlist_url, detail = NULL, delete = FALSE) {

  if (delete == TRUE) {
    watchlist <- new_handle() %>%
      handle_setopt(h, customrequest = "DELETE")
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = watchlist_url) %$% content %>%
      rawToChar %>%
      fromJSON %$% results %>% data.frame
  } else {

  if (is.null(detail)) {
    watchlist <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = watchlist_url) %$% content %>%
      rawToChar %>%
      fromJSON %$% results %>% data.frame
  } else {
    watchlist <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = detail) %>%
      curl_fetch_memory(url = watchlist_url) %$% content %>%
      rawToChar %>%
      fromJSON %$% results %>% data.frame
  }
}

  return(watchlist)
}
